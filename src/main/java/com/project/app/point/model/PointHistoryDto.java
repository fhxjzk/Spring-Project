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

	//조회할 때 거래 → 요청서·서비스를 join해서 채운다 (충전은 null)
	private String serviceName;

	/**
	 * 내역의 "내용" 칸 (④-02)
	 * 충전: 포인트 충전 / 결제: 서비스 이름 / 정산: 서비스 이름 구매확정 / 환불: 서비스 이름 취소 환불
	 */
	public String getDescription() {

		PointHistoryType type = PointHistoryType.of(historyType);

		if (type == null || type == PointHistoryType.CHARGE) {
			return "포인트 충전";
		}

		String name = serviceName == null ? "거래 #" + tradeSeq : serviceName;

		if (type == PointHistoryType.SETTLE) {
			return name + " 구매확정";
		}
		if (type == PointHistoryType.REFUND) {
			return name + " 취소 환불";
		}

		return name;
	}

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
