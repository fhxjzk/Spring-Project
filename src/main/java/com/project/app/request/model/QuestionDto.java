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

	private List<QuestionOptionDto> options;	//객관식 보기 (사용 중인 것만)

}
