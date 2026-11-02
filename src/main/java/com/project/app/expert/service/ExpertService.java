package com.project.app.expert.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.project.app.expert.model.ExpertCardDto;
import com.project.app.expert.model.ExpertCareerDto;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.model.ExpertTalentDto;
import com.project.app.expert.repository.ExpertDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ExpertService {
	private final ExpertDao expertDao;

	//프로필 정보 받아오기
	public ExpertProfileDto getProfile(Long expertSeq) {
		ExpertProfileDto edto = expertDao.getProfile(expertSeq);
		return edto;
	}

	//경력 목록 받아오기 (최근 경력이 위로)
	public List<ExpertCareerDto> getCareerList(Long expertSeq) {
		List<ExpertCareerDto> careerList = expertDao.getCareerList(expertSeq);
		return careerList;
	}

	//활동 가능 지역 이름 목록 (서울, 경기, ...)
	public List<String> getRegionNameList(Long expertSeq) {
		List<String> regionNameList = expertDao.getRegionNameList(expertSeq);
		return regionNameList;
	}

	//제공 서비스 목록 (사용 중인 것만)
	public List<ExpertTalentDto> getTalentList(Long expertSeq) {
		List<ExpertTalentDto> talentList = expertDao.getTalentList(expertSeq);
		return talentList;
	}

	//포트폴리오 목록
	public List<ExpertPortfolioDto> getPortfolioList(Long expertSeq) {
		List<ExpertPortfolioDto> portfolioList = expertDao.getPortfolioList(expertSeq);
		return portfolioList;
	}

	//메인 인기 고수 (평균 별점 높은 순 4명)
	public List<ExpertCardDto> getPopularExpertList() {
		List<ExpertCardDto> expertList = expertDao.getPopularExpertList();
		return expertList;
	}

	// 프로필 주인이 로그인 한 사용자인지 체크
	public boolean OwnerCheck(Long memberSeq, Long expertSeq) {
		
		// memberSeq가 null일 수 있기 때문에 expertSeq에서 equals() 호출하기
		if(expertSeq.equals(memberSeq)) {
			return true;
		}
		return false;
	}

	
}
