package com.project.app.member.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.app.member.model.MemberDto;
import com.project.app.member.repository.MemberDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberService {

	private final MemberDao memberDao;
	private final BCryptPasswordEncoder encoder;

	/**
	 * 회원가입
	 * @return 1: 성공, 0: 실패, -1: 아이디 중복
	 */
	public int add(MemberDto dto) {

		//가입 화면에서 고를 수 있는 권한은 고객, 고수뿐이다 (화면을 조작해서 관리자로 가입하는 것을 막는다)
		if (!"ROLE_CUSTOMER".equals(dto.getRole()) && !"ROLE_EXPERT".equals(dto.getRole())) {
			return 0;
		}

		if (memberDao.countById(dto.getId()) > 0) {
			return -1;
		}

		dto.setPw(encoder.encode(dto.getPw()));

		return memberDao.add(dto);
	}

}
