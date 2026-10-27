<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

	<!-- asset.jsp: 모든 페이지의 <head> 안에 include 한다 -->

	<%-- 링크와 Ajax 주소는 항상 ${path}로 시작한다. 예) ${path}/request/list.do --%>
	<c:set var="path" value="${pageContext.request.contextPath}" />

	<%-- 서비스 이름이 정해지면 여기만 바꾼다 --%>
	<title>재능 거래 플랫폼</title>

	<%-- Ajax로 POST할 때 필요한 CSRF 토큰 (common.js가 자동으로 붙인다) --%>
	<meta name="_csrf" content="${_csrf.token}">
	<meta name="_csrf_header" content="${_csrf.headerName}">

	<link rel="icon" href="${path}/resources/favicon.png" type="image/png">
	<link rel="stylesheet" href="http://bit.ly/3WJ5ilK">
	<link rel="stylesheet" href="${path}/resources/css/common.css">

	<script src="https://code.jquery.com/jquery-4.0.0.js"></script>
	<script src="https://bit.ly/4cMuheh"></script>
	<script>
		const path = '${path}';
	</script>
	<script src="${path}/resources/js/common.js"></script>
