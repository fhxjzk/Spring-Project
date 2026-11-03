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
		.tabs { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 16px; }
		.tabs .btn.active { color: #fff; background-color: var(--color-primary); border-color: var(--color-primary); }
	</style>
</head>
<body>
	<!-- trade/mylist.jsp: ④-04 내 거래 목록 (C-03-b, D-03). 고객·고수가 같은 화면을 쓰고 상대방 표시만 달라진다 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>내 거래</h2>

		<c:if test="${not empty message}"><p class="message-info">${message}</p></c:if>
		<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

		<%-- 상태 탭 --%>
		<div class="tabs">
			<c:forEach var="t" items="${tabs}">
			<a class="btn ${t eq tab ? 'active' : ''}" href="${path}/trade/mylist.do?tab=${t}">${t.label}</a>
			</c:forEach>
		</div>

		<div class="card">
			<table class="table">
				<thead>
					<tr>
						<th>거래번호</th>
						<th>상대방</th>
						<th>서비스</th>
						<th>금액</th>
						<th>상태</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="trade" items="${list}">
					<tr>
						<td>${trade.tradeNo}</td>
						<td>${expert ? trade.customerName : trade.expertName}</td>
						<td>${trade.serviceName}</td>
						<td><fmt:formatNumber value="${trade.price}" />원</td>
						<td><span class="badge ${trade.statusBadge}">${trade.statusLabel}</span></td>
						<td><a class="btn btn-sm" href="${path}/trade/detail.do?tradeSeq=${trade.tradeSeq}">상세</a></td>
					</tr>
					</c:forEach>
					<c:if test="${empty list}">
					<tr>
						<td colspan="6">거래가 없어요.</td>
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
