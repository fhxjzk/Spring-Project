package com.project.app.expert.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.project.app.expert.service.PortfolioService;

import lombok.RequiredArgsConstructor;

/**
 * 포트폴리오 (화면설계서 ②-08 작성, ②-09 상세)
 *
 * URL은 /expert/portfolio/동작.do
 *   - view.do 는 security-context.xml 에서 누구나 (비로그인 포함)
 *   - add.do, addok.do 는 로그인한 회원만. 고수만 들어오게 하려면 담당자에게 요청
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/expert/portfolio")
public class PortfolioController {

	private final PortfolioService portfolioService;

	// TODO 상세 (②-09)  GET /expert/portfolio/view.do?portfolioSeq=
	//  1. 포트폴리오 글 하나 조회 → null이면 redirect (없는 번호)
	//  2. 사진 목록 조회 (slot 순서)
	//  3. 작성한 고수 본인인지 확인 (본인이면 수정·삭제 버튼)
	//  4. Model에 담고 "expert/portfolio/view" 반환
	@RequestMapping(value="/view.do")
	public String viewPortfolio(@RequestParam("portfolioSeq") long portfolioSeq, Model model) {
		
		
		
		return "/expert/portfolio/view";
	}
	
	

	// TODO 작성 화면 (②-08)  GET /expert/portfolio/add.do
	//  - 작성 폼만 보여 준다


	// TODO 작성 처리  POST /expert/portfolio/addok.do
	//  - 작성자 번호는 폼에서 받지 말고 로그인 정보(Authentication)에서 꺼낸다
	//  - 사진은 MultipartFile (최대 5장)
	//  - 끝나면 작성한 포트폴리오 상세로 redirect

}
