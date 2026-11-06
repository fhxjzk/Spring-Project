package com.project.app.expert.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertTalentDto;
import com.project.app.expert.model.PortfolioImageDto;

/**
 * 메서드 이름 = PortfolioMapper.xml 의 id
 */
@Mapper
public interface PortfolioMapper {

	ExpertPortfolioDto getPortfolio(Long portfolioSeq);

	List<PortfolioImageDto> getPortfolioImages(Long portfolioSeq);

	// 이 포트폴리오를 연결한 서비스 (사용 중인 것만)
	List<ExpertTalentDto> getLinkedTalentList(Long portfolioSeq);

	// 글 INSERT (selectKey 로 dto.portfolioSeq 가 채워진다)
	int addPortfolio(ExpertPortfolioDto dto);

	int addPortfolioImage(PortfolioImageDto dto);

	int editPortfolio(ExpertPortfolioDto dto);

	int deletePortfolioImages(Long portfolioSeq);

	int deletePortfolio(ExpertPortfolioDto dto);

}
