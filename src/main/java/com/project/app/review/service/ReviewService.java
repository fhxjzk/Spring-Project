package com.project.app.review.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.project.app.review.model.ReviewDto;
import com.project.app.review.model.ReviewSummaryDto;
import com.project.app.review.repository.ReviewDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewService {
	private final ReviewDao reviewDao;

	// 리뷰 5개만 가져오기
	public List<ReviewDto> getRecentReviewList(Long expertSeq) {
		List<ReviewDto> reviewlist = reviewDao.getRecentReviewList(expertSeq);
		return reviewlist;
	}
	
	public ReviewSummaryDto getReviewSummary(Long expertSeq) {
		ReviewSummaryDto rsdto = reviewDao.getReviewSummary(expertSeq);
		return rsdto;
	}

	// 메인 최근 리뷰 (전체 고수 대상 최신 3개)
	public List<ReviewDto> getLatestReviewList() {
		List<ReviewDto> reviewList = reviewDao.getLatestReviewList();
		return reviewList;
	}
}
