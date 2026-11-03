package com.project.app.stats.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.stats.model.StatsCategoryDto;
import com.project.app.stats.model.StatsMonthlyDto;
import com.project.app.stats.model.StatsSummaryDto;

//SQL은 resources/mappers/stats/StatsMapper.xml 에 있다 (메서드 이름 = XML의 id)
@Mapper
public interface StatsMapper {

	StatsSummaryDto summary();

	List<StatsCategoryDto> categoryPrices();

	List<StatsMonthlyDto> monthlyAmounts(int months);

}
