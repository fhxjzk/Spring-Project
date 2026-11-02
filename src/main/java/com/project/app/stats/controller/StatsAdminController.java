package com.project.app.stats.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.app.stats.model.StatsChartDto;
import com.project.app.stats.service.StatsService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 통계 (④ E-05, 화면 ④-06)
 *
 * /admin/** 는 security-context.xml에서 관리자만 들어올 수 있다.
 * 관리자 메뉴(inc/admin-menu.jsp)의 "통계"가 /admin/stats/index.do 로 연결되어 있다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/admin/stats")
public class StatsAdminController {

	private final StatsService statsService;

	//통계 화면: 숫자 카드 (차트 데이터는 화면에서 chart.do로 받아 온다)
	@GetMapping(value = "/index.do")
	public String index(Model model) {

		model.addAttribute("summary", statsService.getSummary());

		return "admin/stats/index";
	}

	//차트 데이터 (Ajax, JSON)
	@GetMapping(value = "/chart.do")
	@ResponseBody
	public StatsChartDto chart() {

		return statsService.getChart();
	}

}
