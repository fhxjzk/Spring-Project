package com.project.app.request.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.QuestionOptionDto;
import com.project.app.request.model.RequestCategoryDto;

//관리자 요청서 질문 관리 (③ E-04). SQL은 resources/mappers/request/QuestionMapper.xml 에 있다
@Mapper
public interface QuestionMapper {

	List<RequestCategoryDto> subCategoryList();

	RequestCategoryDto getSubCategory(Long categorySeq);

	List<QuestionDto> list(Long categorySeq);

	QuestionDto get(Long questionSeq);

	int add(QuestionDto dto);

	int addOption(QuestionOptionDto dto);

	int edit(QuestionDto dto);

	int editOption(QuestionOptionDto dto);

	int updateEnabled(@Param("questionSeq") Long questionSeq, @Param("enabled") String enabled);

}
