<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body>
	<!-- expert/talent/addok.jsp: 등록 결과 (TalentService.add 반환값) -->
	<script>

		<%-- 등록한 서비스가 고수 프로필의 제공 서비스에 보이니까 내 프로필로 간다 --%>
		<c:if test="${result == 1}">
		location.href = '${path}/expert/view.do?expertSeq=${expertSeq}';
		</c:if>

		<c:if test="${result == 0}">
		alert('서비스를 등록하지 못했습니다. 제목, 소개, 가격을 확인해 주세요. (제목은 한글 약 33자까지)');
		history.back();
		</c:if>

		<c:if test="${result == -1}">
		alert('소분류를 선택해 주세요.');
		history.back();
		</c:if>

		<c:if test="${result == -2}">
		alert('포트폴리오는 겹치지 않게 최대 3개까지 연결할 수 있어요.');
		history.back();
		</c:if>

		<c:if test="${result == -3}">
		alert('내 포트폴리오만 연결할 수 있어요.');
		history.back();
		</c:if>

	</script>
</body>
</html>
