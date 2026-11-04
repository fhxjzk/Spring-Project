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
		.charge-box { max-width: 560px; background-color: var(--color-bg); }
		.charge-box h2 { text-align: center; }
		.quick { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 20px; }
		.quick .btn.selected { color: var(--color-primary); border-color: var(--color-primary); }
		.balance { margin-top: 16px; text-align: center; color: var(--color-text-light); }
		.links { margin-top: 8px; text-align: center; font-size: 14px; }
	</style>
</head>
<body>
	<!-- point/charge.jsp: ④-01 포인트 충전 (B-08). 실제 결제 없이 포인트만 충전한다 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="form-box charge-box">
			<h2>포인트 충전</h2>

			<c:if test="${not empty message}"><p class="message-info">${message}</p></c:if>
			<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

			<form method="POST" action="${path}/point/chargeok.do">
				<div class="quick">
					<button type="button" class="btn" data-amount="10000">1만원</button>
					<button type="button" class="btn" data-amount="30000">3만원</button>
					<button type="button" class="btn" data-amount="50000">5만원</button>
					<button type="button" class="btn" data-amount="100000">10만원</button>
				</div>

				<div class="form-group">
					<label for="amount">충전 금액 직접 입력</label>
					<input type="number" id="amount" name="amount" placeholder="원"
						min="${minCharge}" max="${maxCharge}" step="1000" required>
				</div>

				<button class="btn btn-primary btn-block">충전하기</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>

			<p class="balance">보유 포인트 <fmt:formatNumber value="${balance}" />P</p>
			<p class="links"><a href="${path}/point/mylist.do">포인트 내역 보기</a></p>
		</div>
	</main>

	<script>
		//금액 버튼을 누르면 입력칸에 그 금액을 넣는다
		$('.quick .btn').on('click', function () {
			$('#amount').val($(this).data('amount'));
			$('.quick .btn').removeClass('selected');
			$(this).addClass('selected');
		});

		//직접 입력하면 버튼 선택 표시를 지운다
		$('#amount').on('input', function () {
			$('.quick .btn').removeClass('selected');
		});
	</script>
</body>
</html>
