package com.project.app.quote.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_quote (D-02 견적 전달)
 *
 * 상태: WAITING 대기 / SELECTED 선택됨 / UNSELECTED 미선택
 */
@Getter
@Setter
@ToString
public class QuoteDto {

	private Long quoteSeq;
	private Long requestSeq;
	private Long expertSeq;
	private Integer price;			//견적 금액 (원)
	private Integer workDays;		//예상 작업 기간 (일)
	private String content;			//견적 설명
	private String status;
	private String regdate;
	private Long tradeSeq;			//고객이 이 견적으로 결제한 거래 번호 (없으면 null)

	//내가 보낸 견적 목록용 (join)
	private String categoryName;
	private String address;
	private String requestStatus;	//요청서 상태
	private String designated;		//Y: 지정 요청에 보낸 견적

}
