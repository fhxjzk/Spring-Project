package com.project.app.board.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.app.auth.CustomUser;
import com.project.app.board.model.BoardDto;
import com.project.app.board.model.BoardPageDto;
import com.project.app.board.service.BoardCommentService;
import com.project.app.board.service.BoardService;

import lombok.RequiredArgsConstructor;

/**
 * 동네 커뮤니티 게시판 (⑥ B-09)
 *
 * list.do 와 view.do 는 비회원도 들어올 수 있다.
 * (security-context.xml 에서 /**​/list.do, /**​/view.do 는 permitAll)
 * 나머지는 로그인이 필요하다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/board")
public class BoardController {

	private final BoardService boardService;
	private final BoardCommentService boardCommentService;

	//글 목록 (B-09-01, B-09-02). 비회원도 볼 수 있다
	@GetMapping(value = "/list.do")
	public String list(Model model, BoardPageDto page, Authentication auth) {

		//지역을 안 골랐으면 기본값을 정한다. 회원은 가입 지역, 비회원은 서울
		if (page.getRegionSeq() == null) {
			page.setRegionSeq(boardService.getDefaultRegion(getMemberSeq(auth)));
		}

		model.addAttribute("list", boardService.getList(page));
		model.addAttribute("regionList", boardService.getRegionList());
		model.addAttribute("page", page);

		return "board/list";
	}

	//글 상세 (B-09-04, B-09-05, B-09-08). 비회원도 볼 수 있다
	@GetMapping(value = "/view.do")
	public String view(Model model, RedirectAttributes rttr, Long boardSeq, Integer page, Authentication auth) {

		Long memberSeq = getMemberSeq(auth);

		BoardDto dto = boardService.get(boardSeq, memberSeq);

		//없는 글이거나 숨김 처리된 글이면 목록으로 보낸다
		if (dto == null) {
			rttr.addFlashAttribute("msg", "볼 수 없는 글입니다. 지워졌거나 신고 처리된 글일 수 있습니다.");
			return "redirect:/board/list.do";
		}

		model.addAttribute("dto", dto);
		model.addAttribute("page", page == null ? 1 : page);

		//댓글은 글 상세와 같이 나온다 (B-09-12). 비회원도 읽을 수 있다
		model.addAttribute("commentList", boardCommentService.getList(boardSeq, memberSeq));

		return "board/view";
	}

	//글쓰기 화면 (B-09-03)
	@GetMapping(value = "/add.do")
	public String add(Model model, Authentication auth) {

		model.addAttribute("regionList", boardService.getRegionList());

		//내가 사는 동네가 미리 골라져 있게 한다
		model.addAttribute("defaultRegion", boardService.getDefaultRegion(getMemberSeq(auth)));

		return "board/add";
	}

	//글 등록 (B-09-03)
	@PostMapping(value = "/addok.do")
	public String addok(RedirectAttributes rttr, BoardDto dto, Authentication auth) {

		//글쓴이는 화면에서 보낸 값을 믿지 않고 로그인한 회원 번호를 쓴다
		dto.setMemberSeq(getMemberSeq(auth));

		if (boardService.add(dto) == 0) {
			rttr.addFlashAttribute("msg", "글을 등록하지 못했습니다. 다시 시도해주세요.");
		} else {
			rttr.addFlashAttribute("msg", "글이 등록되었습니다.");
		}

		return "redirect:/board/list.do?regionSeq=" + dto.getRegionSeq();
	}

	//수정 화면 (B-09-06). 내 글이 아니면 상세로 돌려보낸다
	@GetMapping(value = "/edit.do")
	public String edit(Model model, RedirectAttributes rttr, Long boardSeq, Authentication auth) {

		BoardDto dto = boardService.getMine(boardSeq, getMemberSeq(auth));

		if (dto == null) {
			rttr.addFlashAttribute("msg", "고칠 수 없는 글입니다. 본인이 쓴 글만 고칠 수 있습니다.");
			return "redirect:/board/list.do";
		}

		model.addAttribute("dto", dto);
		model.addAttribute("regionList", boardService.getRegionList());

		return "board/edit";
	}

	//글 수정 (B-09-06)
	@PostMapping(value = "/editok.do")
	public String editok(RedirectAttributes rttr, BoardDto dto, Authentication auth) {

		dto.setMemberSeq(getMemberSeq(auth));

		//글쓴이가 아니면 0 이 돌아온다. 그때는 목록으로 보낸다
		if (boardService.edit(dto) == 0) {
			rttr.addFlashAttribute("msg", "고칠 수 없는 글입니다. 본인이 쓴 글만 고칠 수 있습니다.");
			return "redirect:/board/list.do";
		}

		rttr.addFlashAttribute("msg", "글이 수정되었습니다.");

		return "redirect:/board/view.do?boardSeq=" + dto.getBoardSeq();
	}

	//글 삭제 (B-09-07). 지우지 않고 숨김으로 바꾼다
	@PostMapping(value = "/delok.do")
	public String delok(RedirectAttributes rttr, @RequestParam Long boardSeq,
			@RequestParam Integer regionSeq, Authentication auth) {

		//글쓴이가 아니면 0 이 돌아온다
		if (boardService.remove(boardSeq, getMemberSeq(auth)) == 0) {
			rttr.addFlashAttribute("msg", "지울 수 없는 글입니다. 본인이 쓴 글만 지울 수 있습니다.");
		} else {
			rttr.addFlashAttribute("msg", "글이 삭제되었습니다.");
		}

		return "redirect:/board/list.do?regionSeq=" + regionSeq;
	}

	//로그인한 회원 번호. 비회원이면 null
	private Long getMemberSeq(Authentication auth) {

		if (auth == null || !(auth.getPrincipal() instanceof CustomUser)) {
			return null;
		}

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

}
