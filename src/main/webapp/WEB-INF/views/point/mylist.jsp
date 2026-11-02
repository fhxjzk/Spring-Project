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
		.balance-label { color: var(--color-text-light); }
		.balance { font-size: 32px; font-weight: 700; color: var(--color-primary); margin: 4px 0 16px; }
		.charge-form { display: flex; gap: 8px; align-items: center; }
		.charge-form input { max-width: 220px; }
		.help { color: var(--color-text-light); font-size: 14px; margin-top: 8px; }
		.num { text-align: right; }
		.plus { color: var(--color-secondary); font-weight: 600; }
		.minus { color: var(--color-danger); font-weight: 600; }
	</style>
</head>
<body>
	<!-- point/mylist.jsp: 내 포인트 (④ B-08 잔액, 충전, 내역) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>내 포인트</h2>

		<c:if test="${not empty message}"><p class="message-info">${message}</p></c:if>
		<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

		<div class="card">
			<div class="balance-label">현재 잔액</div>
			<div class="balance"><fmt:formatNumber value="${balance}" />P</div>

			<form class="charge-form" method="POST" action="${path}/point/chargeok.do">
				<input type="number" name="amount" min="${minCharge}" max="${maxCharge}" step="1000" placeholder="충전할 금액" required>
				<button class="btn btn-primary">충전하기</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>
			<p class="help">
				실제 결제 없이 포인트만 충전돼요.
				한 번에 <fmt:formatNumber value="${minCharge}" />P ~ <fmt:formatNumber value="${maxCharge}" />P까지 충전할 수 있어요.
			</p>
		</div>

		<div class="card">
			<h3>포인트 내역</h3>
			<table class="table">
				<thead>
					<tr>
						<th>날짜</th>
						<th>종류</th>
						<th class="num">금액</th>
						<th class="num">잔액</th>
						<th>거래</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="history" items="${list}">
					<tr>
						<td>${history.regdate}</td>
						<td><span class="badge ${history.typeBadge}">${history.typeLabel}</span></td>
						<td class="num ${history.amount gt 0 ? 'plus' : 'minus'}">
							<c:if test="${history.amount gt 0}">+</c:if><fmt:formatNumber value="${history.amount}" />P
						</td>
						<td class="num"><fmt:formatNumber value="${history.balance}" />P</td>
						<td>
							<c:if test="${not empty history.tradeSeq}">
							<a href="${path}/trade/detail.do?tradeSeq=${history.tradeSeq}">거래 #${history.tradeSeq}</a>
							</c:if>
						</td>
					</tr>
					</c:forEach>
					<c:if test="${empty list}">
					<tr>
						<td colspan="5">포인트 내역이 없어요.</td>
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
