package com.project.app.board.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.board.model.BoardCommentDto;

/**
 * 동네 게시판 댓글 (⑥ B-09-11 ~ B-09-14)
 *
 * XML은 mappers/board/BoardCommentMapper.xml 이다.
 */
@Mapper
public interface BoardCommentMapper {

	//그 글의 댓글 목록, 등록순 (B-09-12)
	List<BoardCommentDto> getList(Long boardSeq);

	//댓글 하나. 글 번호를 확인할 때 쓴다
	BoardCommentDto get(Long commentSeq);

	//댓글 쓰기 (B-09-11)
	int add(BoardCommentDto dto);

	//댓글 고치기 (B-09-13). 쓴 사람이 맞을 때만 바뀐다
	int edit(BoardCommentDto dto);

	//댓글 지우기 (B-09-14). 지우지 않고 숨김으로 바꾼다. 쓴 사람이 맞을 때만
	int remove(HashMap<String, Object> map);

}
