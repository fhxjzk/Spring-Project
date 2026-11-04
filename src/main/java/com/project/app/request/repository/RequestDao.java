package com.project.app.request.repository;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.request.mapper.RequestMapper;
import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.RequestAnswerDto;
import com.project.app.request.model.RequestCategoryDto;
import com.project.app.request.model.RequestDto;
import com.project.app.request.model.RequestFileDto;
import com.project.app.request.model.RequestQuoteDto;

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

	//--- 내 요청서 관리 (C-01-d) ---

	//status가 null이면 전체
	public List<RequestDto> myList(Long customerSeq, String status) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("customerSeq", customerSeq);
		map.put("status", status);

		return requestMapper.myList(map);
	}

	//본인이 쓴 요청서가 아니면 null
	public RequestDto getMine(Long requestSeq, Long customerSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("requestSeq", requestSeq);
		map.put("customerSeq", customerSeq);

		return requestMapper.getMine(map);
	}

	public List<RequestAnswerDto> answerList(Long requestSeq) {

		return requestMapper.answerList(requestSeq);
	}

	public List<RequestFileDto> fileList(Long requestSeq) {

		return requestMapper.fileList(requestSeq);
	}

	public List<RequestQuoteDto> quoteList(Long requestSeq) {

		return requestMapper.quoteList(requestSeq);
	}

	public int cancel(Long requestSeq, Long customerSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("requestSeq", requestSeq);
		map.put("customerSeq", customerSeq);

		return requestMapper.cancel(map);
	}

	public int unselectQuotes(Long requestSeq) {

		return requestMapper.unselectQuotes(requestSeq);
	}

}
