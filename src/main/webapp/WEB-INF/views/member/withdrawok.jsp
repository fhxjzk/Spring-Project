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
	<!-- member/withdrawok.jsp -->
	<script>

		<c:if test="${result == 1}">
		alert('탈퇴가 완료되었습니다.');
		location.href = '${path}/index.do';
		</c:if>

		<c:if test="${result == -1}">
		alert('비밀번호가 맞지 않습니다.');
		history.back();
		</c:if>

		<c:if test="${result == -2}">
		alert('아직 마무리되지 않은 항목이 있어 탈퇴할 수 없습니다.');
		location.href = '${path}/member/withdraw.do';
		</c:if>

		<c:if test="${result == 0}">
		alert('탈퇴하지 못했습니다.');
		history.back();
		</c:if>

	</script>
</body>
</html>