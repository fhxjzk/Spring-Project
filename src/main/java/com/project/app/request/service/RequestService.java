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
import com.project.app.request.model.RequestQuoteDto;
import com.project.app.request.repository.RequestDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RequestService {

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

	/**
	 * 요청 지역 기본값
	 *
	 * 요청서는 여러 고수가 보기 때문에, 가입 주소에서 시·도와 시·군·구까지만 쓴다.
	 * 예) 서울 강남구 테헤란로 152 → 서울 강남구, 경기 성남시 분당구 판교로 1 → 경기 성남시 분당구
	 */
	public String getDefaultAddress(Long memberSeq) {

		String address = requestDao.getMemberAddress(memberSeq);

		if (address == null || address.isBlank()) {
			return "";
		}

		String[] words = address.trim().split(" ");
		String result = words[0];

		//두 번째, 세 번째 단어가 시·군·구로 끝나면 붙이고, 아니면(도로명 등) 멈춘다
		for (int i = 1; i < words.length && i < 3; i++) {
			if (words[i].endsWith("시") || words[i].endsWith("군") || words[i].endsWith("구")) {
				result += " " + words[i];
			} else {
				break;
			}
		}

		return result;
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

	//--- 내 요청서 관리 (C-01-d) ---

	//내가 쓴 요청서 목록 (최신순). 모르는 상태 값이면 전체를 보여 준다
	public List<RequestDto> myList(Long customerSeq, String status) {

		if (!isStatus(status)) {
			status = null;
		}

		return requestDao.myList(customerSeq, status);
	}

	//요청서 상태 값인지 확인 (모집 중, 견적 마감, 선택 완료, 취소, 거절, 만료)
	private boolean isStatus(String status) {

		return "OPEN".equals(status) || "CLOSED".equals(status) || "SELECTED".equals(status)
				|| "CANCELED".equals(status) || "REJECTED".equals(status) || "EXPIRED".equals(status);
	}

	//내가 쓴 요청서 하나. 다른 사람이 쓴 것이면 null
	public RequestDto getMine(Long requestSeq, Long customerSeq) {

		if (requestSeq == null) {
			return null;
		}

		RequestDto dto = requestDao.getMine(requestSeq, customerSeq);

		if (dto != null && dto.getRemainMinutes() != null) {

			String label = "고수 선택 마감";

			if ("OPEN".equals(dto.getStatus())) {
				label = "견적 마감";
			}

			dto.setRemainText(remainText(label, dto.getRemainMinutes()));
		}

		return dto;
	}

	//예) 견적 마감까지 1일 7시간 남음 / 고수 선택 마감까지 20분 남음 / 견적 마감 시간이 지났어요
	private String remainText(String label, long minutes) {

		if (minutes <= 0) {
			return label + " 시간이 지났어요";
		}

		long day = minutes / (24 * 60);
		long hour = minutes % (24 * 60) / 60;
		long minute = minutes % 60;

		String time;

		if (day > 0) {
			time = day + "일 " + hour + "시간";
		} else if (hour > 0) {
			time = hour + "시간 " + minute + "분";
		} else {
			time = minute + "분";
		}

		return label + "까지 " + time + " 남음";
	}

	/**
	 * 질문 답변 목록
	 *
	 * DB에서는 답 하나가 한 줄이라, 여러 개 고른 질문은 여러 줄로 온다.
	 * 같은 질문의 답은 쉼표로 이어서 질문 하나에 한 줄로 만든다. (예: 평일 저녁, 주말)
	 */
	public List<RequestAnswerDto> answerList(Long requestSeq) {

		List<RequestAnswerDto> result = new ArrayList<>();

		for (RequestAnswerDto answer : requestDao.answerList(requestSeq)) {

			//바로 앞 줄과 같은 질문이면 답만 이어 붙인다
			if (!result.isEmpty()) {
				RequestAnswerDto last = result.get(result.size() - 1);

				if (last.getQuestionSeq().equals(answer.getQuestionSeq())) {
					last.setAnswer(last.getAnswer() + ", " + answer.getAnswer());
					continue;
				}
			}

			result.add(answer);
		}

		return result;
	}

	public List<RequestFileDto> fileList(Long requestSeq) {

		return requestDao.fileList(requestSeq);
	}

	public List<RequestQuoteDto> quoteList(Long requestSeq) {

		return requestDao.quoteList(requestSeq);
	}

	/**
	 * 요청서 취소 (C-01-d)
	 *
	 * 본인이 쓴 요청서이고, 고수를 고르기 전(모집 중·견적 마감)일 때만 취소된다.
	 * 취소되면 대기 중인 견적은 모두 미선택이 된다. 둘은 한 번에 처리한다.
	 *
	 * @return 1: 성공, 0: 취소할 수 없음 (다른 사람 요청서이거나 이미 끝난 요청서)
	 */
	@Transactional
	public int cancel(Long requestSeq, Long customerSeq) {

		//상태 조건을 UPDATE 문에 넣어서, 그 사이 고수가 선택돼도 취소되지 않게 한다
		if (requestSeq == null || requestDao.cancel(requestSeq, customerSeq) == 0) {
			return 0;
		}

		requestDao.unselectQuotes(requestSeq);

		//TODO 견적을 보낸 고수들에게 취소 알림 (⑤ 공통 알림 기능이 생기면 호출)

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

		//참고 이미지로 받을 수 있는 확장자: jpg, jpeg, png, gif
		boolean imageExt = ext.equals("jpg") || ext.equals("jpeg") || ext.equals("png") || ext.equals("gif");

		return imageExt && file.getContentType() != null && file.getContentType().startsWith("image/");
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
