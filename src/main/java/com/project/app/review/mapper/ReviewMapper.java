package com.project.app.review.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.review.model.ReviewDto;
import com.project.app.review.model.ReviewSummaryDto;

@Mapper
public interface ReviewMapper {

	List<ReviewDto> getRecentReviewList(Long expertSeq);
	
	ReviewSummaryDto getReviewSummary(Long expertSeq);

	List<ReviewDto> getLatestReviewList();

	int addReview(ReviewDto dto);

}
