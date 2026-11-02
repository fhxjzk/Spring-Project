package com.project.app.expert.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.expert.mapper.ExpertMapper;
import com.project.app.expert.model.ExpertCardDto;
import com.project.app.expert.model.ExpertCareerDto;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.model.ExpertTalentDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ExpertDao {
	private final ExpertMapper expertMapper;

	public ExpertProfileDto getProfile(Long expertSeq) {
		
		return expertMapper.getProfile(expertSeq);
	}

	public List<ExpertCareerDto> getCareerList(Long expertSeq) {

		return expertMapper.getCareerList(expertSeq);
	}

	public List<String> getRegionNameList(Long expertSeq) {

		return expertMapper.getRegionNameList(expertSeq);
	}

	public List<ExpertTalentDto> getTalentList(Long expertSeq) {

		return expertMapper.getTalentList(expertSeq);
	}

	public List<ExpertPortfolioDto> getPortfolioList(Long expertSeq) {

		return expertMapper.getPortfolioList(expertSeq);
	}

	public List<ExpertCardDto> getPopularExpertList() {

		return expertMapper.getPopularExpertList();
	}

	
}
