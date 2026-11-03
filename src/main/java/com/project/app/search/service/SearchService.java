package com.project.app.search.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.search.model.BaseLocationDto;
import com.project.app.search.model.ExpertSearchDto;
import com.project.app.search.model.RegionDto;
import com.project.app.search.model.SearchCategoryDto;
import com.project.app.search.model.SearchDto;
import com.project.app.search.repository.SearchDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SearchService {

	private final SearchDao searchDao;

	/**
	 * 지역 17개 (체크박스·드롭다운용)
	 */
	public List<RegionDto> getRegionList() {

		return searchDao.getRegionList();
	}

	/**
	 * 그 고수가 체크해둔 활동 가능 지역 번호 목록 (수정 화면 체크 표시용)
	 */
	public List<Integer> getRegionSeqListByExpert(Long expertSeq) {

		return searchDao.getRegionSeqListByExpert(expertSeq);
	}

	/**
	 * 고수의 활동 가능 지역을 저장한다. (② 고수 프로필 저장에서 부른다)
	 * 기존 지역을 전부 지우고 체크한 지역을 다시 넣는다.
	 */
	@Transactional
	public void saveExpertRegions(Long expertSeq, List<Integer> regionSeqList) {

		searchDao.removeExpertRegion(expertSeq);

		//체크를 하나도 안 했으면 지우기만 하고 끝낸다
		//(오라클 insert all은 넣을 게 하나도 없으면 오류가 난다)
		if (regionSeqList == null || regionSeqList.isEmpty()) {
			return;
		}

		searchDao.addExpertRegion(expertSeq, regionSeqList);
	}

	//--- 고수 검색 (B-04) ---

	/**
	 * 검색 조건 드롭다운에 쓸 카테고리 (소분류, B-04-01)
	 */
	public List<SearchCategoryDto> getCategoryList() {

		return searchDao.getCategoryList();
	}

	/**
	 * 로그인한 회원이 등록한 주소·좌표 (검색 기준 위치, B-04-02)
	 */
	public BaseLocationDto getMemberLocation(Long memberSeq) {

		return searchDao.getMemberLocation(memberSeq);
	}

	/**
	 * 고수 검색 결과 목록
	 * page, size, sort 가 비어 있으면 여기서 기본값을 채운다. (쿼리에 반드시 있어야 하는 값들)
	 */
	public List<ExpertSearchDto> searchExperts(SearchDto dto) {

		dto.setDefault();

		return searchDao.searchExperts(dto);
	}

	/**
	 * 검색 결과 전체 개수 ("총 N명" 표시, 더보기 버튼을 보일지 판단할 때 쓴다)
	 */
	public int countExperts(SearchDto dto) {

		dto.setDefault();

		return searchDao.countExperts(dto);
	}

}
