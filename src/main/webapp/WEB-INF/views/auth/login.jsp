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
	<!-- login.jsp -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="form-box">
			<h2>로그인</h2>

			<c:if test="${param.error != null}">
			<p class="message-error">아이디 또는 비밀번호가 맞지 않습니다.</p>
			</c:if>

			<form method="POST" action="${path}/login">
				<div class="form-group">
					<label for="username">아이디</label>
					<input type="text" id="username" name="username" required>
				</div>
				<div class="form-group">
					<label for="password">비밀번호</label>
					<input type="password" id="password" name="password" required>
				</div>
				<button class="btn btn-primary btn-block">로그인</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>

			<p class="form-footer">아직 회원이 아니신가요? <a href="${path}/member/add.do">회원가입</a></p>
		</div>
	</main>

	<script>

	</script>
</body>
</html>
