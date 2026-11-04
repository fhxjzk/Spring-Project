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
			display: flex;
			gap: 8px;
			margin-top: 16px;
		}
		.btn-stop {
			color: var(--color-danger);
			border-color: var(--color-danger);
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

			<%-- 사용 중지/재개 후 결과 문구 --%>
			<c:if test="${not empty msg}">
				<p class="message-info">${msg}</p>
			</c:if>

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
					<%-- 관리자 계정과 탈퇴한 회원은 버튼을 보여주지 않는다 --%>
					<c:if test="${member.role ne 'ROLE_ADMIN' and empty member.withdrawDate}">
						<c:choose>
							<c:when test="${member.enabled eq 'Y'}">
								<form id="stopForm" method="POST" action="${path}/admin/member/stop.do">
									<input type="hidden" name="memberSeq" value="${member.memberSeq}">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
									<button class="btn btn-stop">사용 중지</button>
								</form>
							</c:when>
							<c:otherwise>
								<form method="POST" action="${path}/admin/member/resume.do">
									<input type="hidden" name="memberSeq" value="${member.memberSeq}">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
									<button class="btn btn-primary">사용 재개</button>
								</form>
							</c:otherwise>
						</c:choose>
					</c:if>
					<a class="btn" href="${path}/admin/member/list.do">목록으로</a>
				</div>
			</div>
		</main>
	</div>

	<script>
		$('#stopForm').on('submit', function() {

			return confirm('이 회원의 사용을 중지하시겠습니까?');
		});
	</script>
</body>
</html>
