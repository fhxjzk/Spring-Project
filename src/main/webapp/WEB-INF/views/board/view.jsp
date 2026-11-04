<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.post {
			max-width: 760px;
			margin: 0 auto;
		}
		.post-head {
			padding-bottom: 14px;
			border-bottom: 1px solid var(--color-border);
		}
		.post-head h3 {
			margin: 0 0 10px;
			font-size: 22px;
			line-height: 1.4;
			word-break: break-all;
		}
		.post-meta {
			display: flex;
			gap: 14px;
			flex-wrap: wrap;
			font-size: 13px;
			color: var(--color-text-light);
		}
		/* 줄바꿈을 그대로 보여준다. <br> 로 바꾸지 않아도 된다 */
		.post-body {
			padding: 24px 0;
			min-height: 180px;
			line-height: 1.8;
			white-space: pre-wrap;
			word-break: break-all;
		}
		.post-foot {
			display: flex;
			justify-content: space-between;
			gap: 8px;
			padding-top: 16px;
			border-top: 1px solid var(--color-border);
		}
		.post-foot .right {
			display: flex;
			gap: 8px;
		}
		.post-foot form {
			margin: 0;
		}

		/* 댓글 (B-09-11 ~ B-09-14) */
		.cmt {
			margin-top: 26px;
			padding-top: 18px;
			border-top: 1px solid var(--color-border);
		}
		.cmt h4 {
			margin: 0 0 12px;
			font-size: 15px;
		}
		.cmt-write {
			display: flex;
			gap: 8px;
			margin-bottom: 16px;
		}
		.cmt-write textarea {
			flex: 1;
			min-height: 60px;
			resize: vertical;
		}
		.cmt-item {
			padding: 12px 0;
			border-bottom: 1px solid var(--color-border);
		}
		.cmt-item:last-child {
			border-bottom: 0;
		}
		.cmt-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
			gap: 10px;
			flex-wrap: wrap;
		}
		.cmt-who {
			font-size: 13px;
			font-weight: 600;
		}
		.cmt-when {
			font-size: 12px;
			color: var(--color-text-light);
		}
		.cmt-head form {
			margin: 0;
			display: inline;
		}
		.cmt-head a, .cmt-head button.link {
			font-size: 12px;
			color: var(--color-primary);
			background: none;
			border: 0;
			padding: 0;
			cursor: pointer;
			text-decoration: none;
		}
		/* 줄바꿈을 그대로 보여준다 */
		.cmt-body {
			margin: 6px 0 0;
			font-size: 14px;
			line-height: 1.7;
			white-space: pre-wrap;
			word-break: break-all;
		}
		.cmt-edit {
			margin: 8px 0 0;
			display: none;
			gap: 8px;
		}
		.cmt-edit textarea {
			flex: 1;
			min-height: 60px;
			resize: vertical;
		}
	</style>
</head>
<body>
	<!-- board/view.jsp: 동네 게시판 글 상세 (⑥ B-09-04, B-09-05, B-09-07, B-09-08, B-09-09) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>동네 이야기 <small>Community</small></h2>

		<div class="post">
			<div class="post-head">
				<h3><c:out value="${dto.subject}" /></h3>

				<div class="post-meta">
					<span class="badge badge-primary">${dto.regionName}</span>
					<span><c:out value="${dto.writerName}" /></span>
					<span>${dto.regdate}</span>
					<span>조회 ${dto.readcount}</span>
					<c:if test="${not empty dto.moddate}">
						<span>(수정 ${dto.moddate})</span>
					</c:if>
				</div>
			</div>

			<div class="post-body"><c:out value="${dto.content}" /></div>

			<div class="post-foot">
				<a class="btn" href="${path}/board/list.do?regionSeq=${dto.regionSeq}&page=${page}">목록</a>

				<div class="right">
					<c:choose>
						<%-- 내 글일 때만 수정·삭제가 보인다 (B-09-08) --%>
						<c:when test="${dto.mine}">
							<a class="btn" href="${path}/board/edit.do?boardSeq=${dto.boardSeq}">수정</a>

							<form method="post" action="${path}/board/delok.do"
								onsubmit="return confirm('이 글을 삭제하시겠습니까?');">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
								<input type="hidden" name="boardSeq" value="${dto.boardSeq}">
								<input type="hidden" name="regionSeq" value="${dto.regionSeq}">
								<button type="submit" class="btn btn-danger">삭제</button>
							</form>
						</c:when>

						<%-- 남의 글이면 신고할 수 있다 (B-09-09). 비회원은 모달이 로그인 안내를 한다 --%>
						<c:otherwise>
							<button type="button" class="btn"
								onclick="openReportModal('BOARD', ${dto.boardSeq});">신고하기</button>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<%-- 댓글 (B-09-11 ~ B-09-14). 글 상세 안에 같이 있다. 따로 열리는 화면이 없다 --%>
			<div class="cmt">
				<h4>댓글 ${fn:length(commentList)}</h4>

				<%-- 댓글 쓰기는 로그인한 회원만. 비회원에게는 안내만 보여준다 --%>
				<sec:authorize access="isAuthenticated()">
				<form class="cmt-write" method="post" action="${path}/board/comment/addok.do"
					onsubmit="return checkComment(this);">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<input type="hidden" name="boardSeq" value="${dto.boardSeq}">
					<textarea name="content" maxlength="300" placeholder="댓글을 남겨보세요" required></textarea>
					<button type="submit" class="btn btn-primary">등록</button>
				</form>
				</sec:authorize>

				<sec:authorize access="!isAuthenticated()">
					<p class="message-info">댓글은 로그인 후에 쓸 수 있습니다.
						<a href="${path}/auth/login.do">로그인하러 가기</a></p>
				</sec:authorize>

				<c:forEach var="cmt" items="${commentList}">
				<div class="cmt-item">
					<div class="cmt-head">
						<span class="cmt-who"><c:out value="${cmt.writerName}" /></span>

						<span>
							<span class="cmt-when">${cmt.regdate}<c:if test="${not empty cmt.moddate}"> (수정됨)</c:if></span>

							<%-- 내 댓글일 때만 수정·삭제가 보인다 (B-09-13, B-09-14) --%>
							<c:if test="${cmt.mine}">
								&nbsp;
								<button type="button" class="link" onclick="toggleEdit(${cmt.commentSeq})">수정</button>
								&nbsp;
								<form method="post" action="${path}/board/comment/delok.do"
									onsubmit="return confirm('이 댓글을 삭제하시겠습니까?');">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
									<input type="hidden" name="commentSeq" value="${cmt.commentSeq}">
									<input type="hidden" name="boardSeq" value="${dto.boardSeq}">
									<button type="submit" class="link">삭제</button>
								</form>
							</c:if>
						</span>
					</div>

					<p class="cmt-body" id="cmtBody${cmt.commentSeq}"><c:out value="${cmt.content}" /></p>

					<c:if test="${cmt.mine}">
					<form class="cmt-edit" id="cmtEdit${cmt.commentSeq}" method="post"
						action="${path}/board/comment/editok.do" onsubmit="return checkComment(this);">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						<input type="hidden" name="commentSeq" value="${cmt.commentSeq}">
						<input type="hidden" name="boardSeq" value="${dto.boardSeq}">
						<textarea name="content" maxlength="300" required><c:out value="${cmt.content}" /></textarea>
						<button type="submit" class="btn btn-primary btn-sm">저장</button>
						<button type="button" class="btn btn-sm" onclick="toggleEdit(${cmt.commentSeq})">취소</button>
					</form>
					</c:if>
				</div>
				</c:forEach>

				<c:if test="${empty commentList}">
					<p class="message-info">아직 댓글이 없습니다. 첫 댓글을 남겨보세요.</p>
				</c:if>
			</div>
		</div>
	</main>

	<%-- 신고 모달 (⑥ B-07). 고수 프로필·요청서 화면에 붙인 것과 같은 파일이다 --%>
	<%@ include file="/WEB-INF/views/report/modal.jsp" %>

	<script>
		//댓글 수정칸 열고 닫기. 내용은 그 자리에서 바꾼다
		function toggleEdit(commentSeq) {

			const body = $('#cmtBody' + commentSeq);
			const form = $('#cmtEdit' + commentSeq);

			if (form.css('display') === 'none') {
				body.hide();
				form.css('display', 'flex');
				form.find('textarea').focus();
			} else {
				form.hide();
				body.show();
			}
		}

		//공백만 넣는 것을 막는다 (서버에서도 한 번 더 막는다)
		function checkComment(form) {

			const box = $(form).find('textarea');

			if (box.val().trim() === '') {
				alert('댓글 내용을 입력해주세요.');
				box.focus();
				return false;
			}

			return true;
		}
	</script>
</body>
</html>