package com.project.app.point.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_point_history
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PointHistoryDto {

	private Long pointHistorySeq;
	private Long memberSeq;
	private String historyType;		//PointHistoryType 이름 (CHARGE, PAY ...)
	private Integer amount;			//들어오면 +, 나가면 -
	private Integer balance;		//처리 후 잔액
	private Long tradeSeq;			//관련 거래 (충전은 null)
	private String regdate;

	//JSP: ${history.typeLabel}
	public String getTypeLabel() {

		PointHistoryType type = PointHistoryType.of(historyType);

		return type == null ? "" : type.getLabel();
	}

	//JSP: <span class="badge ${history.typeBadge}">
	public String getTypeBadge() {

		PointHistoryType type = PointHistoryType.of(historyType);

		return type == null ? "" : type.getBadge();
	}

}
