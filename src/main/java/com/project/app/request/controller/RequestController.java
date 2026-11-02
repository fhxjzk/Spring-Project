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
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/request")
public class RequestController {

	private final RequestService requestService;

	//공개 요청서 작성 화면 (C-01-a)
	@GetMapping(value = "/add.do")
	public String add(Model model, Authentication auth) {

		Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();

		model.addAttribute("parentList", requestService.parentCategoryList());
		model.addAttribute("address", requestService.getMemberAddress(memberSeq));

		return "request/add";
	}

	//공개 요청서 등록 처리
	@PostMapping(value = "/addok.do")
	public String addok(Model model, RequestDto dto,
			@RequestParam MultiValueMap<String, String> params,
			@RequestParam(value = "files", required = false) List<MultipartFile> files,
			Authentication auth, HttpServletRequest req) {

		dto.setCustomerSeq(((CustomUser) auth.getPrincipal()).getMemberSeq());

		String uploadPath = req.getServletContext().getRealPath("/resources/upload/request");

		int result = requestService.add(dto, params, files, uploadPath);

		model.addAttribute("result", result);

		return "request/addok";
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

}
