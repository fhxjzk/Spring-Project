<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<%--
		review/item-head.jsp: 리뷰 한 줄(review/item.jsp)이 쓰는 CSS 와 답변 확인 JS

		쓰는 법 — 리뷰 목록이 있는 화면의 <head> 안, asset.jsp 다음에 한 번 넣는다
			<%@ include file="/WEB-INF/views/review/item-head.jsp" %>
		지금 쓰는 곳: 고수 상세(expert/view.jsp), 리뷰 전체보기(review/list.jsp)
	--%>
	<style>
		.review-item + .review-item {
			margin-top: 12px;
			padding-top: 12px;
			border-top: 1px solid var(--color-border);
		}

		.review-head {
			display: flex;
			align-items: center;
			gap: 8px;
		}

		.review-stars {
			color: var(--color-warning);
			letter-spacing: 2px;
		}

		.review-date {
			margin-left: auto;
		}

		.review-body {
			margin: 6px 0 0;
			white-space: pre-line;	/* 리뷰에 쓴 줄바꿈을 그대로 보여 준다 */
		}

		/* 고수 답변: 리뷰 아래 연한 회색 상자. 왼쪽 파란 선으로 "고수가 단 글"인 걸 구분 */
		.review-reply {
			margin-top: 10px;
			padding: 10px 14px;
			border-left: 3px solid var(--color-primary);
			border-radius: 0 8px 8px 0;
			background-color: var(--color-bg-light);
		}

		.review-reply strong {
			margin-right: 6px;
			font-size: 14px;
		}

		.review-reply p {
			margin: 4px 0 0;
			white-space: pre-line;
		}

		/* 본인 고수에게만 보이는 답변 입력 칸 */
		.reply-form {
			margin-top: 10px;
		}

		.reply-form textarea {
			width: 100%;
		}

		.reply-form-footer {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-top: 6px;
		}
	</style>

	<script>
		// 리뷰 답변 등록 전 확인 (②-06). 서버(ReviewService.addReply)에서도 같은 조건으로 한 번 더 확인한다
		// 리뷰마다 폼이 따로 있어서, onsubmit 에서 누른 그 폼(this)을 받는다
		function checkReply(form) {

			const text = form.reply.value.trim();

			if (text === '') {
				alert('답변 내용을 입력해 주세요.');
				form.reply.focus();
				return false;
			}

			// tbl_review.reply VARCHAR2(2000) 은 바이트 기준. 한글 한 글자 = 3바이트
			if (new TextEncoder().encode(text).length > 2000) {
				alert('답변이 너무 길어요. (한글 약 660자까지)');
				form.reply.focus();
				return false;
			}

			return confirm('답변을 등록할까요? 등록한 답변은 수정할 수 없어요.');
		}
	</script>
