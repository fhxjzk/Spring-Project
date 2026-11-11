package com.project.app.wish.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.project.app.expert.model.ExpertCardDto;
import com.project.app.wish.mapper.WishMapper;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class WishDao {
	private final WishMapper wishMapper;

	public int countWish(Long expertSeq) {
		return wishMapper.countWish(expertSeq);
	}

	public boolean isWished(Long memberSeq, Long expertSeq) {
		return wishMapper.isWished(memberSeq, expertSeq) > 0;
	}

	public int addWish(Long memberSeq, Long expertSeq) {
		return wishMapper.addWish(memberSeq, expertSeq);
	}

	public int deleteWish(Long memberSeq, Long expertSeq) {
		return wishMapper.deleteWish(memberSeq, expertSeq);
	}

	public List<ExpertCardDto> getWishList(Long memberSeq) {
		return wishMapper.getWishList(memberSeq);
	}
}
