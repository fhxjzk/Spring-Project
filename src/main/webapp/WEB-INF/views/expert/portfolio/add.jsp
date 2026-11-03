<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<!-- add.jsp: 포트폴리오 작성 (화면설계서 ②-08) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>포트폴리오 작성</h2>

		<%-- TODO 작성 폼
		     - method="POST", enctype="multipart/form-data"
		     - 파일 업로드 form 은 CSRF 토큰을 action 뒤에 붙인다 (CONVENTION.md)
		       action="${path}/expert/portfolio/addok.do?${_csrf.parameterName}=${_csrf.token}"
		     - 입력: 제목(최대 100자), 내용(최대 4000자), 사진(최대 5장, accept="image/*")
		     - 작성자 번호는 폼에 넣지 않는다 (컨트롤러에서 로그인 정보로 꺼낸다) --%>
	</main>

	<script>
		// TODO 사진을 5장 넘게 고르면 막기 (서버에서도 한 번 더 막는다)
	</script>
</body>
</html>
