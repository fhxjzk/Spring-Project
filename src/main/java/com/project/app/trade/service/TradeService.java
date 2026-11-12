package com.project.app.trade.service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.project.app.point.model.PointHistoryType;
import com.project.app.point.service.PointService;
import com.project.app.trade.exception.TradeErrorCode;
import com.project.app.trade.exception.TradeException;
import com.project.app.trade.model.TradeDto;
import com.project.app.trade.model.TradeFileDto;
import com.project.app.trade.model.TradeQuoteDto;
import com.project.app.trade.model.TradeStatus;
import com.project.app.trade.model.TradeTab;
import com.project.app.trade.repository.TradeDao;

import lombok.RequiredArgsConstructor;

/**
 * 거래 (④ C-03 포인트 결제·구매 확정·취소, D-03 작업 진행)
 *
 * 순서도 "④ 결제·거래·통계"를 그대로 따른다. 거래는 결제할 때 만들어진다.
 *
 * "이 거래의 고객/고수인가"와 "지금 상태에서 할 수 있는가"를 모두 여기서 확인한다.
 * URL 권한만으로는 남의 견적·거래 번호를 넣고 요청하는 것(IDOR)을 막을 수 없기 때문이다.
 */
@Service
@RequiredArgsConstructor
public class TradeService {

	//납품 후 이 기간이 지나도록 고객이 구매 확정을 안 하면 자동으로 확정한다
	public static final int AUTO_CONFIRM_DAYS = 7;

	private final TradeDao tradeDao;
	private final PointService pointService;

	/**
	 * 결제할 견적 (③ 견적 확인·고수 선택에서 넘어온다)
	 * 결제 화면을 열 때와 결제 버튼을 누를 때 둘 다 확인한다. (C-03-a-05)
	 *   - 본인 요청서의 견적인가
	 *   - 요청서가 아직 모집 중 또는 견적 마감인가
	 *   - 선택한 고수가 신고 처리로 숨김 상태가 아닌가
	 */
	public TradeQuoteDto getQuoteForPay(Long quoteSeq, Long customerSeq) {

		TradeQuoteDto quote = tradeDao.getQuote(quoteSeq);

		if (quote == null) {
			throw new TradeException(TradeErrorCode.QUOTE_NOT_FOUND);
		}

		if (!quote.getCustomerSeq().equals(customerSeq)) {
			throw new TradeException(TradeErrorCode.NOT_REQUEST_OWNER);
		}

		if (!quote.isSelectable()) {
			throw new TradeException(TradeErrorCode.REQUEST_NOT_SELECTABLE);
		}

		if (quote.isHiddenExpert()) {
			throw new TradeException(TradeErrorCode.EXPERT_HIDDEN);
		}

		return quote;
	}

	/**
	 * C-03-a 포인트 결제 (고객)
	 *
	 * 한 번에 처리한다. 중간에 하나라도 실패하면 전부 취소된다.
	 *   1. 요청서: 선택 완료 (모집 중, 견적 마감일 때만)
	 *   2. 고른 견적: 선택됨, 나머지 견적: 미선택
	 *   3. 거래 생성, 상태: 결제 완료
	 *   4. 포인트 차감 (잔액이 금액 이상일 때만) + 포인트 내역: 결제
	 *
	 * @return 새 거래 번호
	 */
	@Transactional
	public Long pay(Long quoteSeq, Long customerSeq) {

		TradeQuoteDto quote = getQuoteForPay(quoteSeq, customerSeq);

		//상태 조건을 걸고 바꾼다. 결제 버튼을 두 번 누르거나 그 사이 마감되면 0건이라 여기서 막힌다
		if (tradeDao.selectRequest(quote.getRequestSeq()) == 0) {
			throw new TradeException(TradeErrorCode.REQUEST_NOT_SELECTABLE);
		}

		tradeDao.selectQuote(quote.getRequestSeq(), quoteSeq);

		TradeDto trade = TradeDto.builder()
				.requestSeq(quote.getRequestSeq())
				.quoteSeq(quoteSeq)
				.customerSeq(customerSeq)
				.expertSeq(quote.getExpertSeq())
				.price(quote.getPrice())
				.build();

		tradeDao.add(trade);

		//포인트가 모자라면 여기서 예외 → 위의 요청서·견적·거래 변경도 전부 롤백된다
		pointService.decrease(customerSeq, quote.getPrice(), PointHistoryType.PAY, trade.getTradeSeq());

		//채팅방 생성과 알림은 저장이 끝난 뒤 컨트롤러가 TradeNoticeService.paid()로 부른다

		return trade.getTradeSeq();
	}

	//거래 상세: 이 거래의 고객이나 고수만 볼 수 있다
	public TradeDto getForMember(Long tradeSeq, Long memberSeq) {

		TradeDto trade = get(tradeSeq);

		if (!trade.isMember(memberSeq)) {
			throw new TradeException(TradeErrorCode.NOT_TRADE_MEMBER);
		}

		return trade;
	}

	/**
	 * 내 거래 목록 (④-04, 최신순)
	 * 고객이면 내가 맡긴 거래, 고수면 내가 맡은 거래. 상태 탭에 맞는 거래만 남긴다.
	 */
	public List<TradeDto> listMine(Long memberSeq, boolean expert, TradeTab tab) {

		List<TradeDto> list = expert ? tradeDao.listByExpert(memberSeq) : tradeDao.listByCustomer(memberSeq);

		return list.stream()
				.filter(trade -> tab.matches(trade.getStatus()))
				.collect(Collectors.toList());
	}

	//D-03 작업 시작 (고수): 결제 완료 → 진행 중
	@Transactional
	public void start(Long tradeSeq, Long expertSeq) {

		getForExpert(tradeSeq, expertSeq);

		if (tradeDao.start(tradeSeq) == 0) {
			throw new TradeException(TradeErrorCode.CANNOT_START);
		}
	}

	//D-03 작업 완료 (고수): 진행 중 → 납품 완료. 온라인 작업이면 결과물 파일을 같이 올린다 (파일 없이도 된다)
	@Transactional
	public void complete(Long tradeSeq, Long expertSeq, MultipartFile file, String uploadDir) {

		getForExpert(tradeSeq, expertSeq);

		if (tradeDao.complete(tradeSeq) == 0) {
			throw new TradeException(TradeErrorCode.CANNOT_COMPLETE);
		}

		if (file != null && !file.isEmpty()) {
			tradeDao.addFile(saveFile(tradeSeq, file, uploadDir));
		}
	}

	//C-03-b 구매 확정 (고객): 납품 완료 → 구매 확정, 보관하던 포인트를 고수에게 정산
	@Transactional
	public void confirm(Long tradeSeq, Long customerSeq) {

		TradeDto trade = getForCustomer(tradeSeq, customerSeq);

		if (tradeDao.confirm(tradeSeq) == 0) {
			throw new TradeException(TradeErrorCode.CANNOT_CONFIRM);
		}

		settle(trade);
	}

	/**
	 * C-03-b 자동 구매 확정 (TradeAutoConfirmScheduler가 거래마다 부른다). 그 사이 고객이 먼저 확정했으면 넘어간다
	 * @return 이번에 확정했으면 true (스케줄러가 알림을 보낼지 정한다)
	 */
	@Transactional
	public boolean autoConfirm(Long tradeSeq) {

		TradeDto trade = get(tradeSeq);

		if (tradeDao.confirm(tradeSeq) == 0) {
			return false;
		}

		settle(trade);

		return true;
	}

	public List<Long> listAutoConfirmTargets() {

		return tradeDao.listAutoConfirmTargets(AUTO_CONFIRM_DAYS);
	}

	/**
	 * C-03-c 거래 취소 (고객·고수 모두, D-03-04)
	 * 고수가 작업을 시작하기 전(결제 완료)에만, 이 거래의 고객이나 고수만 취소할 수 있다.
	 * 누가 취소하든 결제한 포인트는 고객에게 전액 환불한다.
	 * 거래: 취소, 요청서: 취소(다시 열리지 않음), 포인트 환불을 한 번에 처리한다. (C-03-c-05)
	 */
	@Transactional
	public void cancel(Long tradeSeq, Long memberSeq) {

		TradeDto trade = getForMember(tradeSeq, memberSeq);

		if (tradeDao.cancel(tradeSeq) == 0) {
			throw new TradeException(TradeErrorCode.CANNOT_CANCEL);
		}

		tradeDao.cancelRequest(trade.getRequestSeq());

		pointService.increase(trade.getCustomerSeq(), trade.getPrice(), PointHistoryType.REFUND, tradeSeq);
	}

	//결과물 파일 목록 (getForMember로 본인 확인을 먼저 한 거래에만 쓴다)
	public List<TradeFileDto> getFiles(Long tradeSeq) {

		return tradeDao.listFiles(tradeSeq);
	}

	//결과물 다운로드: 파일이 달린 거래의 고객이나 고수만
	public TradeFileDto getFileForMember(Long tradeFileSeq, Long memberSeq) {

		TradeFileDto file = tradeDao.getFile(tradeFileSeq);

		if (file == null) {
			throw new TradeException(TradeErrorCode.FILE_NOT_FOUND);
		}

		getForMember(file.getTradeSeq(), memberSeq);

		return file;
	}

	//② 리뷰 작성 자격: 구매 확정한 거래의 고객인가
	public boolean canReview(Long tradeSeq, Long customerSeq) {

		TradeDto trade = tradeDao.get(tradeSeq);

		return trade != null
				&& trade.isCustomer(customerSeq)
				&& TradeStatus.CONFIRMED.is(trade.getStatus());
	}

	//거래 상세의 리뷰 작성 버튼: 리뷰 자격이 있고 아직 리뷰를 안 썼을 때만
	public boolean canWriteReview(Long tradeSeq, Long customerSeq) {

		return canReview(tradeSeq, customerSeq) && tradeDao.countReview(tradeSeq) == 0;
	}

	//② 고수 고용 수 (구매 확정 건수). 고수 상세, 메인 인기 고수에 쓴다
	public int countHires(Long expertSeq) {

		return tradeDao.countConfirmedByExpert(expertSeq);
	}

	//① 탈퇴 전 확인: 끝나지 않은 거래(결제 완료 ~ 납품 완료)가 있으면 true
	public boolean hasOngoingTrade(Long memberSeq) {

		return tradeDao.countOngoing(memberSeq) > 0;
	}

	private TradeDto get(Long tradeSeq) {

		TradeDto trade = tradeDao.get(tradeSeq);

		if (trade == null) {
			throw new TradeException(TradeErrorCode.TRADE_NOT_FOUND);
		}

		return trade;
	}

	private TradeDto getForCustomer(Long tradeSeq, Long customerSeq) {

		TradeDto trade = get(tradeSeq);

		if (!trade.isCustomer(customerSeq)) {
			throw new TradeException(TradeErrorCode.NOT_TRADE_CUSTOMER);
		}

		return trade;
	}

	private TradeDto getForExpert(Long tradeSeq, Long expertSeq) {

		TradeDto trade = get(tradeSeq);

		if (!trade.isExpert(expertSeq)) {
			throw new TradeException(TradeErrorCode.NOT_TRADE_EXPERT);
		}

		return trade;
	}

	//구매 확정 → 고수에게 거래 금액만큼 포인트 정산 (수수료 없음)
	private void settle(TradeDto trade) {

		pointService.increase(trade.getExpertSeq(), trade.getPrice(), PointHistoryType.SETTLE, trade.getTradeSeq());
	}

	//결과물 저장: 업로드 폴더/UUID_원래이름 (CONVENTION.md 업로드 규칙)
	private TradeFileDto saveFile(Long tradeSeq, MultipartFile file, String uploadDir) {

		//브라우저에 따라 경로까지 붙어 오는 경우가 있어서 파일 이름만 남긴다
		String original = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
		String orgname = StringUtils.getFilename(original.replace('\\', '/'));

		if (!StringUtils.hasText(orgname)) {
			orgname = "file";
		}

		String filename = UUID.randomUUID() + "_" + orgname;

		File dir = new File(uploadDir);

		if (!dir.exists()) {
			dir.mkdirs();
		}

		try {
			file.transferTo(new File(dir, filename));
		} catch (IOException e) {
			throw new TradeException(TradeErrorCode.FILE_SAVE_FAILED, e);
		}

		return TradeFileDto.builder()
				.tradeSeq(tradeSeq)
				.orgname(orgname)
				.filename(filename)
				.filesize(file.getSize())
				.build();
	}

}
