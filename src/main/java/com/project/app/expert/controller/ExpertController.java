package com.project.app.expert.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.project.app.auth.CustomUser;
import com.project.app.expert.model.ExpertCareerDto;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.model.ExpertTalentDto;
import com.project.app.expert.service.ExpertService;
import com.project.app.review.model.ReviewDto;
import com.project.app.review.model.ReviewSummaryDto;
import com.project.app.review.service.ReviewService;
import com.project.app.search.service.SearchService;
import com.project.app.wish.service.WishService;

import lombok.RequiredArgsConstructor;

/**
 * 고수 상세 (②-04), 고수 프로필 작성·수정 (②-02)
 *
 *   - view.do 는 security-context.xml 에서 누구나 (비로그인 포함)
 *   - add.do, addok.do, edit.do, editok.do 는 로그인한 회원만 (security-context.xml)
 *     고수 회원인지는 여기서 직접 확인한다
 */
@Controller
@RequiredArgsConstructor
public class ExpertController {
	private final ExpertService expertService;
	private final ReviewService reviewService;
	private final WishService wishService;

	//활동 가능 지역 체크박스 (⑥ 지역 17개)
	private final SearchService searchService;

	//카카오맵 자바스크립트 키 (secret.properties). 없으면 빈 값으로 두고 지도만 안 뜬다
	@Value("${kakao.js.key:}")
	private String kakaoJsKey;

	@GetMapping(value = "/expert/view.do")
	public String view(@RequestParam("expertSeq") Long expertSeq, Model model, Authentication auth) {

		ExpertProfileDto edto = expertService.getProfile(expertSeq);


		//TODO 공용 에러 페이지가 있을경우 해당 경로로 redirect 하기
		if(edto == null) {
			return "redirect:/index.do";
		}

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

		// 신고 처리로 숨김(hidden='Y')된 고수인지. 숨김이면 요청하기, 수정하기를 막는다
		boolean isHidden = "Y".equals(edto.getHidden());

		//찜 (추가 기능). 하트 버튼은 고객에게만 보이고, 숨김 고수는 새로 찜할 수 없다. 찜 수는 누구에게나 보인다
		boolean canWish = isCustomer(auth) && !isHidden;
		boolean isWished = wishService.isWished(memberSeq, expertSeq);
		int wishCount = wishService.countWish(expertSeq);

		model.addAttribute("edto",edto);
		model.addAttribute("careerList",careerList);
		model.addAttribute("regionNameList",regionNameList);
		model.addAttribute("talentList",talentList);
		model.addAttribute("portfolioList",portfolioList);
		model.addAttribute("reviewList",reviewList);
		model.addAttribute("rsdto",rsdto);
		model.addAttribute("isOwner",isOwner);
		model.addAttribute("isHidden",isHidden);
		model.addAttribute("canWish",canWish);
		model.addAttribute("isWished",isWished);
		model.addAttribute("wishCount",wishCount);

		return "expert/view";
	}

	// 내 프로필 (②-02)  GET /expert/my.do
	// 헤더의 [내 프로필]이 여기로 온다. 프로필이 있으면 내 고수 상세로, 없으면 작성 안내 화면을 보여 준다
	@GetMapping(value = "/expert/my.do")
	public String my(Authentication auth) {

		//고객, 관리자는 고수 프로필이 없으니 메인으로 보낸다
		if (!isExpertMember(auth)) {
			return "redirect:/index.do";
		}

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		if (expertService.getProfile(memberSeq) != null) {
			return "redirect:/expert/view.do?expertSeq=" + memberSeq;
		}

		return "expert/my";
	}

	// 프로필 작성 화면 (②-02)  GET /expert/add.do
	@GetMapping(value = "/expert/add.do")
	public String add(Model model, Authentication auth) {

		if (!isExpertMember(auth)) {
			return "redirect:/index.do";
		}

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		//이미 프로필이 있으면 작성이 아니라 수정으로 보낸다 (프로필은 한 명당 하나)
		if (expertService.getProfile(memberSeq) != null) {
			return "redirect:/expert/edit.do";
		}

		addFormData(model);

		return "expert/add";
	}

	// 프로필 작성 처리  POST /expert/addok.do
	// imageFile: 프로필 사진. DTO 의 profileImage(String)와 이름이 겹치지 않게 따로 받는다
	@PostMapping(value = "/expert/addok.do")
	public String addok(Model model, ExpertProfileDto dto,
			@RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
			Authentication auth, HttpServletRequest req) {

		//화면을 거치지 않고 바로 POST 해도 막는다
		if (!isExpertMember(auth)) {
			return "redirect:/index.do";
		}

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		//프로필 번호(= 회원 번호)는 폼에서 받지 않고 로그인 정보로 넣는다
		dto.setExpertSeq(memberSeq);

		model.addAttribute("result", expertService.add(dto, imageFile, getUploadPath(req)));
		model.addAttribute("expertSeq", memberSeq);

		return "expert/addok";
	}

	// 프로필 수정 화면  GET /expert/edit.do
	// 내 프로필만 수정하므로 번호를 받지 않는다
	@GetMapping(value = "/expert/edit.do")
	public String edit(Model model, Authentication auth) {

		if (!isExpertMember(auth)) {
			return "redirect:/index.do";
		}

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();
		ExpertProfileDto edto = expertService.getProfile(memberSeq);

		//프로필이 없으면 작성으로 보낸다
		if (edto == null) {
			return "redirect:/expert/add.do";
		}

		//신고 처리로 숨김된 고수는 수정할 수 없다 (고수 상세의 버튼도 막혀 있다)
		if ("Y".equals(edto.getHidden())) {
			return "redirect:/expert/view.do?expertSeq=" + memberSeq;
		}

		addFormData(model);

		model.addAttribute("edto", edto);
		model.addAttribute("careerList", expertService.getCareerList(memberSeq));

		//전에 체크해 둔 활동 가능 지역 (체크박스에 표시)
		model.addAttribute("myRegionSeqs", searchService.getRegionSeqListByExpert(memberSeq));

		return "expert/edit";
	}

	// 프로필 수정 처리  POST /expert/editok.do
	@PostMapping(value = "/expert/editok.do")
	public String editok(Model model, ExpertProfileDto dto,
			@RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
			Authentication auth, HttpServletRequest req) {

		if (!isExpertMember(auth)) {
			return "redirect:/index.do";
		}

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();
		ExpertProfileDto original = expertService.getProfile(memberSeq);

		if (original != null && "Y".equals(original.getHidden())) {
			return "redirect:/expert/view.do?expertSeq=" + memberSeq;
		}

		//폼에 번호를 넣지 않고 로그인 정보로 넣어서, 남의 프로필을 고칠 수 없다
		dto.setExpertSeq(memberSeq);

		model.addAttribute("result", expertService.edit(dto, imageFile, getUploadPath(req)));
		model.addAttribute("expertSeq", memberSeq);

		return "expert/editok";
	}

	//작성·수정 화면이 같이 쓰는 값: 지역 체크박스, 카카오맵 키
	private void addFormData(Model model) {

		model.addAttribute("regionList", searchService.getRegionList());
		model.addAttribute("kakaoJsKey", kakaoJsKey);
	}

	//고수로 가입한 회원인지. 고객도 로그인은 되어 있어서 주소를 직접 치면 들어올 수 있으므로 역할을 확인한다
	private boolean isExpertMember(Authentication auth) {

		if (auth == null || !(auth.getPrincipal() instanceof CustomUser)) {
			return false;
		}

		return "ROLE_EXPERT".equals(((CustomUser) auth.getPrincipal()).getDto().getRole());
	}

	//고객으로 가입한 회원인지. 찜 버튼을 보일지 정한다
	private boolean isCustomer(Authentication auth) {

		if (auth == null || !(auth.getPrincipal() instanceof CustomUser)) {
			return false;
		}

		return "ROLE_CUSTOMER".equals(((CustomUser) auth.getPrincipal()).getDto().getRole());
	}

	//resources/upload/profile 의 실제 경로 (CONVENTION.md "업로드 파일")
	private String getUploadPath(HttpServletRequest req) {

		return req.getServletContext().getRealPath("/resources/upload/profile");
	}

}
