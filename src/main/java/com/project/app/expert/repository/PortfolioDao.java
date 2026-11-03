package com.project.app.expert.repository;

import org.springframework.stereotype.Repository;

import com.project.app.expert.mapper.PortfolioMapper;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PortfolioDao {

	private final PortfolioMapper portfolioMapper;

	// TODO PortfolioMapper 메서드를 하나씩 감싸서 부른다 (ExpertDao 와 같은 모양)

}
