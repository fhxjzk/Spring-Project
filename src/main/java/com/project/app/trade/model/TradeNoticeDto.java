package com.project.app.trade.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 거래 알림을 받을 회원 (TradeNoticeService)
 *
 * ⑤ 공통 알림(NotificationService.send)은 회원 번호와 아이디를 둘 다 받는다.
 * 아이디는 로그인한 회원에게 실시간으로 보낼 때 쓴다.
 */
@Getter
@Setter
@ToString
@NoArgsConstructor
public class TradeNoticeDto {

	private Long memberSeq;		//알림을 받는 회원
	private String id;			//알림을 받는 회원의 아이디

}
