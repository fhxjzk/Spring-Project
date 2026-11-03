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

}
