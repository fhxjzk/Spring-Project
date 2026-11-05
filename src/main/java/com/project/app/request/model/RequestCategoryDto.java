package com.project.app.request.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_category 중 요청서 작성에 필요한 값만 담는다.
 *
 * tbl_category는 ② 담당이다. ②의 CategoryDto와 이름이 겹치지 않게 RequestCategoryDto로 만들었다.
 * parentSeq가 비어 있으면 대분류, 값이 있으면 소분류다.
 */
@Getter
@Setter
@ToString
public class RequestCategoryDto {

	private Long categorySeq;
	private Long parentSeq;
	private String name;

	//관리자 질문 관리 (E-04) 화면에서만 쓴다
	private String parentName;	//대분류 이름
	private String enabled;		//N 이면 사용 안 하는 카테고리

}
