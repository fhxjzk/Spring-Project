package com.project.app.trade.model;

import java.util.Arrays;
import java.util.List;

import lombok.Getter;

/**
 * 내 거래 목록(④-04)의 상태 탭
 *
 * 화면설계서: 전체 / 진행중 / 납품완료 / 구매확정 / 취소
 * 진행중 탭에는 결제 완료(작업 시작 전)와 진행 중을 같이 보여 준다.
 */
@Getter
public enum TradeTab {

	ALL("전체"),
	PROGRESS("진행중", TradeStatus.PAID, TradeStatus.IN_PROGRESS),
	DELIVERED("납품완료", TradeStatus.DELIVERED),
	CONFIRMED("구매확정", TradeStatus.CONFIRMED),
	CANCELED("취소", TradeStatus.CANCELED);

	private final String label;
	private final List<TradeStatus> statuses;	//비어 있으면 전체

	TradeTab(String label, TradeStatus... statuses) {

		this.label = label;
		this.statuses = Arrays.asList(statuses);
	}

	//이 탭에 보여 줄 거래 상태인가
	public boolean matches(String status) {

		return statuses.isEmpty() || statuses.contains(TradeStatus.of(status));
	}

	//주소의 tab 값("PROGRESS")으로 찾는다. 없거나 잘못되면 전체
	public static TradeTab of(String name) {

		for (TradeTab tab : values()) {
			if (tab.name().equals(name)) {
				return tab;
			}
		}

		return ALL;
	}

}
