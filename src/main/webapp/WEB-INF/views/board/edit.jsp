<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.writeform {
			max-width: 760px;
			margin: 0 auto;
			padding: 24px;
			border: 1px solid var(--color-border);
			border-radius: var(--radius);
			background: var(--color-bg);
		}
		.writeform select {
			width: 200px;
		}
		.writeform textarea {
			resize: vertical;
			min-height: 260px;
		}
		.writefoot {
			display: flex;
			justify-content: flex-end;
			gap: 8px;
			margin-top: 20px;
		}
		.counter {
			font-size: 12px;
			color: var(--color-text-light);
			text-align: right;
			margin-top: 4px;
		}
	</style>
</head>
<body>
	<!-- board/edit.jsp: 동네 게시판 글 수정 (⑥ B-09-06). 내 글만 들어올 수 있다 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>글 수정 <small>Edit</small></h2>

		<form class="writeform" id="boardForm" method="post" action="${path}/board/editok.do">

			<%-- CSRF 토큰. 일반 form 은 Ajax 와 달리 직접 넣어야 한다 --%>
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

			<%-- 어느 글을 고치는지 같이 보낸다 --%>
			<input type="hidden" name="boardSeq" value="${dto.boardSeq}">

			<div class="form-group">
				<label for="regionSeq">동네</label>
				<select id="regionSeq" name="regionSeq" required>
					<c:forEach var="region" items="${regionList}">
						<option value="${region.regionSeq}"
							${dto.regionSeq eq region.regionSeq ? 'selected' : ''}>${region.regionName}</option>
					</c:forEach>
				</select>
			</div>

			<div class="form-group">
				<label for="subject">제목</label>
				<input type="text" id="subject" name="subject" maxlength="60"
					value="<c:out value='${dto.subject}' />" required>
			</div>

			<div class="form-group">
				<label for="content">내용</label>
				<textarea id="content" name="content" maxlength="1300" required><c:out value="${dto.content}" /></textarea>
				<p class="counter"><span id="len">0</span> / 1300</p>
			</div>

			<div class="writefoot">
				<a class="btn" href="${path}/board/view.do?boardSeq=${dto.boardSeq}">취소</a>
				<button type="submit" class="btn btn-primary">수정</button>
			</div>
		</form>
	</main>

	<script>
		//처음 들어왔을 때 글자 수를 한 번 세어준다
		$('#len').text($('#content').val().length);

		$('#content').on('input', function () {

			$('#len').text($(this).val().length);
		});

		$('#boardForm').on('submit', function () {

			if ($('#subject').val().trim() === '') {
				alert('제목을 입력해주세요.');
				$('#subject').focus();
				return false;
			}

			if ($('#content').val().trim() === '') {
				alert('내용을 입력해주세요.');
				$('#content').focus();
				return false;
			}

			return true;
		});
	</script>
</body>
</html>