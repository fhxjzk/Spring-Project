package com.project.app.category.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.category.model.CategoryDto;

@Mapper
public interface CategoryMapper {

	List<CategoryDto> getTopCategory();

	List<CategoryDto> getSubCategoryList();

	//── 관리자 카테고리 관리 (E-03) ──

	List<CategoryDto> getAdminTopCategoryList();

	CategoryDto getCategory(Long categorySeq);

	List<CategoryDto> getAdminSubCategoryList(Long parentSeq);

	int countSameName(@Param("parentSeq") Long parentSeq, @Param("name") String name);

	int addSubCategory(CategoryDto dto);

	int updateSortOrder(@Param("categorySeq") Long categorySeq, @Param("sortOrder") int sortOrder);

	int updateEnabled(@Param("categorySeq") Long categorySeq, @Param("enabled") String enabled);

}
