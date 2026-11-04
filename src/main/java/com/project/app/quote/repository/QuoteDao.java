package com.project.app.quote.repository;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.quote.mapper.QuoteMapper;
import com.project.app.quote.model.QuoteDto;
import com.project.app.request.model.RequestDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class QuoteDao {

	private final QuoteMapper quoteMapper;

	//type이 designated면 지정 요청, 아니면 공개 요청
	public List<RequestDto> requestList(Long expertSeq, String type) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("expertSeq", expertSeq);
		map.put("type", type);

		return quoteMapper.requestList(map);
	}

	//이 고수가 볼 수 없는 요청서면 null
	public RequestDto getRequest(Long requestSeq, Long expertSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("requestSeq", requestSeq);
		map.put("expertSeq", expertSeq);

		return quoteMapper.getRequest(map);
	}

	//보낸 견적이 없으면 null
	public QuoteDto getMyQuote(Long requestSeq, Long expertSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("requestSeq", requestSeq);
		map.put("expertSeq", expertSeq);

		return quoteMapper.getMyQuote(map);
	}

	public int activeExpert(Long expertSeq) {

		return quoteMapper.activeExpert(expertSeq);
	}

	public int increaseQuoteCount(Long requestSeq, Long expertSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("requestSeq", requestSeq);
		map.put("expertSeq", expertSeq);

		return quoteMapper.increaseQuoteCount(map);
	}

	public int add(QuoteDto dto) {

		return quoteMapper.add(dto);
	}

	public int reject(Long requestSeq, Long expertSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("requestSeq", requestSeq);
		map.put("expertSeq", expertSeq);

		return quoteMapper.reject(map);
	}

	public List<QuoteDto> myList(Long expertSeq) {

		return quoteMapper.myList(expertSeq);
	}

}
