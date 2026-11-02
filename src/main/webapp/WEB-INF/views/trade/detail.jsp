<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		/* 상태 타임라인: 결제완료 → 진행중 → 납품완료 → 구매확정 */
		.steps { display: grid; grid-template-columns: repeat(4, 1fr); list-style: none; padding: 0; margin: 0 0 24px; text-align: center; }
		.steps li { color: var(--color-text-light); font-size: 14px; }
		.steps .num { display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; margin-bottom: 6px;
			border: 2px solid var(--color-border); border-radius: 50%; background-color: var(--color-bg); font-weight: 700; }
		.steps .label, .steps .date { display: block; }
		.steps .date { font-size: 12px; min-height: 16px; }
		.steps li.done .num { color: #fff; background-color: var(--color-primary); border-color: var(--color-primary); }
		.steps li.current .label { color: var(--color-primary); font-weight: 700; }
		.steps.canceled li.done .num { background-color: var(--color-text-light); border-color: var(--color-text-light); }

		/* 결과물 영역 */
		.files { padding: 24px; border: 1px dashed var(--color-border); border-radius: var(--radius); background-color: var(--color-bg-light); }
		.files ul { list-style: none; padding: 0; margin: 0; }
		.files li + li { margin-top: 8px; }
		.files .empty { text-align: center; color: var(--color-text-light); }
		.upload { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; margin-top: 16px; }

		.help { color: var(--color-text-light); font-size: 14px; }
		.actions { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; margin-top: 16px; }
		.btn-outline-danger { color: var(--color-danger); border-color: var(--color-danger); }
	</style>
</head>
<body>
	<!-- trade/detail.jsp: ④-05 거래 상세 (C-03-b, C-03-c, D-03). 이 거래의 고객·고수만 볼 수 있다 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">

		<c:if test="${not empty message}"><p class="message-info">${message}</p></c:if>
		<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

		<%-- 상태 타임라인 (취소된 거래는 회색으로 멈춤) --%>
		<ol class="steps ${trade.status eq 'CANCELED' ? 'canceled' : ''}">
			<li class="done ${trade.step eq 1 and trade.status ne 'CANCELED' ? 'current' : ''}">
				<span class="num">1</span>
				<span class="label">결제완료</span>
				<span class="date">${trade.paidDay}</span>
			</li>
			<li class="${trade.step ge 2 ? 'done' : ''} ${trade.step eq 2 ? 'current' : ''}">
				<span class="num">2</span>
				<span class="label">진행중</span>
				<span class="date">${fn:substring(trade.startDate, 0, 10)}</span>
			</li>
			<li class="${trade.step ge 3 ? 'done' : ''} ${trade.step eq 3 ? 'current' : ''}">
				<span class="num">3</span>
				<span class="label">납품완료</span>
				<span class="date">${fn:substring(trade.deliveredDate, 0, 10)}</span>
			</li>
			<li class="${trade.step ge 4 ? 'done' : ''} ${trade.step eq 4 ? 'current' : ''}">
				<span class="num">4</span>
				<span class="label">구매확정</span>
				<span class="date">${fn:substring(trade.confirmDate, 0, 10)}</span>
			</li>
		</ol>

		<c:if test="${trade.status eq 'CANCELED'}">
		<p class="message-error">${fn:substring(trade.cancelDate, 0, 10)}에 취소된 거래예요. 결제한 포인트는 환불됐어요.</p>
		</c:if>

		<%-- 거래 정보 --%>
		<div class="card">
			<h3>거래 정보 <small class="help">${trade.tradeNo}</small></h3>
			<table class="table">
				<thead>
					<tr>
						<th>서비스</th>
						<th>상대방</th>
						<th>금액</th>
						<th>결제일</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>${trade.serviceName}</td>
						<td>${isCustomer ? trade.expertName : trade.customerName}</td>
						<td><fmt:formatNumber value="${trade.price}" />원</td>
						<td>${trade.paidDay}</td>
					</tr>
				</tbody>
			</table>
		</div>

		<%-- 결과물 (온라인 작업인 경우). 고수는 진행 중일 때 여기서 파일을 올리고 작업을 완료한다 --%>
		<div class="card">
			<h3>결과물 (온라인 작업인 경우)</h3>
			<div class="files">
				<c:choose>
					<c:when test="${not empty files}">
						<ul>
							<c:forEach var="file" items="${files}">
							<li>
								<a href="${path}/trade/download.do?tradeFileSeq=${file.tradeFileSeq}">${file.orgname}</a>
								<span class="help">${file.filesizeText} · ${file.regdate}</span>
							</li>
							</c:forEach>
						</ul>
					</c:when>
					<c:otherwise>
						<p class="empty">첨부된 결과물이 없어요.</p>
					</c:otherwise>
				</c:choose>
			</div>

			<c:if test="${isExpert and trade.status eq 'IN_PROGRESS'}">
			<%-- 파일 form은 CSRF 토큰을 action 뒤에 붙인다 (CONVENTION.md) --%>
			<form class="upload" method="POST" enctype="multipart/form-data"
					action="${path}/trade/completeok.do?${_csrf.parameterName}=${_csrf.token}"
					onsubmit="return confirm('작업을 완료할까요?');">
				<input type="hidden" name="tradeSeq" value="${trade.tradeSeq}">
				<input type="file" name="file">
				<button class="btn btn-primary">작업 완료</button>
			</form>
			<p class="help">그림·영상 같은 온라인 작업이면 결과물을 첨부해 주세요. 직접 만나서 하는 작업이면 파일 없이 완료해도 돼요.</p>
			</c:if>
		</div>

		<%-- 버튼: 내 역할과 지금 상태에 따라 달라진다 --%>
		<div class="actions">

			<%-- 고객: 납품 완료 → 구매 확정 --%>
			<c:if test="${isCustomer and trade.status eq 'DELIVERED'}">
			<form method="POST" action="${path}/trade/confirmok.do" onsubmit="return confirm('구매 확정할까요? 확정 후에는 취소할 수 없어요.');">
				<input type="hidden" name="tradeSeq" value="${trade.tradeSeq}">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<button class="btn btn-primary">구매 확정</button>
			</form>
			</c:if>

			<%-- 고객: 결제 완료(작업 시작 전) → 거래 취소 --%>
			<c:if test="${isCustomer and trade.status eq 'PAID'}">
			<form method="POST" action="${path}/trade/cancelok.do" onsubmit="return confirm('거래를 취소할까요? 결제한 포인트가 돌아와요.');">
				<input type="hidden" name="tradeSeq" value="${trade.tradeSeq}">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<button class="btn btn-outline-danger">거래 취소</button>
			</form>
			</c:if>

			<%-- 고객: 구매 확정 후 아직 리뷰를 안 썼으면 → ② 리뷰·별점 작성 --%>
			<c:if test="${canWriteReview}">
			<a class="btn btn-primary" href="${path}/review/add.do?tradeSeq=${trade.tradeSeq}">리뷰 작성</a>
			</c:if>

			<%-- 고수: 결제 완료 → 작업 시작 --%>
			<c:if test="${isExpert and trade.status eq 'PAID'}">
			<form method="POST" action="${path}/trade/startok.do" onsubmit="return confirm('작업을 시작할까요? 시작하면 고객이 취소할 수 없어요.');">
				<input type="hidden" name="tradeSeq" value="${trade.tradeSeq}">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<button class="btn btn-primary">작업 시작</button>
			</form>
			</c:if>

			<a class="btn" href="${path}/trade/mylist.do">목록</a>
		</div>

		<c:if test="${trade.status eq 'PAID'}">
		<p class="help">고수가 작업을 시작하기 전까지는 고객이 거래를 취소할 수 있어요.</p>
		</c:if>
		<c:if test="${trade.status eq 'DELIVERED'}">
		<p class="help">납품 후 ${autoConfirmDays}일 동안 구매 확정이 없으면 자동으로 구매 확정되고 고수에게 정산돼요.</p>
		</c:if>
	</main>

	<script>

	</script>
</body>
</html>
