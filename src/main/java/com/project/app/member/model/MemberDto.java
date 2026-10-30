package com.project.app.member.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_member
 *
 * 필드 이름은 칼럼 이름을 camelCase로 바꾼 것 (member_seq → memberSeq)
 */
@Getter
@Setter
@ToString(exclude = "pw")
public class MemberDto {

	private Long memberSeq;
	private String id;
	private String pw;
	private String name;
	private String email;
	private String role;		//ROLE_CUSTOMER, ROLE_EXPERT, ROLE_ADMIN
	private String enabled;		//Y: 사용, N: 탈퇴
	private String regdate;
	private String address; 	//주소
	private Double latitude;	//위도
	private Double longitude;	//경도
}
