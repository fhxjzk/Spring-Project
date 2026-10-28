package com.project.app.member.repository;

import org.springframework.stereotype.Repository;

import com.project.app.member.mapper.MemberMapper;
import com.project.app.member.model.MemberDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class MemberDao {

	private final MemberMapper memberMapper;

	public int add(MemberDto dto) {

		return memberMapper.add(dto);
	}

	public MemberDto getById(String id) {

		return memberMapper.getById(id);
	}

	public int countById(String id) {

		return memberMapper.countById(id);
	}

}
