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

	public int addPortfolio(ExpertPortfolioDto dto) {

		return portfolioMapper.addPortfolio(dto);
	}

	public int addPortfolioImage(PortfolioImageDto dto) {

		return portfolioMapper.addPortfolioImage(dto);
	}

	public int editPortfolio(ExpertPortfolioDto dto) {

		return portfolioMapper.editPortfolio(dto);
	}

	public int deletePortfolioImages(Long portfolioSeq) {

		return portfolioMapper.deletePortfolioImages(portfolioSeq);
	}

	public int deletePortfolio(ExpertPortfolioDto dto) {

		return portfolioMapper.deletePortfolio(dto);
	}

}
