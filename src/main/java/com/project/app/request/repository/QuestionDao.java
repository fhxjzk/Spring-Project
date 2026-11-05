package com.project.app.request.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.request.mapper.QuestionMapper;
import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.QuestionOptionDto;
import com.project.app.request.model.RequestCategoryDto;

import lombok.RequiredArgsConstructor;

//관리자 요청서 질문 관리 (③ E-04)
@Repository
@RequiredArgsConstructor
public class QuestionDao {

	private final QuestionMapper questionMapper;

	public List<RequestCategoryDto> subCategoryList() {

		return questionMapper.subCategoryList();
	}

	public RequestCategoryDto getSubCategory(Long categorySeq) {

		return questionMapper.getSubCategory(categorySeq);
	}

	public List<QuestionDto> list(Long categorySeq) {

		return questionMapper.list(categorySeq);
	}

	public QuestionDto get(Long questionSeq) {

		return questionMapper.get(questionSeq);
	}

	public int add(QuestionDto dto) {

		return questionMapper.add(dto);
	}

	public int addOption(QuestionOptionDto dto) {

		return questionMapper.addOption(dto);
	}

	public int edit(QuestionDto dto) {

		return questionMapper.edit(dto);
	}

	public int editOption(QuestionOptionDto dto) {

		return questionMapper.editOption(dto);
	}

	public int updateEnabled(Long questionSeq, String enabled) {

		return questionMapper.updateEnabled(questionSeq, enabled);
	}

}
