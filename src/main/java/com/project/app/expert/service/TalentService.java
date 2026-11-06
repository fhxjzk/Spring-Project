package com.project.app.expert.service;

import java.nio.charset.StandardCharsets;
import java.util.HashSet;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertTalentDto;
import com.project.app.expert.repository.TalentDao;

import lombok.RequiredArgsConstructor;

/**
 * 제공 서비스 (화면설계서 ②-03 등록·수정·삭제, ②-10 상세)
 */
@Service
@RequiredArgsConstructor
public class TalentService {

	//서비스 하나에 연결할 수 있는 포트폴리오 수 (tbl_talent_portfolio.slot 1 ~ 3)
	private static final int MAX_PORTFOLIOS = 3;

	private final TalentDao talentDao;

	public ExpertTalentDto getTalent(Long talentSeq) {
		ExpertTalentDto tdto = talentDao.getTalent(talentSeq);
		return tdto;
	}

	public List<ExpertPortfolioDto> getPortfolioList(Long talentSeq) {
		List<ExpertPortfolioDto> plist = talentDao.getPortfolioList(talentSeq);
		return plist;
	}

	/**
	 * 서비스 등록
	 * 서비스 INSERT → 포트폴리오 연결 INSERT 를 한 번에 처리한다. 중간에 실패하면 전부 취소된다.
	 * @return 1: 성공, 0: 잘못된 입력, -1: 소분류가 아닌 카테고리, -2: 포트폴리오 개수 초과·중복, -3: 내 포트폴리오가 아님
	 */
	@Transactional
	public int add(ExpertTalentDto dto, List<Long> portfolioSeqs) {

		int checkResult = checkInput(dto, portfolioSeqs);

		if (checkResult != 1) {
			return checkResult;
		}

		//selectKey 가 dto.talentSeq 에 새 번호를 넣어 준다
		talentDao.addTalent(dto);

		savePortfolios(dto.getTalentSeq(), portfolioSeqs);

		return 1;
	}

	/**
	 * 서비스 수정
	 * 연결한 포트폴리오는 순서까지 바뀔 수 있어서, 기존 연결을 전부 지우고 고른 순서대로 다시 넣는다.
	 * @return add 와 같다. 0 에는 내 서비스가 아니거나 이미 삭제된 경우도 포함된다
	 */
	@Transactional
	public int edit(ExpertTalentDto dto, List<Long> portfolioSeqs) {

		int checkResult = checkInput(dto, portfolioSeqs);

		if (checkResult != 1) {
			return checkResult;
		}

		//where 에 expert_seq 까지 걸려 있어서, 내 서비스가 아니면 0줄이 바뀐다
		if (talentDao.editTalent(dto) == 0) {
			return 0;
		}

		//slot 이 UNIQUE 라서 새 연결을 넣기 전에 기존 연결을 먼저 지운다
		talentDao.deleteTalentPortfolios(dto.getTalentSeq());

		savePortfolios(dto.getTalentSeq(), portfolioSeqs);

		return 1;
	}

	/**
	 * 서비스 삭제
	 * 요청서, 거래가 서비스 제목을 참조할 수 있어서 행을 지우지 않고 enabled 만 N 으로 바꾼다 (CONVENTION.md "삭제")
	 * @return 1: 성공, 0: 내 서비스가 아니거나 이미 삭제된 서비스
	 */
	public int delete(ExpertTalentDto dto) {

		return talentDao.deleteTalent(dto);
	}

	//포트폴리오 연결 INSERT. 리스트 순서가 고객에게 보이는 순서(slot 1 ~ 3)가 된다
	private void savePortfolios(Long talentSeq, List<Long> portfolioSeqs) {

		if (portfolioSeqs == null) {
			return;
		}

		int slot = 1;

		for (Long portfolioSeq : portfolioSeqs) {
			talentDao.addTalentPortfolio(talentSeq, portfolioSeq, slot++);
		}
	}

	//등록, 수정에서 같이 쓰는 입력 확인. 반환값은 add 와 같다
	private int checkInput(ExpertTalentDto dto, List<Long> portfolioSeqs) {

		if (!isValidText(dto) || dto.getPrice() < 0) {
			return 0;
		}

		//대분류 번호를 보내도 막는다. 견적을 받는 기준이 소분류라서 소분류만 등록할 수 있다
		if (dto.getCategorySeq() == null || talentDao.countSubCategory(dto.getCategorySeq()) == 0) {
			return -1;
		}

		//포트폴리오 연결은 필수가 아니다 (화면설계서 ②-03)
		if (portfolioSeqs == null || portfolioSeqs.isEmpty()) {
			return 1;
		}

		//HashSet 에 넣으면 중복이 사라지니까, 크기가 줄어들면 같은 번호가 들어온 것이다
		if (portfolioSeqs.size() > MAX_PORTFOLIOS
				|| portfolioSeqs.contains(null)
				|| new HashSet<>(portfolioSeqs).size() != portfolioSeqs.size()) {
			return -2;
		}

		//번호는 화면에서 바꿔 보낼 수 있으니, 전부 내 포트폴리오인지 DB로 확인한다
		if (talentDao.countMyPortfolios(dto.getExpertSeq(), portfolioSeqs) != portfolioSeqs.size()) {
			return -3;
		}

		return 1;
	}

	//제목, 소개가 비어 있지 않고 컬럼 크기(바이트)를 넘지 않는지. 한글은 한 글자에 3바이트
	private boolean isValidText(ExpertTalentDto dto) {

		if (dto.getTitle() == null || dto.getContent() == null) {
			return false;
		}

		dto.setTitle(dto.getTitle().trim());
		dto.setContent(dto.getContent().trim());

		return !dto.getTitle().isEmpty() && byteLength(dto.getTitle()) <= 100
				&& !dto.getContent().isEmpty() && byteLength(dto.getContent()) <= 4000;
	}

	private int byteLength(String value) {

		return value.getBytes(StandardCharsets.UTF_8).length;
	}
}
