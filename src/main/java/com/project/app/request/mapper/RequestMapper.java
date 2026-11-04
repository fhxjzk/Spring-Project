package com.project.app.request.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.RequestAnswerDto;
import com.project.app.request.model.RequestCategoryDto;
import com.project.app.request.model.RequestDto;
import com.project.app.request.model.RequestFileDto;
import com.project.app.request.model.RequestQuoteDto;

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

	//--- 내 요청서 관리 (C-01-d) ---

	String getExpertName(Long expertSeq);

	List<RequestCategoryDto> expertCategoryList(Long expertSeq);

	List<RequestDto> myList(HashMap<String, Object> map);

	RequestDto getMine(HashMap<String, Object> map);

	List<RequestAnswerDto> answerList(Long requestSeq);

	List<RequestFileDto> fileList(Long requestSeq);

	List<RequestQuoteDto> quoteList(Long requestSeq);

	int cancel(HashMap<String, Object> map);

	int unselectQuotes(Long requestSeq);

}
