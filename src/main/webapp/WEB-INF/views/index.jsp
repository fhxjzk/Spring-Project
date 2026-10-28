<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>

	</style>
</head>
<body>
	<!-- index.jsp: 메인 페이지 (화면 구성은 ② 담당) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>메인 <small>Index</small></h2>

		<p>기본 프로젝트가 정상적으로 실행되었습니다.</p>

		<sec:authorize access="isAuthenticated()">
		<p>로그인: <sec:authentication property="principal.dto.name" /> (<sec:authentication property="principal.dto.role" />)</p>
		</sec:authorize>
	</main>

	<script>

	</script>
</body>
</html>
