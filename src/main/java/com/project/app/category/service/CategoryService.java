package com.project.app.category.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.project.app.category.model.CategoryDto;
import com.project.app.category.repository.CategoryDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CategoryService {
	private final CategoryDao categoryDao;

	//사용중인(enabled가 'Y'인) 대분류 카테고리만 가져오는 메서드
	public List<CategoryDto> getTopCategory() {
		List<CategoryDto> clist = categoryDao.getTopCategory();
		return clist;
	}

	//사용중인 소분류 전체. 대분류 순서(parent_seq) → 소분류 순서(sort_order)로 정렬되어 있다
	public List<CategoryDto> getSubCategoryList() {
		return categoryDao.getSubCategoryList();
	}

}
