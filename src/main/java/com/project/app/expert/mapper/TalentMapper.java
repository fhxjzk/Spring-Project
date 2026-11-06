package com.project.app.expert.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertTalentDto;

@Mapper
public interface TalentMapper {

	ExpertTalentDto getTalent(Long talentSeq);

	List<ExpertPortfolioDto> getPortfolioList(Long talentSeq);

}
