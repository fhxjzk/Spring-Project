package com.project.app.expert.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.project.app.auth.CustomUser;
import com.project.app.expert.model.ExpertCareerDto;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.model.ExpertTalentDto;
import com.project.app.expert.service.ExpertService;
import com.project.app.review.model.ReviewDto;
import com.project.app.review.model.ReviewSummaryDto;
import com.project.app.review.service.ReviewService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ExpertController {
	private final ExpertService expertService;
	private final ReviewService reviewService;
	
	@GetMapping(value = "/expert/view.do")
	public String view(@RequestParam("expertSeq") Long expertSeq, Model model, Authentication auth) {
		
		ExpertProfileDto edto = expertService.getProfile(expertSeq);

		//경력 목록
		List<ExpertCareerDto> careerList = expertService.getCareerList(expertSeq);

		//활동 가능 지역 이름
		List<String> regionNameList = expertService.getRegionNameList(expertSeq);

		//제공 서비스, 포트폴리오
		List<ExpertTalentDto> talentList = expertService.getTalentList(expertSeq);
		List<ExpertPortfolioDto> portfolioList = expertService.getPortfolioList(expertSeq);

		//프로필 화면에 띄울 리뷰 최신순으로 5개만 가져오기
		List<ReviewDto> reviewList = reviewService.getRecentReviewList(expertSeq);
		
		//리뷰 갯수, 평균 별점 가져오기
		ReviewSummaryDto rsdto = reviewService.getReviewSummary(expertSeq);
		
		// 로그인 안한경우 null
		Long memberSeq = null;
		
		if (auth != null) {
			memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();
		}
		boolean isOwner = expertService.ownerCheck(memberSeq, expertSeq);
		
		model.addAttribute("edto",edto);
		model.addAttribute("careerList",careerList);
		model.addAttribute("regionNameList",regionNameList);
		model.addAttribute("talentList",talentList);
		model.addAttribute("portfolioList",portfolioList);
		model.addAttribute("reviewList",reviewList);
		model.addAttribute("rsdto",rsdto);
		model.addAttribute("isOwner",isOwner);
		
		return "expert/view";
	}
	
}
