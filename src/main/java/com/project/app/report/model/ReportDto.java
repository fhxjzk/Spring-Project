package com.project.app.report.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_report
 *
 * 필드 이름은 칼럼 이름을 camelCase로 바꾼 것 (report_seq → reportSeq)
 */
@Getter
@Setter
@ToString
public class ReportDto {

	private Long reportSeq;
	private Long reporterSeq;		//신고한 회원
	private String targetType;		//PROFILE: 고수 프로필, REQUEST: 요청서
	private Long targetSeq;			//신고 대상 번호
	private String reasonType;		//ABUSE, FALSE_INFO, FRAUD, ETC
	private String reasonDetail;	//회원이 쓴 상세 내용
	private String status;			//RECEIVED, REVIEWING, DONE, REJECTED
	private String processReason;	//관리자가 쓴 처리 사유
	private Long adminSeq;			//처리한 관리자
	private String regdate;			//신고한 날짜
	private String processDate;		//처리한 날짜

	//--- 아래는 테이블에 없다. 목록 화면에 이름을 보여주려고 조인해서 채운다 ---
	private String reporterId;		//신고한 회원 아이디
	private String adminId;			//처리한 관리자 아이디

}
