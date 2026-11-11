package com.project.app.wish.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.app.expert.model.ExpertCardDto;

@Mapper
public interface WishMapper {

	int countWish(Long expertSeq);

	int isWished(@Param("memberSeq") Long memberSeq, @Param("expertSeq") Long expertSeq);

	int addWish(@Param("memberSeq") Long memberSeq, @Param("expertSeq") Long expertSeq);

	int deleteWish(@Param("memberSeq") Long memberSeq, @Param("expertSeq") Long expertSeq);

	List<ExpertCardDto> getWishList(Long memberSeq);

}
