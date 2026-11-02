package com.project.app.expert.repository;

import org.springframework.stereotype.Repository;

import com.project.app.expert.mapper.ExpertMapper;
import com.project.app.expert.model.ExpertDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ExpertDao {
	private final ExpertMapper expertMapper;

	public ExpertDto getProfile(Long expertSeq) {
		
		return expertMapper.getProfile(expertSeq);
	}
}
