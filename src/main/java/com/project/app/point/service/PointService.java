package com.project.app.point.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.point.model.PointHistoryDto;
import com.project.app.point.model.PointHistoryType;
import com.project.app.point.repository.PointDao;
import com.project.app.trade.exception.TradeErrorCode;
import com.project.app.trade.exception.TradeException;

import lombok.RequiredArgsConstructor;

/**
 * 포인트 (④ B-08)
 *
 * 실제 카드 결제는 하지 않는다. 충전은 입력한 금액만큼 더하기만 하고,
 * 거래 결제·정산·환불은 TradeService가 increase(), decrease()로 처리한다.
 */
@Service
@RequiredArgsConstructor
public class PointService {

	//1회 충전 범위 (TradeErrorCode.INVALID_CHARGE_AMOUNT 메시지와 맞춘다)
	public static final int MIN_CHARGE = 1_000;
	public static final int MAX_CHARGE = 1_000_000;

	private final PointDao pointDao;

	public int getBalance(Long memberSeq) {

		Integer balance = pointDao.getBalance(memberSeq);

		if (balance == null) {
			throw new TradeException(TradeErrorCode.MEMBER_NOT_FOUND);
		}

		return balance;
	}

	//최신순
	public List<PointHistoryDto> getHistory(Long memberSeq) {

		return pointDao.listHistory(memberSeq);
	}

	//B-08 포인트 충전
	@Transactional
	public void charge(Long memberSeq, Integer amount) {

		if (amount == null || amount < MIN_CHARGE || amount > MAX_CHARGE) {
			throw new TradeException(TradeErrorCode.INVALID_CHARGE_AMOUNT);
		}

		increase(memberSeq, amount, PointHistoryType.CHARGE, null);
	}

	/**
	 * 포인트를 늘리고 내역을 남긴다 (충전, 정산, 환불)
	 * 잔액 변경과 내역 기록이 한 트랜잭션이라 둘 중 하나만 되는 일이 없다.
	 */
	@Transactional
	public void increase(Long memberSeq, int amount, PointHistoryType type, Long tradeSeq) {

		if (pointDao.addPoint(memberSeq, amount) == 0) {
			throw new TradeException(TradeErrorCode.MEMBER_NOT_FOUND);
		}

		record(memberSeq, type, amount, tradeSeq);
	}

	/**
	 * 포인트를 줄이고 내역을 남긴다 (결제)
	 * 잔액이 충분할 때만 빼는 UPDATE라서, 동시에 두 번 결제해도 잔액이 마이너스가 되지 않는다.
	 */
	@Transactional
	public void decrease(Long memberSeq, int amount, PointHistoryType type, Long tradeSeq) {

		if (pointDao.subtractPoint(memberSeq, amount) == 0) {
			throw new TradeException(TradeErrorCode.POINT_NOT_ENOUGH);
		}

		record(memberSeq, type, -amount, tradeSeq);
	}

	private void record(Long memberSeq, PointHistoryType type, int amount, Long tradeSeq) {

		PointHistoryDto dto = PointHistoryDto.builder()
				.memberSeq(memberSeq)
				.historyType(type.name())
				.amount(amount)
				.balance(getBalance(memberSeq))	//같은 트랜잭션 안이라 방금 바뀐 잔액이 읽힌다
				.tradeSeq(tradeSeq)
				.build();

		pointDao.addHistory(dto);
	}

}
