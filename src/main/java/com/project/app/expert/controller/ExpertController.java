package com.project.app.expert.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.project.app.expert.model.ExpertDto;
import com.project.app.expert.service.ExpertService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ExpertController {
	private final ExpertService expertService;
	
	@GetMapping(value = "/expert/view.do")
	public String view(@RequestParam("expertSeq") Long expertSeq, Model model) {
		
		ExpertDto edto = expertService.getProfile(expertSeq);
		
		model.addAttribute("edto",edto);
		
		return "expert/view";
	}
	
}
