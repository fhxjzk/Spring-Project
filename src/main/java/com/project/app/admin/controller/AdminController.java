package com.project.app.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 관리자 공통 화면 (① 회원·공통)
 *
 * 관리자 메뉴의 각 화면은 담당 파트가 자기 패키지에 만든다.
 * URL은 /admin/기능/동작.do 로 맞춘다. (메뉴 목록: views/inc/admin-menu.jsp)
 */
@Controller
@RequestMapping(value = "/admin")
public class AdminController {

	@GetMapping(value = "/index.do")
	public String index() {

		return "admin/index";
	}

}
