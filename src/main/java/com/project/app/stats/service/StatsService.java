package com.project.app.stats.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.project.app.stats.model.StatsCategoryDto;
import com.project.app.stats.repository.StatsDao;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 통계 (④ E-05): 분류별 평균 단가
 */
@Service
@RequiredArgsConstructor
public class StatsService {

	//화면에서 고를 수 있는 기간 (일). 0은 전체 기간
	public static final int[] PERIODS = { 30, 90, 365, 0 };
	public static final int DEFAULT_DAYS = 30;

	private final StatsDao statsDao;

	//목록에 없는 기간이 들어오면 기본값(30일)으로 본다
	public List<StatsCategoryDto> getCategoryPrices(int days) {

		for (int period : PERIODS) {
			if (period == days) {
				return statsDao.categoryPrices(days);
			}
		}

		return statsDao.categoryPrices(DEFAULT_DAYS);
	}

}
