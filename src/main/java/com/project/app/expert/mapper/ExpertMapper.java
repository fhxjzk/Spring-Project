package com.project.app.expert.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.expert.model.ExpertCardDto;
import com.project.app.expert.model.ExpertCareerDto;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.model.ExpertTalentDto;

@Mapper
public interface ExpertMapper {

	ExpertProfileDto getProfile(Long expertSeq);

	List<ExpertCareerDto> getCareerList(Long expertSeq);

	List<String> getRegionNameList(Long expertSeq);

	List<ExpertTalentDto> getTalentList(Long expertSeq);

	List<ExpertPortfolioDto> getPortfolioList(Long expertSeq);

	List<ExpertCardDto> getPopularExpertList();

	

}
