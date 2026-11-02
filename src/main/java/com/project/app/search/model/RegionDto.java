package com.project.app.search.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_region (지역 17개 시도)
 *
 * 필드 이름은 칼럼 이름을 camelCase로 바꾼 것 (region_seq → regionSeq)
 * centerLat/centerLng는 비회원이 지역만 고르고 검색할 때 기준 좌표다. (B-04-02)
 */
@Getter
@Setter
@ToString
public class RegionDto {

	private Integer regionSeq;		//1 ~ 17
	private String regionName;		//서울, 경기, ...
	private Double centerLat;		//중심 위도
	private Double centerLng;		//중심 경도

}
