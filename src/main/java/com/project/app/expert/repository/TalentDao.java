package com.project.app.expert.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.expert.mapper.TalentMapper;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertTalentDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class TalentDao {
	private final TalentMapper talentMapper;

	public ExpertTalentDto getTalent(Long talentSeq) {
		
		return talentMapper.getTalent(talentSeq);
	}

	public List<ExpertPortfolioDto> getPortfolioList(Long talentSeq) {
		return talentMapper.getPortfolioList(talentSeq);
	}
}
