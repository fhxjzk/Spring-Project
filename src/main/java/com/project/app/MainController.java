package com.project.app;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

	@GetMapping(value = "/")
	public String root() {

		return "redirect:/index.do";
	}

	//메인 페이지 (화면 구성은 ② 담당)
	@GetMapping(value = "/index.do")
	public String index() {

		return "index";
	}

}
