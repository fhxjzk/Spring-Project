package com.project.app.request.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_request_answer
 *
 * 객관식은 optionSeq, 주관식은 answer에 담는다. 여러 개 고른 객관식은 한 줄씩 저장한다.
 */
@Getter
@Setter
@ToString
public class RequestAnswerDto {

	private Long answerSeq;
	private Long requestSeq;
	private Long questionSeq;
	private Long optionSeq;
	private String answer;

}
