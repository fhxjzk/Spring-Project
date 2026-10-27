package com.project.app.auth;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthController {

	//로그인 화면 (로그인 처리는 Spring Security가 POST /login 으로 한다)
	@GetMapping(value = "/auth/login.do")
	public String login() {

		return "auth/login";
	}

	//로그아웃 화면 (로그아웃 처리는 Spring Security가 POST /auth/logout.do 로 한다)
	@GetMapping(value = "/auth/logout.do")
	public String logout() {

		return "auth/logout";
	}

}
