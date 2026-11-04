package com.project.app.point.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.point.mapper.PointMapper;
import com.project.app.point.model.PointHistoryDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PointDao {

	private final PointMapper pointMapper;

	public Integer getBalance(Long memberSeq) {

		return pointMapper.getBalance(memberSeq);
	}

	public int addPoint(Long memberSeq, int amount) {

		return pointMapper.addPoint(memberSeq, amount);
	}

	public int subtractPoint(Long memberSeq, int amount) {

		return pointMapper.subtractPoint(memberSeq, amount);
	}

	public int addHistory(PointHistoryDto dto) {

		return pointMapper.addHistory(dto);
	}

	public List<PointHistoryDto> listHistory(Long memberSeq) {

		return pointMapper.listHistory(memberSeq);
	}

}
