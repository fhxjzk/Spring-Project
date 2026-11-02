package com.project.app.expert.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExpertProfileDto {
	private Long expertSeq;
	private String name;
	private String intro;
	private String serviceAddress;
	private double serviceLatitude;
	private double serviceLongitude;
	private Date regdate;
	private String hidden;	// Y: 신고 처리로 숨김, N: 공개
	
	
	
}
