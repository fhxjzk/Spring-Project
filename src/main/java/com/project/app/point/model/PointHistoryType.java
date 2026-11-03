package com.project.app.point.model;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * 포인트 내역 종류 (tbl_point_history.history_type)
 */
@Getter
@RequiredArgsConstructor
public enum PointHistoryType {

	CHARGE("충전", "badge-primary"),	//+
	PAY("결제", "badge-warning"),		//- 플랫폼이 보관
	SETTLE("정산", "badge-success"),	//+ 구매 확정 후 고수에게
	REFUND("환불", "badge-danger");	//+ 결제 후 취소

	private final String label;	//화면에 보여 줄 이름
	private final String badge;	//common.css 배지 색

	//DB 값("CHARGE")으로 찾는다. 없으면 null
	public static PointHistoryType of(String code) {

		for (PointHistoryType type : values()) {
			if (type.name().equals(code)) {
				return type;
			}
		}

		return null;
	}

}
