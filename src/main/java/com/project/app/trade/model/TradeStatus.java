package com.project.app.trade.model;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * 거래 상태 (tbl_trade.status) - 순서도 "거래 상태 흐름"
 *
 * 결제 완료 → 진행 중 → 납품 완료 → 구매 확정
 *    └ 취소 (작업 시작 전, 포인트 환불)
 */
@Getter
@RequiredArgsConstructor
public enum TradeStatus {

	PAID("결제 완료", "badge-primary"),		//고객 포인트를 플랫폼이 보관 중
	IN_PROGRESS("진행 중", "badge-primary"),
	DELIVERED("납품 완료", "badge-warning"),	//고객의 구매 확정을 기다림
	CONFIRMED("구매 확정", "badge-success"),	//고수에게 정산됨
	CANCELED("취소", "badge-danger");		//포인트 환불됨

	private final String label;	//화면에 보여 줄 이름
	private final String badge;	//common.css 배지 색

	//DB 값("PAID")으로 찾는다. 없으면 null
	public static TradeStatus of(String code) {

		for (TradeStatus status : values()) {
			if (status.name().equals(code)) {
				return status;
			}
		}

		return null;
	}

	public boolean is(String code) {

		return name().equals(code);
	}

}
