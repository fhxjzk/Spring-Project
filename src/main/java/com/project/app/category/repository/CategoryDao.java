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
}
