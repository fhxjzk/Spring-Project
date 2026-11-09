<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body>
	<!-- expert/editok.jsp: 프로필 수정 결과 (ExpertService.edit 반환값) -->
	<script>

		<c:if test="${result == 1}">
		location.href = '${path}/expert/view.do?expertSeq=${expertSeq}';
		</c:if>

		<c:if test="${result == 0}">
		alert('프로필을 저장하지 못했습니다. 소개와 서비스 제공 위치를 확인해 주세요. (소개는 한글 약 660자까지)');
		history.back();
		</c:if>

		<c:if test="${result == -1}">
		alert('경력을 확인해 주세요. 활동/회사명과 시작 연월은 꼭 입력하고, 종료는 시작보다 빠를 수 없어요. (최대 20개)');
		history.back();
		</c:if>

		<c:if test="${result == -2}">
		alert('활동 가능 지역을 다시 골라 주세요.');
		history.back();
		</c:if>

		<c:if test="${result == -3}">
		alert('프로필 사진은 jpg, png, gif 파일만 올릴 수 있어요.');
		history.back();
		</c:if>

		<%-- 프로필이 없는데 수정을 보낸 경우 --%>
		<c:if test="${result == -4}">
		alert('프로필이 없어요. 프로필 작성으로 이동합니다.');
		location.href = '${path}/expert/add.do';
		</c:if>

	</script>
</body>
</html>
