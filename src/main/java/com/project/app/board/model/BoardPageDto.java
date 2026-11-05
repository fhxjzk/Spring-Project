package com.project.app.board.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 동네 게시판 목록 조건과 페이징 (⑥ B-09-01, B-09-02)
 *
 * 화면에서 넘어온 지역·페이지를 담고, 화면에 그릴 페이지 번호도 여기서 계산한다.
 */
@Getter
@Setter
@ToString
public class BoardPageDto {

	private Integer regionSeq;		//동네. 비어 있으면 서비스에서 기본값을 채운다
	private Integer page;			//1부터 시작
	private Integer size;			//한 페이지에 보여줄 글 수
	private int total;				//전체 글 수. 서비스가 세어서 채운다

	private String searchType;		//검색 기준. subject(제목) / content(내용) / writer(작성자)
	private String keyword;			//검색어. 비어 있으면 검색 안 한 것으로 본다

	private static final int BLOCK = 5;		//페이지 번호를 다섯 개씩 끊어서 보여준다

	//page, size 가 비어 있을 때 기본값을 채운다. Service 에서 부른다
	public void setDefault() {

		if (page == null || page < 1) {
			page = 1;
		}

		if (size == null || size < 1) {
			size = 10;
		}

		//검색 기준이 엉뚱한 값이면 제목으로 되돌린다.
		//화면에서 넘어온 값을 그대로 믿지 않는다 (SQL 에 끼워 넣는 값이라서)
		if (!"subject".equals(searchType)
				&& !"content".equals(searchType)
				&& !"writer".equals(searchType)) {
			searchType = "subject";
		}

		//앞뒤 공백만 넣은 것은 검색 안 한 것으로 본다
		if (keyword != null) {
			keyword = keyword.trim();
		}
	}

	//오라클에게 "몇 개를 건너뛸지" 알려주는 값
	public int getOffset() {

		return (page - 1) * size;
	}

	//전체 페이지 수. 글이 하나도 없어도 1쪽은 있는 것으로 본다
	public int getTotalPages() {

		int pages = (int) Math.ceil(total / (double) size);

		return pages < 1 ? 1 : pages;
	}

	//화면에 보여줄 첫 번호. 1~5, 6~10 처럼 끊는다
	public int getStartPage() {

		return ((page - 1) / BLOCK) * BLOCK + 1;
	}

	//화면에 보여줄 끝 번호
	public int getEndPage() {

		int end = getStartPage() + BLOCK - 1;

		return end > getTotalPages() ? getTotalPages() : end;
	}

	//[이전] 버튼을 보일지
	public boolean isHasPrev() {

		return getStartPage() > 1;
	}

	//[다음] 버튼을 보일지
	public boolean isHasNext() {

		return getEndPage() < getTotalPages();
	}

	//검색 중인지. 화면에서 "검색 결과가 없습니다" 와 "글이 없습니다" 를 가려 쓸 때 쓴다
	public boolean isSearching() {

		return keyword != null && !keyword.isEmpty();
	}

}
