package com.project.app.stats.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 관리자 통계(④-06) 위쪽의 숫자 카드 4개
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatsSummaryDto {

	private Integer memberCount;		//전체 회원 (탈퇴 제외)
	private Long totalAmount;			//누적 거래액 (취소 제외 결제 금액 합계, 수수료 없음)
	private Integer monthTradeCount;	//이번 달 거래 건수 (취소 제외)
	private Integer monthSignupCount;	//이번 달 신규 가입자

}
