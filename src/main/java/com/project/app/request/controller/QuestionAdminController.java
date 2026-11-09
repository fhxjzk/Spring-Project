package com.project.app.request.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.QuestionOptionDto;
import com.project.app.request.model.RequestCategoryDto;
import com.project.app.request.service.QuestionService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 요청서 질문 관리 (③ E-04)
 *
 * /admin/** 은 ROLE_ADMIN 만 들어올 수 있다 (security-context.xml)
 * 여기서 등록한 질문이 고객 요청서 작성 화면(C-01)에 나온다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/admin/question")
public class QuestionAdminController {

	private final QuestionService questionService;

	//카테고리(소분류)를 고르면 그 카테고리의 질문 목록을 보여 준다
	@GetMapping(value = "/list.do")
	public String list(Model model, @RequestParam(value = "categorySeq", required = false) Long categorySeq) {

		List<RequestCategoryDto> categoryList = questionService.subCategoryList();

		//처음 들어오면 첫 번째 소분류를 보여 준다
		if (categorySeq == null && !categoryList.isEmpty()) {
			categorySeq = categoryList.get(0).getCategorySeq();
		}

		RequestCategoryDto category = questionService.getSubCategory(categorySeq);

		model.addAttribute("categoryList", categoryList);
		model.addAttribute("category", category);

		if (category != null) {
			model.addAttribute("list", questionService.list(category.getCategorySeq()));
		}

		return "admin/question/list";
	}

	//질문 등록 화면
	@GetMapping(value = "/add.do")
	public String add(Model model, RedirectAttributes rttr, @RequestParam(value = "categorySeq") Long categorySeq) {

		RequestCategoryDto category = questionService.getSubCategory(categorySeq);

		if (category == null) {
			rttr.addFlashAttribute("msg", "없는 카테고리입니다.");
			return "redirect:/admin/question/list.do";
		}

		model.addAttribute("category", category);

		return "admin/question/form";	//등록·수정이 같은 화면을 쓴다 (dto 가 없으면 등록)
	}

	@PostMapping(value = "/addok.do")
	public String addok(QuestionDto dto, BindingResult bindingResult, RedirectAttributes rttr,
			@RequestParam MultiValueMap<String, String> params) {

		List<QuestionOptionDto> options = toOptions(params);
		int result = (bindingResult.hasErrors() || options == null) ? 0 : questionService.add(dto, options);

		if (result != 1) {
			rttr.addFlashAttribute("msg", getMessage(result));
			return "redirect:/admin/question/add.do?categorySeq=" + dto.getCategorySeq();
		}

		rttr.addFlashAttribute("msg", "질문을 등록했습니다.");

		return "redirect:/admin/question/list.do?categorySeq=" + dto.getCategorySeq();
	}

	//질문 수정 화면
	@GetMapping(value = "/edit.do")
	public String edit(Model model, RedirectAttributes rttr, @RequestParam(value = "questionSeq") Long questionSeq) {

		QuestionDto dto = questionService.get(questionSeq);

		if (dto == null) {
			rttr.addFlashAttribute("msg", "없는 질문입니다.");
			return "redirect:/admin/question/list.do";
		}

		model.addAttribute("dto", dto);

		return "admin/question/form";
	}

	@PostMapping(value = "/editok.do")
	public String editok(QuestionDto dto, BindingResult bindingResult, RedirectAttributes rttr,
			@RequestParam MultiValueMap<String, String> params) {

		List<QuestionOptionDto> options = toOptions(params);
		int result = (bindingResult.hasErrors() || options == null) ? 0 : questionService.edit(dto, options);

		if (result == -5) {
			rttr.addFlashAttribute("msg", getMessage(result));
			return "redirect:/admin/question/list.do";
		}

		if (result != 1) {
			rttr.addFlashAttribute("msg", getMessage(result));
			return "redirect:/admin/question/edit.do?questionSeq=" + dto.getQuestionSeq();
		}

		rttr.addFlashAttribute("msg", "질문을 수정했습니다.");

		return "redirect:/admin/question/edit.do?questionSeq=" + dto.getQuestionSeq();
	}

	//사용 / 사용 안 함. 목록 화면의 버튼에서 부른다
	@PostMapping(value = "/enable.do")
	public String enable(RedirectAttributes rttr,
			@RequestParam(value = "questionSeq") Long questionSeq,
			@RequestParam(value = "enabled") String enabled,
			@RequestParam(value = "categorySeq") Long categorySeq) {

		int result = questionService.updateEnabled(questionSeq, enabled);

		if (result > 0) {
			rttr.addFlashAttribute("msg", "Y".equals(enabled) ? "질문을 다시 사용합니다." : "질문을 사용 안 함으로 바꿨습니다. 이미 쓴 요청서의 답변은 그대로 남습니다.");
		} else {
			rttr.addFlashAttribute("msg", "바꾸지 못했습니다.");
		}

		return "redirect:/admin/question/list.do?categorySeq=" + categorySeq;
	}

	/**
	 * 화면의 보기 줄을 DTO 목록으로 바꾼다.
	 * 줄마다 optionSeq(새 보기는 빈 값), optionContent, optionEnabled 가 하나씩 온다. 개수가 다르면 null
	 * (List<String> 으로 바로 받으면 쉼표가 들어간 보기가 둘로 나뉠 수 있어서 MultiValueMap 으로 받는다)
	 */
	private List<QuestionOptionDto> toOptions(MultiValueMap<String, String> params) {

		List<String> seqs = params.getOrDefault("optionSeq", new ArrayList<>());
		List<String> contents = params.getOrDefault("optionContent", new ArrayList<>());
		List<String> enableds = params.getOrDefault("optionEnabled", new ArrayList<>());

		if (seqs.size() != contents.size() || seqs.size() != enableds.size()) {
			return null;
		}

		List<QuestionOptionDto> options = new ArrayList<>();

		for (int i = 0; i < seqs.size(); i++) {

			QuestionOptionDto option = new QuestionOptionDto();

			if (seqs.get(i) != null && !seqs.get(i).isBlank()) {
				try {
					option.setOptionSeq(Long.parseLong(seqs.get(i).trim()));
				} catch (NumberFormatException e) {
					return null;
				}
			}

			option.setContent(contents.get(i) == null ? "" : contents.get(i).trim());
			option.setEnabled(enableds.get(i));
			options.add(option);
		}

		return options;
	}

	//QuestionService 가 돌려준 숫자를 화면에 보여 줄 말로 바꾼다
	private String getMessage(int result) {

		switch (result) {
			case -1: return "질문과 보기 내용을 입력해 주세요.";
			case -2: return "객관식 질문은 사용하는 보기가 2개 이상 있어야 합니다.";
			case -3: return "이미 답변이 달린 질문은 유형을 바꿀 수 없습니다. 사용 안 함으로 바꾸고 새 질문을 등록해 주세요.";
			case -4: return "고객이 이미 고른 보기는 내용을 바꿀 수 없습니다. 사용 안 함으로 바꾸고 새 보기를 추가해 주세요.";
			case -5: return "없는 질문이거나 카테고리입니다.";
			case -6: return "글자 수가 너무 많습니다. 질문은 160자, 보기는 100자 안으로 줄여 주세요.";
			default: return "입력한 값이 올바르지 않습니다.";
		}
	}

}
