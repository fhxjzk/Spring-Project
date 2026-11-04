package com.project.app.member.repository;
import java.util.HashMap;
import java.util.List;
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

	public int countByEmail(String email) {

		return memberMapper.countByEmail(email);
	}

	//비어 있는 조건은 빼고 찾는다
	public List<MemberDto> getList(String word, String role, String status) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("word", word);
		map.put("role", role);
		map.put("status", status);

		return memberMapper.getList(map);
	}
	public MemberDto getBySeq(Long memberSeq) {
		
		return memberMapper.getBySeq(memberSeq);
	}
	public int updateEnabled(Long memberSeq, String enabled) {
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("memberSeq", memberSeq);	
		map.put("enabled", enabled);
		
		return memberMapper.updateEnabled(map);
	}
}
