package com.project.app.stats.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.stats.mapper.StatsMapper;
import com.project.app.stats.model.StatsCategoryDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class StatsDao {

	private final StatsMapper statsMapper;

	public List<StatsCategoryDto> categoryPrices(int days) {

		return statsMapper.categoryPrices(days);
	}

}
