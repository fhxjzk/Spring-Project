package com.project.app.member.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	//마이페이지. 고객·고수의 본인 정보만 보여준다
	@GetMapping(value = "/mypage.do")
	public String mypage(Model model, Authentication auth) {

		CustomUser user = (CustomUser) auth.getPrincipal();

		//관리자는 관리자 홈으로 보낸다
		if ("ROLE_ADMIN".equals(user.getDto().getRole())) {
			return "redirect:/admin/index.do";
		}

		model.addAttribute("member", memberService.getBySeq(user.getMemberSeq()));
		model.addAttribute("kakaoJsKey", kakaoJsKey);

		return "member/mypage";
	}

	//마이페이지 정보 수정. 회원 번호는 폼 값이 아니라 로그인 정보로 정한다
	@PostMapping(value = "/mypageok.do")
	public String mypageok(RedirectAttributes rttr, Authentication auth, MemberDto dto) {

		CustomUser user = (CustomUser) auth.getPrincipal();
		
		if ("ROLE_ADMIN".equals(user.getDto().getRole())) {
		    return "redirect:/admin/index.do";
		}
		
		dto.setMemberSeq(user.getMemberSeq());

		int result = memberService.edit(dto);

		//헤더는 세션의 로그인 정보를 보여주므로 같이 바꾼다
		if (result > 0) {
			user.getDto().setName(dto.getName());
			user.getDto().setEmail(dto.getEmail());
		}

		rttr.addFlashAttribute("msg", getEditMessage(result));

		return "redirect:/member/mypage.do";
	}

	//MemberService.edit() 가 돌려준 숫자를 화면에 보여줄 말로 바꾼다
	private String getEditMessage(int result) {

		if (result > 0) {
			return "정보를 수정했습니다.";
		}

		if (result == -2) {
			return "이미 사용 중인 이메일입니다.";
		}
		
		if (result == -3) {
			return "주소 검색으로 위치를 다시 확인해 주세요.";
		}
		
		if (result == -4) {
			return "입력한 값을 다시 확인해 주세요.";
		}

		return "수정하지 못했습니다.";
	}
}