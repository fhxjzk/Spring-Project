package com.project.app.expert.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.expert.mapper.ExpertMapper;
import com.project.app.expert.model.ExpertCardDto;
import com.project.app.expert.model.ExpertProfileDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ExpertDao {
	private final ExpertMapper expertMapper;

	public ExpertProfileDto getProfile(Long expertSeq) {
		
		return expertMapper.getProfile(expertSeq);
	}

	public List<ExpertCardDto> getPopularExpertList() {

		return expertMapper.getPopularExpertList();
	}

	
}
