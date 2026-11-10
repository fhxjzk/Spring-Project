package com.project.app.request.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 요청서 알림을 받을 사람 한 명 (B-06 실시간 알림)
 *
 * 알림을 보내려면 받는 회원의 번호와 아이디가 둘 다 필요해서 같이 조회한다.
 */
@Getter
@Setter
@ToString
public class RequestNoticeDto {

	private Long requestSeq;		//어느 요청서의 알림인지
	private Long memberSeq;			//알림을 받는 회원
	private String id;				//알림을 받는 회원의 아이디 (실시간 전송에 쓴다)
	private String categoryName;	//알림 글에 넣을 카테고리 이름
	private Long expertSeq;			//지정 요청이면 지정한 고수 (공개 요청은 null)

}
