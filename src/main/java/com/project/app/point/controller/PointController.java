package com.project.app.point.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.app.auth.CustomUser;
import com.project.app.point.service.PointService;

import lombok.RequiredArgsConstructor;

/**
 * 포인트 (④ B-08)
 *
 * 로그인한 회원만 볼 수 있어서 list.do가 아니라 mylist.do를 쓴다. (list.do는 누구나 볼 수 있음)
 * 오류는 TradeExceptionHandler가 처리한다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/point")
public class PointController {

	private final PointService pointService;

	//포인트 충전 화면 (④-01)
	@GetMapping(value = "/charge.do")
	public String charge(Model model, Authentication auth) {

		model.addAttribute("balance", pointService.getBalance(memberSeq(auth)));
		model.addAttribute("minCharge", PointService.MIN_CHARGE);
		model.addAttribute("maxCharge", PointService.MAX_CHARGE);

		return "point/charge";
	}

	//포인트 충전: 실제 결제 없이 입력한 금액만큼 더한다. 충전 후 잔액은 충전 화면에서 보여 준다
	@PostMapping(value = "/chargeok.do")
	public String chargeok(Integer amount, Authentication auth, RedirectAttributes ra) {

		pointService.charge(memberSeq(auth), amount);

		ra.addFlashAttribute("message", String.format("%,dP를 충전했어요.", amount));

		return "redirect:/point/charge.do";
	}

	//포인트 내역 (④-02): 충전, 결제, 정산, 환불
	@GetMapping(value = "/mylist.do")
	public String mylist(Model model, Authentication auth) {

		Long memberSeq = memberSeq(auth);

		model.addAttribute("balance", pointService.getBalance(memberSeq));
		model.addAttribute("list", pointService.getHistory(memberSeq));

		return "point/mylist";
	}

	private Long memberSeq(Authentication auth) {

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

}
