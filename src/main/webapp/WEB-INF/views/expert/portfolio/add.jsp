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
	<!-- add.jsp: 포트폴리오 작성 (화면설계서 ②-08) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<%-- 파일 업로드 form 은 CSRF 토큰을 action 뒤에 붙인다 (CONVENTION.md) --%>
		<form class="card portfolio-form" id="portfolioForm" method="POST" enctype="multipart/form-data"
			action="${path}/expert/portfolio/addok.do?${_csrf.parameterName}=${_csrf.token}">

			<h2>포트폴리오 작성</h2>

			<div class="form-group">
				<label for="title">제목 <span class="required-mark">*</span></label>
				<input type="text" id="title" name="title" maxlength="100" placeholder="예: 입시 대비 레슨 기록" required>
			</div>

			<div class="form-group">
				<label for="content">내용 <span class="required-mark">*</span></label>
				<textarea id="content" name="content" rows="8" maxlength="4000" placeholder="어떤 작업이었는지 소개해 주세요" required></textarea>
			</div>

			<%-- 사진 칸 5개 + [+ 사진 추가] (작성 · 수정 공통) --%>
			<%@ include file="/WEB-INF/views/expert/portfolio/photo-slots.jsp" %>

			<div class="form-buttons">
				<a class="btn" href="${path}/expert/view.do?expertSeq=${expertSeq}">취소</a>
				<button class="btn btn-primary">등록</button>
			</div>
		</form>
	</main>
</body>
</html>
