<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.portfolio-form {
			max-width: 760px;
			margin: 0 auto;
		}

		.form-hint {
			margin-top: 6px;
			font-size: 13px;
			color: var(--color-text-light);
		}

		.form-buttons {
			margin-top: 8px;
			text-align: right;
		}
	</style>
</head>
<body>
	<!-- edit.jsp: 포트폴리오 수정 (화면설계서 ②-08, 작성과 같은 모양) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<%-- 파일 업로드 form 은 CSRF 토큰을 action 뒤에 붙인다 (CONVENTION.md) --%>
		<form class="card portfolio-form" id="portfolioForm" method="POST" enctype="multipart/form-data"
			action="${path}/expert/portfolio/editok.do?${_csrf.parameterName}=${_csrf.token}">

			<h2>포트폴리오 수정</h2>

			<%-- 어떤 글을 고치는지. 바꿔서 보낼 수 있으니 컨트롤러에서 내 글인지 다시 확인한다 --%>
			<input type="hidden" name="portfolioSeq" value="${pdto.portfolioSeq}">

			<div class="form-group">
				<label for="title">제목 <span class="required-mark">*</span></label>
				<%-- 제목에 큰따옴표가 있으면 value 속성이 거기서 끊겨 제목칸이 비거나 잘린다. c:out 으로 이스케이프한다 --%>
				<input type="text" id="title" name="title" maxlength="100" placeholder="예: 입시 대비 레슨 기록" value="<c:out value='${pdto.title}' />" required>
			</div>

			<div class="form-group">
				<label for="content">내용 <span class="required-mark">*</span></label>
				<%-- textarea 는 value 속성이 없어서 태그 사이에 넣는다 (사이에 공백, 줄바꿈이 있으면 그대로 들어간다) --%>
				<%-- 내용에 </textarea> 가 있으면 입력칸이 거기서 닫혀 폼이 깨진다. c:out 으로 이스케이프한다 --%>
				<textarea id="content" name="content" rows="8" maxlength="4000" placeholder="어떤 작업이었는지 소개해 주세요" required><c:out value="${pdto.content}" /></textarea>
			</div>

			<%-- 사진 칸 5개 + [+ 사진 추가] (작성 · 수정 공통). 지금 사진(imgList)이 먼저 채워진다 --%>
			<%@ include file="/WEB-INF/views/expert/portfolio/photo-slots.jsp" %>

			<div class="form-buttons">
				<a class="btn" href="${path}/expert/portfolio/view.do?portfolioSeq=${pdto.portfolioSeq}">취소</a>
				<button class="btn btn-primary">수정</button>
			</div>
		</form>
	</main>
</body>
</html>
