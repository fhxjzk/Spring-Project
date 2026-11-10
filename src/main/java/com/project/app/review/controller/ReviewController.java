package com.project.app.review.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.app.auth.CustomUser;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.service.ExpertService;
import com.project.app.review.model.ReviewDto;
import com.project.app.review.service.ReviewService;
import com.project.app.trade.model.TradeDto;

import lombok.RequiredArgsConstructor;

/**
 * 리뷰 (화면설계서 ②-05 리뷰·별점 작성, ②-06 리뷰 답변)
 *
 * URL은 /review/동작.do
 *   - list.do 는 누구나 (비로그인 포함, security-context.xml 의 list.do 규칙)
 *   - add.do, addok.do, replyok.do 는 로그인한 회원만 (security-context.xml 의 /** isAuthenticated)
 *     구매 확정한 거래의 고객인지, 내가 받은 리뷰인지는 여기서(ReviewService) 직접 확인한다
 *   - 거래 상세(④-05)의 [리뷰 작성] 버튼이 add.do?tradeSeq= 로 들어온다
 *   - 고수 상세(②-04)의 리뷰 [전체보기]가 list.do?expertSeq= 로 들어온다
 *   - 고수 상세, 리뷰 전체보기의 답변 칸이 replyok.do 로 보낸다
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/review")
public class ReviewController {

	private final ReviewService reviewService;
	private final ExpertService expertService;

	// 리뷰 전체보기  GET /review/list.do?expertSeq=
	// 고수 상세에는 최근 5개만 나와서, 그보다 오래된 리뷰는 여기서 보고 답변한다
	@GetMapping(value = "/list.do")
	public String list(Long expertSeq, Model model, Authentication auth) {

		ExpertProfileDto edto = expertSeq == null ? null : expertService.getProfile(expertSeq);

		//없는 고수
		if (edto == null) {
			return "redirect:/index.do";
		}

		//답변 칸을 보일지 정하는 값은 고수 상세(ExpertController.view)와 같다
		model.addAttribute("edto", edto);
		model.addAttribute("reviewList", reviewService.getReviewList(expertSeq));
		model.addAttribute("rsdto", reviewService.getReviewSummary(expertSeq));
		model.addAttribute("isOwner", expertService.ownerCheck(getMemberSeqOrNull(auth), expertSeq));
		model.addAttribute("isHidden", "Y".equals(edto.getHidden()));

		return "review/list";
	}

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

	// 리뷰 답변 처리  POST /review/replyok.do  (②-06)
	// 폼에서 오는 값: reviewSeq(hidden), reply, from(hidden, 리뷰 전체보기에서 보낼 때만 'list')
	@PostMapping(value = "/replyok.do")
	public String replyok(Long reviewSeq, String reply, String from, Model model, Authentication auth) {

		Long memberSeq = getMemberSeq(auth);

		model.addAttribute("result", reviewService.addReply(reviewSeq, reply, memberSeq));

		//답변 후 돌아갈 곳: 내 고수 상세 또는 내 리뷰 전체보기 (고수 번호 = 회원 번호)
		model.addAttribute("expertSeq", memberSeq);
		model.addAttribute("fromList", "list".equals(from));

		return "review/replyok";
	}

	//로그인해야 들어오는 주소용 (add, addok, replyok)
	private Long getMemberSeq(Authentication auth) {

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

	//비로그인도 들어오는 주소용 (list). 비회원이면 auth 가 null 이거나 principal 이 CustomUser 가 아니다
	private Long getMemberSeqOrNull(Authentication auth) {

		if (auth == null || !(auth.getPrincipal() instanceof CustomUser)) {
			return null;
		}

		return getMemberSeq(auth);
	}

}
