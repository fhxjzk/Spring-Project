package com.project.app.board.repository;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.board.mapper.BoardCommentMapper;
import com.project.app.board.model.BoardCommentDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BoardCommentDao {

	private final BoardCommentMapper boardCommentMapper;

	//그 글의 댓글 목록 (B-09-12)
	public List<BoardCommentDto> getList(Long boardSeq) {

		return boardCommentMapper.getList(boardSeq);
	}

	public BoardCommentDto get(Long commentSeq) {

		return boardCommentMapper.get(commentSeq);
	}

	//댓글 쓰기 (B-09-11)
	public int add(BoardCommentDto dto) {

		return boardCommentMapper.add(dto);
	}

	//댓글 고치기 (B-09-13). 쓴 사람이 아니면 0 이 돌아온다
	public int edit(BoardCommentDto dto) {

		return boardCommentMapper.edit(dto);
	}

	//댓글 지우기 (B-09-14). 쓴 사람이 아니면 0 이 돌아온다
	public int remove(Long commentSeq, Long memberSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("commentSeq", commentSeq);
		map.put("memberSeq", memberSeq);

		return boardCommentMapper.remove(map);
	}

}
