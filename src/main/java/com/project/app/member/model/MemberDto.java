package com.project.app.member.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_member
 *
 * 필드 이름은 칼럼 이름을 camelCase로 바꾼 것 (member_seq → memberSeq)
 * 주소, 좌표 등 회원가입 요구사항(A-01) 필드는 ① 담당자가 추가한다.
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

}
