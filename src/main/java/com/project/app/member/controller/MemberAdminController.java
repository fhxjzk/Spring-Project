package com.project.app.member.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.project.app.member.model.MemberDto;
import com.project.app.member.service.MemberService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 회원 관리 (① E-01)
 *
 * /admin/** 은 ROLE_ADMIN 만 들어올 수 있다 (security-context.xml 에 이미 설정돼 있다)
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/admin/member")
public class MemberAdminController {

	private final MemberService memberService;

	//회원 목록. 조건이 없으면 전체를 보여준다
	@GetMapping(value = "/list.do")
	public String list(Model model,
			@RequestParam(value = "word", required = false) String word,
			@RequestParam(value = "role", required = false) String role,
			@RequestParam(value = "status", required = false) String status) {

		List<MemberDto> list = memberService.getList(word, role, status);

		model.addAttribute("list", list);
		model.addAttribute("word", word);
		model.addAttribute("role", role);
		model.addAttribute("status", status);

		return "admin/member/list";
	}

}