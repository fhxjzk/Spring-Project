package com.project.app.trade.exception;

import org.springframework.http.HttpStatus;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * ④ 결제·거래·포인트·통계의 오류 목록
 *
 * 새 오류가 필요하면 여기에 한 줄 추가하고 throw new TradeException(TradeErrorCode.XXX) 로 던진다.
 * 메시지는 사용자 화면에 그대로 보인다. (TradeExceptionHandler)
 */
@Getter
@RequiredArgsConstructor
public enum TradeErrorCode {

	//결제 (③ 견적 선택에서 넘어올 때)
	QUOTE_NOT_FOUND(HttpStatus.NOT_FOUND, "견적을 찾을 수 없어요."),
	NOT_REQUEST_OWNER(HttpStatus.FORBIDDEN, "본인 요청서의 견적만 결제할 수 있어요."),
	REQUEST_NOT_SELECTABLE(HttpStatus.CONFLICT, "이미 마감되거나 취소된 요청서예요."),

	//거래
	TRADE_NOT_FOUND(HttpStatus.NOT_FOUND, "거래를 찾을 수 없어요."),
	NOT_TRADE_MEMBER(HttpStatus.FORBIDDEN, "본인 거래만 볼 수 있어요."),
	NOT_TRADE_CUSTOMER(HttpStatus.FORBIDDEN, "이 거래의 고객만 할 수 있어요."),
	NOT_TRADE_EXPERT(HttpStatus.FORBIDDEN, "이 거래를 맡은 고수만 할 수 있어요."),

	//지금 거래 상태에서 할 수 없는 일
	CANNOT_START(HttpStatus.CONFLICT, "결제 완료된 거래만 작업을 시작할 수 있어요."),
	CANNOT_COMPLETE(HttpStatus.CONFLICT, "진행 중인 거래만 작업 완료할 수 있어요."),
	CANNOT_CONFIRM(HttpStatus.CONFLICT, "아직 구매 확정할 수 없어요. 납품 완료된 거래만 확정할 수 있어요."),
	CANNOT_CANCEL(HttpStatus.CONFLICT, "취소할 수 없어요. 고수가 작업을 시작하기 전까지만 취소할 수 있어요."),

	//포인트 (충전 금액 범위는 PointService.MIN_CHARGE, MAX_CHARGE와 맞춘다)
	MEMBER_NOT_FOUND(HttpStatus.NOT_FOUND, "회원을 찾을 수 없어요."),
	INVALID_CHARGE_AMOUNT(HttpStatus.BAD_REQUEST, "충전 금액은 1,000P 이상 1,000,000P 이하로 입력해 주세요."),
	POINT_NOT_ENOUGH(HttpStatus.CONFLICT, "포인트가 부족해요. 충전한 뒤 다시 결제해 주세요."),

	//결과물 파일
	FILE_SAVE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "파일을 저장하지 못했어요. 다시 시도해 주세요."),
	FILE_NOT_FOUND(HttpStatus.NOT_FOUND, "파일을 찾을 수 없어요.");

	private final HttpStatus status;	//Ajax 요청일 때 돌려줄 상태 코드
	private final String message;		//사용자에게 보여 줄 메시지

}
