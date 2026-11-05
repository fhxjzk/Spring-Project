package com.project.app.board.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.project.app.board.model.BoardCommentDto;
import com.project.app.board.repository.BoardCommentDao;

import lombok.RequiredArgsConstructor;

/**
 * 동네 게시판 댓글 (⑥ B-09-11 ~ B-09-14)
 *
 * 글 수정·삭제와 같은 규칙이다. 화면에서 버튼을 감추는 것으로 끝내지 않고,
 * 저장·삭제할 때 쓴 사람이 맞는지 SQL 조건으로 한 번 더 확인한다.
 */
@Service
@RequiredArgsConstructor
public class BoardCommentService {

	private final BoardCommentDao boardCommentDao;

	/**
	 * 그 글의 댓글 목록 (B-09-12)
	 *
	 * @param memberSeq 로그인한 회원 번호. 비회원이면 null
	 */
	public List<BoardCommentDto> getList(Long boardSeq, Long memberSeq) {

		List<BoardCommentDto> list = boardCommentDao.getList(boardSeq);

		//내 댓글에만 수정·삭제 버튼을 그린다
		for (BoardCommentDto dto : list) {
			dto.setMine(memberSeq != null && memberSeq.equals(dto.getMemberSeq()));
		}

		return list;
	}

	/**
	 * 댓글 쓰기 (B-09-11)
	 *
	 * @return 1: 성공, 0: 실패(내용이 비었거나 글이 없거나 숨김 처리된 글)
	 */
	public int add(BoardCommentDto dto) {

		if (dto.getContent() == null || dto.getContent().trim().isEmpty()) {
			return 0;
		}

		dto.setContent(dto.getContent().trim());

		return boardCommentDao.add(dto);
	}

	//댓글 고치기 (B-09-13). 쓴 사람이 아니면 0 이 돌아온다
	public int edit(BoardCommentDto dto) {

		if (dto.getContent() == null || dto.getContent().trim().isEmpty()) {
			return 0;
		}

		dto.setContent(dto.getContent().trim());

		return boardCommentDao.edit(dto);
	}

	//댓글 지우기 (B-09-14). 쓴 사람이 아니면 0 이 돌아온다
	public int remove(Long commentSeq, Long memberSeq) {

		return boardCommentDao.remove(commentSeq, memberSeq);
	}

}
