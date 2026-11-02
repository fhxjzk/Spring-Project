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
		.info { display: grid; grid-template-columns: 120px 1fr; gap: 8px 16px; }
		.info dt { color: var(--color-text-light); }
		.info dd { margin: 0; }
		.price { font-size: 24px; font-weight: 700; }
		.after { font-weight: 600; }
		.help { color: var(--color-text-light); font-size: 14px; }
		.actions { display: flex; gap: 8px; margin-top: 16px; }
	</style>
</head>
<body>
	<!-- trade/pay.jsp: 포인트 결제 (④ C-03-a). ③ 견적 확인·고수 선택에서 넘어온다 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="form-box">
			<h2>결제</h2>

			<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

			<dl class="info">
				<dt>고수</dt>
				<dd>${quote.expertName}</dd>
				<dt>결제 금액</dt>
				<dd class="price"><fmt:formatNumber value="${quote.price}" />P</dd>
				<dt>내 포인트</dt>
				<dd><fmt:formatNumber value="${balance}" />P</dd>
				<dt>결제 후</dt>
				<dd class="after"><fmt:formatNumber value="${balance - quote.price}" />P</dd>
			</dl>

			<c:choose>
				<c:when test="${balance ge quote.price}">
					<p class="help">결제한 포인트는 구매 확정 전까지 플랫폼이 보관해요. 고수가 작업을 시작하기 전까지는 취소할 수 있어요.</p>
					<form method="POST" action="${path}/trade/payok.do" onsubmit="return confirm('결제할까요?');">
						<input type="hidden" name="quoteSeq" value="${quote.quoteSeq}">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						<button class="btn btn-primary btn-block">결제하기</button>
					</form>
				</c:when>
				<c:otherwise>
					<p class="message-error">포인트가 부족해요. 충전한 뒤 다시 결제해 주세요.</p>
					<div class="actions">
						<a class="btn btn-primary" href="${path}/point/mylist.do">포인트 충전하기</a>
						<a class="btn" href="${path}/trade/pay.do?quoteSeq=${quote.quoteSeq}">다시 확인</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</main>

	<script>

	</script>
</body>
</html>
