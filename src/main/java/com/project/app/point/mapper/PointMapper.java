package com.project.app.point.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.point.model.PointHistoryDto;

//SQL은 resources/mappers/point/PointMapper.xml 에 있다 (메서드 이름 = XML의 id)
@Mapper
public interface PointMapper {

	Integer getBalance(Long memberSeq);

	int addPoint(@Param("memberSeq") Long memberSeq, @Param("amount") int amount);

	//잔액이 모자라면 0을 돌려준다
	int subtractPoint(@Param("memberSeq") Long memberSeq, @Param("amount") int amount);

	int addHistory(PointHistoryDto dto);

	List<PointHistoryDto> listHistory(Long memberSeq);

}
