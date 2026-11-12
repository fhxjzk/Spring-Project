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

	/**
	 * 고수 상세에 보여 줄 서비스 위치. 시·도 + 시·군·구까지만 (화면설계서 ②-04)
	 * 도로명 · 번지까지 다 보이면 고수의 정확한 위치가 드러나서 자른다. 작성·수정 폼은 serviceAddress 를 그대로 쓴다
	 *   "서울 강남구 테헤란로 123"        → "서울 강남구"
	 *   "경기 성남시 분당구 판교역로 235"  → "경기 성남시 분당구"
	 *   "세종특별자치시 한누리대로 2130"   → "세종특별자치시"
	 * 첫 단어(시·도) 뒤로 "시", "군", "구"로 끝나는 단어만 최대 두 개 붙인다
	 */
	public String getServiceRegion() {

		if (serviceAddress == null || serviceAddress.isBlank()) {
			return serviceAddress;
		}

		String[] words = serviceAddress.trim().split("\\s+");
		StringBuilder region = new StringBuilder(words[0]);

		for (int i = 1; i < words.length && i <= 2; i++) {

			if (!words[i].matches(".+[시군구]")) {
				break;
			}

			region.append(' ').append(words[i]);
		}

		return region.toString();
	}

}
