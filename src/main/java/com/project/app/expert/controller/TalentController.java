package com.project.app.expert.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.project.app.auth.CustomUser;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.model.ExpertTalentDto;
import com.project.app.expert.service.ExpertService;
import com.project.app.expert.service.TalentService;
import com.project.app.review.model.ReviewSummaryDto;
import com.project.app.review.service.ReviewService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping(value="/expert/talent")
public class TalentController {
	private final TalentService talentService;
	private final ExpertService expertService;
	private final ReviewService reviewService;
	
	@GetMapping(value="/view.do")
	public String viewTalent(@RequestParam("talentSeq") Long talentSeq, Model model, Authentication auth) {
		
		ExpertTalentDto tdto = talentService.getTalent(talentSeq);
		
		if(tdto == null) {
			return "redirect:/index.do";
		}
		
		ExpertProfileDto edto = expertService.getProfile(tdto.getExpertSeq());
		List<ExpertPortfolioDto> plist = talentService.getPortfolioList(talentSeq);
		ReviewSummaryDto rsdto = reviewService.getReviewSummary(tdto.getExpertSeq());

		// 로그인 안한경우 null
		Long memberSeq = null;

		if (auth != null) {
			memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();
		}

		//서비스 주인 = 서비스를 등록한 고수. 본인이면 요청하기 대신 수정 버튼을 보여 준다
		boolean isOwner = expertService.ownerCheck(memberSeq, tdto.getExpertSeq());

		// 신고 처리로 숨김(hidden='Y')된 고수인지. 숨김이면 요청하기, 수정을 막는다
		boolean isHidden = "Y".equals(edto.getHidden());
		
		model.addAttribute("tdto",tdto);
		model.addAttribute("edto",edto);
		model.addAttribute("plist",plist);
		model.addAttribute("rsdto",rsdto);
		model.addAttribute("isOwner",isOwner);
		model.addAttribute("isHidden",isHidden);
		
		return "expert/talent/view";
	}
	
}
