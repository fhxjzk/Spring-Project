package com.project.app.member.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.member.model.MemberDto;

//SQL은 resources/mappers/member/MemberMapper.xml 에 있다 (메서드 이름 = XML의 id)
@Mapper
public interface MemberMapper {

	int add(MemberDto dto);

	MemberDto getById(String id);

	int countById(String id);

	int countByEmail(String email);
	
	int updateLastLogin(Long memberSeq);

	List<MemberDto> getList(HashMap<String, Object> map);
	
	MemberDto getBySeq(Long memberSeq);
	
	int updateEnabled(HashMap<String, Object> map);
}