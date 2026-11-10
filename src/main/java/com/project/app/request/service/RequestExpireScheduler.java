package com.project.app.request.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.project.app.request.model.RequestExpireResult;

import lombok.RequiredArgsConstructor;

/**
 * 요청서 자동 마감·만료
 *
 * 견적 마감(등록 + 48시간)과 고수 선택 마감(견적 마감 + 7일)이 지난 요청서의 상태를 바꾼다.
 * 할 일은 RequestService.expire()에 있다. (@Scheduled 설정은 root-context.xml에 있다)
 */
@Component
@RequiredArgsConstructor
public class RequestExpireScheduler {

	private static final Logger log = LoggerFactory.getLogger(RequestExpireScheduler.class);

	private final RequestService requestService;
	private final RequestNoticeService requestNoticeService;

	//서버가 켜지고 1분 뒤에 처음 실행하고, 그 뒤로 10분마다 실행한다
	@Scheduled(initialDelay = 60000, fixedDelay = 600000)
	public void expire() {

		try {
			RequestExpireResult result = requestService.expire();
			log.info("요청서 자동 마감·만료: {}", result.getSummary());

			//상태 변경이 저장된 뒤에 고객·고수에게 알린다
			requestNoticeService.expired(result);

		} catch (RuntimeException e) {
			log.error("요청서 자동 마감·만료 실패", e);
		}
	}

}
