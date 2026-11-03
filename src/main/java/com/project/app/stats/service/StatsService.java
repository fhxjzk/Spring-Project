package com.project.app.stats.service;

import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.project.app.stats.model.StatsChartDto;
import com.project.app.stats.model.StatsMonthlyDto;
import com.project.app.stats.model.StatsSummaryDto;
import com.project.app.stats.repository.StatsDao;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 통계 (④ E-05, 화면 ④-06)
 */
@Service
@RequiredArgsConstructor
public class StatsService {

	//월별 거래액 추이에 보여 줄 개월 수 (이번 달 포함)
	public static final int MONTHS = 12;

	private final StatsDao statsDao;

	//숫자 카드 4개
	public StatsSummaryDto getSummary() {

		return statsDao.summary();
	}

	//차트 두 개: 카테고리별 거래 비중, 월별 거래액 추이 (거래가 없는 달은 0으로 채운다)
	public StatsChartDto getChart() {

		Map<String, StatsMonthlyDto> byMonth = new HashMap<>();

		for (StatsMonthlyDto dto : statsDao.monthlyAmounts(MONTHS)) {
			byMonth.put(dto.getStatMonth(), dto);
		}

		List<String> labels = new ArrayList<>();
		List<Long> amounts = new ArrayList<>();
		List<Integer> counts = new ArrayList<>();

		YearMonth now = YearMonth.now();

		for (int i = MONTHS - 1; i >= 0; i--) {

			String month = now.minusMonths(i).toString();	//YYYY-MM
			StatsMonthlyDto dto = byMonth.get(month);

			labels.add(month);
			amounts.add(dto == null ? 0L : dto.getAmount());
			counts.add(dto == null ? 0 : dto.getCnt());
		}

		return StatsChartDto.builder()
				.categories(statsDao.categoryPrices())
				.monthLabels(labels)
				.monthAmounts(amounts)
				.monthCounts(counts)
				.build();
	}

}
