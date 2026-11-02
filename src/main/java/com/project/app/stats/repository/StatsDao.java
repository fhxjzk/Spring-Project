package com.project.app.stats.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.stats.mapper.StatsMapper;
import com.project.app.stats.model.StatsCategoryDto;
import com.project.app.stats.model.StatsMonthlyDto;
import com.project.app.stats.model.StatsSummaryDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class StatsDao {

	private final StatsMapper statsMapper;

	public StatsSummaryDto summary() {

		return statsMapper.summary();
	}

	public List<StatsCategoryDto> categoryPrices() {

		return statsMapper.categoryPrices();
	}

	public List<StatsMonthlyDto> monthlyAmounts(int months) {

		return statsMapper.monthlyAmounts(months);
	}

}
