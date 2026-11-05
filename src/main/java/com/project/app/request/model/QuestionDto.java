package com.project.app.request.model;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_question (요청서 질문 항목)
 *
 * 유형: SINGLE 객관식 하나 / MULTI 객관식 여러 개 / TEXT 주관식
 */
@Getter
@Setter
@ToString
public class QuestionDto {

	private Long questionSeq;
	private Long categorySeq;
	private String content;
	private String questionType;
	private String required;		//Y: 필수
	private Integer sortOrder;
	private String enabled;
	private String regdate;

	private List<QuestionOptionDto> options;	//객관식 보기 (요청서 작성: 사용 중인 것만, 관리자 화면: 전부)

	//관리자 질문 관리 (E-04) 화면에서만 쓴다
	private String categoryName;	//대분류 > 소분류
	private Integer answerCount;	//이 질문에 달린 답변 수. 0보다 크면 유형을 바꿀 수 없다
	private Integer optionCount;	//사용 중인 보기 수

}
