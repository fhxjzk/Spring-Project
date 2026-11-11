package com.project.app.request.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_request_file (참고 이미지)
 */
@Getter
@Setter
@ToString
public class RequestFileDto {

	private Long fileSeq;
	private Long requestSeq;
	private String orgFilename;		//사용자가 올린 원래 파일 이름
	private String saveFilename;	//저장한 파일 이름 (UUID.확장자)
	private String regdate;

}
