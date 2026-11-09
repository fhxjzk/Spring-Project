package com.project.app.expert.model;

import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExpertProfileDto {
	private Long expertSeq;
	private String name;
	private String intro;
	private String serviceAddress;
	//double 이면 폼에서 값이 비어 왔을 때 변환 오류(400)가 나서, 비어 있으면 null 이 되도록 Double 을 쓴다
	private Double serviceLatitude;
	private Double serviceLongitude;
	private Date regdate;
	private String hidden;	// Y: 신고 처리로 숨김, N: 공개
	private String profileImage;	// 프로필 사진 파일 이름 (resources/upload/profile), 없으면 null

	//--- 프로필 작성·수정 폼에서만 쓰는 값 (테이블 컬럼 아님) ---

	//경력 입력 줄. 폼의 careerList[0].title, careerList[0].startDate ... 가 여기에 담긴다
	private List<ExpertCareerDto> careerList;

	//체크한 활동 가능 지역 번호 (tbl_region 1 ~ 17)
	private List<Integer> regionSeqs;

}
