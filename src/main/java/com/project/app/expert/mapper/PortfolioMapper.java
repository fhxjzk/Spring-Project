package com.project.app.expert.mapper;

import org.apache.ibatis.annotations.Mapper;

/**
 * 메서드 이름 = PortfolioMapper.xml 의 id
 */
@Mapper
public interface PortfolioMapper {

	// TODO 포트폴리오 글 하나 조회  (tbl_portfolio, 결과 1줄 → 단일 Dto)

	// TODO 사진 목록 조회  (tbl_portfolio_image, 결과 N줄 → List)

	// TODO 포트폴리오 글 INSERT  (seq_portfolio)
	//  - 사진 INSERT 할 때 방금 만든 portfolio_seq 가 필요하다 → <selectKey> 찾아보기

	// TODO 사진 INSERT  (seq_portfolio_image)

}
