package com.project.app.trade.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.trade.mapper.TradeMapper;
import com.project.app.trade.model.TradeDto;
import com.project.app.trade.model.TradeFileDto;
import com.project.app.trade.model.TradeQuoteDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class TradeDao {

	private final TradeMapper tradeMapper;

	public TradeQuoteDto getQuote(Long quoteSeq) {

		return tradeMapper.getQuote(quoteSeq);
	}

	public int selectRequest(Long requestSeq) {

		return tradeMapper.selectRequest(requestSeq);
	}

	public int selectQuote(Long requestSeq, Long quoteSeq) {

		return tradeMapper.selectQuote(requestSeq, quoteSeq);
	}

	public int cancelRequest(Long requestSeq) {

		return tradeMapper.cancelRequest(requestSeq);
	}

	public int add(TradeDto dto) {

		return tradeMapper.add(dto);
	}

	public TradeDto get(Long tradeSeq) {

		return tradeMapper.get(tradeSeq);
	}

	public List<TradeDto> listByCustomer(Long customerSeq) {

		return tradeMapper.listByCustomer(customerSeq);
	}

	public List<TradeDto> listByExpert(Long expertSeq) {

		return tradeMapper.listByExpert(expertSeq);
	}

	public int start(Long tradeSeq) {

		return tradeMapper.start(tradeSeq);
	}

	public int complete(Long tradeSeq) {

		return tradeMapper.complete(tradeSeq);
	}

	public int confirm(Long tradeSeq) {

		return tradeMapper.confirm(tradeSeq);
	}

	public int cancel(Long tradeSeq) {

		return tradeMapper.cancel(tradeSeq);
	}

	public List<Long> listAutoConfirmTargets(int days) {

		return tradeMapper.listAutoConfirmTargets(days);
	}

	public int countReview(Long tradeSeq) {

		return tradeMapper.countReview(tradeSeq);
	}

	public int countConfirmedByExpert(Long expertSeq) {

		return tradeMapper.countConfirmedByExpert(expertSeq);
	}

	public int countOngoing(Long memberSeq) {

		return tradeMapper.countOngoing(memberSeq);
	}

	public int addFile(TradeFileDto dto) {

		return tradeMapper.addFile(dto);
	}

	public List<TradeFileDto> listFiles(Long tradeSeq) {

		return tradeMapper.listFiles(tradeSeq);
	}

	public TradeFileDto getFile(Long tradeFileSeq) {

		return tradeMapper.getFile(tradeFileSeq);
	}

}
