<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.mylist-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 16px;
		}

		.status-tabs {
			display: flex;
			flex-wrap: wrap;
			gap: 6px;
			margin-bottom: 16px;
		}

		.mylist-wrap {
			overflow-x: auto;
		}

		.table td, .table th {
			white-space: nowrap;
		}

		.sub {
			font-size: 13px;
			color: var(--color-text-light);
		}
	</style>
</head>
<body>
	<!-- request/mylist.jsp: 내 요청서 목록 (C-01-d) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="mylist-head">
			<h2>내 요청서</h2>
			<a class="btn btn-primary btn-sm" href="${path}/request/add.do">요청서 작성</a>
		</div>

		<c:if test="${not empty msg}">
		<p class="message-info"><c:out value="${msg}" /></p>
		</c:if>

		<!-- 상태별 보기 -->
		<div class="status-tabs">
			<a class="btn btn-sm <c:if test="${empty status}">btn-primary</c:if>" href="${path}/request/mylist.do">전체</a>
			<a class="btn btn-sm <c:if test="${status eq 'OPEN'}">btn-primary</c:if>" href="${path}/request/mylist.do?status=OPEN">모집 중</a>
			<a class="btn btn-sm <c:if test="${status eq 'CLOSED'}">btn-primary</c:if>" href="${path}/request/mylist.do?status=CLOSED">견적 마감</a>
			<a class="btn btn-sm <c:if test="${status eq 'SELECTED'}">btn-primary</c:if>" href="${path}/request/mylist.do?status=SELECTED">선택 완료</a>
			<a class="btn btn-sm <c:if test="${status eq 'CANCELED'}">btn-primary</c:if>" href="${path}/request/mylist.do?status=CANCELED">취소</a>
			<a class="btn btn-sm <c:if test="${status eq 'REJECTED'}">btn-primary</c:if>" href="${path}/request/mylist.do?status=REJECTED">거절</a>
			<a class="btn btn-sm <c:if test="${status eq 'EXPIRED'}">btn-primary</c:if>" href="${path}/request/mylist.do?status=EXPIRED">만료</a>
		</div>

		<div class="mylist-wrap">
			<table class="table">
				<thead>
					<tr>
						<th>번호</th>
						<th>서비스</th>
						<th>지역</th>
						<th>종류</th>
						<th>상태</th>
						<th>받은 견적</th>
						<th>견적 마감</th>
						<th>등록일</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="r" items="${list}">
					<tr>
						<td>${r.requestSeq}</td>
						<td><c:out value="${r.categoryName}" /></td>
						<td><c:out value="${r.address}" /></td>
						<td>
							<c:choose>
								<c:when test="${empty r.expertSeq}">공개 요청</c:when>
								<c:otherwise>지정 요청 <span class="sub">(<c:out value="${r.expertName}" />)</span></c:otherwise>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${r.status eq 'OPEN'}"><span class="badge badge-primary">모집 중</span></c:when>
								<c:when test="${r.status eq 'CLOSED'}"><span class="badge badge-warning">견적 마감</span></c:when>
								<c:when test="${r.status eq 'SELECTED'}"><span class="badge badge-success">선택 완료</span></c:when>
								<c:when test="${r.status eq 'CANCELED'}"><span class="badge">취소</span></c:when>
								<c:when test="${r.status eq 'REJECTED'}"><span class="badge badge-danger">거절</span></c:when>
								<c:otherwise><span class="badge">만료</span></c:otherwise>
							</c:choose>
							<c:if test="${r.hidden eq 'Y'}"><span class="badge badge-danger">비공개</span></c:if>
						</td>
						<td>${r.quoteCount}개</td>
						<td>${r.quoteDeadline}</td>
						<td>${r.regdate}</td>
						<td><a class="btn btn-sm" href="${path}/request/myview.do?requestSeq=${r.requestSeq}">보기</a></td>
					</tr>
					</c:forEach>

					<c:if test="${empty list}">
					<tr>
						<td colspan="9">
								<c:if test="${empty status}">작성한 요청서가 없습니다.</c:if>
								<c:if test="${not empty status}">이 상태의 요청서가 없습니다.</c:if>
							</td>
					</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</main>

	<script>
	</script>
</body>
</html>
