<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>

	</style>
</head>
<body>
	<!-- member/add.jsp: 회원가입 (주소, 좌표 등 A-01 항목은 ① 담당자가 추가) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="form-box">
			<h2>회원가입</h2>

			<form method="POST" action="${path}/member/addok.do">
				<div class="form-group">
					<label>가입 유형</label>
					<div class="radio-group">
						<label><input type="radio" name="role" value="ROLE_CUSTOMER" checked> 고객</label>
						<label><input type="radio" name="role" value="ROLE_EXPERT"> 고수</label>
					</div>
				</div>
				<div class="form-group">
					<label for="id">아이디</label>
					<input type="text" id="id" name="id" required maxlength="50">
				</div>
				<div class="form-group">
					<label for="pw">비밀번호</label>
					<input type="password" id="pw" name="pw" required>
				</div>
				<div class="form-group">
					<label for="name">이름</label>
					<input type="text" id="name" name="name" required maxlength="50">
				</div>
				<div class="form-group">
					<label for="email">이메일</label>
					<input type="email" id="email" name="email" required maxlength="100">
				</div>
				<button class="btn btn-primary btn-block">가입하기</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>

			<p class="form-footer">이미 회원이신가요? <a href="${path}/auth/login.do">로그인</a></p>
		</div>
	</main>

	<script>

	</script>
</body>
</html>
