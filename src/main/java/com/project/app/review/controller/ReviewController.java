package com.project.app.review.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.app.auth.CustomUser;
import com.project.app.review.model.ReviewDto;
import com.project.app.review.service.ReviewService;
import com.project.app.trade.model.TradeDto;

import lombok.RequiredArgsConstructor;

/**
 * 리뷰 (화면설계서 ②-05 리뷰·별점 작성)
 *
 * URL은 /review/동작.do
 *   - add.do, addok.do 는 로그인한 회원만 (security-context.xml 의 /** isAuthenticated)
 *     구매 확정한 거래의 고객인지는 여기서(ReviewService) 직접 확인한다
 *   - 거래 상세(④-05)의 [리뷰 작성] 버튼이 add.do?tradeSeq= 로 들어온다
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/review")
public class ReviewController {

	private final ReviewService reviewService;

	// 리뷰 작성 화면  GET /review/add.do?tradeSeq=
	// 버튼은 쓸 수 있을 때만 보이지만, 주소를 직접 치고 들어올 수 있어서 여기서도 막는다
	@GetMapping(value = "/add.do")
	public String add(Long tradeSeq, Model model, Authentication auth) {

		TradeDto trade = reviewService.getTradeForReview(tradeSeq, getMemberSeq(auth));

		//없는 거래, 남의 거래, 구매 확정 전, 이미 쓴 거래
		if (trade == null) {
			return "redirect:/trade/mylist.do";
		}

		//화면 위쪽 "어떤 거래의 리뷰인지" 요약에 쓴다
		model.addAttribute("trade", trade);

		return "review/add";
	}

	// 리뷰 작성 처리  POST /review/addok.do
	// 폼에서 오는 값: tradeSeq(hidden), rating, content
	@PostMapping(value = "/addok.do")
	public String addok(ReviewDto dto, Model model, Authentication auth) {

		model.addAttribute("result", reviewService.add(dto, getMemberSeq(auth)));

		//저장 후, 또는 쓸 수 없는 거래일 때 돌아갈 거래 상세
		model.addAttribute("tradeSeq", dto.getTradeSeq());

		return "review/addok";
	}

	private Long getMemberSeq(Authentication auth) {

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

}
