package com.project.app.auth;

import java.util.List;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import com.project.app.member.model.MemberDto;

import lombok.Getter;

/**
 * 로그인한 회원 정보
 *
 * 컨트롤러에서 로그인한 회원 번호를 꺼내는 방법
 *   Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();
 */
@Getter
public class CustomUser extends User {

	private final MemberDto dto;

	public CustomUser(MemberDto dto) {

		super(dto.getId(), dto.getPw(), List.of(new SimpleGrantedAuthority(dto.getRole())));

		this.dto = dto;
	}

	public Long getMemberSeq() {

		return dto.getMemberSeq();
	}

}
