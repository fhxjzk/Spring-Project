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
	<!-- request/addok.jsp -->
	<script>

		<c:if test="${result == 1}">
		alert('요청서가 등록되었습니다. 48시간 동안 견적을 받을 수 있어요.');
		location.href = '${path}/request/mylist.do';
		</c:if>

		<c:if test="${result == -1}">
		alert('필수 질문에 답해 주세요.');
		history.back();
		</c:if>

		<c:if test="${result == -2}">
		alert('참고 이미지는 jpg, png, gif 파일만 첨부할 수 있습니다.');
		history.back();
		</c:if>

		<c:if test="${result == 0}">
		alert('요청서를 등록하지 못했습니다. 입력한 내용을 확인해 주세요.');
		history.back();
		</c:if>

	</script>
</body>
</html>
