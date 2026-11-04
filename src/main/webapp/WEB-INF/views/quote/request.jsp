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

		.type-tabs {
			display: flex;
			gap: 6px;
			margin-bottom: 8px;
		}

		.guide {
			margin-bottom: 16px;
			font-size: 14px;
			color: var(--color-text-light);
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
	<!-- quote/request.jsp: 받은 요청서 목록 (D-02) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="quote-head">
			<h2>받은 요청서</h2>
			<a class="btn btn-sm" href="${path}/quote/mylist.do">보낸 견적</a>
		</div>

		<c:if test="${not empty msg}">
		<p class="message-info"><c:out value="${msg}" /></p>
		</c:if>

		<!-- 공개 요청 / 지정 요청 -->
		<div class="type-tabs">
			<a class="btn btn-sm <c:if test="${type eq 'open'}">btn-primary</c:if>" href="${path}/quote/request.do">공개 요청</a>
			<a class="btn btn-sm <c:if test="${type eq 'designated'}">btn-primary</c:if>" href="${path}/quote/request.do?type=designated">지정 요청</a>
		</div>

		<c:if test="${type eq 'open'}">
		<p class="guide">내가 등록한 서비스 카테고리의 공개 요청서예요. 견적은 요청서마다 5개까지 받아요.</p>
		</c:if>
		<c:if test="${type eq 'designated'}">
		<p class="guide">고객이 나에게만 보낸 요청서예요. 견적을 보내거나 거절할 수 있어요.</p>
		</c:if>

		<div class="list-wrap">
			<table class="table">
				<thead>
					<tr>
						<th>번호</th>
						<th>서비스</th>
						<th>지역</th>
						<th>희망 일정</th>
						<th>예산</th>
						<c:if test="${type eq 'open'}"><th>받은 견적</th></c:if>
						<th>견적 마감</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="r" items="${list}">
					<tr>
						<td>${r.requestSeq}</td>
						<td><c:out value="${r.categoryName}" /></td>
						<td><c:out value="${r.address}" /></td>
						<td><c:out value="${r.wishDate}" default="협의" /></td>
						<td>
							<c:choose>
								<c:when test="${empty r.budget}">협의</c:when>
								<c:otherwise><fmt:formatNumber value="${r.budget}" />원</c:otherwise>
							</c:choose>
						</td>
						<c:if test="${type eq 'open'}"><td>${r.quoteCount} / 5</td></c:if>
						<td>${r.quoteDeadline}</td>
						<td><a class="btn btn-sm" href="${path}/quote/requestview.do?requestSeq=${r.requestSeq}">보기</a></td>
					</tr>
					</c:forEach>

					<c:if test="${empty list}">
					<tr>
						<td colspan="8">견적을 보낼 수 있는 요청서가 없습니다.</td>
					</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</main>
</body>
</html>
