package com.project.app.search.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.app.auth.CustomUser;
import com.project.app.search.model.BaseLocationDto;
import com.project.app.search.model.ExpertSearchDto;
import com.project.app.search.model.RegionDto;
import com.project.app.search.model.SearchDto;
import com.project.app.search.service.SearchService;

import lombok.RequiredArgsConstructor;

/**
 * 고수 검색·지도 조회 (⑥ B-04)
 *
 * 비회원도 들어올 수 있다. (security-context.xml 에서 list.do 는 permitAll)
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/search")
public class SearchController {

	private final SearchService searchService;

	//카카오맵 자바스크립트 키. secret.properties 에 있고 깃에는 올라가지 않는다.
	//뒤의 ':' 은 "값이 없으면 빈 값으로 두고 넘어가라"는 뜻이다.
	//이게 없으면 키를 안 넣은 팀원 PC에서 서버 자체가 안 뜬다.
	@Value("${kakao.js.key:}")
	private String kakaoMapKey;

	//검색 화면
	@GetMapping(value = "/list.do")
	public String list(Model model, SearchDto dto, Authentication auth) {

		List<RegionDto> regionList = searchService.getRegionList();

		//기준 위치를 정한다 (B-04-02)
		setBaseLocation(dto, auth, regionList, model);

		List<ExpertSearchDto> list = searchService.searchExperts(dto);
		int total = searchService.countExperts(dto);

		model.addAttribute("list", list);
		model.addAttribute("total", total);
		model.addAttribute("regionList", regionList);
		model.addAttribute("categoryList", searchService.getCategoryList());
		model.addAttribute("kakaoMapKey", kakaoMapKey);
		model.addAttribute("search", dto);

		//더보기 버튼을 보일지 (B-04-09)
		model.addAttribute("hasMore", dto.getPage() * dto.getSize() < total);

		return "search/list";
	}

	/**
	 * 검색 기준 위치를 정한다 (B-04-02)
	 *
	 *   1. 화면에서 GPS 좌표를 보냈으면 그것을 쓴다
	 *   2. 로그인한 회원이면 가입할 때 등록한 주소의 좌표
	 *   3. 비회원이면 고른 지역의 중심 좌표
	 *   4. 셋 다 없으면 거리 없이 카테고리 조건으로만 검색한다 (B-04-11)
	 */
	private void setBaseLocation(SearchDto dto, Authentication auth, List<RegionDto> regionList, Model model) {

		//1. GPS 로 찾기
		if (dto.getBaseLat() != null && dto.getBaseLng() != null) {

			model.addAttribute("baseLabel", "현재 위치 (GPS)");
			model.addAttribute("baseMode", "gps");
			return;
		}

		//2. 로그인한 회원이 등록한 주소
		if (auth != null && auth.getPrincipal() instanceof CustomUser) {

			Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();
			BaseLocationDto my = searchService.getMemberLocation(memberSeq);

			if (my != null && my.getBaseLat() != null && my.getBaseLng() != null) {

				dto.setBaseLat(my.getBaseLat());
				dto.setBaseLng(my.getBaseLng());

				model.addAttribute("baseLabel", my.getAddress() + " (내 등록 주소)");
				model.addAttribute("baseMode", "member");
				return;
			}
		}

		//3. 비회원 — 고른 지역의 중심 좌표
		if (dto.getRegionSeq() != null) {

			for (RegionDto region : regionList) {

				if (region.getRegionSeq().equals(dto.getRegionSeq())) {

					dto.setBaseLat(region.getCenterLat());
					dto.setBaseLng(region.getCenterLng());

					model.addAttribute("baseLabel", region.getRegionName() + " 중심");
					model.addAttribute("baseMode", "region");
					return;
				}
			}
		}

		//4. 기준 위치 없음 — 거리 조건 없이 검색한다
		model.addAttribute("baseLabel", "기준 위치 없음 (거리 조건 없이 검색합니다)");
		model.addAttribute("baseMode", "none");
	}

}
