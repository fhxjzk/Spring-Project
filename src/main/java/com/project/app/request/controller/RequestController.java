package com.project.app.request.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.app.auth.CustomUser;
import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.RequestCategoryDto;
import com.project.app.request.model.RequestDto;
import com.project.app.request.service.RequestService;

import lombok.RequiredArgsConstructor;

/**
 * 요청서 (③ 요청서·견적)
 *
 * /request/add*.do 는 고객만 들어올 수 있다. (security-context.xml)
 * 로그인하지 않고 고수 상세에서 '요청하기'를 누르면, 로그인한 뒤 다시 이 주소로 돌아온다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/request")
public class RequestController {

	private final RequestService requestService;

	/**
	 * 요청서 작성 화면
	 *
	 * add.do                  : 공개 요청서 (C-01-a). 대분류 → 소분류를 고른다.
	 * add.do?expertSeq=고수번호 : 지정 요청서 (C-01-b). 고수 상세의 '요청하기'로 들어온다. 그 고수의 서비스 중에서 고른다.
	 */
	@GetMapping(value = "/add.do")
	public String add(Model model, Authentication auth,
			@RequestParam(value = "expertSeq", required = false) Long expertSeq) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		if (expertSeq != null) {

			String expertName = requestService.getExpertName(expertSeq);

			//없는 고수, 탈퇴한 고수, 숨김 처리된 고수
			if (expertName == null) {
				model.addAttribute("result", -3);
				return "request/addok";
			}

			List<RequestCategoryDto> categoryList = requestService.expertCategoryList(expertSeq);

			//아직 등록한 서비스가 없는 고수
			if (categoryList.isEmpty()) {
				model.addAttribute("result", -5);
				return "request/addok";
			}

			model.addAttribute("expertSeq", expertSeq);
			model.addAttribute("expertName", expertName);
			model.addAttribute("categoryList", categoryList);

		} else {
			model.addAttribute("parentList", requestService.parentCategoryList());
		}

		model.addAttribute("address", requestService.getDefaultAddress(memberSeq));

		return "request/add";
	}

	//요청서 등록 처리 (공개·지정 모두)
	@PostMapping(value = "/addok.do")
	public String addok(Model model, RequestDto dto,
			@RequestParam MultiValueMap<String, String> params,
			@RequestParam(value = "files", required = false) List<MultipartFile> files,
			Authentication auth, HttpServletRequest req) {

		dto.setCustomerSeq(((CustomUser) auth.getPrincipal()).getMemberSeq());

		String uploadPath = req.getServletContext().getRealPath("/resources/upload/request");

		int result = requestService.add(dto, params, files, uploadPath);

		model.addAttribute("result", result);
		model.addAttribute("expertSeq", dto.getExpertSeq());

		return "request/addok";
	}

	//내 요청서 목록 (C-01-d). status로 상태별 보기
	@GetMapping(value = "/mylist.do")
	public String mylist(Model model, Authentication auth,
			@RequestParam(value = "status", required = false) String status) {

		model.addAttribute("list", requestService.myList(getMemberSeq(auth), status));
		model.addAttribute("status", status);

		return "request/mylist";
	}

	//내 요청서 상세. 다른 사람 요청서면 목록으로 돌려보낸다
	@GetMapping(value = "/myview.do")
	public String myview(Model model, Authentication auth, RedirectAttributes rttr,
			@RequestParam(value = "requestSeq", required = false) Long requestSeq) {

		RequestDto dto = requestService.getMine(requestSeq, getMemberSeq(auth));

		if (dto == null) {
			rttr.addFlashAttribute("msg", "요청서를 찾을 수 없습니다.");
			return "redirect:/request/mylist.do";
		}

		model.addAttribute("dto", dto);
		model.addAttribute("answerList", requestService.answerList(requestSeq));
		model.addAttribute("fileList", requestService.fileList(requestSeq));
		model.addAttribute("quoteList", requestService.quoteList(requestSeq));

		return "request/myview";
	}

	//요청서 취소 (고수를 고르기 전에만)
	@PostMapping(value = "/cancel.do")
	public String cancel(Authentication auth, RedirectAttributes rttr,
			@RequestParam(value = "requestSeq") Long requestSeq) {

		int result = requestService.cancel(requestSeq, getMemberSeq(auth));

		rttr.addFlashAttribute("msg", result == 1 ? "요청서를 취소했습니다." : "취소할 수 없는 요청서입니다.");

		return "redirect:/request/myview.do?requestSeq=" + requestSeq;
	}

	//대분류의 소분류 목록 (Ajax)
	@GetMapping(value = "/category.do")
	@ResponseBody
	public List<RequestCategoryDto> category(Long parentSeq) {

		return requestService.childCategoryList(parentSeq);
	}

	//카테고리의 질문 항목과 보기 (Ajax)
	@GetMapping(value = "/question.do")
	@ResponseBody
	public List<QuestionDto> question(Long categorySeq) {

		return requestService.questionList(categorySeq);
	}

	//로그인한 회원 번호
	private Long getMemberSeq(Authentication auth) {

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

}
