<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
	<style>
		.chart-head { display: flex; justify-content: space-between; align-items: center; }
		.chart-head select { width: auto; }
		.chart-box { position: relative; height: 360px; }
		.help { color: var(--color-text-light); font-size: 14px; }
		.num { text-align: right; }
	</style>
</head>
<body>
	<!-- stats/index.jsp: 관리자 통계 (④ E-05) - 분류별 평균 단가 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>통계 <small>Statistics</small></h2>

			<div class="card">
				<div class="chart-head">
					<h3>분류별 평균 단가</h3>
					<select id="days">
						<option value="30">최근 30일</option>
						<option value="90">최근 90일</option>
						<option value="365">최근 1년</option>
						<option value="0">전체 기간</option>
					</select>
				</div>
				<p class="help">취소된 거래는 빼고, 결제일 기준으로 셉니다. 매출은 구매 확정된 거래 금액 합계예요. (수수료 없음)</p>
				<div class="chart-box"><canvas id="chart"></canvas></div>
			</div>

			<div class="card">
				<table class="table">
					<thead>
						<tr>
							<th>분류</th>
							<th class="num">거래 건수</th>
							<th class="num">평균 단가</th>
							<th class="num">매출</th>
						</tr>
					</thead>
					<tbody id="rows"></tbody>
				</table>
			</div>
		</main>
	</div>

	<script>
		//차트 색은 common.css 변수를 그대로 쓴다
		const colorPrimary = getComputedStyle(document.documentElement).getPropertyValue('--color-primary').trim();

		let chart = null;

		function load(days) {

			$.get(path + '/admin/stats/category.do', { days: days })
				.done(function (list) {
					drawChart(list);
					drawTable(list);
				})
				.fail(function (xhr) {
					alert(xhr.responseJSON ? xhr.responseJSON.message : '통계를 불러오지 못했어요.');
				});
		}

		function drawChart(list) {

			if (chart) chart.destroy();

			chart = new Chart(document.getElementById('chart'), {
				type: 'bar',
				data: {
					labels: list.map(function (row) { return row.categoryName; }),
					datasets: [
						{ label: '평균 단가(P)', data: list.map(function (row) { return row.avgPrice; }), backgroundColor: colorPrimary }
					]
				},
				options: {
					maintainAspectRatio: false,
					scales: { y: { beginAtZero: true } }
				}
			});
		}

		function drawTable(list) {

			const $rows = $('#rows').empty();

			if (list.length === 0) {
				$rows.append($('<tr>').append($('<td colspan="4">').text('이 기간에는 거래가 없어요.')));
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

		$('#days').val('${defaultDays}').on('change', function () {
			load($(this).val());
		});

		load(${defaultDays});
	</script>
</body>
</html>
