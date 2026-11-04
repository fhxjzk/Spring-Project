package com.project.app.board.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.board.model.BoardDto;
import com.project.app.board.model.BoardPageDto;
import com.project.app.board.repository.BoardDao;
import com.project.app.search.model.RegionDto;
import com.project.app.search.service.SearchService;

import lombok.RequiredArgsConstructor;

/**
 * 동네 커뮤니티 게시판 (⑥ B-09)
 *
 * 지역 목록은 고수 검색(B-04)에서 쓰는 것과 같아서 SearchService 를 그대로 쓴다.
 */
@Service
@RequiredArgsConstructor
public class BoardService {

	private final BoardDao boardDao;
	private final SearchService searchService;

	//지역 드롭다운에 쓸 17개
	public List<RegionDto> getRegionList() {

		return searchService.getRegionList();
	}

	/**
	 * 지역별 글 목록 (B-09-01, B-09-02)
	 *
	 * 전체 글 수를 세어 page 에 담아 준다. 화면은 그 값으로 페이지 번호를 그린다.
	 */
	public List<BoardDto> getList(BoardPageDto page) {

		page.setDefault();
		page.setTotal(boardDao.getCount(page));

		return boardDao.getList(page);
	}

	/**
	 * 글 상세 (B-09-04, B-09-05, B-09-08)
	 *
	 * 열 때마다 조회수를 1 올리고, 내 글인지 표시해서 돌려준다.
	 * 없는 글이거나 숨김 처리된 글이면 null 이다.
	 *
	 * @param memberSeq 로그인한 회원 번호. 비회원이면 null
	 */
	@Transactional
	public BoardDto get(Long boardSeq, Long memberSeq) {

		if (boardSeq == null) {
			return null;
		}

		boardDao.addReadcount(boardSeq);

		BoardDto dto = boardDao.get(boardSeq);

		if (dto == null) {
			return null;
		}

		//내 글이면 수정·삭제 버튼, 남의 글이면 신고하기를 보여준다
		dto.setMine(memberSeq != null && memberSeq.equals(dto.getMemberSeq()));

		return dto;
	}

	//수정 화면에 띄울 글. 내 글이 아니면 null 이라 수정 화면이 안 열린다 (B-09-06)
	public BoardDto getMine(Long boardSeq, Long memberSeq) {

		BoardDto dto = boardDao.get(boardSeq);

		if (dto == null || !dto.getMemberSeq().equals(memberSeq)) {
			return null;
		}

		dto.setMine(true);

		return dto;
	}

	//글 쓰기 (B-09-03)
	public int add(BoardDto dto) {

		return boardDao.add(dto);
	}

	//글 고치기 (B-09-06). 글쓴이가 아니면 0 이 돌아온다
	public int edit(BoardDto dto) {

		return boardDao.edit(dto);
	}

	//글 지우기 (B-09-07). 글쓴이가 아니면 0 이 돌아온다
	public int remove(Long boardSeq, Long memberSeq) {

		return boardDao.remove(boardSeq, memberSeq);
	}

	//--- 관리자 신고 처리에서 쓴다 (E-02-05) ---

	public int hide(Long boardSeq) {

		return boardDao.hide(boardSeq);
	}

	public int show(Long boardSeq) {

		return boardDao.show(boardSeq);
	}

}
