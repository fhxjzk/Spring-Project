package com.project.app.expert.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertTalentDto;
import com.project.app.expert.repository.TalentDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TalentService {
	private final TalentDao talentDao;

	public ExpertTalentDto getTalent(Long talentSeq) {
		ExpertTalentDto tdto = talentDao.getTalent(talentSeq);
		return tdto;
	}

	public List<ExpertPortfolioDto> getPortfolioList(Long talentSeq) {
		List<ExpertPortfolioDto> plist = talentDao.getPortfolioList(talentSeq);
		return plist;
	}
}
