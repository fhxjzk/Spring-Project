package com.project.app.expert.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExpertCareerDto {
	private Long careerSeq;
	private Long expertSeq;
	private String title;
	private Date startDate;
	private Date endDate;
	private String description;
}
