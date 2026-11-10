package com.project.app.category.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CategoryDto {
	private Long categorySeq;
	private Long parentSeq;
	private String name;
	private int sortOrder;
	private String enabled;

	//관리자 카테고리 관리(E-03) 목록에서만 채운다
	private int talentCount;	//이 소분류로 등록된 서비스 수 (삭제한 서비스 제외)
	private int requestCount;	//이 소분류로 쓴 요청서 수
}
