<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.profile-form {
			max-width: 860px;
			margin: 0 auto;
		}

		.form-buttons {
			text-align: right;
		}
	</style>
</head>
<body>
	<!-- expert/add.jsp: 고수 프로필 작성 (화면설계서 ②-02) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="profile-form">
			<h2>고수 프로필 작성</h2>

			<%-- 사진을 올리는 form 이라 CSRF 토큰을 action 뒤에 붙인다 (CONVENTION.md)
			     프로필 번호(= 회원 번호)는 폼에 넣지 않는다 (컨트롤러에서 로그인 정보로 꺼낸다) --%>
			<form id="profileForm" method="POST" enctype="multipart/form-data"
				action="${path}/expert/addok.do?${_csrf.parameterName}=${_csrf.token}">

				<%@ include file="/WEB-INF/views/expert/form.jsp" %>

				<div class="form-buttons">
					<a class="btn" href="${path}/index.do">취소</a>
					<button class="btn btn-primary">프로필 저장</button>
				</div>
			</form>
		</div>
	</main>
</body>
</html>
