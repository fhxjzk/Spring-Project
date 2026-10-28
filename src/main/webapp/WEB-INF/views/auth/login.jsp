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
		<h2>로그인 <small>Login</small></h2>

		<c:if test="${param.error != null}">
		<p class="message-error">아이디 또는 비밀번호가 맞지 않습니다.</p>
		</c:if>

		<form method="POST" action="${path}/login">
		<table class="vertical content">
			<tr>
				<th>아이디</th>
				<td><input type="text" name="username" required class="short"></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="password" required class="short"></td>
			</tr>
		</table>
		<div>
			<button class="login">로그인</button>
		</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		</form>
	</main>

	<script>

	</script>
</body>
</html>
