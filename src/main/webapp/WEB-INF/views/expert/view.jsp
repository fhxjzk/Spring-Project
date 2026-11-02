<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		/* 왼쪽 프로필 카드는 고정 너비, 오른쪽 본문은 남은 공간 전부 */
		.expert-layout {
			display: flex;
			gap: 24px;
			align-items: flex-start;
		}

		/* 왼쪽 프로필 카드 */
		.expert-side {
			flex: 0 0 280px;
			padding: 0;
			overflow: hidden;
		}

		.expert-photo {
			height: 200px;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		.expert-side-body {
			padding: 18px;
		}

		.expert-name {
			display: block;
			font-size: 20px;
		}

		.expert-meta {
			margin: 14px 0;
			font-size: 14px;
			line-height: 1.8;
		}

		.expert-meta dt {
			float: left;
			width: 90px;
			color: var(--color-text-light);
		}

		.expert-meta dd {
			margin: 0;
		}

		.expert-side-footer {
			margin-top: 10px;
			text-align: right;
			font-size: 13px;
		}

		/* 오른쪽 본문 */
		.expert-main {
			flex: 1;
			min-width: 0;
		}

		.expert-main h3 {
			margin-top: 0;
		}

		/* 서비스, 포트폴리오 카드 가로 3칸 */
		.grid-3 {
			display: grid;
			grid-template-columns: repeat(3, 1fr);
			gap: 16px;
		}

		/* common.css의 .card + .card { margin-top } 이 그리드에서는 줄을 어긋나게 해서 끈다 */
		.grid-3 > .card + .card {
			margin-top: 0;
		}

		.card-link {
			display: block;
			padding: 0;
			overflow: hidden;
			color: var(--color-text);
		}

		.card-link:hover {
			text-decoration: none;
			border-color: var(--color-primary);
		}

		.thumb {
			height: 110px;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		.thumb-info {
			padding: 12px 14px;
		}

		.thumb-info strong {
			display: block;
		}

		/* 리뷰 */
		.review-item + .review-item {
			margin-top: 12px;
			padding-top: 12px;
			border-top: 1px solid var(--color-border);
		}

		.review-stars {
			color: var(--color-warning);
			letter-spacing: 2px;
		}

		.small {
			font-size: 14px;
		}
	</style>
</head>
<body>
	<!-- view.jsp: 고수 상세 (화면설계서 ②-04) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="expert-layout">

			<!-- 왼쪽: 프로필 요약 -->
			<aside class="card expert-side">
				<div class="expert-photo"></div>

				<div class="expert-side-body">
					<%-- TODO: 평균 별점, 리뷰 수 --%>
					<strong class="expert-name">${edto.name}</strong>
					<span class="message-info small">★4.9 (128)</span>

					<dl class="expert-meta">
						<dt>서비스 위치</dt>
						<dd>${edto.serviceAddress}</dd>
						<%-- TODO: ⑥ 활동 지역 연동 --%>
						<dt>활동 가능 지역</dt>
						<dd>서울 · 경기 · 인천</dd>
					</dl>

					<%-- TODO: 본인(isOwner)이면 요청하기 대신 프로필 수정 버튼 --%>
					<a class="btn btn-primary btn-block" href="#">요청하기</a>

					<div class="expert-side-footer">
						<%-- TODO: ⑥ 신고 주소 --%>
						<a class="message-info" href="#">신고하기</a>
					</div>
				</div>
			</aside>

			<!-- 오른쪽: 상세 내용 -->
			<div class="expert-main">

				<section class="card">
					<h3>소개</h3>
					<p>${edto.intro}</p>
				</section>

				<section class="card">
					<h3>경력</h3>
					<table class="table">
						<thead>
							<tr>
								<th style="width: 40%;">기간</th>
								<th>내용</th>
							</tr>
						</thead>
						<tbody>
							<%-- TODO: <c:forEach>로 바꾼다. tbl_expert_career --%>
							<tr>
								<td>2016 ~ 진행중</td>
								<td>OO음악학원 강사</td>
							</tr>
						</tbody>
					</table>
				</section>

				<section class="card">
					<h3>제공 서비스</h3>
					<div class="grid-3">
						<%-- TODO: <c:forEach>로 바꾼다. tbl_talent (enabled='Y'만) --%>
						<a class="card card-link" href="#">
							<div class="thumb"></div>
							<div class="thumb-info">
								<strong>서비스 제목</strong>
								<span class="message-info small">피아노 · 50,000원</span>
							</div>
						</a>
					</div>
				</section>

				<section class="card">
					<h3>포트폴리오</h3>
					<div class="grid-3">
						<%-- TODO: <c:forEach>로 바꾼다. 링크는 포트폴리오 상세(②-09) --%>
						<a class="card card-link" href="#">
							<div class="thumb"></div>
							<div class="thumb-info">
								<strong>포트폴리오 제목</strong>
								<span class="message-info small">사진 5장</span>
							</div>
						</a>
					</div>
				</section>

				<section class="card">
					<h3>리뷰</h3>
					<%-- TODO: <c:forEach>로 바꾼다. tbl_review --%>
					<div class="review-item">
						<div><span class="review-stars">★★★★★</span> 고객1</div>
						<div class="message-info small">꼼꼼하게 잘 가르쳐주셨어요</div>
					</div>
				</section>

			</div>
		</div>
	</main>

	<script>
	</script>
</body>
</html>
