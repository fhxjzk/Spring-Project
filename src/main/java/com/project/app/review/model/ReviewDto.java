package com.project.app.review.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReviewDto {
	private Long reviewSeq;
	private Long tradeSeq;
	private Long customerSeq;
	private Long expertSeq;
	private Integer rating;		// 1 ~ 5. 작성 폼에서 별점을 안 고르고 보내면 빈 값이 와서, int 면 400 오류가 난다. 그래서 Integer (비면 null)
	private String content;
	private String reply;
	private Date replyDate;
	private Date regdate;
	
	private String customerName;
	private String expertName;
}
