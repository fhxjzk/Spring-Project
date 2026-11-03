package com.project.app.expert.service;

import org.springframework.stereotype.Service;

import com.project.app.expert.repository.PortfolioDao;

import lombok.RequiredArgsConstructor;

/**
 * 포트폴리오 글 + 사진
 */
@Service
@RequiredArgsConstructor
public class PortfolioService {

	private final PortfolioDao portfolioDao;

	// TODO 포트폴리오 글 하나 조회 (상세 화면)

	// TODO 사진 목록 조회 (slot 1 ~ 5 순서)

	// TODO 작성자 본인인지 확인 (ExpertService.ownerCheck 참고)

	// TODO 포트폴리오 작성
	//  - 글 INSERT → 사진 파일 저장 → 사진 INSERT 를 한 번에 처리해야 해서 @Transactional
	//  - 중간에 실패하면 글만 남지 않도록 전부 취소된다
	//  - 파일 저장 위치: resources/upload/portfolio/  (폴더 없으면 mkdirs())
	//  - 파일 이름: UUID_원래이름  (CONVENTION.md "업로드 파일")
	//  - 사진은 최대 5장, 올린 순서대로 slot 1 ~ 5 (1번이 대표 사진)

}
