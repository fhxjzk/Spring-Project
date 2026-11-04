package com.project.app.board.repository;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.board.mapper.BoardMapper;
import com.project.app.board.model.BoardDto;
import com.project.app.board.model.BoardPageDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BoardDao {

	private final BoardMapper boardMapper;

	public List<BoardDto> getList(BoardPageDto page) {

		return boardMapper.getList(page);
	}

	public int getCount(BoardPageDto page) {

		return boardMapper.getCount(page);
	}

	public BoardDto get(Long boardSeq) {

		return boardMapper.get(boardSeq);
	}

	public int addReadcount(Long boardSeq) {

		return boardMapper.addReadcount(boardSeq);
	}

	public int add(BoardDto dto) {

		return boardMapper.add(dto);
	}

	public int edit(BoardDto dto) {

		return boardMapper.edit(dto);
	}

	public int remove(Long boardSeq, Long memberSeq) {

		//파라미터가 두 개라 HashMap에 담아서 넘긴다
		HashMap<String, Object> map = new HashMap<>();
		map.put("boardSeq", boardSeq);
		map.put("memberSeq", memberSeq);

		return boardMapper.remove(map);
	}

	//--- 관리자 신고 처리에서 쓴다 (E-02-05) ---

	public int hide(Long boardSeq) {

		return boardMapper.hide(boardSeq);
	}

	public int show(Long boardSeq) {

		return boardMapper.show(boardSeq);
	}

}
