package com.project.app.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.project.app.member.mapper.MemberMapper;
import com.project.app.member.model.MemberDto;

public class CustomUserDetailsService implements UserDetailsService {

	@Autowired
	private MemberMapper mapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

		MemberDto dto = mapper.getById(username);

		//없는 아이디이거나 탈퇴한 회원이면 로그인 실패
		if (dto == null || !"Y".equals(dto.getEnabled())) {
			throw new UsernameNotFoundException(username);
		}

		return new CustomUser(dto);
	}

}
