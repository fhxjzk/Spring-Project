package com.project.app;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.project.app.auth.CustomUser;
import com.project.app.board.model.BoardPageDto;
import com.project.app.board.service.BoardService;
import com.project.app.category.service.CategoryService;
import com.project.app.category.model.CategoryDto;
import com.project.app.expert.model.ExpertCardDto;
import com.project.app.expert.service.ExpertService;
import com.project.app.review.model.ReviewDto;
import com.project.app.review.service.ReviewService;
import com.project.app.search.model.RegionDto;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {

	private final CategoryService categoryService;
	private final ExpertService expertService;
	private final ReviewService reviewService;
	private final BoardService boardService;

	//메인에 보여 줄 커뮤니티 글 수
	private static final int BOARD_SIZE = 5;
	
	@GetMapping(value = "/")
	public String root() {

		return "redirect:/index.do";
	}

	//메인 페이지 (화면 구성은 ② 담당)
	@GetMapping(value = "/index.do")
	public String index(Model model, Authentication auth) {
		
		List<CategoryDto> clist = categoryService.getTopCategory();
		model.addAttribute("clist",clist);

		//카드에 마우스를 올리거나 누르면 뜨는 소분류 목록
		model.addAttribute("subList", categoryService.getSubCategoryList());

		List<ExpertCardDto> expertList = expertService.getPopularExpertList();
		model.addAttribute("expertList", expertList);

		List<ReviewDto> reviewList = reviewService.getLatestReviewList();
		model.addAttribute("reviewList", reviewList);

		addBoardList(model, auth);

		return "index";
	}

	//커뮤니티 최근 글 5개 (②-01). 동네 게시판(⑥) 목록을 그대로 쓴다
	//회원은 가입 주소의 동네, 비회원이나 주소가 없으면 서울 (게시판 첫 화면과 같은 기준)
	private void addBoardList(Model model, Authentication auth) {

		int regionSeq = boardService.getDefaultRegion(getMemberSeq(auth));

		BoardPageDto page = new BoardPageDto();
		page.setRegionSeq(regionSeq);
		page.setPage(1);
		page.setSize(BOARD_SIZE);

		model.addAttribute("boardList", boardService.getList(page));
		model.addAttribute("boardRegionSeq", regionSeq);

		//제목 "서울 커뮤니티 최근 글"에 쓸 지역 이름. 글이 없어도 이름은 보여야 해서 지역 목록에서 찾는다
		for (RegionDto region : boardService.getRegionList()) {
			if (region.getRegionSeq() == regionSeq) {
				model.addAttribute("boardRegionName", region.getRegionName());
				break;
			}
		}
	}

	//비회원이면 auth 가 null 이거나 principal 이 "anonymousUser" 문자열이라 CustomUser 인지 확인한다
	private Long getMemberSeq(Authentication auth) {

		if (auth == null || !(auth.getPrincipal() instanceof CustomUser)) {
			return null;
		}

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

}
