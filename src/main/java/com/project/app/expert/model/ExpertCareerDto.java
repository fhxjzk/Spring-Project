package com.project.app.expert.model;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

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

	//폼의 <input type="month"> 는 "2023-01" 처럼 연-월만 보내서, 그 형식을 Date 로 바꾸도록 알려 준다 (1일로 저장된다)
	@DateTimeFormat(pattern = "yyyy-MM")
	private Date startDate;

	//비워서 보내면 null = 진행 중
	@DateTimeFormat(pattern = "yyyy-MM")
	private Date endDate;

	private String description;
}
