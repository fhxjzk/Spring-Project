package com.project.app.search.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 고수 검색 조건 (B-04)
 *
 * 화면에서 넘어온 검색 조건을 담는다.
 */
@Getter
@Setter
@ToString
public class SearchDto {

	private Integer categorySeq;	//카테고리. 없으면 전체
	private Integer regionSeq;		//활동 가능 지역. 없으면 전국
	private String keyword;			//고수 이름 / 소개글 검색어

	//기준 위치. 회원은 등록 주소, 비회원은 선택한 지역의 중심 좌표, GPS를 쓰면 실시간 위치 (B-04-02)
	//셋 다 없으면 거리 없이 검색한다 (B-04-11)
	private Double baseLat;
	private Double baseLng;

	private Integer radiusKm;		//거리 필터 (km). 없으면 거리 제한 없음 (B-04-03)

	//distance(기본) / review / rating / recent / hire (B-04-08)
	private String sort;

	//더보기 (B-04-09)
	private Integer page;			//1부터 시작
	private Integer size;			//한 번에 가져올 개수

	//page, size, sort 가 비어 있을 때 기본값을 채운다. Service 에서 부른다
	public void setDefault() {

		if (page == null || page < 1) {
			page = 1;
		}

		if (size == null || size < 1) {
			size = 10;
		}

		if (sort == null || sort.isEmpty()) {
			sort = "distance";
		}
	}

	//오라클에게 "몇 개를 건너뛸지" 알려주는 값
	public int getOffset() {

		return (page - 1) * size;
	}

}
