package com.project.app.member.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.project.app.auth.CustomUser;
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

	@Value("${kakao.js.key:}")
	private String kakaoJsKey;

	//회원가입 화면
	@GetMapping(value = "/add.do")
	public String add(Model model) {

		model.addAttribute("kakaoJsKey", kakaoJsKey);

		return "member/add";
	}

	//회원가입 처리
	@PostMapping(value = "/addok.do")
	public String addok(Model model, MemberDto dto) {

		int result = memberService.add(dto);

		model.addAttribute("result", result);

		return "member/addok";
	}
	
	//마이페이지. 회원 번호는 로그인 정보에서 꺼내서 본인 정보만 보여준다
	@GetMapping(value = "/mypage.do")
	public String mypage(Model model, Authentication auth) {
		
		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();
		
		model.addAttribute("member", memberService.getBySeq(memberSeq));
		
		return "member/mypage";
	}
}
