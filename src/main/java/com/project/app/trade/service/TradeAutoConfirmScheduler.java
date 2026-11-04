package com.project.app.trade.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

/**
 * 자동 구매 확정
 *
 * 작업 완료 후 TradeService.AUTO_CONFIRM_DAYS일이 지나도록 고객이 구매 확정을 안 하면
 * 자동으로 구매 확정하고 고수에게 정산한다. (@Scheduled 설정은 root-context.xml에 있다)
 *
 * 거래마다 TradeService.autoConfirm()을 따로 불러서, 하나가 실패해도 나머지는 처리된다.
 */
@Component
@RequiredArgsConstructor
public class TradeAutoConfirmScheduler {

	private static final Logger log = LoggerFactory.getLogger(TradeAutoConfirmScheduler.class);

	private final TradeService tradeService;

	//서버가 켜지고 1분 뒤에 처음 실행하고, 그 뒤로 10분마다 실행한다
	@Scheduled(initialDelay = 60000, fixedDelay = 600000)
	public void autoConfirm() {

		for (Long tradeSeq : tradeService.listAutoConfirmTargets()) {
			try {
				tradeService.autoConfirm(tradeSeq);
				log.info("자동 구매 확정: 거래 {}", tradeSeq);
			} catch (RuntimeException e) {
				log.error("자동 구매 확정 실패: 거래 {}", tradeSeq, e);
			}
		}
	}

}
