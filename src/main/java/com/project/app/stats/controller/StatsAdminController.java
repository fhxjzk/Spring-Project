package com.project.app.stats.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.app.stats.model.StatsCategoryDto;
import com.project.app.stats.service.StatsService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 통계 (④ E-05)
 *
 * /admin/** 는 security-context.xml에서 관리자만 들어올 수 있다.
 * 관리자 메뉴(inc/admin-menu.jsp)의 "통계"가 /admin/stats/index.do 로 연결되어 있다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/admin/stats")
public class StatsAdminController {

	private final StatsService statsService;

	//통계 화면 (데이터는 화면에서 category.do로 받아 와서 차트를 그린다)
	@GetMapping(value = "/index.do")
	public String index(Model model) {

		model.addAttribute("defaultDays", StatsService.DEFAULT_DAYS);

		return "stats/index";
	}

	//분류별 평균 단가 (Ajax, JSON)
	@GetMapping(value = "/category.do")
	@ResponseBody
	public List<StatsCategoryDto> category(@RequestParam(defaultValue = "30") int days) {

		return statsService.getCategoryPrices(days);
	}

}
