<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
	<style>
		.summary { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 16px; }
		.charts { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; margin-bottom: 16px; }
		.summary .card, .charts .card { margin: 0; }
		.summary .label { color: var(--color-text-light); font-size: 14px; }
		.summary .value { margin-top: 6px; font-size: 26px; font-weight: 700; }
		.chart-box { position: relative; height: 300px; }
		.num { text-align: right; }
		@media (max-width: 1000px) {
			.summary { grid-template-columns: repeat(2, 1fr); }
			.charts { grid-template-columns: 1fr; }
		}
	</style>
</head>
<body>
	<!-- admin/stats/index.jsp: ④-06 관리자 통계 차트 (E-05). 취소된 거래는 빼고, 거래액은 결제 금액 그대로(수수료 없음) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>통계</h2>

			<c:if test="${not empty error}"><p class="message-error">${error}</p></c:if>

			<%-- 숫자 카드 --%>
			<div class="summary">
				<div class="card">
					<div class="label">전체 회원</div>
					<div class="value"><fmt:formatNumber value="${summary.memberCount}" />명</div>
				</div>
				<div class="card">
					<div class="label">누적 거래액</div>
					<div class="value"><fmt:formatNumber value="${summary.totalAmount}" />P</div>
				</div>
				<div class="card">
					<div class="label">이번 달 거래</div>
					<div class="value"><fmt:formatNumber value="${summary.monthTradeCount}" />건</div>
				</div>
				<div class="card">
					<div class="label">신규 가입(이번 달)</div>
					<div class="value"><fmt:formatNumber value="${summary.monthSignupCount}" />명</div>
				</div>
			</div>

			<%-- 차트 --%>
			<div class="charts">
				<div class="card">
					<h3>카테고리별 거래 비중</h3>
					<div class="chart-box"><canvas id="categoryChart"></canvas></div>
				</div>
				<div class="card">
					<h3>월별 거래액 추이</h3>
					<div class="chart-box"><canvas id="monthChart"></canvas></div>
				</div>
			</div>

			<%-- 카테고리별 숫자 (평균 단가) --%>
			<div class="card">
				<h3>카테고리별 평균 단가</h3>
				<table class="table">
					<thead>
						<tr>
							<th>카테고리</th>
							<th class="num">거래 건수</th>
							<th class="num">평균 단가</th>
							<th class="num">구매 확정 금액</th>
						</tr>
					</thead>
					<tbody id="categoryRows"></tbody>
				</table>
			</div>
		</main>
	</div>

	<script>
		//차트 색은 common.css 변수를 먼저 쓰고, 모자라면 아래 색을 이어서 쓴다
		const css = getComputedStyle(document.documentElement);
		const colors = [
			css.getPropertyValue('--color-primary').trim(),
			css.getPropertyValue('--color-secondary').trim(),
			css.getPropertyValue('--color-warning').trim(),
			css.getPropertyValue('--color-danger').trim(),
			'#8b5cf6',
			'#94a3b8'
		];

		$.get(path + '/admin/stats/chart.do')
			.done(function (data) {
				drawCategory(data.categories);
				drawMonth(data);
				drawTable(data.categories);
			})
			.fail(function (xhr) {
				alert(xhr.responseJSON ? xhr.responseJSON.message : '통계를 불러오지 못했어요.');
			});

		//카테고리별 거래 비중 (거래 건수 기준 도넛)
		function drawCategory(list) {

			new Chart(document.getElementById('categoryChart'), {
				type: 'doughnut',
				data: {
					labels: list.map(function (row) { return row.categoryName; }),
					datasets: [{
						data: list.map(function (row) { return row.tradeCount; }),
						backgroundColor: list.map(function (row, i) { return colors[i % colors.length]; })
					}]
				},
				options: {
					maintainAspectRatio: false,
					plugins: { legend: { position: 'right' } }
				}
			});
		}

		//월별 거래액 추이 (최근 12개월)
		function drawMonth(data) {

			new Chart(document.getElementById('monthChart'), {
				type: 'line',
				data: {
					labels: data.monthLabels,
					datasets: [{
						label: '거래액(P)',
						data: data.monthAmounts,
						borderColor: colors[0],
						backgroundColor: colors[0],
						tension: 0.3
					}]
				},
				options: {
					maintainAspectRatio: false,
					scales: { y: { beginAtZero: true } }
				}
			});
		}

		function drawTable(list) {

			const $rows = $('#categoryRows').empty();

			if (list.length === 0) {
				$rows.append($('<tr>').append($('<td colspan="4">').text('거래가 없어요.')));
				return;
			}

			list.forEach(function (row) {
				$rows.append($('<tr>')
					.append($('<td>').text(row.categoryName))
					.append($('<td class="num">').text(row.tradeCount.toLocaleString() + '건'))
					.append($('<td class="num">').text(row.avgPrice.toLocaleString() + 'P'))
					.append($('<td class="num">').text(row.salesAmount.toLocaleString() + 'P')));
			});
		}
	</script>
</body>
</html>
