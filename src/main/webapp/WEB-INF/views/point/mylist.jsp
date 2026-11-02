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
		.page-head { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 16px; }
		.page-head h2 { margin-bottom: 4px; }
		.sub { color: var(--color-text-light); }
		.plus { color: var(--color-primary); }
		.minus { color: var(--color-danger); }
	</style>
</head>
<body>
	<!-- point/mylist.jsp: ④-02 포인트 내역 조회 (B-08). 충전·결제·정산·환불을 시간순으로 보여 준다 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="page-head">
			<div>
				<h2>포인트 내역</h2>
				<p class="sub">보유 포인트 <fmt:formatNumber value="${balance}" />P</p>
			</div>
			<a class="btn btn-sm" href="${path}/point/charge.do">포인트 충전</a>
		</div>

		<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

		<div class="card">
			<table class="table">
				<thead>
					<tr>
						<th>일시</th>
						<th>구분</th>
						<th>금액</th>
						<th>잔액</th>
						<th>내용</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="history" items="${list}">
					<tr>
						<td>${history.regdate}</td>
						<td>${history.typeLabel}</td>
						<td class="${history.amount gt 0 ? 'plus' : 'minus'}">
							<c:if test="${history.amount gt 0}">+</c:if><fmt:formatNumber value="${history.amount}" />P
						</td>
						<td><fmt:formatNumber value="${history.balance}" />P</td>
						<td>
							<c:choose>
								<c:when test="${not empty history.tradeSeq}">
									<a href="${path}/trade/detail.do?tradeSeq=${history.tradeSeq}">${history.description}</a>
								</c:when>
								<c:otherwise>${history.description}</c:otherwise>
							</c:choose>
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
