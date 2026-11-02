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
		.pay-box { max-width: 760px; margin: 0 auto; }
		.balance { margin: 20px 0 12px; color: var(--color-text-light); }
		.note { margin-top: 12px; text-align: center; color: var(--color-text-light); font-size: 14px; }
		.lack { display: flex; gap: 8px; }
	</style>
</head>
<body>
	<!-- trade/pay.jsp: ④-03 결제 (안전결제, C-03-a). ③-04 견적 비교의 '이 고수 선택'에서 넘어온다 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="card pay-box">
			<h2>결제하기</h2>

			<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

			<table class="table">
				<thead>
					<tr>
						<th>서비스</th>
						<th>고수</th>
						<th>견적 금액</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>${quote.serviceName}</td>
						<td>${quote.expertName}</td>
						<td><fmt:formatNumber value="${quote.price}" />원</td>
					</tr>
				</tbody>
			</table>

			<p class="balance">보유 포인트 <fmt:formatNumber value="${balance}" />P</p>

			<c:choose>
				<c:when test="${balance ge quote.price}">
					<form method="POST" action="${path}/trade/payok.do" onsubmit="return confirm('결제할까요?');">
						<input type="hidden" name="quoteSeq" value="${quote.quoteSeq}">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						<button class="btn btn-primary btn-block"><fmt:formatNumber value="${quote.price}" />P로 안전결제</button>
					</form>
				</c:when>
				<c:otherwise>
					<p class="message-error">포인트가 <fmt:formatNumber value="${quote.price - balance}" />P 부족해요. 충전한 뒤 다시 결제해 주세요.</p>
					<div class="lack">
						<a class="btn btn-primary" href="${path}/point/charge.do">포인트 충전하기</a>
						<a class="btn" href="${path}/trade/pay.do?quoteSeq=${quote.quoteSeq}">다시 확인</a>
					</div>
				</c:otherwise>
			</c:choose>

			<p class="note">결제 금액은 구매 확정 전까지 플랫폼이 보관합니다</p>
		</div>
	</main>

	<script>

	</script>
</body>
</html>
