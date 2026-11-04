<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body>
	<!-- expert/portfolio/addok.jsp: 작성 결과 (PortfolioService.add 반환값) -->
	<script>

		<c:if test="${result == 1}">
		location.href = '${path}/expert/portfolio/view.do?portfolioSeq=${portfolioSeq}';
		</c:if>

		<c:if test="${result == -1}">
		alert('사진은 최대 5장까지 올릴 수 있어요.');
		history.back();
		</c:if>

		<c:if test="${result == -2}">
		alert('사진은 jpg, png, gif 파일만 올릴 수 있어요.');
		history.back();
		</c:if>

		<c:if test="${result == 0}">
		alert('포트폴리오를 등록하지 못했습니다. 제목과 내용을 확인해 주세요. (제목은 한글 약 33자까지)');
		history.back();
		</c:if>

	</script>
</body>
</html>
