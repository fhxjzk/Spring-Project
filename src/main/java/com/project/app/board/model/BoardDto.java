package com.project.app.board.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 동네 게시판 글 (⑥ B-09)
 */
@Getter
@Setter
@ToString
public class BoardDto {

	private Long boardSeq;
	private Long memberSeq;			//글쓴이
	private Integer regionSeq;		//동네
	private String subject;
	private String content;
	private int readcount;
	private String enabled;			//Y: 사용, N: 삭제 또는 신고 처리로 숨김
	private String regdate;			//to_char 로 받아서 문자열로 둔다
	private String moddate;			//안 고쳤으면 비어 있다

	//조인해서 가져오는 값
	private String writerName;		//① tbl_member.name
	private String regionName;		//⑥ tbl_region.region_name

	//상세 화면에서 "내 글인가"를 판단한다 (B-09-08)
	//수정·삭제 버튼을 보일지, 신고하기를 보일지 가른다
	private boolean mine;

}
