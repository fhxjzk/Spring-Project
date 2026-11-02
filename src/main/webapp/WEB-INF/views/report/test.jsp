<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body>
	<!-- report/test.jsp: 신고 모달 임시 확인용. ②③번 화면이 생기면 지운다 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>신고 모달 확인용 <small>임시</small></h2>
		<p>②③번 화면이 완성되면 이 파일은 지웁니다.</p>

		<p>
			<button class="btn btn-danger" onclick="openReportModal('PROFILE', 5)">고수 5번 신고</button>
			<button class="btn btn-danger" onclick="openReportModal('PROFILE', 6)">고수 6번 신고</button>
			<button class="btn btn-danger" onclick="openReportModal('REQUEST', 1)">요청서 1번 신고</button>
			<button class="btn btn-danger" onclick="openReportModal('REQUEST', 2)">요청서 2번 신고</button>
		</p>
	</main>

	<%@ include file="/WEB-INF/views/report/modal.jsp" %>
</body>
</html>