package com.project.app.expert.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.project.app.auth.CustomUser;
import com.project.app.category.service.CategoryService;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.model.ExpertTalentDto;
import com.project.app.expert.service.ExpertService;
import com.project.app.expert.service.TalentService;
import com.project.app.review.model.ReviewSummaryDto;
import com.project.app.review.service.ReviewService;

import lombok.RequiredArgsConstructor;

/**
 * 제공 서비스 (화면설계서 ②-03 등록·수정·삭제, ②-10 상세)
 *
 * URL은 /expert/talent/동작.do
 *   - view.do 는 security-context.xml 에서 누구나 (비로그인 포함)
 *   - add.do, addok.do, edit.do, editok.do, delok.do 는 로그인한 회원만 (security-context.xml)
 *     고수인지, 내 서비스인지는 여기서 직접 확인한다
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value="/expert/talent")
public class TalentController {
	private final TalentService talentService;
	private final ExpertService expertService;
	private final ReviewService reviewService;
	private final CategoryService categoryService;
	
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
		
		// 보는 사람이 고수 회원인지. 고수는 다른 고수에게 요청을 보낼 수 없어서 요청하기를 숨긴다 (/request/add*.do 는 고객만)
		boolean isExpertViewer = auth != null && auth.getPrincipal() instanceof CustomUser
				&& "ROLE_EXPERT".equals(((CustomUser) auth.getPrincipal()).getDto().getRole());

		model.addAttribute("tdto",tdto);
		model.addAttribute("edto",edto);
		model.addAttribute("plist",plist);
		model.addAttribute("rsdto",rsdto);
		model.addAttribute("isOwner",isOwner);
		model.addAttribute("isHidden",isHidden);
		model.addAttribute("isExpertViewer",isExpertViewer);
		
		return "expert/talent/view";
	}

	// 등록 화면 + 내 서비스 목록 (②-03)  GET /expert/talent/add.do
	// 버튼은 본인 프로필에만 보이지만, 주소를 직접 치고 들어올 수 있어서 여기서도 막는다
	@GetMapping(value="/add.do")
	public String add(Model model, Authentication auth) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		if (!canWrite(memberSeq)) {
			return "redirect:/index.do";
		}

		addFormData(model, memberSeq);

		//아래쪽 "등록된 서비스" 표
		model.addAttribute("talentList", expertService.getTalentList(memberSeq));

		return "expert/talent/add";
	}

	// 등록 처리  POST /expert/talent/addok.do
	// portfolioSeqs: 화면에서 고른 순서대로 온다. 이 순서가 slot 1 ~ 3 이 된다
	@PostMapping(value="/addok.do")
	public String addok(Model model, ExpertTalentDto dto,
			@RequestParam(value = "portfolioSeqs", required = false) List<Long> portfolioSeqs,
			Authentication auth) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		//화면을 거치지 않고 바로 POST 해도 막는다
		if (!canWrite(memberSeq)) {
			return "redirect:/index.do";
		}

		//고수 번호는 폼에서 받지 않고 로그인 정보로 넣는다
		dto.setExpertSeq(memberSeq);

		model.addAttribute("result", talentService.add(dto, portfolioSeqs));

		//등록이 끝나면 내 프로필로 돌아갈 때 쓴다
		model.addAttribute("expertSeq", memberSeq);

		return "expert/talent/addok";
	}

	// 수정 화면  GET /expert/talent/edit.do?talentSeq=
	@GetMapping(value="/edit.do")
	public String edit(@RequestParam("talentSeq") Long talentSeq, Model model, Authentication auth) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		ExpertTalentDto tdto = talentService.getTalent(talentSeq);

		//없거나 삭제된 서비스, 내 서비스가 아니면 못 들어온다
		if (!canChange(tdto, memberSeq)) {
			return "redirect:/index.do";
		}

		addFormData(model, memberSeq);

		model.addAttribute("tdto", tdto);

		//이미 연결한 포트폴리오. 화면에서 처음부터 골라 둔 상태로 보여 준다 (slot 순서)
		model.addAttribute("plist", talentService.getPortfolioList(talentSeq));

		return "expert/talent/edit";
	}

	// 수정 처리  POST /expert/talent/editok.do
	@PostMapping(value="/editok.do")
	public String editok(Model model, ExpertTalentDto dto,
			@RequestParam(value = "portfolioSeqs", required = false) List<Long> portfolioSeqs,
			Authentication auth) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		//hidden 으로 온 talentSeq 는 바꿔서 보낼 수 있으니, DB의 서비스로 다시 확인한다
		ExpertTalentDto original = dto.getTalentSeq() == null ? null : talentService.getTalent(dto.getTalentSeq());

		if (!canChange(original, memberSeq)) {
			return "redirect:/index.do";
		}

		dto.setExpertSeq(memberSeq);

		model.addAttribute("result", talentService.edit(dto, portfolioSeqs));
		model.addAttribute("talentSeq", dto.getTalentSeq());

		return "expert/talent/editok";
	}

	// 삭제 처리  POST /expert/talent/delok.do
	// 확인 창은 목록, 서비스 상세의 confirm 으로 띄워서 del.do 화면은 따로 없다
	// 삭제 후에는 내 고수 상세로 돌아간다 (화면설계서 ②-10). 서비스 등록 화면의 표에서 지워도 같다
	@PostMapping(value="/delok.do")
	public String delok(@RequestParam("talentSeq") Long talentSeq, Authentication auth) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		ExpertTalentDto tdto = talentService.getTalent(talentSeq);

		if (!canChange(tdto, memberSeq)) {
			return "redirect:/index.do";
		}

		talentService.delete(tdto);

		return "redirect:/expert/view.do?expertSeq=" + memberSeq;
	}

	//등록, 수정 화면이 같이 쓰는 값: 대분류 셀렉트박스, 고를 수 있는 내 포트폴리오 카드
	private void addFormData(Model model, Long memberSeq) {

		model.addAttribute("expertSeq", memberSeq);
		model.addAttribute("topCategoryList", categoryService.getTopCategory());
		model.addAttribute("portfolioList", expertService.getPortfolioList(memberSeq));
	}

	//고수 프로필이 있고 숨김 처리되지 않았으면 등록·수정·삭제할 수 있다 (고수 프로필 번호 = 회원 번호)
	private boolean canWrite(Long memberSeq) {

		ExpertProfileDto edto = expertService.getProfile(memberSeq);

		return edto != null && !"Y".equals(edto.getHidden());
	}

	//있는 서비스이고, 내 서비스이고, 숨김 고수가 아니면 수정·삭제할 수 있다
	private boolean canChange(ExpertTalentDto tdto, Long memberSeq) {

		return tdto != null && expertService.ownerCheck(memberSeq, tdto.getExpertSeq()) && canWrite(memberSeq);
	}

}
