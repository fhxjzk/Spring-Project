package com.project.app.trade.exception;

import lombok.Getter;

/**
 * ④ 파트의 규칙 위반 예외 (TradeErrorCode 참고)
 *
 * RuntimeException이라서 @Transactional 메서드 안에서 던지면 그 안의 DB 변경이 모두 롤백된다.
 */
@Getter
public class TradeException extends RuntimeException {

	private final TradeErrorCode errorCode;

	public TradeException(TradeErrorCode errorCode) {

		super(errorCode.getMessage());
		this.errorCode = errorCode;
	}

	public TradeException(TradeErrorCode errorCode, Throwable cause) {

		super(errorCode.getMessage(), cause);
		this.errorCode = errorCode;
	}

}
