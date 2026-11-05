package com.project.app.request.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_question_option (객관식 보기)
 */
@Getter
@Setter
@ToString
public class QuestionOptionDto {

	private Long optionSeq;
	private Long questionSeq;
	private String content;
	private Integer sortOrder;
	private String enabled;

	private Integer answerCount;	//관리자 화면(E-04): 이 보기를 고른 답변 수. 0보다 크면 내용을 바꿀 수 없다

}
