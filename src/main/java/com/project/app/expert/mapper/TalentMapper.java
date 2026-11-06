package com.project.app.expert.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertTalentDto;

@Mapper
public interface TalentMapper {

	ExpertTalentDto getTalent(Long talentSeq);

	List<ExpertPortfolioDto> getPortfolioList(Long talentSeq);

	int addTalent(ExpertTalentDto dto);

	int addTalentPortfolio(@Param("talentSeq") Long talentSeq, @Param("portfolioSeq") Long portfolioSeq, @Param("slot") int slot);

	int editTalent(ExpertTalentDto dto);

	int deleteTalentPortfolios(Long talentSeq);

	int deleteTalent(ExpertTalentDto dto);

	int countSubCategory(Long categorySeq);

	int countMyPortfolios(@Param("expertSeq") Long expertSeq, @Param("portfolioSeqs") List<Long> portfolioSeqs);

}
