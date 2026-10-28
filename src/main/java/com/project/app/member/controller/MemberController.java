package com.project.app.member.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.app.member.model.MemberDto;
import com.project.app.member.service.MemberService;

import lombok.RequiredArgsConstructor;

/**
 * 회원 (① 회원·공통)
 *
 * 기본 프로젝트의 예시 기능이다. 다른 파트도 이 구조를 그대로 따라 만든다.
 * Controller → Service → Dao → Mapper(인터페이스) → Mapper XML
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/member")
public class MemberController {

	private final MemberService memberService;

	//회원가입 화면
	@GetMapping(value = "/add.do")
	public String add() {

		return "member/add";
	}

	//회원가입 처리
	@PostMapping(value = "/addok.do")
	public String addok(Model model, MemberDto dto) {

		int result = memberService.add(dto);

		model.addAttribute("result", result);

		return "member/addok";
	}

}
