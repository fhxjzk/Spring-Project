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
	<!-- member/addok.jsp -->
	<script>

		<c:if test="${result == 1}">
		alert('회원가입이 완료되었습니다.');
		location.href = '${path}/auth/login.do';
		</c:if>

		<c:if test="${result == -1}">
		alert('이미 사용 중인 아이디입니다.');
		history.back();
		</c:if>

		<c:if test="${result == 0}">
		alert('회원가입에 실패했습니다.');
		history.back();
		</c:if>

	</script>
</body>
</html>
