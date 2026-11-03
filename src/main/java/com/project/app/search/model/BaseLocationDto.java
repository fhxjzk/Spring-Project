package com.project.app.search.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 검색 기준 위치 (B-04-02)
 *
 * 로그인한 회원이 가입할 때 등록한 주소와 좌표다.
 * ① MemberDto 에는 주소·좌표가 없어서 tbl_member 를 직접 조회해 담는다.
 */
@Getter
@Setter
@ToString
public class BaseLocationDto {

	private Double baseLat;		//tbl_member.latitude
	private Double baseLng;		//tbl_member.longitude
	private String address;		//tbl_member.address

}
