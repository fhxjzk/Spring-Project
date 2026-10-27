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
	<!-- admin/index.jsp: 관리자 홈 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>관리자 <small>Admin</small></h2>
			<p>왼쪽 메뉴에서 관리할 항목을 선택하세요.</p>
		</main>
	</div>

	<script>

	</script>
</body>
</html>
