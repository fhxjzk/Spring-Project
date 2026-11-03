package com.project.app.search.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 고수 검색 결과 한 줄 (B-04)
 *
 * 여러 테이블을 조인해서 채운다. 테이블 하나와 짝이 맞지 않는다.
 */
@Getter
@Setter
@ToString
public class ExpertSearchDto {

	private Long expertSeq;				//고수 번호 (= 회원 번호)
	private String name;				//고수 이름 (tbl_member.name)
	private String intro;				//고수 소개 (tbl_expert_profile.intro)
	private String serviceAddress;		//서비스 제공 주소
	private Double serviceLatitude;		//지도 마커를 찍을 위도
	private Double serviceLongitude;	//지도 마커를 찍을 경도

	private Double distanceKm;			//기준 위치에서 몇 km. 기준 위치가 없으면 null

	//정렬에 쓰는 값들 (B-04-08)
	private Integer reviewCount;		//리뷰 수
	private Double avgRating;			//평균 평점
	private Integer hireCount;			//구매 확정된 거래 수
	private String lastLoginDate;		//마지막 로그인

	private String talentTitle;			//대표 서비스 이름
	private Integer price;				//대표 서비스 가격

}