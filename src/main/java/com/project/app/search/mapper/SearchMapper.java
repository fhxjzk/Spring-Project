package com.project.app.search.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.search.model.RegionDto;

//SQL은 resources/mappers/search/SearchMapper.xml 에 있다 (메서드 이름 = XML의 id)
@Mapper
public interface SearchMapper {

	List<RegionDto> getRegionList();

	List<Integer> getRegionSeqListByExpert(Long expertSeq);

	int removeExpertRegion(Long expertSeq);

	int addExpertRegion(HashMap<String, Object> map);

}