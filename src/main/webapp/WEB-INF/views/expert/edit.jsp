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
	<!-- expert/edit.jsp: 고수 프로필 수정 (화면설계서 ②-02) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="profile-form">
			<h2>고수 프로필 수정</h2>

			<%-- 내 프로필만 고치므로 프로필 번호를 폼에 넣지 않는다 (컨트롤러에서 로그인 정보로 꺼낸다) --%>
			<form id="profileForm" method="POST" enctype="multipart/form-data"
				action="${path}/expert/editok.do?${_csrf.parameterName}=${_csrf.token}">

				<%@ include file="/WEB-INF/views/expert/form.jsp" %>

				<div class="form-buttons">
					<a class="btn" href="${path}/expert/view.do?expertSeq=${edto.expertSeq}">취소</a>
					<button class="btn btn-primary">프로필 저장</button>
				</div>
			</form>
		</div>
	</main>
</body>
</html>
