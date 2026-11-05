package com.project.app.board.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.app.auth.CustomUser;
import com.project.app.board.model.BoardCommentDto;
import com.project.app.board.service.BoardCommentService;

import lombok.RequiredArgsConstructor;

/**
 * 동네 게시판 댓글 (⑥ B-09-11, B-09-13, B-09-14)
 *
 * 댓글 목록(B-09-12)은 글 상세와 같이 나오므로 BoardController 가 담고,
 * 여기서는 쓰기·수정·삭제만 받는다.
 *
 * 주소가 /board/comment/... 라서 security-context.xml 의 /** 규칙에 걸린다.
 * 즉 로그인해야 들어올 수 있다. (list.do · view.do 만 비회원 허용)
 */
@Controller
@RequiredArgsConstructor
@RequestMapping(value = "/board/comment")
public class BoardCommentController {

	private final BoardCommentService boardCommentService;

	//댓글 쓰기 (B-09-11)
	@PostMapping(value = "/addok.do")
	public String addok(RedirectAttributes rttr, BoardCommentDto dto, Authentication auth) {

		//쓴 사람은 화면에서 보낸 값을 믿지 않고 로그인한 회원 번호를 쓴다
		dto.setMemberSeq(getMemberSeq(auth));

		if (boardCommentService.add(dto) == 0) {
			rttr.addFlashAttribute("msg", "댓글을 남기지 못했습니다. 볼 수 없는 글일 수 있습니다.");
		}

		return goBack(dto.getBoardSeq());
	}

	//댓글 고치기 (B-09-13)
	@PostMapping(value = "/editok.do")
	public String editok(RedirectAttributes rttr, BoardCommentDto dto, Authentication auth) {

		dto.setMemberSeq(getMemberSeq(auth));

		if (boardCommentService.edit(dto) == 0) {
			rttr.addFlashAttribute("msg", "고칠 수 없는 댓글입니다. 본인이 쓴 댓글만 고칠 수 있습니다.");
		}

		return goBack(dto.getBoardSeq());
	}

	//댓글 지우기 (B-09-14)
	@PostMapping(value = "/delok.do")
	public String delok(RedirectAttributes rttr, @RequestParam Long commentSeq,
			@RequestParam Long boardSeq, Authentication auth) {

		if (boardCommentService.remove(commentSeq, getMemberSeq(auth)) == 0) {
			rttr.addFlashAttribute("msg", "지울 수 없는 댓글입니다. 본인이 쓴 댓글만 지울 수 있습니다.");
		}

		return goBack(boardSeq);
	}

	//어느 글의 댓글이었는지 모르면 목록으로 보낸다
	private String goBack(Long boardSeq) {

		if (boardSeq == null) {
			return "redirect:/board/list.do";
		}

		return "redirect:/board/view.do?boardSeq=" + boardSeq;
	}

	//로그인한 회원 번호. 이 화면은 로그인해야 들어오지만 그래도 확인한다
	private Long getMemberSeq(Authentication auth) {

		if (auth == null || !(auth.getPrincipal() instanceof CustomUser)) {
			return null;
		}

		return ((CustomUser) auth.getPrincipal()).getMemberSeq();
	}

}
