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
	<!-- logout.jsp -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="form-box">
			<h2>로그아웃</h2>

			<p class="message-info">로그아웃 하시겠어요?</p>

			<form method="POST" action="${path}/auth/logout.do">
				<button class="btn btn-primary btn-block">로그아웃</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>
		</div>
	</main>

	<script>

	</script>
</body>
</html>
