<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.profile-empty {
			max-width: 860px;
			margin: 0 auto;
			padding: 56px 24px;
			text-align: center;
		}

		.profile-empty h2 {
			margin: 0 0 8px;
		}

		.profile-empty p {
			margin: 0 0 20px;
			color: var(--color-text-light);
		}
	</style>
</head>
<body>
	<!-- expert/my.jsp: 내 프로필 - 아직 프로필이 없는 고수에게 보이는 안내 (화면설계서 ②-02)
	     프로필이 있으면 컨트롤러가 내 고수 상세로 바로 보내서 이 화면은 보이지 않는다 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<section class="card profile-empty">
			<h2>아직 고수 프로필이 없어요</h2>
			<p>프로필을 작성하면 제공 서비스와 포트폴리오를 등록할 수 있어요.</p>
			<a class="btn btn-primary" href="${path}/expert/add.do">프로필 작성하러 가기</a>
		</section>
	</main>
</body>
</html>
