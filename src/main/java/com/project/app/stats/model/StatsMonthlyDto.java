package com.project.app.stats.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 월별 거래 통계 한 줄 (StatsMapper.monthlyAmounts 결과)
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatsMonthlyDto {

	private String statMonth;	//YYYY-MM
	private Integer cnt;		//거래 건수
	private Long amount;		//거래액

}
