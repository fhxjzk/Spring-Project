package com.project.app.report.repository;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.report.mapper.ReportMapper;
import com.project.app.report.model.ReportDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ReportDao {

	private final ReportMapper reportMapper;

	//--- 신고 접수 (B-07) ---

	public int add(ReportDto dto) {

		return reportMapper.add(dto);
	}

	//같은 사람이 같은 대상을 신고해두고 아직 처리가 안 됐는지 센다
	public int countDuplicate(Long reporterSeq, String targetType, Long targetSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("reporterSeq", reporterSeq);
		map.put("targetType", targetType);
		map.put("targetSeq", targetSeq);

		return reportMapper.countDuplicate(map);
	}

	//--- 관리자 신고 처리 (E-02) ---

	//status 가 null 이거나 빈 문자열이면 전체 목록이 나온다
	public List<ReportDto> getList(String status) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("status", status);

		return reportMapper.getList(map);
	}

	public ReportDto getBySeq(Long reportSeq) {

		return reportMapper.getBySeq(reportSeq);
	}
	
	//요청서를 쓴 사람 번호
	public Long getRequestOwner(Long targetSeq) {

		return reportMapper.getRequestOwner(targetSeq);
	}

	public int updateReviewing(Long reportSeq, Long adminSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("reportSeq", reportSeq);
		map.put("adminSeq", adminSeq);

		return reportMapper.updateReviewing(map);
	}

	public int updateProcess(Long reportSeq, String status, String processReason, Long adminSeq) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("reportSeq", reportSeq);
		map.put("status", status);
		map.put("processReason", processReason);
		map.put("adminSeq", adminSeq);

		return reportMapper.updateProcess(map);
	}

	//고수 프로필 숨김 / 해제. hidden 에 "Y" 또는 "N" 을 넣는다
	public int updateExpertHidden(Long targetSeq, String hidden) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("targetSeq", targetSeq);
		map.put("hidden", hidden);

		return reportMapper.updateExpertHidden(map);
	}

	//요청서 숨김 / 해제
	public int updateRequestHidden(Long targetSeq, String hidden) {

		HashMap<String, Object> map = new HashMap<>();
		map.put("targetSeq", targetSeq);
		map.put("hidden", hidden);

		return reportMapper.updateRequestHidden(map);
	}

}