package com.project.app.category.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.category.mapper.CategoryMapper;
import com.project.app.category.model.CategoryDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CategoryDao {
	private final CategoryMapper categoryMapper;

	public List<CategoryDto> getTopCategory() {

		return categoryMapper.getTopCategory();
	}

	public List<CategoryDto> getSubCategoryList() {

		return categoryMapper.getSubCategoryList();
	}

	//── 관리자 카테고리 관리 (E-03) ──

	public List<CategoryDto> getAdminTopCategoryList() {
		return categoryMapper.getAdminTopCategoryList();
	}

	public CategoryDto getCategory(Long categorySeq) {
		return categoryMapper.getCategory(categorySeq);
	}

	public List<CategoryDto> getAdminSubCategoryList(Long parentSeq) {
		return categoryMapper.getAdminSubCategoryList(parentSeq);
	}

	public int countSameName(Long parentSeq, String name) {
		return categoryMapper.countSameName(parentSeq, name);
	}

	public int addSubCategory(CategoryDto dto) {
		return categoryMapper.addSubCategory(dto);
	}

	public int updateSortOrder(Long categorySeq, int sortOrder) {
		return categoryMapper.updateSortOrder(categorySeq, sortOrder);
	}

	public int updateEnabled(Long categorySeq, String enabled) {
		return categoryMapper.updateEnabled(categorySeq, enabled);
	}
}
