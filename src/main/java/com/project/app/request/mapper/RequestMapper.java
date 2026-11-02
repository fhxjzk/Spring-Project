package com.project.app.request.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.RequestAnswerDto;
import com.project.app.request.model.RequestCategoryDto;
import com.project.app.request.model.RequestDto;
import com.project.app.request.model.RequestFileDto;

//SQL은 resources/mappers/request/RequestMapper.xml 에 있다 (메서드 이름 = XML의 id)
@Mapper
public interface RequestMapper {

	List<RequestCategoryDto> categoryList(Long parentSeq);

	RequestCategoryDto getCategory(Long categorySeq);

	List<QuestionDto> questionList(Long categorySeq);

	String getMemberAddress(Long memberSeq);

	int add(RequestDto dto);

	int addAnswer(RequestAnswerDto dto);

	int addFile(RequestFileDto dto);

}
