<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.table-card {
			overflow-x: auto;
		}
		.table td, .table th {
			white-space: nowrap;
		}
		.btn-area {
			margin-top: 16px;
		}
	</style>
</head>
<body>
	<!-- member/mypage.jsp: 마이페이지 (① B-02-a) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<%-- 정보 수정 후 결과 문구 --%>
		<c:if test="${not empty msg}">
			<p class="message-info">${msg}</p>
		</c:if>

		<div class="card table-card">
			<h2>내 정보</h2>

			<table class="table">
				<thead>
					<tr>
						<th>아이디</th>
						<th>이름</th>
						<th>이메일</th>
						<th>활동지역</th>
						<th>가입일</th>
						<th>구분</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><c:out value="${member.id}" /></td>
						<td><c:out value="${member.name}" /></td>
						<td><c:out value="${member.email}" /></td>
						<td><c:out value="${member.address}" default="-" /></td>
						<td>${member.regdate}</td>
						<td>
							<c:choose>
								<c:when test="${member.role eq 'ROLE_ADMIN'}"><span class="badge badge-danger">관리자</span></c:when>
								<c:when test="${member.role eq 'ROLE_EXPERT'}"><span class="badge badge-warning">고수</span></c:when>
								<c:otherwise><span class="badge badge-primary">고객</span></c:otherwise>
							</c:choose>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="card">
			<h2>정보 수정</h2>

			<form id="editForm" method="POST" action="${path}/member/mypageok.do">
				<div class="form-group">
					<label for="name">이름</label>
					<input type="text" id="name" name="name" value="<c:out value='${member.name}' />" required maxlength="16">
				</div>

				<div class="form-group">
					<label for="email">이메일</label>
					<input type="email" id="email" name="email" value="<c:out value='${member.email}' />" required maxlength="100">
				</div>

				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>
		</div>

		<div class="btn-area">
			<button class="btn btn-primary" form="editForm">정보 수정</button>
		</div>
	</main>
</body>
</html>