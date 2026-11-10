package com.project.app.wish.service;

import java.util.List;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import com.project.app.expert.model.ExpertCardDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.service.ExpertService;
import com.project.app.wish.repository.WishDao;

import lombok.RequiredArgsConstructor;

/**
 * 찜하기 (추가 기능)
 *
 * 고객만 고수를 찜한다. 고수는 다른 고수에게 요청을 보낼 수 없어서 찜도 하지 않는다 (WishController 에서 확인)
 */
@Service
@RequiredArgsConstructor
public class WishService {
	private final WishDao wishDao;
	private final ExpertService expertService;

	//고수가 받은 찜 수 (고수 상세의 ♡ 옆 숫자)
	public int countWish(Long expertSeq) {
		return wishDao.countWish(expertSeq);
	}

	//이 회원이 이 고수를 찜했는지. 비로그인(null)이면 false
	public boolean isWished(Long memberSeq, Long expertSeq) {

		if (memberSeq == null || expertSeq == null) {
			return false;
		}

		return wishDao.isWished(memberSeq, expertSeq);
	}

	/**
	 * 찜 ↔ 찜 해제
	 * 찜한 고수면 해제하고, 아니면 찜한다
	 * @return 1 찜함, 0 찜 해제함, -1 찜할 수 없는 고수 (없는 고수, 숨김 처리된 고수)
	 */
	public int toggle(Long memberSeq, Long expertSeq) {

		if (memberSeq == null || expertSeq == null) {
			return -1;
		}

		//찜 해제는 고수가 숨김이 되었어도 할 수 있다
		if (wishDao.deleteWish(memberSeq, expertSeq) > 0) {
			return 0;
		}

		ExpertProfileDto profile = expertService.getProfile(expertSeq);

		if (profile == null || "Y".equals(profile.getHidden())) {
			return -1;
		}

		try {
			wishDao.addWish(memberSeq, expertSeq);
		} catch (DuplicateKeyException e) {
			//하트를 빠르게 두 번 눌러서 거의 동시에 두 요청이 온 경우. 이미 찜이 들어가 있다 (pk_wish)
		}

		return 1;
	}

	//찜 해제만 (찜한 고수 목록). 지운 줄 수를 돌려준다 (이미 해제했으면 0)
	public int delete(Long memberSeq, Long expertSeq) {

		if (memberSeq == null || expertSeq == null) {
			return 0;
		}

		return wishDao.deleteWish(memberSeq, expertSeq);
	}

	//내가 찜한 고수 (최근에 찜한 순, 숨김 · 탈퇴 고수 제외)
	public List<ExpertCardDto> getWishList(Long memberSeq) {
		return wishDao.getWishList(memberSeq);
	}

}
