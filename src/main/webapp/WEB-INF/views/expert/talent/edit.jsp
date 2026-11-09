<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.form-buttons {
			text-align: right;
		}
	</style>
</head>
<body>
	<!-- edit.jsp: 제공 서비스 수정 (화면설계서 ②-03) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<form class="card" id="talentForm" method="POST" action="${path}/expert/talent/editok.do">
			<h2>서비스 수정</h2>

			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

			<%-- 어떤 서비스를 고치는지. 바꿔서 보낼 수 있으니 컨트롤러에서 내 서비스인지 다시 확인한다 --%>
			<input type="hidden" name="talentSeq" value="${tdto.talentSeq}">

			<%@ include file="/WEB-INF/views/expert/talent/form.jsp" %>

			<div class="form-buttons">
				<a class="btn" href="${path}/expert/talent/view.do?talentSeq=${tdto.talentSeq}">취소</a>
				<button class="btn btn-primary">수정하기</button>
			</div>
		</form>
	</main>
</body>
</html>
