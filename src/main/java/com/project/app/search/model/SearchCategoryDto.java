package com.project.app.search.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 검색 조건으로 쓰는 카테고리 (B-04-01)
 *
 * ② tbl_category 를 읽어서 담는다. 고수의 서비스(tbl_talent)는 소분류에 달리므로
 * 드롭다운에도 소분류를 넣고, 대분류 이름은 묶음 제목으로만 쓴다.
 *
 * 클래스 이름이 겹치면 MyBatis 가 뜨지 않으므로 Search 를 붙였다.
 */
@Getter
@Setter
@ToString
public class SearchCategoryDto {

	private Integer categorySeq;	//소분류 번호
	private String name;			//소분류 이름 (피아노, 청소 ...)
	private String parentName;		//대분류 이름 (레슨, 홈·리빙 ...)

}
