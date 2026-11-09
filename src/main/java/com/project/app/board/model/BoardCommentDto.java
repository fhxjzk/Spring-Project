package com.project.app.board.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 동네 게시판 댓글 (⑥ B-09-11 ~ B-09-14)
 *
 * 글 상세 화면 아래에 같이 나온다. 따로 열리는 화면은 없다.
 */
@Getter
@Setter
@ToString
public class BoardCommentDto {

	private Long commentSeq;
	private Long boardSeq;			//어느 글의 댓글인지
	private Long memberSeq;			//쓴 사람
	private String content;
	private String enabled;			//Y: 사용, N: 삭제
	private String regdate;
	private String moddate;			//수정일. 안 고쳤으면 비어 있다

	//조인해서 가져오는 값
	private String writerName;		//쓴 사람 이름

	//화면에서만 쓰는 값. 내 댓글일 때만 수정·삭제 버튼을 그린다 (B-09-13, B-09-14)
	private boolean mine;

}
