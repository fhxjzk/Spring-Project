package com.project.app.request.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 요청서 상세에서 보여 주는 받은 견적 (tbl_quote + 고수 이름)
 *
 * 상태: WAITING 대기 / SELECTED 선택됨 / UNSELECTED 미선택
 */
@Getter
@Setter
@ToString
public class RequestQuoteDto {

	private Long quoteSeq;
	private Long requestSeq;
	private Long expertSeq;
	private String expertName;
	private Integer price;
	private Integer workDays;
	private String content;
	private String status;
	private String regdate;
	private String expertHidden;	//Y: 신고 처리로 숨김 상태인 고수 (선택 불가)
	private Long tradeSeq;			//이 견적으로 결제한 거래 번호 (없으면 null)

}
