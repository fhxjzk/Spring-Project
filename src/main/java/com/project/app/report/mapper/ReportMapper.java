package com.project.app.report.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.report.model.ReportDto;

//SQL은 resources/mappers/report/ReportMapper.xml 에 있다 (메서드 이름 = XML의 id)
@Mapper
public interface ReportMapper {

	//--- 신고 접수 (B-07) ---

	int add(ReportDto dto);

	int countDuplicate(HashMap<String, Object> map);

	//--- 관리자 신고 처리 (E-02) ---

	List<ReportDto> getList(HashMap<String, Object> map);

	ReportDto getBySeq(Long reportSeq);

	Long getRequestOwner(Long targetSeq);
	
	int updateReviewing(HashMap<String, Object> map);

	int updateProcess(HashMap<String, Object> map);

	int updateExpertHidden(HashMap<String, Object> map);

	int updateRequestHidden(HashMap<String, Object> map);

}
