package com.project.app;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.project.app.category.service.CategoryService;
import com.project.app.category.model.CategoryDto;
import com.project.app.expert.model.ExpertCardDto;
import com.project.app.expert.service.ExpertService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {

	private final CategoryService categoryService;
	private final ExpertService expertService;
	
	@GetMapping(value = "/")
	public String root() {

		return "redirect:/index.do";
	}

	//메인 페이지 (화면 구성은 ② 담당)
	@GetMapping(value = "/index.do")
	public String index(Model model) {
		
		List<CategoryDto> clist = categoryService.getTopCategory();
		model.addAttribute("clist",clist);

		List<ExpertCardDto> expertList = expertService.getPopularExpertList();
		model.addAttribute("expertList", expertList);
		return "index";
	}

}
