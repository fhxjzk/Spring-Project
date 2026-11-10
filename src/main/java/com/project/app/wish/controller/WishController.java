package com.project.app.wish.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.app.auth.CustomUser;
import com.project.app.expert.model.ExpertCardDto;
import com.project.app.wish.service.WishService;

import lombok.RequiredArgsConstructor;

/**
 * 찜하기 (추가 기능)
 *
 *   - toggle.do : 고수 상세의 하트 버튼 (Ajax). 찜 ↔ 찜 해제
 *   - delete.do : 찜한 고수 목록의 ♥ 버튼 (Ajax). 찜 해제만
 *   - mylist.do : 내가 찜한 고수 목록
 *   - mycard.do : 마이페이지 "찜한 고수" 카드 내용 (wish/mypage-card.jsp 가 불러간다)
 * 모두 로그인한 회원만 (security-context.xml 의 /**), 고객인지는 여기서 확인한다
 * (목록 주소를 list.do 로 하면 /**\/list.do 가 누구나 볼 수 있게 열려 있어서 mylist.do 로 했다)
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/wish")
public class WishController {

	private final WishService wishService;

	//찜 ↔ 찜 해제 (Ajax). 바뀐 찜 상태와 찜 수를 JSON 으로 돌려준다
	@PostMapping(value = "/toggle.do")
	@ResponseBody
	public Map<String, Object> toggle(Authentication auth, @RequestParam(value = "expertSeq") Long expertSeq) {

		Map<String, Object> map = new HashMap<>();

		if (!isCustomer(auth)) {
			map.put("success", false);
			map.put("message", "찜은 고객 회원만 할 수 있어요.");
			return map;
		}

		int result = wishService.toggle(((CustomUser) auth.getPrincipal()).getMemberSeq(), expertSeq);

		map.put("success", result >= 0);
		map.put("wished", result == 1);
		map.put("count", wishService.countWish(expertSeq));

		if (result < 0) {
			map.put("message", "찜할 수 없는 고수예요.");
		}

		return map;
	}

	//찜 해제만 (Ajax). 찜한 고수 목록의 ♥ 버튼. 이미 해제된 고수여도 성공으로 본다 (다른 창에서 먼저 해제한 경우)
	@PostMapping(value = "/delete.do")
	@ResponseBody
	public Map<String, Object> delete(Authentication auth, @RequestParam(value = "expertSeq") Long expertSeq) {

		Map<String, Object> map = new HashMap<>();

		if (!isCustomer(auth)) {
			map.put("success", false);
			map.put("message", "찜은 고객 회원만 할 수 있어요.");
			return map;
		}

		wishService.delete(((CustomUser) auth.getPrincipal()).getMemberSeq(), expertSeq);
		map.put("success", true);

		return map;
	}

	//내가 찜한 고수 목록
	@GetMapping(value = "/mylist.do")
	public String mylist(Model model, Authentication auth) {

		//고수, 관리자는 찜이 없으니 메인으로 보낸다
		if (!isCustomer(auth)) {
			return "redirect:/index.do";
		}

		model.addAttribute("wishList", wishService.getWishList(((CustomUser) auth.getPrincipal()).getMemberSeq()));

		return "wish/mylist";
	}

	/**
	 * 마이페이지의 "찜한 고수" 카드 내용 (HTML 조각).
	 * 마이페이지에 include 한 wish/mypage-card.jsp 가 화면이 뜬 뒤 이 주소를 불러와서 카드 안에 넣는다.
	 * 그래서 마이페이지(MemberController)는 찜 목록을 넘기지 않아도 된다.
	 * 최근에 찜한 3명 + 전체 수. 고객이 아니면 빈 목록
	 * 주소창에 직접 치고 들어오면 스타일 없는 조각만 보여서, 찜한 고수 목록 화면으로 보낸다
	 * (jQuery .load() 는 X-Requested-With: XMLHttpRequest 헤더를 붙인다)
	 */
	@GetMapping(value = "/mycard.do")
	public String mycard(Model model, Authentication auth,
			@RequestHeader(value = "X-Requested-With", required = false) String requestedWith) {

		if (!"XMLHttpRequest".equals(requestedWith)) {
			return "redirect:/wish/mylist.do";
		}

		List<ExpertCardDto> wishList = isCustomer(auth)
				? wishService.getWishList(((CustomUser) auth.getPrincipal()).getMemberSeq())
				: new ArrayList<>();

		model.addAttribute("previewList", wishList.subList(0, Math.min(3, wishList.size())));
		model.addAttribute("total", wishList.size());

		return "wish/mycard";
	}

	//고객으로 가입한 회원인지
	private boolean isCustomer(Authentication auth) {

		if (auth == null || !(auth.getPrincipal() instanceof CustomUser)) {
			return false;
		}

		return "ROLE_CUSTOMER".equals(((CustomUser) auth.getPrincipal()).getDto().getRole());
	}

}
