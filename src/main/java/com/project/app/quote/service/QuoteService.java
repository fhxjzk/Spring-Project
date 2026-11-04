package com.project.app.quote.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.quote.model.QuoteDto;
import com.project.app.quote.repository.QuoteDao;
import com.project.app.request.model.RequestDto;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class QuoteService {

	private final QuoteDao quoteDao;

	//받은 요청서 목록. type이 designated가 아니면 공개 요청을 보여 준다
	public List<RequestDto> requestList(Long expertSeq, String type) {

		if (!"designated".equals(type)) {
			type = "open";
		}

		return quoteDao.requestList(expertSeq, type);
	}

	//고수가 볼 수 있는 요청서 하나. 볼 수 없으면 null
	public RequestDto getRequest(Long requestSeq, Long expertSeq) {

		if (requestSeq == null) {
			return null;
		}

		return quoteDao.getRequest(requestSeq, expertSeq);
	}

	//이 요청서에 내가 보낸 견적. 없으면 null
	public QuoteDto getMyQuote(Long requestSeq, Long expertSeq) {

		return quoteDao.getMyQuote(requestSeq, expertSeq);
	}

	//신고로 숨김 처리되지 않은 고수인지
	public boolean isActiveExpert(Long expertSeq) {

		return quoteDao.activeExpert(expertSeq) == 1;
	}

	/**
	 * 견적 보내기 (D-02)
	 *
	 * 견적 수를 먼저 늘리고(조건에 맞을 때만), 성공하면 견적을 저장한다. 둘은 한 번에 처리한다.
	 *
	 * @return 1: 성공, 0: 입력값 오류, -1: 숨김 고수, -2: 이미 보낸 견적, -3: 견적을 보낼 수 없는 요청서
	 */
	@Transactional
	public int add(QuoteDto dto) {

		if (dto.getRequestSeq() == null || !isValid(dto)) {
			return 0;
		}

		if (!isActiveExpert(dto.getExpertSeq())) {
			return -1;
		}

		if (quoteDao.getMyQuote(dto.getRequestSeq(), dto.getExpertSeq()) != null) {
			return -2;
		}

		//모집 중, 비공개 아님, 마감 전, 5개 미만, 내가 받을 수 있는 요청서일 때만 1
		if (quoteDao.increaseQuoteCount(dto.getRequestSeq(), dto.getExpertSeq()) == 0) {
			return -3;
		}

		dto.setContent(dto.getContent().trim());
		quoteDao.add(dto);

		//TODO 고객에게 견적 도착 알림 (⑤ 공통 알림 기능이 생기면 호출)

		return 1;
	}

	//금액 1원~1억 원, 작업 기간 1~365일, 설명 1~1000자
	private boolean isValid(QuoteDto dto) {

		if (dto.getPrice() == null || dto.getPrice() < 1 || dto.getPrice() > 100000000) {
			return false;
		}

		if (dto.getWorkDays() == null || dto.getWorkDays() < 1 || dto.getWorkDays() > 365) {
			return false;
		}

		if (dto.getContent() == null) {
			return false;
		}

		int length = dto.getContent().trim().length();

		return length >= 1 && length <= 1000;
	}

	/**
	 * 지정 요청 거절 (D-02)
	 *
	 * @return 1: 성공, 0: 거절할 수 없음 (나를 지정한 요청서가 아니거나, 모집 중이 아님)
	 */
	public int reject(Long requestSeq, Long expertSeq) {

		if (requestSeq == null) {
			return 0;
		}

		//TODO 고객에게 거절 알림 (⑤ 공통 알림 기능이 생기면 호출)

		return quoteDao.reject(requestSeq, expertSeq);
	}

	//내가 보낸 견적 목록
	public List<QuoteDto> myList(Long expertSeq) {

		return quoteDao.myList(expertSeq);
	}

}
