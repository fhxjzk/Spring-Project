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
			margin-bottom: 16px;
		}
		.filter a {
			margin-right: 6px;
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
	<!-- admin/report/list.jsp: 관리자 신고 목록 (⑥ E-02) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>신고 관리 <small>Report</small></h2>

			<%-- 상태 필터. 주소 뒤에 status를 붙여서 다시 불러온다 --%>
			<div class="filter">
				<a class="btn btn-sm ${empty status ? 'btn-primary' : ''}" href="${path}/admin/report/list.do">전체</a>
				<a class="btn btn-sm ${status eq 'RECEIVED' ? 'btn-primary' : ''}" href="${path}/admin/report/list.do?status=RECEIVED">접수</a>
				<a class="btn btn-sm ${status eq 'REVIEWING' ? 'btn-primary' : ''}" href="${path}/admin/report/list.do?status=REVIEWING">검토중</a>
				<a class="btn btn-sm ${status eq 'DONE' ? 'btn-primary' : ''}" href="${path}/admin/report/list.do?status=DONE">처리완료</a>
				<a class="btn btn-sm ${status eq 'REJECTED' ? 'btn-primary' : ''}" href="${path}/admin/report/list.do?status=REJECTED">반려</a>
			</div>

			<table class="table">
				<thead>
					<tr>
						<th>번호</th>
						<th>신고 대상</th>
						<th>사유</th>
						<th>신고자</th>
						<th>상태</th>
						<th>신고일</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="r" items="${list}">
					<tr>
						<td>${r.reportSeq}</td>
						<td>
							<c:choose>
								<c:when test="${r.targetType eq 'PROFILE'}">고수 프로필</c:when>
								<c:otherwise>요청서</c:otherwise>
							</c:choose>
							${r.targetSeq}번
						</td>
						<td>
							<c:choose>
								<c:when test="${r.reasonType eq 'ABUSE'}">욕설</c:when>
								<c:when test="${r.reasonType eq 'FALSE_INFO'}">허위정보</c:when>
								<c:when test="${r.reasonType eq 'FRAUD'}">사기의심</c:when>
								<c:otherwise>기타</c:otherwise>
							</c:choose>
						</td>
						<td><c:out value="${r.reporterId}" /></td>
						<td>
							<c:choose>
								<c:when test="${r.status eq 'RECEIVED'}"><span class="badge badge-primary">접수</span></c:when>
								<c:when test="${r.status eq 'REVIEWING'}"><span class="badge badge-warning">검토중</span></c:when>
								<c:when test="${r.status eq 'DONE'}"><span class="badge badge-success">처리완료</span></c:when>
								<c:otherwise><span class="badge badge-danger">반려</span></c:otherwise>
							</c:choose>
						</td>
						<td>${r.regdate}</td>
						<td><a class="btn btn-sm" href="${path}/admin/report/view.do?reportSeq=${r.reportSeq}">보기</a></td>
					</tr>
					</c:forEach>

					<c:if test="${empty list}">
					<tr>
						<td colspan="7">신고 내역이 없습니다.</td>
					</tr>
					</c:if>
				</tbody>
			</table>
		</main>
	</div>

	<script>

	</script>
</body>
</html>