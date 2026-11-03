<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		/* 이 화면에만 쓰는 스타일 */
	</style>
</head>
<body>
	<!-- view.jsp: 포트폴리오 상세 (화면설계서 ②-09) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>포트폴리오</h2>

		<%-- TODO 제목, 작성일 (fmt:formatDate) --%>

		<%-- TODO 사진 (최대 5장, slot 순서)
		     경로: ${path}/resources/upload/portfolio/파일이름
		     파일이 없을 때는 고수 상세처럼 onerror="this.remove()" --%>

		<%-- TODO 내용 --%>

		<%-- TODO 작성한 고수 상세로 돌아가기 링크 (/expert/view.do?expertSeq=) --%>

		<%-- TODO 본인이면 수정·삭제 버튼 --%>
	</main>

	<script>
	</script>
</body>
</html>
