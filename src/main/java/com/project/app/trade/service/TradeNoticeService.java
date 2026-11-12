package com.project.app.trade.service;

import java.text.NumberFormat;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.project.app.chat.service.ChatRoomService;
import com.project.app.notice.service.NotificationService;
import com.project.app.trade.model.TradeDto;
import com.project.app.trade.model.TradeNoticeDto;
import com.project.app.trade.repository.TradeDao;

import lombok.RequiredArgsConstructor;

/**
 * 거래 알림과 채팅방 (B-06 실시간 알림, B-05-01 매칭 채팅방 생성)
 *
 * ⑤의 공통 알림(NotificationService)과 채팅방(ChatRoomService)을 부른다.
 *
 * 결제·작업 완료·취소 같은 거래 처리가 DB에 저장된 뒤에 불러야 한다.
 * 받는 사람 화면은 알림이 오면 바로 목록을 다시 읽는데, 저장 전에 보내면 새 알림이 안 보이기 때문이다.
 * 그래서 이 클래스에는 @Transactional을 붙이지 않고, 컨트롤러와 스케줄러가 TradeService 일을 마친 뒤에 부른다.
 * (③ RequestNoticeService와 같은 방식)
 *
 * 알림이나 채팅방 생성이 실패해도 결제·취소는 이미 끝났으므로, 오류는 로그만 남기고 넘어간다.
 * 채팅방은 거래 상세의 채팅하기를 누를 때도 없으면 만들어지므로(ChatRoomService.getOrCreateRoom) 여기서 실패해도 괜찮다.
 */
@Service
@RequiredArgsConstructor
public class TradeNoticeService {

	private static final Logger log = LoggerFactory.getLogger(TradeNoticeService.class);

	//알림 종류 (tbl_notice.notification_type)
	private static final String TYPE_TRADE = "TRADE";
	private static final String TYPE_QUOTE = "QUOTE";

	private final TradeDao tradeDao;
	private final NotificationService notificationService;
	private final ChatRoomService chatRoomService;

	/**
	 * 결제 완료 (C-03-a)
	 *   - 고객과 고수의 채팅방 생성 (B-05-01)
	 *   - 선택된 고수에게 결제 완료, 같은 요청서에 견적을 보낸 나머지 고수에게 미선택 (B-06-04)
	 */
	public void paid(Long tradeSeq) {

		TradeDto trade = trade(tradeSeq);

		if (trade == null) {
			return;
		}

		try {
			chatRoomService.getOrCreateRoom(tradeSeq);
		} catch (RuntimeException e) {
			log.error("채팅방 생성 실패: 거래 {}", tradeSeq, e);
		}

		send(trade.getExpertSeq(), trade, TYPE_TRADE, "견적 선택됨",
				"고객이 내 견적을 선택하고 결제했습니다. 작업을 시작해 주세요.");

		for (TradeNoticeDto target : unselectedExperts(trade)) {
			send(target, trade.getRequestSeq(), TYPE_QUOTE, "견적 미선택",
					"[요청서 " + trade.getRequestSeq() + "번] 고객이 다른 고수를 선택해 보낸 견적이 미선택 처리되었습니다.");
		}
	}

	//작업 시작 (D-03) → 고객에게
	public void started(Long tradeSeq) {

		TradeDto trade = trade(tradeSeq);

		if (trade != null) {
			send(trade.getCustomerSeq(), trade, TYPE_TRADE, "작업 시작", "고수가 작업을 시작했습니다.");
		}
	}

	//작업 완료 (D-03, B-06-03) → 고객에게
	public void completed(Long tradeSeq) {

		TradeDto trade = trade(tradeSeq);

		if (trade != null) {
			send(trade.getCustomerSeq(), trade, TYPE_TRADE, "작업 완료",
					"고수가 작업을 완료했습니다. 결과를 확인하고 구매 확정해 주세요. "
					+ TradeService.AUTO_CONFIRM_DAYS + "일이 지나면 자동으로 구매 확정됩니다.");
		}
	}

	//구매 확정 (C-03-b) → 고수에게 정산
	public void confirmed(Long tradeSeq) {

		TradeDto trade = trade(tradeSeq);

		if (trade != null) {
			send(trade.getExpertSeq(), trade, TYPE_TRADE, "구매 확정",
					"고객이 구매를 확정해 " + point(trade) + "가 정산되었습니다.");
		}
	}

	//자동 구매 확정 (C-03-b-04) → 고객과 고수에게
	public void autoConfirmed(Long tradeSeq) {

		TradeDto trade = trade(tradeSeq);

		if (trade == null) {
			return;
		}

		send(trade.getCustomerSeq(), trade, TYPE_TRADE, "자동 구매 확정",
				"납품 후 " + TradeService.AUTO_CONFIRM_DAYS + "일이 지나 자동으로 구매 확정되었습니다.");
		send(trade.getExpertSeq(), trade, TYPE_TRADE, "구매 확정",
				"자동 구매 확정으로 " + point(trade) + "가 정산되었습니다.");
	}

	/**
	 * 거래 취소 (C-03-c-04) → 상대방에게
	 * 고객이 취소하면 고수에게, 고수가 취소하면 고객에게 보낸다.
	 */
	public void canceled(Long tradeSeq, Long canceledBy) {

		TradeDto trade = trade(tradeSeq);

		if (trade == null) {
			return;
		}

		if (trade.isCustomer(canceledBy)) {
			send(trade.getExpertSeq(), trade, TYPE_TRADE, "거래 취소", "고객이 거래를 취소했습니다.");
		} else {
			send(trade.getCustomerSeq(), trade, TYPE_TRADE, "거래 취소",
					"고수가 거래를 취소했습니다. 결제한 " + point(trade) + "는 전액 환불되었습니다.");
		}
	}

	//알림 글에 쓸 거래. 조회하다 오류가 나면 null (거래 처리는 이미 끝났으므로 화면에 오류를 띄우지 않는다)
	private TradeDto trade(Long tradeSeq) {

		try {
			return tradeDao.get(tradeSeq);
		} catch (RuntimeException e) {
			log.error("거래 알림 대상 조회 실패: 거래 {}", tradeSeq, e);
			return null;
		}
	}

	private List<TradeNoticeDto> unselectedExperts(TradeDto trade) {

		try {
			return tradeDao.noticeUnselectedExperts(trade.getRequestSeq(), trade.getQuoteSeq());
		} catch (RuntimeException e) {
			log.error("미선택 알림 대상 조회 실패: 거래 {}", trade.getTradeSeq(), e);
			return List.of();
		}
	}

	//거래 알림 한 건. 글 앞에 어느 거래인지 붙인다. 예) [기초 피아노 레슨 T-16] 고수가 작업을 완료했습니다.
	private void send(Long memberSeq, TradeDto trade, String type, String title, String text) {

		TradeNoticeDto target;

		try {
			target = tradeDao.noticeMember(memberSeq);
		} catch (RuntimeException e) {
			log.error("거래 알림 대상 조회 실패: 거래 {}, 받는 회원 {}", trade.getTradeSeq(), memberSeq, e);
			return;
		}

		if (target != null) {
			send(target, trade.getTradeSeq(), type, title, "[" + trade.getServiceName() + " " + trade.getTradeNo() + "] " + text);
		}
	}

	private void send(TradeNoticeDto target, Long referenceId, String type, String title, String message) {

		try {
			notificationService.send(target.getMemberSeq(), target.getId(), type, title, message, referenceId);
		} catch (RuntimeException e) {
			log.error("거래 알림 전송 실패: 참조 {}, 받는 회원 {}", referenceId, target.getMemberSeq(), e);
		}
	}

	private String point(TradeDto trade) {

		return NumberFormat.getInstance().format(trade.getPrice()) + "P";
	}

}
