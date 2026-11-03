<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.filter {
			display: flex;
			gap: 12px;
		}
		.filter .form-group {
			margin-bottom: 0;
		}
		.filter label {
			font-size: 13px;
			color: var(--color-text-light);
		}
		.filter select {
			width: 130px;
		}
		.table-card {
			overflow-x: auto;
		}
		.table td, .table th {
			white-space: nowrap;
		}
		.admin-content {
			overflow-x: auto;
		}
	</style>
</head>
<body>
	<!-- admin/member/list.jsp: 관리자 회원 목록 (① E-01) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>회원 관리 <small>Member</small></h2>

			<%-- 검색어는 Enter로, 권한과 상태는 고르면 바로 다시 불러온다 --%>
			<form id="searchForm" class="card filter" method="get" action="${path}/admin/member/list.do">
				<div class="form-group">
					<label for="word">검색</label>
					<input type="search" id="word" name="word" value="<c:out value='${word}' />" placeholder="아이디 / 이름">
				</div>
				<div class="form-group">
					<label for="role">권한</label>
					<select id="role" name="role" onchange="document.getElementById('searchForm').submit();">
						<option value="">전체</option>
						<option value="ROLE_CUSTOMER" ${role eq 'ROLE_CUSTOMER' ? 'selected' : ''}>고객</option>
						<option value="ROLE_EXPERT" ${role eq 'ROLE_EXPERT' ? 'selected' : ''}>고수</option>
						<option value="ROLE_ADMIN" ${role eq 'ROLE_ADMIN' ? 'selected' : ''}>관리자</option>
					</select>
				</div>
				<div class="form-group">
					<label for="status">상태</label>
					<select id="status" name="status" onchange="document.getElementById('searchForm').submit();">
						<option value="">전체</option>
						<option value="ACTIVE" ${status eq 'ACTIVE' ? 'selected' : ''}>사용</option>
						<option value="STOP" ${status eq 'STOP' ? 'selected' : ''}>중지</option>
						<option value="WITHDRAW" ${status eq 'WITHDRAW' ? 'selected' : ''}>탈퇴</option>
					</select>
				</div>
			</form>

			<div class="card table-card">
				<table class="table">
					<thead>
						<tr>
							<th>번호</th>
							<th>아이디</th>
							<th>이름</th>
							<th>이메일</th>
							<th>권한</th>
							<th>상태</th>
							<th>가입일</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="m" items="${list}">
						<tr>
							<td>${m.memberSeq}</td>
							<td><c:out value="${m.id}" /></td>
							<td><c:out value="${m.name}" /></td>
							<td><c:out value="${m.email}" /></td>
							<td>
								<c:choose>
									<c:when test="${m.role eq 'ROLE_ADMIN'}"><span class="badge badge-danger">관리자</span></c:when>
									<c:when test="${m.role eq 'ROLE_EXPERT'}"><span class="badge badge-warning">고수</span></c:when>
									<c:otherwise><span class="badge badge-primary">고객</span></c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${m.enabled eq 'Y'}"><span class="badge badge-success">사용</span></c:when>
									<c:when test="${empty m.withdrawDate}"><span class="badge badge-warning">중지</span></c:when>
									<c:otherwise><span class="badge badge-danger">탈퇴</span></c:otherwise>
								</c:choose>
							</td>
							<td>${m.regdate}</td>
							<td><a class="btn btn-sm" href="${path}/admin/member/view.do?memberSeq=${m.memberSeq}">상세</a></td>
						</tr>
						</c:forEach>

						<c:if test="${empty list}">
						<tr>
							<td colspan="8">회원이 없습니다.</td>
						</tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</main>
	</div>
</body>
</html>