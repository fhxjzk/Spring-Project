package com.project.app.trade.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_trade (+ 화면에 보여 줄 고객·고수 이름)
 *
 * 거래는 결제할 때 만들어진다. 그래서 regdate가 곧 결제 시각이다.
 *
 * MyBatis는 빈 객체를 만든 뒤 값을 채우므로 @NoArgsConstructor가 필요하고,
 * @Builder는 @AllArgsConstructor가 있어야 같이 쓸 수 있다.
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TradeDto {

	private Long tradeSeq;
	private Long requestSeq;
	private Long quoteSeq;
	private Long customerSeq;
	private Long expertSeq;
	private Integer price;
	private String status;			//TradeStatus 이름 (PAID, IN_PROGRESS ...)
	private String regdate;			//결제 (거래 생성)
	private String startDate;		//작업 시작
	private String deliveredDate;	//납품 완료
	private String confirmDate;		//구매 확정
	private String cancelDate;		//취소

	//조회할 때 join해서 채운다
	private String customerName;
	private String expertName;
	private String serviceName;		//고수가 등록한 서비스 제목, 없으면 요청서 카테고리 이름

	//화면에 보여 줄 거래 번호. JSP: ${trade.tradeNo} → T-14
	public String getTradeNo() {

		return "T-" + tradeSeq;
	}

	//결제일 (날짜만). JSP: ${trade.paidDay}
	public String getPaidDay() {

		return regdate == null ? "" : regdate.substring(0, 10);
	}

	/**
	 * 거래 상세 타임라인(④-05)에서 몇 번째 단계까지 왔는지
	 * 1 결제완료, 2 진행중, 3 납품완료, 4 구매확정. 취소된 거래는 결제완료(1)에서 멈춘 것으로 본다.
	 */
	public int getStep() {

		TradeStatus s = TradeStatus.of(status);

		if (s == TradeStatus.IN_PROGRESS) {
			return 2;
		}
		if (s == TradeStatus.DELIVERED) {
			return 3;
		}
		if (s == TradeStatus.CONFIRMED) {
			return 4;
		}

		return 1;
	}

	//JSP: ${trade.statusLabel}
	public String getStatusLabel() {

		TradeStatus s = TradeStatus.of(status);

		return s == null ? "" : s.getLabel();
	}

	//JSP: <span class="badge ${trade.statusBadge}">
	public String getStatusBadge() {

		TradeStatus s = TradeStatus.of(status);

		return s == null ? "" : s.getBadge();
	}

	public boolean isCustomer(Long memberSeq) {

		return customerSeq != null && customerSeq.equals(memberSeq);
	}

	public boolean isExpert(Long memberSeq) {

		return expertSeq != null && expertSeq.equals(memberSeq);
	}

	//이 거래의 고객이나 고수인가
	public boolean isMember(Long memberSeq) {

		return isCustomer(memberSeq) || isExpert(memberSeq);
	}

}
