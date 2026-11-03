package com.project.app.expert.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

// 메인 인기 고수 카드에 보여 줄 값 (프로필 + 이름 + 리뷰 집계)
@Getter
@Setter
@ToString
public class ExpertCardDto {
	private Long expertSeq;
	private String name;
	private int reviewCount;
	private Double averageRating;	// 리뷰가 없으면 null
}
