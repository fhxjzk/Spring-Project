package com.project.app.request.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * 요청서 자동 마감·만료 결과
 *
 * 상태를 바꾼 요청서마다 누구에게 알림을 보낼지 담아 둔다.
 * 알림은 DB 저장이 끝난 뒤에 보내야 해서, 바꾸는 일과 보내는 일을 나눴다.
 */
@Getter
@Setter
public class RequestExpireResult {

	private List<RequestNoticeDto> closed = new ArrayList<>();				//견적 마감 → 고객
	private List<RequestNoticeDto> expired = new ArrayList<>();				//견적 없이 만료 → 고객
	private List<RequestNoticeDto> unselected = new ArrayList<>();			//고수를 고르지 않아 만료 → 고객
	private List<RequestNoticeDto> unselectedExperts = new ArrayList<>();	//고수를 고르지 않아 만료 → 견적을 보낸 고수

	private int closedCount;
	private int expiredCount;
	private int unselectedCount;

	//로그에 남길 처리 건수 (예: 마감 1, 만료 2, 선택 기간 만료 0)
	public String getSummary() {

		return "마감 " + closedCount + ", 만료 " + expiredCount + ", 선택 기간 만료 " + unselectedCount;
	}

}
