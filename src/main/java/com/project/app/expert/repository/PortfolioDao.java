package com.project.app.expert.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.expert.mapper.PortfolioMapper;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.PortfolioImageDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PortfolioDao {

	private final PortfolioMapper portfolioMapper;

	public ExpertPortfolioDto getPortfolio(Long portfolioSeq) {
		return portfolioMapper.getPortfolio(portfolioSeq);
	}

	public List<PortfolioImageDto> getPortfolioImages(Long portfolioSeq) {
		
		return portfolioMapper.getPortfolioImages(portfolioSeq);
	}

	// TODO PortfolioMapper 메서드를 하나씩 감싸서 부른다 (ExpertDao 와 같은 모양)

}
