package com.project.app.report.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.app.auth.CustomUser;
import com.project.app.report.model.ReportDto;
import com.project.app.report.service.ReportService;

import lombok.RequiredArgsConstructor;

/**
 * 신고 접수 (⑥ B-07)
 *
 * 고수 프로필 화면(②)과 요청서 상세 화면(③)에서 Ajax로 부른다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/report")
public class ReportController {

	private final ReportService reportService;

	//신고 접수 (Ajax). 결과를 JSON으로 돌려준다
	@PostMapping(value = "/add.do")
	@ResponseBody
	public Map<String, Object> add(ReportDto dto, Authentication auth) {

		//신고자는 화면에서 보낸 값을 믿지 않고 로그인한 회원 번호를 쓴다
		dto.setReporterSeq(((CustomUser) auth.getPrincipal()).getMemberSeq());

		int result = reportService.add(dto);

		Map<String, Object> map = new HashMap<>();

		map.put("success", result > 0);
		map.put("message", getMessage(result));

		return map;
	}

	//임시 확인용 화면. ②③번 화면이 생기면 이 메서드와 test.jsp 를 지운다
	@GetMapping(value = "/test.do")
	public String test() {

		return "report/test";
	}

	private String getMessage(int result) {

		if (result > 0) {
			return "신고가 접수되었습니다.";
		}

		if (result == -1) {
			return "기타를 선택하셨으면 상세 내용을 입력해주세요.";
		}

		if (result == -2) {
			return "본인은 신고할 수 없습니다.";
		}

		if (result == -3) {
			return "이미 신고한 대상입니다.";
		}

		return "신고하지 못했습니다.";
	}

}
