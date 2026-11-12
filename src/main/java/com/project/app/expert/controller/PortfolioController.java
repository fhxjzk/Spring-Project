package com.project.app.expert.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.project.app.auth.CustomUser;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.model.PortfolioImageDto;
import com.project.app.expert.service.ExpertService;
import com.project.app.expert.service.PortfolioService;

import lombok.RequiredArgsConstructor;

/**
 * 포트폴리오 (화면설계서 ②-08 작성, ②-09 상세)
 *
 * URL은 /expert/portfolio/동작.do
 *   - view.do 는 security-context.xml 에서 누구나 (비로그인 포함)
 *   - add.do, addok.do, edit.do, editok.do, delok.do 는 로그인한 회원만 (security-context.xml)
 *     고수인지, 내 글인지는 여기서 직접 확인한다
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/expert/portfolio")
public class PortfolioController {

	private final PortfolioService portfolioService;
	private final ExpertService expertService;

	// 포트폴리오 상세 (②-09)  GET /expert/portfolio/view.do?portfolioSeq=
	@GetMapping(value="/view.do")
	public String viewPortfolio(@RequestParam("portfolioSeq") Long portfolioSeq, Model model, Authentication auth) {
		
		//포폴 글 조회
		ExpertPortfolioDto pdto = portfolioService.getPortfolio(portfolioSeq);
		
		//없는 포폴 번호면 메인으로 보낸다
		if (pdto == null) {
			return "redirect:/index.do";
		}
		
		//포폴에 등록된 사진 목록 조회
		List<PortfolioImageDto> imgList = portfolioService.getPortfolioImages(portfolioSeq);

		// 로그인 안한경우 null
		Long memberSeq = null;

		if (auth != null) {
			memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();
		}

		//포폴 주인 = 글을 쓴 고수 (고수 상세와 같은 비교라 ExpertService 것을 그대로 쓴다)
		boolean isOwner = expertService.ownerCheck(memberSeq, pdto.getExpertSeq());

		model.addAttribute("pdto",pdto);
		model.addAttribute("imgList",imgList);
		model.addAttribute("isOwner",isOwner);

		//이 포트폴리오를 연결한 서비스. 버튼을 누르면 서비스 상세(②-10)로 간다
		model.addAttribute("talentList",portfolioService.getLinkedTalentList(portfolioSeq));
		
		return "expert/portfolio/view";
	}
	
	

	// 작성 화면 (②-08)  GET /expert/portfolio/add.do
	// 버튼은 본인 프로필에만 보이지만, 주소를 직접 치고 들어올 수 있어서 여기서도 막는다
	@GetMapping(value="/add.do")
	public String add(Model model, Authentication auth) {

		//add.do 는 permitAll 이 아니라서 비로그인은 여기까지 못 오지만, 혹시 몰라 한 번 더 확인
		if (auth == null) {
			return "redirect:/index.do";
		}

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		if (!canWrite(memberSeq)) {
			return "redirect:/index.do";
		}

		//취소 버튼에서 내 프로필로 돌아갈 때 쓴다
		model.addAttribute("expertSeq", memberSeq);

		return "expert/portfolio/add";
	}

	// 작성 처리  POST /expert/portfolio/addok.do
	@PostMapping(value="/addok.do")
	public String addok(Model model, ExpertPortfolioDto dto,
			@RequestParam(value = "images", required = false) List<MultipartFile> images,
			Authentication auth, HttpServletRequest req) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		//화면을 거치지 않고 바로 POST 해도 막는다
		if (!canWrite(memberSeq)) {
			return "redirect:/index.do";
		}

		//작성자 번호는 폼에서 받지 않고 로그인 정보로 넣는다
		dto.setExpertSeq(memberSeq);

		int result = portfolioService.add(dto, images, getUploadPath(req));

		model.addAttribute("result", result);
		model.addAttribute("portfolioSeq", dto.getPortfolioSeq());

		return "expert/portfolio/addok";
	}

	// 수정 화면  GET /expert/portfolio/edit.do?portfolioSeq=
	@GetMapping(value="/edit.do")
	public String edit(@RequestParam("portfolioSeq") Long portfolioSeq, Model model, Authentication auth) {

		ExpertPortfolioDto pdto = portfolioService.getPortfolio(portfolioSeq);
		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		//없는 글이거나 내 글이 아니면 못 들어온다
		if (pdto == null || !expertService.ownerCheck(memberSeq, pdto.getExpertSeq()) || !canWrite(memberSeq)) {
			return "redirect:/index.do";
		}

		model.addAttribute("pdto", pdto);
		model.addAttribute("imgList", portfolioService.getPortfolioImages(portfolioSeq));

		return "expert/portfolio/edit";
	}

	// 수정 처리  POST /expert/portfolio/editok.do
	@PostMapping(value="/editok.do")
	public String editok(Model model, ExpertPortfolioDto dto,
			@RequestParam(value = "images", required = false) List<MultipartFile> images,
			Authentication auth, HttpServletRequest req) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		//hidden 으로 온 portfolioSeq 는 바꿔서 보낼 수 있으니, DB의 글로 다시 확인한다
		ExpertPortfolioDto original = dto.getPortfolioSeq() == null ? null : portfolioService.getPortfolio(dto.getPortfolioSeq());

		if (original == null || !expertService.ownerCheck(memberSeq, original.getExpertSeq()) || !canWrite(memberSeq)) {
			return "redirect:/index.do";
		}

		dto.setExpertSeq(memberSeq);

		int result = portfolioService.edit(dto, images, getUploadPath(req));

		model.addAttribute("result", result);
		model.addAttribute("portfolioSeq", dto.getPortfolioSeq());

		return "expert/portfolio/editok";
	}

	// 삭제 처리  POST /expert/portfolio/delok.do
	// 확인 창은 상세 화면의 confirm 으로 띄워서 del.do 화면은 따로 없다
	@PostMapping(value="/delok.do")
	public String delok(@RequestParam("portfolioSeq") Long portfolioSeq, Authentication auth, HttpServletRequest req) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		ExpertPortfolioDto pdto = portfolioService.getPortfolio(portfolioSeq);

		//없는 글이거나 내 글이 아니면 못 지운다
		if (pdto == null || !expertService.ownerCheck(memberSeq, pdto.getExpertSeq()) || !canWrite(memberSeq)) {
			return "redirect:/index.do";
		}

		portfolioService.delete(pdto, getUploadPath(req));

		return "redirect:/expert/view.do?expertSeq=" + memberSeq;
	}

	//고수 프로필이 있고 숨김 처리되지 않았으면 작성·수정·삭제할 수 있다 (고수 프로필 번호 = 회원 번호)
	private boolean canWrite(Long memberSeq) {

		ExpertProfileDto edto = expertService.getProfile(memberSeq);

		return edto != null && !"Y".equals(edto.getHidden());
	}

	//resources/upload/portfolio 의 실제 경로 (CONVENTION.md "업로드 파일")
	private String getUploadPath(HttpServletRequest req) {

		return req.getServletContext().getRealPath("/resources/upload/portfolio");
	}

}
