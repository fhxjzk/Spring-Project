package com.project.app.quote.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.quote.model.QuoteDto;
import com.project.app.request.model.RequestDto;

//SQL은 resources/mappers/quote/QuoteMapper.xml 에 있다 (메서드 이름 = XML의 id)
@Mapper
public interface QuoteMapper {

	List<RequestDto> requestList(HashMap<String, Object> map);

	RequestDto getRequest(HashMap<String, Object> map);

	QuoteDto getMyQuote(HashMap<String, Object> map);

	int activeExpert(Long expertSeq);

	int increaseQuoteCount(HashMap<String, Object> map);

	int add(QuoteDto dto);

	int reject(HashMap<String, Object> map);

	List<QuoteDto> myList(Long expertSeq);

}
