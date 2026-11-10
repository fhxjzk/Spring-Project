package com.project.app.request.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.project.app.notice.service.NotificationService;
import com.project.app.request.model.RequestExpireResult;
import com.project.app.request.model.RequestNoticeDto;
import com.project.app.request.repository.RequestDao;

import lombok.RequiredArgsConstructor;

/**
 * 요청서·견적 알림 (B-06 실시간 알림)
 *
 * ⑤의 공통 알림 기능(NotificationService)을 불러서 보낸다.
 *
 * 알림은 DB 저장이 끝난 뒤에 보내야 한다. 받는 사람 화면은 알림이 오면 바로 목록을 다시 읽는데,
 * 저장이 끝나기 전에 보내면 새 알림이 아직 안 보이기 때문이다.
 * 그래서 이 클래스에는 @Transactional을 붙이지 않고, 컨트롤러와 스케줄러가 서비스 일을 마친 뒤에 부른다.
 *
 * 알림을 보내다 실패해도 요청서·견적 처리는 이미 끝났으므로, 오류는 로그만 남기고 넘어간다.
 */
@Service
@RequiredArgsConstructor
public class RequestNoticeService {

	private static final Logger log = LoggerFactory.getLogger(RequestNoticeService.class);

	//알림 종류 (tbl_notice.notification_type)
	private static final String TYPE_REQUEST = "REQUEST";
	private static final String TYPE_QUOTE = "QUOTE";

	private final RequestDao requestDao;
	private final NotificationService notificationService;

	//요청서 등록 → 공개 요청은 그 카테고리의 고수들에게, 지정 요청은 지정한 고수에게
	public void requestAdded(Long requestSeq) {

		for (RequestNoticeDto target : experts(requestSeq, true)) {

			if (target.getExpertSeq() == null) {
				send(target, TYPE_REQUEST, "새 요청서", "새 요청서가 등록되었습니다. 받은 요청서에서 확인해 주세요.");
			} else {
				send(target, TYPE_REQUEST, "지정 요청 도착", "고객이 나를 지정해서 요청서를 보냈습니다. 48시간 안에 응답해 주세요.");
			}
		}
	}

	//요청서 취소 → 견적을 보낸 고수들과 지정된 고수에게
	public void requestCanceled(Long requestSeq) {

		sendAll(experts(requestSeq, false), TYPE_REQUEST, "요청서 취소", "고객이 요청서를 취소했습니다.");
	}

	//견적 도착 → 고객에게
	public void quoteArrived(Long requestSeq) {

		RequestNoticeDto target = customer(requestSeq);

		if (target != null) {
			send(target, TYPE_QUOTE, "견적 도착", "새 견적이 도착했습니다. 내 요청서에서 확인해 주세요.");
		}
	}

	//지정 요청 거절 → 고객에게
	public void requestRejected(Long requestSeq) {

		RequestNoticeDto target = customer(requestSeq);

		if (target != null) {
			send(target, TYPE_REQUEST, "지정 요청 거절", "고수가 요청을 거절했습니다.");
		}
	}

	//자동 마감·만료 → 고객과 견적을 보낸 고수에게
	public void expired(RequestExpireResult result) {

		sendAll(result.getClosed(), TYPE_REQUEST, "견적 마감", "견적 접수가 마감되었습니다. 7일 안에 고수를 선택해 주세요.");

		for (RequestNoticeDto target : result.getExpired()) {

			if (target.getExpertSeq() == null) {
				send(target, TYPE_REQUEST, "요청서 만료", "48시간 동안 받은 견적이 없어 요청서가 만료되었습니다.");
			} else {
				send(target, TYPE_REQUEST, "요청서 만료", "고수가 48시간 안에 응답하지 않아 요청서가 만료되었습니다.");
			}
		}

		sendAll(result.getUnselected(), TYPE_REQUEST, "요청서 만료", "고수 선택 기간이 지나 요청서가 만료되었습니다.");
		sendAll(result.getUnselectedExperts(), TYPE_QUOTE, "견적 미선택", "요청서가 만료되어 보낸 견적이 미선택 처리되었습니다.");
	}

	/**
	 * 알림을 받을 고수 조회. newRequest가 true면 새 요청서를 알릴 고수, false면 견적을 보낸 고수와 지정된 고수.
	 *
	 * 조회하다 오류가 나도 밖으로 던지지 않고 빈 목록을 준다.
	 * 요청서는 이미 저장됐는데 화면에 오류가 뜨면, 사용자가 다시 눌러 두 번 등록할 수 있기 때문이다.
	 */
	private List<RequestNoticeDto> experts(Long requestSeq, boolean newRequest) {

		try {
			return newRequest ? requestDao.noticeNewRequestExperts(requestSeq) : requestDao.noticeQuoteExperts(requestSeq);
		} catch (RuntimeException e) {
			log.error("요청서 알림 대상 조회 실패: 요청서 {}", requestSeq, e);
			return List.of();
		}
	}

	//알림을 받을 고객 조회. 탈퇴했거나 조회하다 오류가 나면 null
	private RequestNoticeDto customer(Long requestSeq) {

		try {
			return requestDao.noticeCustomer(requestSeq);
		} catch (RuntimeException e) {
			log.error("요청서 알림 대상 조회 실패: 요청서 {}", requestSeq, e);
			return null;
		}
	}

	private void sendAll(List<RequestNoticeDto> targets, String type, String title, String text) {

		for (RequestNoticeDto target : targets) {
			send(target, type, title, text);
		}
	}

	//알림 한 건 보내기. 글 앞에 어느 요청서인지 붙인다. 예) [피아노 요청서 12번] 새 견적이 도착했습니다.
	private void send(RequestNoticeDto target, String type, String title, String text) {

		String message = "[" + target.getCategoryName() + " 요청서 " + target.getRequestSeq() + "번] " + text;

		try {
			notificationService.send(target.getMemberSeq(), target.getId(), type, title, message, target.getRequestSeq());
		} catch (RuntimeException e) {
			log.error("요청서 알림 전송 실패: 요청서 {}, 받는 회원 {}", target.getRequestSeq(), target.getMemberSeq(), e);
		}
	}

}
