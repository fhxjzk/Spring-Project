<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		/*
			common.css 의 .form-box 는 420px 로그인 상자다. 글쓰기에는 좁아서 쓰지 않는다.
			.form-group 만 가져다 쓰고 폭은 여기서 따로 준다
		*/
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
	<!-- board/add.jsp: 동네 게시판 글쓰기 (⑥ B-09-03) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>글쓰기 <small>Write</small></h2>

		<form class="writeform" id="boardForm" method="post" action="${path}/board/addok.do">

			<%-- CSRF 토큰. 일반 form 은 Ajax 와 달리 직접 넣어야 한다 --%>
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

			<div class="form-group">
				<label for="regionSeq">동네</label>
				<select id="regionSeq" name="regionSeq" required>
					<c:forEach var="region" items="${regionList}">
						<option value="${region.regionSeq}">${region.regionName}</option>
					</c:forEach>
				</select>
			</div>

			<div class="form-group">
				<label for="subject">제목</label>
				<input type="text" id="subject" name="subject" maxlength="60"
					placeholder="제목을 입력해주세요" required>
			</div>

			<div class="form-group">
				<label for="content">내용</label>
				<textarea id="content" name="content" maxlength="1300"
					placeholder="이웃들에게 하고 싶은 이야기를 적어주세요" required></textarea>
				<p class="counter"><span id="len">0</span> / 1300</p>
			</div>

			<div class="writefoot">
				<a class="btn" href="${path}/board/list.do">취소</a>
				<button type="submit" class="btn btn-primary">등록</button>
			</div>
		</form>
	</main>

	<script>
		//글자 수 표시
		$('#content').on('input', function () {

			$('#len').text($(this).val().length);
		});

		$('#boardForm').on('submit', function () {

			//공백만 넣는 것을 막는다
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