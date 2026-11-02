package com.project.app.expert.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExpertDto {
	private Long expertSeq;
	private String name;
	private String intro;
	private String serviceAddress;
	private double serviceLatitude;
	private double serviceLongitude;
	private String regdate;
	private char hidden;
}
