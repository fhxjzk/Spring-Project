package com.project.app.report.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.app.auth.CustomUser;
import com.project.app.report.model.ReportDto;
import com.project.app.report.service.ReportService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 신고 처리 (⑥ E-02)
 *
 * /admin/** 은 ROLE_ADMIN 만 들어올 수 있다 (security-context.xml 에 이미 설정돼 있다)
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/admin/report")
public class ReportAdminController {

	private final ReportService reportService;

	//신고 목록. status 가 없으면 전체를 보여준다
	@GetMapping(value = "/list.do")
	public String list(Model model, @RequestParam(value = "status", required = false) String status) {

		List<ReportDto> list = reportService.getList(status);

		model.addAttribute("list", list);
		model.addAttribute("status", status);

		return "admin/report/list";
	}

	//신고 상세
	@GetMapping(value = "/view.do")
	public String view(Model model, @RequestParam(value = "reportSeq") Long reportSeq) {

		model.addAttribute("report", reportService.getBySeq(reportSeq));

		return "admin/report/view";
	}

	//검토중으로 바꾸기
	@PostMapping(value = "/review.do")
	public String review(@RequestParam(value = "reportSeq") Long reportSeq, Authentication auth) {

		reportService.review(reportSeq, getAdminSeq(auth));

		return "redirect:/admin/report/view.do?reportSeq=" + reportSeq;
	}

	//처리완료 / 반려
	@PostMapping(value = "/process.do")
	public String process(RedirectAttributes rttr, Authentication auth,
			@RequestParam(value = "reportSeq") Long reportSeq,
			@RequestParam(value = "status") String status,
			@RequestParam(value = "processReason") String processReason) {

		int result = reportService.process(reportSeq, status, processReason, getAdminSeq(auth));

		rttr.addFlashAttribute("msg", getMessage(result));

		return "redirect:/admin/report/view.do?reportSeq=" + reportSeq;
	}

	//숨김 / 비공개 해제
	@PostMapping(value = "/unhide.do")
	public String unhide(RedirectAttributes rttr, @RequestParam(value = "reportSeq") Long reportSeq) {

		int result = reportService.unhide(reportSeq);

		rttr.addFlashAttribute("msg", result > 0 ? "숨김을 해제했습니다." : "해제하지 못했습니다.");

		return "redirect:/admin/report/view.do?reportSeq=" + reportSeq;
	}

	//로그인한 관리자 번호
	private Long getAdminSeq(Authentication auth) {

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

	//ReportService.process() 가 돌려준 숫자를 화면에 보여줄 말로 바꾼다
	private String getMessage(int result) {

		if (result > 0) {
			return "처리했습니다.";
		}

		if (result == -1) {
			return "처리 사유를 입력해주세요.";
		}

		if (result == -2) {
			return "이미 처리가 끝난 신고입니다.";
		}

		return "처리하지 못했습니다.";
	}

}