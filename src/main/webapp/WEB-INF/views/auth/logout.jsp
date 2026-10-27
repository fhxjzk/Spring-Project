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
		<h2>로그아웃 <small>Logout</small></h2>

		<form method="POST" action="${path}/auth/logout.do">
		<div>
			<button class="logout">로그아웃</button>
		</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		</form>
	</main>

	<script>

	</script>
</body>
</html>
