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

	public int addTalent(ExpertTalentDto dto) {
		return talentMapper.addTalent(dto);
	}

	public int addTalentPortfolio(Long talentSeq, Long portfolioSeq, int slot) {
		return talentMapper.addTalentPortfolio(talentSeq, portfolioSeq, slot);
	}

	public int editTalent(ExpertTalentDto dto) {
		return talentMapper.editTalent(dto);
	}

	public int deleteTalentPortfolios(Long talentSeq) {
		return talentMapper.deleteTalentPortfolios(talentSeq);
	}

	public int deleteTalent(ExpertTalentDto dto) {
		return talentMapper.deleteTalent(dto);
	}

	public int countSubCategory(Long categorySeq) {
		return talentMapper.countSubCategory(categorySeq);
	}

	public int countMyPortfolios(Long expertSeq, List<Long> portfolioSeqs) {
		return talentMapper.countMyPortfolios(expertSeq, portfolioSeqs);
	}
}
