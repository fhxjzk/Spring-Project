package com.project.app.board.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.board.model.BoardDto;
import com.project.app.board.model.BoardPageDto;

/**
 * 동네 게시판 (⑥ B-09)
 *
 * XML은 mappers/board/BoardMapper.xml 이다.
 */
@Mapper
public interface BoardMapper {

	//지역별 글 목록 (B-09-01, B-09-02)
	List<BoardDto> getList(BoardPageDto page);

	//그 지역 글이 몇 개인지. 페이지 수를 구할 때 쓴다
	int getCount(BoardPageDto page);

	//로그인한 회원이 사는 동네. 주소로 찾는다. 못 찾으면 null
	Integer getMemberRegion(Long memberSeq);

	//글 하나 (B-09-04). 숨김 처리된 글은 null 로 돌아온다
	BoardDto get(Long boardSeq);

	//조회수 1 올리기 (B-09-05)
	int addReadcount(Long boardSeq);

	//글 쓰기 (B-09-03)
	int add(BoardDto dto);

	//글 고치기 (B-09-06). 글쓴이가 맞을 때만 바뀐다
	int edit(BoardDto dto);

	//글 지우기 (B-09-07). 지우지 않고 숨김으로 바꾼다. 글쓴이가 맞을 때만
	int remove(HashMap<String, Object> map);

	//신고 처리로 숨기기 (E-02-05). 관리자가 처리완료할 때 부른다
	int hide(Long boardSeq);

	//숨김 해제 (관리자)
	int show(Long boardSeq);

}