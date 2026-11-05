package com.project.app.quote.controller;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.app.auth.CustomUser;
import com.project.app.quote.model.QuoteDto;
import com.project.app.quote.service.QuoteService;
import com.project.app.request.model.RequestDto;
import com.project.app.request.service.RequestService;

import lombok.RequiredArgsConstructor;

/**
 * 견적 전달 (D-02, ③ 요청서·견적)
 *
 * /quote/** 는 고수만 들어올 수 있다. (security-context.xml)
 * 요청서의 질문 답변과 참고 이미지는 고객 화면과 같은 것을 RequestService에서 가져온다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/quote")
public class QuoteController {

	private final QuoteService quoteService;
	private final RequestService requestService;

	//받은 요청서 목록. type=designated면 나를 지정한 요청서, 없으면 공개 요청서
	@GetMapping(value = "/request.do")
	public String request(Model model, Authentication auth,
			@RequestParam(value = "type", required = false) String type) {

		model.addAttribute("list", quoteService.requestList(getMemberSeq(auth), type));
		model.addAttribute("type", "designated".equals(type) ? "designated" : "open");

		return "quote/request";
	}

	//요청서 상세 + 견적 작성. 볼 수 없는 요청서면 목록으로 돌려보낸다
	@GetMapping(value = "/requestview.do")
	public String requestview(Model model, Authentication auth, RedirectAttributes rttr,
			@RequestParam(value = "requestSeq", required = false) Long requestSeq) {

		Long expertSeq = getMemberSeq(auth);
		RequestDto dto = quoteService.getRequest(requestSeq, expertSeq);

		if (dto == null) {
			rttr.addFlashAttribute("msg", "요청서를 찾을 수 없습니다.");
			return "redirect:/quote/request.do";
		}

		model.addAttribute("dto", dto);
		model.addAttribute("answerList", requestService.answerList(requestSeq));
		model.addAttribute("fileList", requestService.fileList(requestSeq));
		model.addAttribute("myQuote", quoteService.getMyQuote(requestSeq, expertSeq));
		model.addAttribute("activeExpert", quoteService.isActiveExpert(expertSeq));

		return "quote/requestview";
	}

	//견적 보내기
	@PostMapping(value = "/addok.do")
	public String addok(Authentication auth, RedirectAttributes rttr, QuoteDto dto) {

		dto.setExpertSeq(getMemberSeq(auth));

		int result;

		try {
			result = quoteService.add(dto);
		} catch (DuplicateKeyException e) {
			//같은 고수가 거의 동시에 두 번 보낸 경우 (DB의 중복 금지 조건에 걸림)
			result = -2;
		}

		String msg = "견적을 보내지 못했습니다. 입력한 내용을 확인해 주세요.";

		if (result == 1) {
			msg = "견적을 보냈습니다.";
		} else if (result == -1) {
			msg = "신고 처리로 숨김 상태라 견적을 보낼 수 없습니다.";
		} else if (result == -2) {
			msg = "이미 견적을 보낸 요청서입니다.";
		} else if (result == -3) {
			msg = "견적을 보낼 수 없는 요청서입니다. (마감되었거나 견적이 5개 모두 찼어요)";
		}

		rttr.addFlashAttribute("msg", msg);

		return "redirect:/quote/requestview.do?requestSeq=" + dto.getRequestSeq();
	}

	//지정 요청 거절
	@PostMapping(value = "/rejectok.do")
	public String rejectok(Authentication auth, RedirectAttributes rttr,
			@RequestParam(value = "requestSeq") Long requestSeq) {

		int result = quoteService.reject(requestSeq, getMemberSeq(auth));

		rttr.addFlashAttribute("msg", result == 1 ? "요청을 거절했습니다." : "거절할 수 없는 요청서입니다.");

		return "redirect:/quote/requestview.do?requestSeq=" + requestSeq;
	}

	//내가 보낸 견적 목록
	@GetMapping(value = "/mylist.do")
	public String mylist(Model model, Authentication auth) {

		model.addAttribute("list", quoteService.myList(getMemberSeq(auth)));

		return "quote/mylist";
	}

	//로그인한 회원 번호
	private Long getMemberSeq(Authentication auth) {

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

}
