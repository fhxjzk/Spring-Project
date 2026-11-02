package com.project.app.expert.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.project.app.expert.model.ExpertDto;

@Mapper
public interface ExpertMapper {

	ExpertDto getProfile(Long expertSeq);

}
