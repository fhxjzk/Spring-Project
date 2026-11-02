package com.project.app.expert.service;

import org.springframework.stereotype.Service;

import com.project.app.expert.model.ExpertDto;
import com.project.app.expert.repository.ExpertDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ExpertService {
	private final ExpertDao expertDao;

	public ExpertDto getProfile(Long expertSeq) {
		ExpertDto edto = expertDao.getProfile(expertSeq);
		return edto;
	}
}
