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
	private String profileImage;	// 프로필 사진 파일 이름. 없으면 null
	private String categoryNames;	// 등록한 서비스의 소분류 이름 ("영어 회화, 피아노"). 서비스가 없으면 null
	private int wishCount;			// 이 고수가 받은 찜 수
}
