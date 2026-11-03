package com.project.app.trade.exception;

import java.net.URI;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * ④ 파트 컨트롤러(trade, point, stats)에서 난 TradeException을 한곳에서 처리한다.
 *
 * - 화면 요청: 오류 메시지를 flash로 담아서 보던 화면으로 돌아간다. JSP에서 ${error}로 보여 준다.
 * - Ajax 요청: {"code": "POINT_NOT_ENOUGH", "message": "..."} JSON과 오류 상태 코드를 돌려준다.
 *
 * 그래서 컨트롤러에서는 try-catch 없이 서비스만 부르면 된다.
 */
@ControllerAdvice(basePackages = {
		"com.project.app.trade",
		"com.project.app.point",
		"com.project.app.stats"
})
public class TradeExceptionHandler {

	private static final Logger log = LoggerFactory.getLogger(TradeExceptionHandler.class);

	@ExceptionHandler(TradeException.class)
	public Object handle(TradeException e, HttpServletRequest req, RedirectAttributes ra) {

		TradeErrorCode code = e.getErrorCode();

		log.info("{} {} → {}", req.getMethod(), req.getRequestURI(), code);

		if (isAjax(req)) {
			return ResponseEntity.status(code.getStatus())
					.body(Map.of("code", code.name(), "message", code.getMessage()));
		}

		ra.addFlashAttribute("error", code.getMessage());

		return "redirect:" + backUrl(req);
	}

	//jQuery Ajax는 X-Requested-With 헤더를 붙인다
	private boolean isAjax(HttpServletRequest req) {

		return "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
	}

	//보던 화면(Referer)으로 돌아간다. 없거나 다른 사이트 주소면 내 거래 목록으로 보낸다
	private String backUrl(HttpServletRequest req) {

		String referer = req.getHeader("Referer");

		if (referer != null) {
			try {
				if (req.getServerName().equals(URI.create(referer).getHost())) {
					return referer;
				}
			} catch (IllegalArgumentException ignored) {
				//형식이 잘못된 Referer는 무시한다
			}
		}

		return "/trade/mylist.do";
	}

}
