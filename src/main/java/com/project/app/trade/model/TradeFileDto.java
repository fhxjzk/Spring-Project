package com.project.app.trade.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * tbl_trade_file (작업 결과물)
 *
 * 파일은 resources/upload/trade/ 에 "UUID_원래이름"으로 저장한다. (CONVENTION.md 업로드 규칙)
 */
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TradeFileDto {

	private Long tradeFileSeq;
	private Long tradeSeq;
	private String orgname;		//올린 파일 이름
	private String filename;	//저장한 파일 이름
	private Long filesize;		//바이트
	private String regdate;

	//JSP: ${file.filesizeText} → 1.2 MB
	public String getFilesizeText() {

		if (filesize == null) {
			return "";
		}
		if (filesize < 1024) {
			return filesize + " B";
		}
		if (filesize < 1024 * 1024) {
			return String.format("%.1f KB", filesize / 1024.0);
		}

		return String.format("%.1f MB", filesize / 1024.0 / 1024.0);
	}

}
