package com.project.app.request.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.request.mapper.RequestMapper;
import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.RequestAnswerDto;
import com.project.app.request.model.RequestCategoryDto;
import com.project.app.request.model.RequestDto;
import com.project.app.request.model.RequestFileDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RequestDao {

	private final RequestMapper requestMapper;

	public List<RequestCategoryDto> categoryList(Long parentSeq) {

		return requestMapper.categoryList(parentSeq);
	}

	public RequestCategoryDto getCategory(Long categorySeq) {

		return requestMapper.getCategory(categorySeq);
	}

	public List<QuestionDto> questionList(Long categorySeq) {

		return requestMapper.questionList(categorySeq);
	}

	public String getMemberAddress(Long memberSeq) {

		return requestMapper.getMemberAddress(memberSeq);
	}

	public int add(RequestDto dto) {

		return requestMapper.add(dto);
	}

	public int addAnswer(RequestAnswerDto dto) {

		return requestMapper.addAnswer(dto);
	}

	public int addFile(RequestFileDto dto) {

		return requestMapper.addFile(dto);
	}

}
