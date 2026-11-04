package com.project.app.request.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_request
 *
 * expertSeq가 비어 있으면 공개 요청, 값이 있으면 지정 요청이다.
 * 상태: OPEN 모집 중 / CLOSED 견적 마감 / SELECTED 선택 완료 / CANCELED 취소 / REJECTED 거절 / EXPIRED 만료
 */
@Getter
@Setter
@ToString
public class RequestDto {

	private Long requestSeq;
	private Long customerSeq;
	private Long expertSeq;
	private Long categorySeq;
	private String address;
	private String wishDate;		//yyyy-MM-dd
	private Integer budget;
	private String content;
	private String status;
	private String hidden;			//Y: 신고 처리로 비공개
	private Integer quoteCount;
	private String quoteDeadline;
	private String selectDeadline;
	private String regdate;

	//목록·상세 화면용 (join)
	private String categoryName;
	private String expertName;		//지정 요청한 고수 이름
	private Long remainMinutes;		//모집 중이면 견적 마감, 견적 마감이면 고수 선택 마감까지 남은 분
	private String remainText;		//remainMinutes를 화면용 글로 바꾼 것 (예: 견적 마감까지 1일 7시간 남음)

}
