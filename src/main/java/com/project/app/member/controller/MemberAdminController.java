package com.project.app.member.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

	//회원 상세. 없는 회원이면 목록으로 돌려보낸다
	@GetMapping(value = "/view.do")
	public String view(Model model, RedirectAttributes rttr, @RequestParam(value = "memberSeq") Long memberSeq) {

		MemberDto member = memberService.getBySeq(memberSeq);

		if (member == null) {
			rttr.addFlashAttribute("msg", "없는 회원입니다.");
			return "redirect:/admin/member/list.do";
		}

		model.addAttribute("member", member);

		return "admin/member/view";
	}
	
	//사용 중지
	@PostMapping(value = "/stop.do")
	public String stop(RedirectAttributes rttr,
	@RequestParam(value = "memberSeq") Long memberSeq) {
		int result = memberService.updateEnabled(memberSeq, "N");
		
		rttr.addFlashAttribute("msg", getMessage(result, "사용을 중지했습니다."));

		return "redirect:/admin/member/view.do?memberSeq=" + memberSeq;
	}
	
	//사용 재개
		@PostMapping(value = "/resume.do")
		public String resume(RedirectAttributes rttr, @RequestParam(value = "memberSeq") Long memberSeq) {

			int result = memberService.updateEnabled(memberSeq, "Y");

			rttr.addFlashAttribute("msg", getMessage(result, "사용을 재개했습니다."));

			return "redirect:/admin/member/view.do?memberSeq=" + memberSeq;
		}
		
	//MemberService.updateEnabled()가 돌려준 숫자를 화면에 보여줄 말로 바꾼다.
	private String getMessage(int result, String success) {
		
		if (result > 0) {
			return success;
		}
		
		if (result == -1) {
			return "관리자 계정은 바꿀 수 없습니다.";
		}
		
		if (result == -2) {
			return "탈퇴한 회원은 바꿀 수 없습니다.";
		}
		return "변경하지 못했습니다.";
	}

}