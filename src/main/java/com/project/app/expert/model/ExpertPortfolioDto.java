package com.project.app.expert.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

// 고수 상세의 포트폴리오 카드 (tbl_portfolio + 사진 수 + 대표 사진)
@Getter
@Setter
@ToString
public class ExpertPortfolioDto {
	private Long portfolioSeq;
	private Long expertSeq;
	private String title;
	private String content;
	private Date regdate;

	private int imageCount;		// 사진 수 (최대 5)
	private String thumbnail;	// 1번 사진 파일 이름, 없으면 null
}
