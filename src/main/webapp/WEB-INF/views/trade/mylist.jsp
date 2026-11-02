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
		.num { text-align: right; }
		.page-actions { display: flex; justify-content: flex-end; margin-bottom: 12px; }
	</style>
</head>
<body>
	<!-- trade/mylist.jsp: 내 거래 목록 (고객: 맡긴 거래, 고수: 맡은 거래) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>${expert ? '맡은 거래' : '내 거래'}</h2>

		<c:if test="${not empty message}"><p class="message-info">${message}</p></c:if>
		<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

		<div class="page-actions">
			<a class="btn btn-sm" href="${path}/point/mylist.do">내 포인트</a>
		</div>

		<table class="table">
			<thead>
				<tr>
					<th>번호</th>
					<th>${expert ? '고객' : '고수'}</th>
					<th class="num">금액</th>
					<th>상태</th>
					<th>거래일</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="trade" items="${list}">
				<tr>
					<td>${trade.tradeSeq}</td>
					<td>${expert ? trade.customerName : trade.expertName}</td>
					<td class="num"><fmt:formatNumber value="${trade.price}" />P</td>
					<td><span class="badge ${trade.statusBadge}">${trade.statusLabel}</span></td>
					<td>${trade.regdate}</td>
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
	</main>

	<script>

	</script>
</body>
</html>
