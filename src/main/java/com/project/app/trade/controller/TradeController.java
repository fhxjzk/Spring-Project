package com.project.app.trade.controller;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.app.auth.CustomUser;
import com.project.app.point.service.PointService;
import com.project.app.trade.exception.TradeErrorCode;
import com.project.app.trade.exception.TradeException;
import com.project.app.trade.model.TradeDto;
import com.project.app.trade.model.TradeFileDto;
import com.project.app.trade.model.TradeTab;
import com.project.app.trade.service.TradeService;

import lombok.RequiredArgsConstructor;

/**
 * 거래 (④ 결제·거래·통계)
 *
 * ③ 견적 확인·고수 선택에서 /trade/pay.do?quoteSeq=견적번호 로 넘어오면 결제 화면이 열리고,
 * 결제하면 거래가 만들어진다.
 *
 * 본인 견적·거래인지, 지금 상태에서 할 수 있는지는 TradeService에서 확인한다. (IDOR 방지)
 * 오류는 TradeExceptionHandler가 처리한다. (오류 메시지를 들고 보던 화면으로 돌아감)
 *
 * security-context.xml에서 list.do, view.do는 비로그인에게도 열려 있어서 mylist.do, detail.do를 쓴다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/trade")
public class TradeController {

	//결과물 저장 폴더 (CONVENTION.md: resources/upload/기능/)
	private static final String UPLOAD_PATH = "/resources/upload/trade";

	private final TradeService tradeService;
	private final PointService pointService;

	//결제 화면: 견적 금액, 내 잔액
	@GetMapping(value = "/pay.do")
	public String pay(Model model, Long quoteSeq, Authentication auth) {

		Long memberSeq = memberSeq(auth);

		model.addAttribute("quote", tradeService.getQuoteForPay(quoteSeq, memberSeq));
		model.addAttribute("balance", pointService.getBalance(memberSeq));

		return "trade/pay";
	}

	//결제: 요청서·견적 선택 확정 + 거래 생성 + 포인트 차감을 한 번에 처리한다
	@PostMapping(value = "/payok.do")
	public String payok(Long quoteSeq, Authentication auth, RedirectAttributes ra) {

		Long tradeSeq = tradeService.pay(quoteSeq, memberSeq(auth));

		ra.addFlashAttribute("message", "결제가 완료됐어요. 포인트는 구매 확정 전까지 플랫폼이 보관해요.");

		return redirectDetail(tradeSeq);
	}

	//내 거래 목록 (④-04). 고객: 맡긴 거래, 고수: 맡은 거래. tab으로 상태를 거른다 (?tab=PROGRESS)
	@GetMapping(value = "/mylist.do")
	public String mylist(Model model, String tab, Authentication auth) {

		CustomUser user = (CustomUser) auth.getPrincipal();
		boolean expert = "ROLE_EXPERT".equals(user.getDto().getRole());
		TradeTab current = TradeTab.of(tab);

		model.addAttribute("expert", expert);
		model.addAttribute("tabs", TradeTab.values());
		model.addAttribute("tab", current);
		model.addAttribute("list", tradeService.listMine(user.getMemberSeq(), expert, current));

		return "trade/mylist";
	}

	//거래 상세: 진행 상황, 결과물과 작업 시작·완료, 구매 확정, 취소 버튼
	@GetMapping(value = "/detail.do")
	public String detail(Model model, Long tradeSeq, Authentication auth) {

		Long memberSeq = memberSeq(auth);
		TradeDto trade = tradeService.getForMember(tradeSeq, memberSeq);

		model.addAttribute("trade", trade);
		model.addAttribute("files", tradeService.getFiles(tradeSeq));
		model.addAttribute("isCustomer", trade.isCustomer(memberSeq));
		model.addAttribute("isExpert", trade.isExpert(memberSeq));
		model.addAttribute("autoConfirmDays", TradeService.AUTO_CONFIRM_DAYS);
		model.addAttribute("canWriteReview", trade.isCustomer(memberSeq) && tradeService.canWriteReview(tradeSeq, memberSeq));

		return "trade/detail";
	}

	//작업 시작 (고수)
	@PostMapping(value = "/startok.do")
	public String startok(Long tradeSeq, Authentication auth, RedirectAttributes ra) {

		tradeService.start(tradeSeq, memberSeq(auth));

		ra.addFlashAttribute("message", "작업을 시작했어요.");

		return redirectDetail(tradeSeq);
	}

	//작업 완료 + 결과물 파일 (고수). 파일 form이라 CSRF 토큰은 action 주소에 붙인다 (detail.jsp)
	@PostMapping(value = "/completeok.do")
	public String completeok(Long tradeSeq, MultipartFile file, Authentication auth, HttpServletRequest req, RedirectAttributes ra) {

		tradeService.complete(tradeSeq, memberSeq(auth), file, uploadDir(req));

		ra.addFlashAttribute("message", "납품을 완료했어요. 고객이 구매 확정하면 포인트가 정산돼요.");

		return redirectDetail(tradeSeq);
	}

	//구매 확정 (고객)
	@PostMapping(value = "/confirmok.do")
	public String confirmok(Long tradeSeq, Authentication auth, RedirectAttributes ra) {

		tradeService.confirm(tradeSeq, memberSeq(auth));

		ra.addFlashAttribute("message", "구매 확정했어요. 고수에게 포인트가 정산됐어요.");

		return redirectDetail(tradeSeq);
	}

	//거래 취소 (고객, 작업 시작 전)
	@PostMapping(value = "/cancelok.do")
	public String cancelok(Long tradeSeq, Authentication auth, RedirectAttributes ra) {

		tradeService.cancel(tradeSeq, memberSeq(auth));

		ra.addFlashAttribute("message", "거래를 취소했어요. 결제한 포인트를 돌려드렸어요.");

		return redirectDetail(tradeSeq);
	}

	//결과물 다운로드 (이 거래의 고객, 고수만)
	@GetMapping(value = "/download.do")
	public void download(Long tradeFileSeq, Authentication auth, HttpServletRequest req, HttpServletResponse resp) throws IOException {

		TradeFileDto file = tradeService.getFileForMember(tradeFileSeq, memberSeq(auth));
		File target = new File(uploadDir(req), file.getFilename());

		if (!target.exists()) {
			throw new TradeException(TradeErrorCode.FILE_NOT_FOUND);
		}

		//한글 파일 이름이 깨지지 않게 UTF-8로 인코딩한다
		String encoded = URLEncoder.encode(file.getOrgname(), StandardCharsets.UTF_8).replace("+", "%20");

		resp.setContentType("application/octet-stream");
		resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);
		resp.setContentLengthLong(target.length());

		Files.copy(target.toPath(), resp.getOutputStream());
	}

	private Long memberSeq(Authentication auth) {

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

	private String uploadDir(HttpServletRequest req) {

		return req.getServletContext().getRealPath(UPLOAD_PATH);
	}

	private String redirectDetail(Long tradeSeq) {

		return "redirect:/trade/detail.do?tradeSeq=" + tradeSeq;
	}

}
