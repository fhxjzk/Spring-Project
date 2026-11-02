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
		.steps { list-style: none; padding: 0; margin: 0; }
		.steps li { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid var(--color-border); }
		.steps li:last-child { border-bottom: 0; }
		.steps .empty { color: var(--color-text-light); }
		.actions { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; margin-top: 12px; }
		.help { color: var(--color-text-light); font-size: 14px; }
		.files { list-style: none; padding: 0; margin: 0; }
		.files li { padding: 6px 0; }
	</style>
</head>
<body>
	<!-- trade/detail.jsp: 거래 상세 (④ C-03 구매 확정·취소, D-03 작업 진행) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>거래 #${trade.tradeSeq} <span class="badge ${trade.statusBadge}">${trade.statusLabel}</span></h2>

		<c:if test="${not empty message}"><p class="message-info">${message}</p></c:if>
		<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

		<%-- 거래 정보 --%>
		<div class="card">
			<dl class="info">
				<dt>금액</dt>
				<dd class="price"><fmt:formatNumber value="${trade.price}" />P</dd>
				<dt>고객</dt>
				<dd>${trade.customerName}</dd>
				<dt>고수</dt>
				<dd>${trade.expertName}</dd>
				<dt>요청서 번호</dt>
				<dd>${trade.requestSeq}</dd>
			</dl>
		</div>

		<%-- 할 수 있는 일 (내 역할과 지금 상태에 따라 버튼이 달라진다) --%>

		<%-- 고객: 결제 완료(작업 시작 전) → 취소 --%>
		<c:if test="${isCustomer and trade.status eq 'PAID'}">
		<div class="card">
			<h3>고수가 작업을 시작하기를 기다리고 있어요</h3>
			<p class="help">작업이 시작되기 전까지는 취소할 수 있어요. 취소하면 결제한 포인트를 돌려드려요.</p>
			<form class="actions" method="POST" action="${path}/trade/cancelok.do" onsubmit="return confirm('거래를 취소할까요? 포인트가 돌아와요.');">
				<input type="hidden" name="tradeSeq" value="${trade.tradeSeq}">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<button class="btn btn-danger">거래 취소</button>
			</form>
		</div>
		</c:if>

		<%-- 고객: 납품 완료 → 구매 확정 --%>
		<c:if test="${isCustomer and trade.status eq 'DELIVERED'}">
		<div class="card">
			<h3>납품이 완료됐어요</h3>
			<p class="help">
				결과를 확인하고 구매 확정을 눌러 주세요. 고수에게 포인트가 정산돼요.
				납품 후 ${autoConfirmDays}일이 지나면 자동으로 구매 확정돼요.
			</p>
			<form class="actions" method="POST" action="${path}/trade/confirmok.do" onsubmit="return confirm('구매 확정할까요? 확정 후에는 취소할 수 없어요.');">
				<input type="hidden" name="tradeSeq" value="${trade.tradeSeq}">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<button class="btn btn-primary">구매 확정</button>
			</form>
		</div>
		</c:if>

		<%-- 고수: 결제 완료 → 작업 시작 --%>
		<c:if test="${isExpert and trade.status eq 'PAID'}">
		<div class="card">
			<h3>고객이 결제를 마쳤어요</h3>
			<form class="actions" method="POST" action="${path}/trade/startok.do" onsubmit="return confirm('작업을 시작할까요? 시작하면 고객이 취소할 수 없어요.');">
				<input type="hidden" name="tradeSeq" value="${trade.tradeSeq}">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<button class="btn btn-primary">작업 시작</button>
			</form>
		</div>
		</c:if>

		<%-- 고수: 진행 중 → 작업 완료 (+ 결과물 파일). 파일 form은 CSRF 토큰을 action 뒤에 붙인다 --%>
		<c:if test="${isExpert and trade.status eq 'IN_PROGRESS'}">
		<div class="card">
			<h3>작업 완료</h3>
			<p class="help">그림·영상 같은 온라인 작업이면 결과물 파일을 첨부해 주세요. 직접 만나서 하는 작업이면 파일 없이 완료해도 돼요.</p>
			<form class="actions" method="POST" enctype="multipart/form-data"
					action="${path}/trade/completeok.do?${_csrf.parameterName}=${_csrf.token}"
					onsubmit="return confirm('작업을 완료할까요?');">
				<input type="hidden" name="tradeSeq" value="${trade.tradeSeq}">
				<input type="file" name="file">
				<button class="btn btn-primary">작업 완료</button>
			</form>
		</div>
		</c:if>

		<%-- 진행 상황 --%>
		<div class="card">
			<h3>진행 상황</h3>
			<ul class="steps">
				<li><span>결제</span><span>${trade.regdate}</span></li>
				<li><span>작업 시작</span><span class="${empty trade.startDate ? 'empty' : ''}">${empty trade.startDate ? '-' : trade.startDate}</span></li>
				<li><span>납품 완료</span><span class="${empty trade.deliveredDate ? 'empty' : ''}">${empty trade.deliveredDate ? '-' : trade.deliveredDate}</span></li>
				<li><span>구매 확정</span><span class="${empty trade.confirmDate ? 'empty' : ''}">${empty trade.confirmDate ? '-' : trade.confirmDate}</span></li>
				<c:if test="${not empty trade.cancelDate}">
				<li><span>취소</span><span>${trade.cancelDate}</span></li>
				</c:if>
			</ul>
		</div>

		<%-- 결과물 --%>
		<c:if test="${not empty files}">
		<div class="card">
			<h3>결과물</h3>
			<ul class="files">
				<c:forEach var="file" items="${files}">
				<li>
					<a href="${path}/trade/download.do?tradeFileSeq=${file.tradeFileSeq}">${file.orgname}</a>
					<span class="help">${file.filesizeText} · ${file.regdate}</span>
				</li>
				</c:forEach>
			</ul>
		</div>
		</c:if>

		<div class="actions">
			<a class="btn" href="${path}/trade/mylist.do">목록</a>
		</div>
	</main>

	<script>

	</script>
</body>
</html>
