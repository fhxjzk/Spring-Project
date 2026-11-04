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
		.admin-content {
			overflow-x: auto;
		}
		.btn-area {
			margin-top: 16px;
		}
	</style>
</head>
<body>
	<!-- admin/member/view.jsp: 관리자 회원 상세 (① E-01) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>회원 상세 <small>Member</small></h2>

			<div class="card table-card">
				<table class="table">
					<thead>
						<tr>
							<th>아이디</th>
							<th>이름</th>
							<th>이메일</th>
							<th>활동지역</th>
							<th>가입일</th>
							<th>권한</th>
							<th>상태</th>
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
							<td>
								<c:choose>
									<c:when test="${member.enabled eq 'Y'}"><span class="badge badge-success">사용</span></c:when>
									<c:when test="${empty member.withdrawDate}"><span class="badge badge-warning">중지</span></c:when>
									<c:otherwise><span class="badge badge-danger">탈퇴</span></c:otherwise>
								</c:choose>
							</td>
						</tr>
					</tbody>
				</table>

				<div class="btn-area">
					<a class="btn" href="${path}/admin/member/list.do">목록으로</a>
				</div>
			</div>
		</main>
	</div>
</body>
</html>
