<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.quote-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 16px;
		}

		.list-wrap {
			overflow-x: auto;
		}

		.table td, .table th {
			white-space: nowrap;
		}
	</style>
</head>
<body>
	<!-- quote/mylist.jsp: 내가 보낸 견적 목록 (D-02) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="quote-head">
			<h2>보낸 견적</h2>
			<a class="btn btn-sm btn-primary" href="${path}/quote/request.do">받은 요청서</a>
		</div>

		<div class="list-wrap">
			<table class="table">
				<thead>
					<tr>
						<th>요청서</th>
						<th>서비스</th>
						<th>지역</th>
						<th>종류</th>
						<th>견적 금액</th>
						<th>작업 기간</th>
						<th>견적 상태</th>
						<th>보낸 날</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="q" items="${list}">
					<tr>
						<td>${q.requestSeq}</td>
						<td><c:out value="${q.categoryName}" /></td>
						<td><c:out value="${q.address}" /></td>
						<td>
							<c:choose>
								<c:when test="${q.designated eq 'Y'}">지정 요청</c:when>
								<c:otherwise>공개 요청</c:otherwise>
							</c:choose>
						</td>
						<td><fmt:formatNumber value="${q.price}" />원</td>
						<td>${q.workDays}일</td>
						<td>
							<c:choose>
								<c:when test="${q.status eq 'SELECTED'}"><span class="badge badge-success">선택됨</span></c:when>
								<c:when test="${q.status eq 'UNSELECTED'}"><span class="badge">미선택</span></c:when>
								<c:otherwise><span class="badge badge-primary">대기</span></c:otherwise>
							</c:choose>
						</td>
						<td>${q.regdate}</td>
						<td><a class="btn btn-sm" href="${path}/quote/requestview.do?requestSeq=${q.requestSeq}">보기</a></td>
					</tr>
					</c:forEach>

					<c:if test="${empty list}">
					<tr>
						<td colspan="9">보낸 견적이 없습니다.</td>
					</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</main>
</body>
</html>
