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
	</style>
</head>
<body>
	<!-- member/mypage.jsp: 마이페이지 (① B-02-a) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
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
	</main>
</body>
</html>