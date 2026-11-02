package com.project.app.stats.model;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 관리자 통계(④-06) 차트 데이터 (Ajax로 JSON을 돌려준다)
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatsChartDto {

	private List<StatsCategoryDto> categories;	//카테고리별 거래 비중 (대분류 기준)

	//월별 거래액 추이. 세 목록의 같은 위치가 같은 달이고, 거래가 없는 달은 0이다
	private List<String> monthLabels;			//YYYY-MM
	private List<Long> monthAmounts;
	private List<Integer> monthCounts;

}
