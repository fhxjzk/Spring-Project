<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.guide {
			margin-bottom: 20px;
			color: var(--color-text-light);
		}
		.block-list {
			margin: 0 0 20px;
			padding-left: 20px;
		}
		.btn-row {
			display: flex;
			gap: 8px;
		}
		.btn-row .btn {
			flex: 1;
		}
	</style>
</head>
<body>
	<!-- member/withdraw.jsp: 회원 탈퇴 확인 (① B-02-b) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="form-box">
			<c:choose>
				<%-- 탈퇴를 막는 항목이 남아 있으면 안내만 보여준다 --%>
				<c:when test="${not empty blocks}">
					<h2>지금은 탈퇴할 수 없어요</h2>
					<p class="guide">아래 항목을 먼저 마무리해 주세요.</p>

					<ul class="block-list">
						<c:forEach var="block" items="${blocks}">
							<li>${block}</li>
						</c:forEach>
					</ul>

					<a class="btn btn-block" href="${path}/member/mypage.do">마이페이지로</a>
				</c:when>

				<c:otherwise>
					<h2>정말 탈퇴하시겠어요?</h2>
					<p class="guide">탈퇴해도 작성한 게시물·거래 기록은 남아있어요.</p>

					<form method="POST" action="${path}/member/withdrawok.do">
						<div class="form-group">
							<label for="pw">비밀번호 확인</label>
							<input type="password" id="pw" name="pw" required autocomplete="current-password">
						</div>

						<div class="btn-row">
							<a class="btn" href="${path}/member/mypage.do">취소</a>
							<button class="btn btn-danger">탈퇴하기</button>
						</div>

						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					</form>
				</c:otherwise>
			</c:choose>
		</div>
	</main>
</body>
</html>