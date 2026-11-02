package com.project.app.search.repository;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.search.mapper.SearchMapper;
import com.project.app.search.model.RegionDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class SearchDao {

	private final SearchMapper searchMapper;

	public List<RegionDto> getRegionList() {

		return searchMapper.getRegionList();
	}

	public List<Integer> getRegionSeqListByExpert(Long expertSeq) {

		return searchMapper.getRegionSeqListByExpert(expertSeq);
	}

	public int removeExpertRegion(Long expertSeq) {

		return searchMapper.removeExpertRegion(expertSeq);
	}

	public int addExpertRegion(Long expertSeq, List<Integer> regionSeqList) {

		//파라미터가 두 개라 HashMap에 담아서 넘긴다
		HashMap<String, Object> map = new HashMap<>();
		map.put("expertSeq", expertSeq);
		map.put("regionSeqList", regionSeqList);

		return searchMapper.addExpertRegion(map);
	}

}