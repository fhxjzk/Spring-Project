package com.project.app.review.model;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReviewSummaryDto {
	private int reviewCount;
	private Double averageRating;
}
