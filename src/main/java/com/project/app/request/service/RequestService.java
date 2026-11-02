package com.project.app.request.service;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;

import com.project.app.request.model.QuestionDto;
import com.project.app.request.model.QuestionOptionDto;
import com.project.app.request.model.RequestAnswerDto;
import com.project.app.request.model.RequestCategoryDto;
import com.project.app.request.model.RequestDto;
import com.project.app.request.model.RequestFileDto;
import com.project.app.request.repository.RequestDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RequestService {

	//참고 이미지로 받을 수 있는 확장자
	private static final Set<String> IMAGE_EXT = Set.of("jpg", "jpeg", "png", "gif");

	private final RequestDao requestDao;

	//대분류 목록
	public List<RequestCategoryDto> parentCategoryList() {

		return requestDao.categoryList(null);
	}

	//대분류의 소분류 목록
	public List<RequestCategoryDto> childCategoryList(Long parentSeq) {

		return requestDao.categoryList(parentSeq);
	}

	//카테고리의 질문 항목과 보기
	public List<QuestionDto> questionList(Long categorySeq) {

		return requestDao.questionList(categorySeq);
	}

	//가입할 때 등록한 주소 (요청 지역 기본값)
	public String getMemberAddress(Long memberSeq) {

		return requestDao.getMemberAddress(memberSeq);
	}

	/**
	 * 공개 요청서 등록 (C-01-a)
	 *
	 * 요청서, 질문 답변, 참고 이미지를 한 번에 저장한다. 중간에 실패하면 전부 취소하고 저장한 파일도 지운다.
	 *
	 * @param params 질문 답변. 이름은 "q" + 질문 번호 (객관식은 보기 번호, 주관식은 글)
	 * @param uploadPath 참고 이미지를 저장할 폴더
	 * @return 1: 성공, 0: 잘못된 입력, -1: 필수 질문에 답하지 않음, -2: 이미지가 아닌 파일
	 */
	@Transactional
	public int add(RequestDto dto, MultiValueMap<String, String> params, List<MultipartFile> files, String uploadPath) {

		//1. 입력 값 검사
		RequestCategoryDto category = dto.getCategorySeq() == null ? null : requestDao.getCategory(dto.getCategorySeq());

		//요청서는 소분류로만 쓴다
		if (category == null || category.getParentSeq() == null) {
			return 0;
		}

		dto.setAddress(dto.getAddress() == null ? "" : dto.getAddress().trim());

		if (dto.getAddress().isEmpty() || byteLength(dto.getAddress()) > 300) {
			return 0;
		}

		if (!isValidWishDate(dto.getWishDate())) {
			return 0;
		}

		if (dto.getBudget() != null && dto.getBudget() <= 0) {
			return 0;
		}

		List<RequestAnswerDto> answers = new ArrayList<>();
		int answerResult = makeAnswers(dto.getCategorySeq(), params, answers);

		if (answerResult != 1) {
			return answerResult;
		}

		List<MultipartFile> images = new ArrayList<>();

		if (files != null) {
			for (MultipartFile file : files) {
				if (file.isEmpty()) {
					continue;
				}
				if (!isImage(file)) {
					return -2;
				}
				images.add(file);
			}
		}

		//2. 요청서 저장 (화면에서 보낸 값이 아니라 공개 요청 기준으로 채운다)
		dto.setExpertSeq(null);
		dto.setContent(null);
		dto.setWishDate(dto.getWishDate() == null || dto.getWishDate().isBlank() ? null : dto.getWishDate());

		requestDao.add(dto);

		for (RequestAnswerDto answer : answers) {
			answer.setRequestSeq(dto.getRequestSeq());
			requestDao.addAnswer(answer);
		}

		//3. 참고 이미지 저장
		List<File> saved = new ArrayList<>();

		try {
			File dir = new File(uploadPath);

			if (!dir.exists()) {
				dir.mkdirs();
			}

			for (MultipartFile image : images) {
				String orgFilename = Paths.get(image.getOriginalFilename()).getFileName().toString();
				String saveFilename = UUID.randomUUID() + "_" + orgFilename;

				File target = new File(dir, saveFilename);
				image.transferTo(target);
				saved.add(target);

				RequestFileDto fileDto = new RequestFileDto();
				fileDto.setRequestSeq(dto.getRequestSeq());
				fileDto.setOrgFilename(orgFilename);
				fileDto.setSaveFilename(saveFilename);

				requestDao.addFile(fileDto);
			}

		} catch (IOException | RuntimeException e) {
			//DB는 @Transactional이 되돌리고, 이미 저장한 파일은 여기서 지운다
			for (File file : saved) {
				file.delete();
			}
			throw new IllegalStateException("요청서 참고 이미지 저장 실패", e);
		}

		//TODO 해당 카테고리 고수들에게 요청서 도착 알림 (⑤ 공통 알림 기능이 생기면 호출)

		return 1;
	}

	/**
	 * 질문 답변 만들기
	 *
	 * 화면에서 보낸 값을 그대로 믿지 않고, DB의 질문·보기와 맞는지 확인한다.
	 * @return 1: 성공, 0: 잘못된 값, -1: 필수 질문에 답하지 않음
	 */
	private int makeAnswers(Long categorySeq, MultiValueMap<String, String> params, List<RequestAnswerDto> answers) {

		for (QuestionDto question : requestDao.questionList(categorySeq)) {

			List<String> values = new ArrayList<>();

			if (params.get("q" + question.getQuestionSeq()) != null) {
				for (String value : params.get("q" + question.getQuestionSeq())) {
					if (value != null && !value.isBlank()) {
						values.add(value.trim());
					}
				}
			}

			if (values.isEmpty()) {
				if ("Y".equals(question.getRequired())) {
					return -1;
				}
				continue;
			}

			if ("TEXT".equals(question.getQuestionType())) {

				if (values.size() > 1 || byteLength(values.get(0)) > 1000) {
					return 0;
				}

				RequestAnswerDto answer = new RequestAnswerDto();
				answer.setQuestionSeq(question.getQuestionSeq());
				answer.setAnswer(values.get(0));
				answers.add(answer);

				continue;
			}

			//객관식: 하나만(SINGLE) 또는 여러 개(MULTI), 이 질문의 보기만 고를 수 있다
			Set<Long> chosen = new LinkedHashSet<>();

			for (String value : values) {
				Long optionSeq = toLong(value);

				if (optionSeq == null || !hasOption(question, optionSeq)) {
					return 0;
				}
				chosen.add(optionSeq);
			}

			if ("SINGLE".equals(question.getQuestionType()) && chosen.size() > 1) {
				return 0;
			}

			for (Long optionSeq : chosen) {
				RequestAnswerDto answer = new RequestAnswerDto();
				answer.setQuestionSeq(question.getQuestionSeq());
				answer.setOptionSeq(optionSeq);
				answers.add(answer);
			}
		}

		return 1;
	}

	private boolean hasOption(QuestionDto question, Long optionSeq) {

		if (question.getOptions() == null) {
			return false;
		}

		for (QuestionOptionDto option : question.getOptions()) {
			if (option.getOptionSeq().equals(optionSeq)) {
				return true;
			}
		}

		return false;
	}

	//희망 일정은 비워도 되고, 쓰면 오늘 이후 날짜여야 한다
	private boolean isValidWishDate(String wishDate) {

		if (wishDate == null || wishDate.isBlank()) {
			return true;
		}

		try {
			return !LocalDate.parse(wishDate).isBefore(LocalDate.now());
		} catch (DateTimeParseException e) {
			return false;
		}
	}

	private boolean isImage(MultipartFile file) {

		String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
		int dot = name.lastIndexOf('.');
		String ext = dot < 0 ? "" : name.substring(dot + 1).toLowerCase();

		return IMAGE_EXT.contains(ext) && file.getContentType() != null && file.getContentType().startsWith("image/");
	}

	private Long toLong(String value) {

		try {
			return Long.valueOf(value);
		} catch (NumberFormatException e) {
			return null;
		}
	}

	//Oracle VARCHAR2 길이는 바이트 기준이다 (한글 1글자 = 3바이트)
	private int byteLength(String value) {

		return value.getBytes(StandardCharsets.UTF_8).length;
	}

}
