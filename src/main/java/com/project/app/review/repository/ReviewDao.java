package com.project.app.review.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.review.mapper.ReviewMapper;
import com.project.app.review.model.ReviewDto;
import com.project.app.review.model.ReviewSummaryDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ReviewDao {
	private final ReviewMapper reviewMapper;

	public List<ReviewDto> getRecentReviewList(Long expertSeq) {
		
		return reviewMapper.getRecentReviewList(expertSeq);
	}
	
	public ReviewSummaryDto getReviewSummary(Long expertSeq) {
		return reviewMapper.getReviewSummary(expertSeq);
	}

	public List<ReviewDto> getLatestReviewList() {
		return reviewMapper.getLatestReviewList();
	}

	public int addReview(ReviewDto dto) {
		return reviewMapper.addReview(dto);
	}

	public int addReply(ReviewDto dto) {
		return reviewMapper.addReply(dto);
	}
	
	
}
