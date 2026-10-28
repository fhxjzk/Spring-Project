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
		<h2>회원가입 <small>Register</small></h2>

		<form method="POST" action="${path}/member/addok.do">
		<table class="vertical">
			<tr>
				<th>가입 유형</th>
				<td>
					<label><input type="radio" name="role" value="ROLE_CUSTOMER" checked> 고객</label>
					<label><input type="radio" name="role" value="ROLE_EXPERT"> 고수</label>
				</td>
			</tr>
			<tr>
				<th>아이디</th>
				<td><input type="text" name="id" required class="short" maxlength="50"></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="pw" required class="short"></td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" name="name" required class="short" maxlength="50"></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="email" name="email" required maxlength="100"></td>
			</tr>
		</table>
		<div>
			<button class="in">가입하기</button>
		</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		</form>
	</main>

	<script>

	</script>
</body>
</html>
