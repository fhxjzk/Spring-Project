package com.project.app.category.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.category.model.CategoryDto;

@Mapper
public interface CategoryMapper {

	List<CategoryDto> getTopCategory();

	List<CategoryDto> getSubCategoryList();

}
