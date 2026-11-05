package com.project.app.request.service;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.QuestionOptionDto;
import com.project.app.request.model.RequestCategoryDto;
import com.project.app.request.repository.QuestionDao;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 요청서 질문 관리 (③ E-04)
 *
 * 이미 쓴 요청서의 답변이 그대로 보여야 하므로
 * - 질문과 보기는 지우지 않고 사용 안 함(enabled = 'N')으로 바꾼다
 * - 답변이 달린 질문은 유형을 바꿀 수 없다
 * - 누군가 고른 보기는 내용을 바꿀 수 없다 (사용 안 함으로 바꾸고 새 보기를 추가한다)
 *
 * 저장 결과: 1 성공, 0 잘못된 값, -1 내용을 비움, -2 객관식 보기가 2개 미만,
 *           -3 답변이 달린 질문의 유형 변경, -4 고른 사람이 있는 보기의 내용 변경, -5 없는 질문·카테고리,
 *           -6 글자 수 초과 (DB 칸이 바이트 기준이라 이모지처럼 큰 글자는 화면 제한보다 먼저 넘칠 수 있다)
 */
@Service
@RequiredArgsConstructor
public class QuestionService {

	private static final Set<String> TYPES = Set.of("SINGLE", "MULTI", "TEXT");
	private static final int MAX_OPTIONS = 20;

	private final QuestionDao questionDao;

	public List<RequestCategoryDto> subCategoryList() {

		return questionDao.subCategoryList();
	}

	//대분류이거나 없는 번호면 null
	public RequestCategoryDto getSubCategory(Long categorySeq) {

		if (categorySeq == null) {
			return null;
		}

		return questionDao.getSubCategory(categorySeq);
	}

	public List<QuestionDto> list(Long categorySeq) {

		return questionDao.list(categorySeq);
	}

	public QuestionDto get(Long questionSeq) {

		if (questionSeq == null) {
			return null;
		}

		return questionDao.get(questionSeq);
	}

	/**
	 * 질문 등록
	 * @param options 화면에서 보낸 보기 (내용이 빈 줄은 무시한다)
	 */
	@Transactional
	public int add(QuestionDto dto, List<QuestionOptionDto> options) {

		if (getSubCategory(dto.getCategorySeq()) == null) {
			return -5;
		}

		int result = check(dto);

		if (result != 1) {
			return result;
		}

		List<QuestionOptionDto> newOptions = new ArrayList<>();

		if (!"TEXT".equals(dto.getQuestionType())) {

			for (QuestionOptionDto option : options) {
				if (option.getOptionSeq() != null) {
					return 0;	//등록할 때는 기존 보기가 있을 수 없다
				}
				if (!option.getContent().isEmpty()) {
					newOptions.add(option);
				}
			}

			result = checkOptions(newOptions, newOptions.size());

			if (result != 1) {
				return result;
			}
		}

		questionDao.add(dto);

		int order = 1;

		for (QuestionOptionDto option : newOptions) {
			option.setQuestionSeq(dto.getQuestionSeq());
			option.setSortOrder(order++);
			option.setEnabled("Y");
			questionDao.addOption(option);
		}

		return 1;
	}

	/**
	 * 질문 수정 (카테고리는 바꾸지 않는다)
	 * @param options 화면의 보기 줄 순서대로. optionSeq 가 있으면 기존 보기, 없으면 새 보기
	 */
	@Transactional
	public int edit(QuestionDto dto, List<QuestionOptionDto> options) {

		QuestionDto saved = get(dto.getQuestionSeq());

		if (saved == null) {
			return -5;
		}

		int result = check(dto);

		if (result != 1) {
			return result;
		}

		if (saved.getAnswerCount() > 0 && !saved.getQuestionType().equals(dto.getQuestionType())) {
			return -3;
		}

		//기존 보기는 이 질문의 것만 받는다 (다른 질문의 보기 번호를 보내는 경우를 막는다)
		Map<Long, QuestionOptionDto> savedOptions = new HashMap<>();

		if (saved.getOptions() != null) {
			for (QuestionOptionDto option : saved.getOptions()) {
				savedOptions.put(option.getOptionSeq(), option);
			}
		}

		boolean text = "TEXT".equals(dto.getQuestionType());
		List<QuestionOptionDto> rows = new ArrayList<>();
		int enabledCount = 0;

		for (QuestionOptionDto option : options) {

			if (option.getOptionSeq() == null) {

				if (text || option.getContent().isEmpty()) {
					continue;	//주관식이거나 빈 새 줄은 무시한다
				}
				option.setEnabled("Y");

			} else {

				QuestionOptionDto before = savedOptions.remove(option.getOptionSeq());

				if (before == null || !("Y".equals(option.getEnabled()) || "N".equals(option.getEnabled()))) {
					return 0;
				}

				if (text) {
					//주관식으로 바꾸면 보기는 숨겨진 칸이므로 내용은 그대로 두고 모두 사용 안 함으로 바꾼다
					option.setContent(before.getContent());
					option.setEnabled("N");
				} else {
					if (option.getContent().isEmpty()) {
						return -1;
					}
					if (before.getAnswerCount() > 0 && !before.getContent().equals(option.getContent())) {
						return -4;
					}
				}
			}

			if ("Y".equals(option.getEnabled())) {
				enabledCount++;
			}
			rows.add(option);
		}

		//화면에서 빠진 기존 보기가 있으면 잘못 보낸 것이다
		if (!savedOptions.isEmpty()) {
			return 0;
		}

		if (!text) {
			result = checkOptions(rows, enabledCount);

			if (result != 1) {
				return result;
			}
		}

		questionDao.edit(dto);

		int order = 1;

		for (QuestionOptionDto option : rows) {

			option.setQuestionSeq(dto.getQuestionSeq());
			option.setSortOrder(order++);

			if (option.getOptionSeq() == null) {
				questionDao.addOption(option);
			} else {
				questionDao.editOption(option);
			}
		}

		return 1;
	}

	//사용 / 사용 안 함. 없는 질문이면 0
	public int updateEnabled(Long questionSeq, String enabled) {

		if (questionSeq == null || !("Y".equals(enabled) || "N".equals(enabled))) {
			return 0;
		}

		return questionDao.updateEnabled(questionSeq, enabled);
	}

	//질문 내용, 유형, 필수 여부, 순서 확인. 내용은 앞뒤 공백을 지워 둔다
	private int check(QuestionDto dto) {

		String content = dto.getContent() == null ? "" : dto.getContent().trim();
		dto.setContent(content);

		if (content.isEmpty()) {
			return -1;
		}

		if (byteLength(content) > 500) {
			return -6;
		}

		if (!TYPES.contains(dto.getQuestionType())) {
			return 0;
		}

		if (!("Y".equals(dto.getRequired()) || "N".equals(dto.getRequired()))) {
			return 0;
		}

		if (dto.getSortOrder() == null) {
			dto.setSortOrder(0);
		}

		if (dto.getSortOrder() < 0 || dto.getSortOrder() > 999) {
			return 0;
		}

		return 1;
	}

	//객관식 보기 확인: 줄 수, 길이, 사용 중인 보기 2개 이상
	private int checkOptions(List<QuestionOptionDto> rows, int enabledCount) {

		if (rows.size() > MAX_OPTIONS) {
			return 0;
		}

		for (QuestionOptionDto option : rows) {
			if (byteLength(option.getContent()) > 300) {
				return -6;
			}
		}

		if (enabledCount < 2) {
			return -2;
		}

		return 1;
	}

	private int byteLength(String value) {

		return value.getBytes(StandardCharsets.UTF_8).length;
	}

}
