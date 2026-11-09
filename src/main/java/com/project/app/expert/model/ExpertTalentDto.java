package com.project.app.expert.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

// 고수 상세의 제공 서비스 카드 (tbl_talent + 카테고리 이름 + 대표 사진)
@Getter
@Setter
@ToString
public class ExpertTalentDto {
	private Long talentSeq;
	private Long expertSeq;
	private Long categorySeq;
	private String title;
	private String content;
	private int price;
	private String enabled;
	private Date regdate;

	private String categoryName;		// 소분류 이름 (피아노)
	private String parentCategoryName;	// 대분류 이름 (레슨)
	private Long parentCategorySeq;		// 대분류 번호 (수정 화면에서 대분류를 미리 골라 둘 때 쓴다)
	private int portfolioCount;			// 연결한 포트폴리오 수 (최대 3)
	private String thumbnail;			// 1번 포트폴리오의 1번 사진 파일 이름, 없으면 null
}
