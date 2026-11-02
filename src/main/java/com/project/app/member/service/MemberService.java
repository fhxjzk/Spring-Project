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
	 * @return 1: 성공, 0: 실패, -1: 아이디 중복, -2: 이메일 중복, -3: 위치 확인 실패, -4: 입력값 오류
	 */
	public int add(MemberDto dto) {

		//가입 화면에서 고를 수 있는 권한은 고객, 고수뿐이다 (화면을 조작해서 관리자로 가입하는 것을 막는다)
		if (!"ROLE_CUSTOMER".equals(dto.getRole()) && !"ROLE_EXPERT".equals(dto.getRole())) {
			return 0;
		}

		//아이디, 비밀번호 규칙을 서버에서도 확인한다 (화면 검사는 우회할 수 있다)
		if (dto.getId() == null || !dto.getId().matches("[A-Za-z0-9]{3,20}")
				|| dto.getPw() == null || dto.getPw().length() < 8) {
			return -4;
		}

		//이름, 이메일, 주소는 필수 항목이다
		if (dto.getName() == null || dto.getName().isBlank()
				|| dto.getEmail() == null || dto.getEmail().isBlank()
				|| dto.getAddress() == null || dto.getAddress().isBlank()) {
			return -4;
		}

		if (memberDao.countById(dto.getId()) > 0) {
			return -1;
		}

		if (memberDao.countByEmail(dto.getEmail()) > 0) {
			return -2;
		}

		//좌표는 화면에서 오는 값이라 서버에서 값과 범위를 한 번 더 확인한다
		if (dto.getLatitude() == null || dto.getLongitude() == null
				|| !(dto.getLatitude() >= -90 && dto.getLatitude() <= 90)
				|| !(dto.getLongitude() >= -180 && dto.getLongitude() <= 180)) {
			return -3;
		}

		dto.setPw(encoder.encode(dto.getPw()));

		return memberDao.add(dto);
	}

}
