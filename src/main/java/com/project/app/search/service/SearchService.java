package com.project.app.search.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.search.model.RegionDto;
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

}
