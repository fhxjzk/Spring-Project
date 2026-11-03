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
	private int rating;
	private String content;
	private String reply;
	private Date replyDate;
	private Date regdate;
	
	private String customerName;
	private String expertName;
}
