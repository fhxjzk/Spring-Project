package com.project.app.stats.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 카테고리(대분류)별 거래 통계 한 줄 (StatsMapper.categoryPrices 결과)
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatsCategoryDto {

	private Long categorySeq;
	private String categoryName;
	private Integer tradeCount;		//거래 건수 (취소 제외)
	private Long avgPrice;			//평균 단가
	private Long salesAmount;		//매출 = 구매 확정된 거래 금액 합계 (수수료 없음)

}
