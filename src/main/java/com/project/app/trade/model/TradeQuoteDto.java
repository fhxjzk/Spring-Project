package com.project.app.trade.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 결제할 견적 정보 (③ 견적·요청서 + 고수 이름)
 *
 * ③ 견적 확인·고수 선택에서 고른 견적을 결제 화면에 보여 주고, 결제할 때 다시 확인하는 데 쓴다.
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TradeQuoteDto {

	private Long quoteSeq;
	private Long requestSeq;
	private Long customerSeq;		//요청서를 쓴 고객
	private Long expertSeq;			//견적을 보낸 고수
	private String expertName;
	private Integer price;			//견적 금액 = 결제 금액
	private String requestStatus;	//③ 요청서 상태 (OPEN 모집 중, CLOSED 견적 마감, SELECTED 선택 완료 ...)

	//요청서가 아직 모집 중이거나 견적 마감이면 고수를 선택(결제)할 수 있다
	public boolean isSelectable() {

		return "OPEN".equals(requestStatus) || "CLOSED".equals(requestStatus);
	}

}
