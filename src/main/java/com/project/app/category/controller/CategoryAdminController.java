package com.project.app.category.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.app.category.model.CategoryDto;
import com.project.app.category.service.CategoryService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 카테고리 관리 (② E-03, 화면설계서 ②-07)
 *
 * /admin/** 은 ROLE_ADMIN 만 들어올 수 있다 (security-context.xml)
 * 대분류는 고정이고, 대분류를 골라서 그 안의 소분류를 추가 · 순서 변경 · 사용 안 함으로 바꾼다.
 * 카테고리는 서비스 · 요청서가 참조해서 지우지 않는다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/admin/category")
public class CategoryAdminController {

	private final CategoryService categoryService;

	//대분류를 고르면 그 대분류의 소분류 목록을 보여 준다
	@GetMapping(value = "/list.do")
	public String list(Model model, @RequestParam(value = "parentSeq", required = false) Long parentSeq) {

		List<CategoryDto> topList = categoryService.getAdminTopCategoryList();

		//처음 들어오면 첫 번째 대분류를 보여 준다
		if (parentSeq == null && !topList.isEmpty()) {
			parentSeq = topList.get(0).getCategorySeq();
		}

		CategoryDto top = categoryService.getAdminTopCategory(parentSeq);

		model.addAttribute("topList", topList);
		model.addAttribute("top", top);

		if (top != null) {
			model.addAttribute("list", categoryService.getAdminSubCategoryList(top.getCategorySeq()));
		}

		return "admin/category/list";
	}

	//소분류 추가
	@PostMapping(value = "/addok.do")
	public String addok(RedirectAttributes rttr,
			@RequestParam(value = "parentSeq") Long parentSeq,
			@RequestParam(value = "name", required = false) String name) {

		int result = categoryService.addSubCategory(parentSeq, name);

		switch (result) {
			case 1:  rttr.addFlashAttribute("msg", "소분류를 추가했습니다. 목록 맨 아래에 들어갑니다."); break;
			case -1: rttr.addFlashAttribute("msg", "소분류 이름을 입력해 주세요. (한글 16자까지)"); break;
			case -2: rttr.addFlashAttribute("msg", "같은 대분류에 같은 이름의 소분류가 있습니다. 사용 안 함인 소분류라면 다시 사용으로 바꿔 주세요."); break;
			default:
				rttr.addFlashAttribute("msg", "없는 대분류입니다.");
				return "redirect:/admin/category/list.do";
		}

		return "redirect:/admin/category/list.do?parentSeq=" + parentSeq;
	}

	//순서 한 칸 위로 / 아래로 (direction = up | down)
	@PostMapping(value = "/moveok.do")
	public String moveok(RedirectAttributes rttr,
			@RequestParam(value = "categorySeq") Long categorySeq,
			@RequestParam(value = "direction") String direction) {

		Long parentSeq = categoryService.move(categorySeq, "up".equals(direction));

		if (parentSeq == null) {
			rttr.addFlashAttribute("msg", "없는 소분류입니다.");
			return "redirect:/admin/category/list.do";
		}

		return "redirect:/admin/category/list.do?parentSeq=" + parentSeq;
	}

	//사용 / 사용 안 함
	@PostMapping(value = "/enableok.do")
	public String enableok(RedirectAttributes rttr,
			@RequestParam(value = "categorySeq") Long categorySeq,
			@RequestParam(value = "enabled") String enabled,
			@RequestParam(value = "parentSeq") Long parentSeq) {

		int result = categoryService.updateEnabled(categorySeq, enabled);

		if (result > 0) {
			rttr.addFlashAttribute("msg", "Y".equals(enabled)
					? "소분류를 다시 사용합니다."
					: "소분류를 사용 안 함으로 바꿨습니다. 이미 등록된 서비스와 요청서는 그대로 남습니다.");
		} else {
			rttr.addFlashAttribute("msg", "바꾸지 못했습니다.");
		}

		return "redirect:/admin/category/list.do?parentSeq=" + parentSeq;
	}

}
