package com.project.app.review.service;

import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.service.ExpertService;
import com.project.app.review.model.ReviewDto;
import com.project.app.review.model.ReviewSummaryDto;
import com.project.app.review.repository.ReviewDao;
import com.project.app.trade.model.TradeDto;
import com.project.app.trade.service.TradeService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewService {
	private final ReviewDao reviewDao;

	//④ 거래. 리뷰 작성 자격(구매 확정한 거래의 고객, 아직 안 씀)은 ④가 만든 걸 그대로 쓴다
	private final TradeService tradeService;

	//답변할 때 숨김(신고 처리) 고수인지 확인한다
	private final ExpertService expertService;

	//tbl_review.content, reply 둘 다 VARCHAR2(2000) 이고 바이트 기준이다. 한글은 3바이트라 약 660자
	private static final int MAX_CONTENT_BYTES = 2000;

	/**
	 * 리뷰를 쓸 수 있는 거래면 거래 정보를, 아니면 null (②-05 작성 화면)
	 *
	 * 구매 확정한 거래의 고객이고 아직 리뷰를 안 썼을 때만 쓸 수 있다.
	 * 거래 상세의 [리뷰 작성] 버튼과 같은 조건이라, 주소를 직접 쳐서 들어와도 똑같이 막힌다.
	 */
	public TradeDto getTradeForReview(Long tradeSeq, Long customerSeq) {

		//canWriteReview 는 없는 거래, 남의 거래, 구매 확정 전, 이미 쓴 거래를 모두 false 로 돌려준다
		if (!tradeService.canWriteReview(tradeSeq, customerSeq)) {
			return null;
		}

		//위에서 이 거래의 고객인 걸 확인했으니 getForMember 가 예외를 던지지 않는다
		return tradeService.getForMember(tradeSeq, customerSeq);
	}

	/**
	 * 리뷰 작성 (②-05)
	 *
	 * @return 1 저장, 0 별점·내용이 잘못됨, -1 쓸 수 없는 거래 (남의 거래, 구매 확정 전, 이미 씀)
	 */
	public int add(ReviewDto dto, Long customerSeq) {

		//화면에서 막아도 POST 는 직접 보낼 수 있어서 서버에서 다시 확인한다
		String content = dto.getContent() == null ? "" : dto.getContent().trim();

		if (dto.getRating() == null || dto.getRating() < 1 || dto.getRating() > 5
				|| content.isEmpty() || content.getBytes(StandardCharsets.UTF_8).length > MAX_CONTENT_BYTES) {
			return 0;
		}

		TradeDto trade = getTradeForReview(dto.getTradeSeq(), customerSeq);

		if (trade == null) {
			return -1;
		}

		//작성자·고수 번호는 폼에서 받지 않는다. 로그인 정보와 거래 정보로 채운다 (폼 값은 바꿔서 보낼 수 있다)
		dto.setCustomerSeq(customerSeq);
		dto.setExpertSeq(trade.getExpertSeq());
		dto.setContent(content);

		try {
			reviewDao.addReview(dto);
		} catch (DuplicateKeyException e) {
			//[등록]을 두 번 눌러서 거의 동시에 두 요청이 온 경우. 먼저 들어간 하나만 남고 두 번째는 uq_review_trade 에 걸린다
			return -1;
		}

		return 1;
	}

	/**
	 * 리뷰 답변 (②-06). 등록한 답변은 수정할 수 없다
	 *
	 * @param expertSeq 로그인한 회원 번호 (= 고수 번호). 이 고수가 받은 리뷰에만 답변할 수 있다
	 * @return 1 저장, 0 답변 내용이 잘못됨, -1 답변할 수 없음 (남의 리뷰, 이미 답변함, 숨김 고수, 고수 아님)
	 */
	public int addReply(Long reviewSeq, String reply, Long expertSeq) {

		String text = reply == null ? "" : reply.trim();

		if (text.isEmpty() || text.getBytes(StandardCharsets.UTF_8).length > MAX_CONTENT_BYTES) {
			return 0;
		}

		//고수 프로필이 없거나(고객) 신고 처리로 숨김된 고수는 답변할 수 없다. 서비스 등록·수정과 같은 기준
		ExpertProfileDto edto = expertService.getProfile(expertSeq);

		if (edto == null || "Y".equals(edto.getHidden())) {
			return -1;
		}

		ReviewDto dto = new ReviewDto();
		dto.setReviewSeq(reviewSeq);
		dto.setExpertSeq(expertSeq);
		dto.setReply(text);

		//"내가 받은 리뷰 + 아직 답변 없음" 은 쿼리 where 조건이 확인한다 (ReviewMapper.addReply).
		//하나라도 아니면 0줄이 바뀐다. 먼저 조회해서 확인하지 않는 이유: 확인과 저장 사이에 다른 창에서 답변하면 덮어쓸 수 있어서
		return reviewDao.addReply(dto) == 1 ? 1 : -1;
	}

	// 리뷰 5개만 가져오기
	public List<ReviewDto> getRecentReviewList(Long expertSeq) {
		List<ReviewDto> reviewlist = reviewDao.getRecentReviewList(expertSeq);
		return reviewlist;
	}
	
	public ReviewSummaryDto getReviewSummary(Long expertSeq) {
		ReviewSummaryDto rsdto = reviewDao.getReviewSummary(expertSeq);
		return rsdto;
	}

	// 리뷰 전체보기: 한 고수가 받은 리뷰 전부 (최신순)
	public List<ReviewDto> getReviewList(Long expertSeq) {
		return reviewDao.getReviewList(expertSeq);
	}

	// 메인 최근 리뷰 (전체 고수 대상 최신 3개)
	public List<ReviewDto> getLatestReviewList() {
		List<ReviewDto> reviewList = reviewDao.getLatestReviewList();
		return reviewList;
	}
}
