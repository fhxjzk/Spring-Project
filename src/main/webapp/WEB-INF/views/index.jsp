<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		/* 상단 배너: 화면 가로 전체에 배경을 깔고, 안쪽만 가운데 정렬 */
		.main-hero {
			padding: 64px 16px;
			text-align: center;
			background-color: color-mix(in srgb, var(--color-primary) 8%, var(--color-bg));
		}

		.main-hero h1 {
			margin-bottom: 10px;
			font-size: 36px;
		}

		.main-hero p {
			margin: 0 0 24px;
			color: var(--color-text-light);
		}

		.hero-search {
			display: flex;
			gap: 8px;
			max-width: 560px;
			margin: 0 auto;
		}

		.hero-search input {
			flex: 1;
		}

		/* 본문 섹션 */
		.main-section + .main-section {
			margin-top: 48px;
		}

		.main-section h2 {
			font-size: 20px;
		}

		/* 카드 가로 배치: 칸 수만 다르다 */
		.grid {
			display: grid;
			gap: 16px;
		}

		/* common.css의 .card + .card { margin-top } 이 그리드에서는 줄을 어긋나게 해서 끈다 */
		.grid > .card + .card {
			margin-top: 0;
		}

		.grid-6 { grid-template-columns: repeat(6, 1fr); }
		.grid-4 { grid-template-columns: repeat(4, 1fr); }
		.grid-3 { grid-template-columns: repeat(3, 1fr); }

		/* 카드 전체를 링크로 쓴다 */
		.card-link {
			display: block;
			color: var(--color-text);
		}

		.card-link:hover {
			text-decoration: none;
			border-color: var(--color-primary);
		}

		/* 카테고리 */
		.category-card {
			padding: 20px 12px;
			text-align: center;
			font-weight: 600;
		}

		.category-icon {
			width: 44px;
			height: 44px;
			margin: 0 auto 10px;
			border-radius: 12px;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		/* 인기 고수 */
		.expert-card {
			padding: 0;
			overflow: hidden;
		}

		.expert-thumb {
			height: 140px;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		.expert-info {
			padding: 14px 16px;
		}

		.expert-info strong {
			display: block;
		}

		/* 최근 리뷰 */
		.review-stars {
			color: var(--color-warning);
			letter-spacing: 2px;
		}

		.review-content {
			margin: 8px 0;
		}

		.small {
			font-size: 14px;
		}
	</style>
</head>
<body>
	<!-- index.jsp: 메인 페이지 (B-03, 화면설계서 ②-01) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<!-- 상단 배너: .container 바깥에 둬야 배경이 가로 전체에 깔린다 -->
	<section class="main-hero">
		<h1>우리 동네 고수를 찾아보세요</h1>
		<p>레슨부터 집수리까지, 요청서 한 번으로 견적을 비교하세요</p>

		<%-- TODO: 검색 주소와 파라미터 이름은 ⑥(고수 검색)과 맞춘다 --%>
		<form class="hero-search" method="GET" action="${path}/search/list.do">
			<input type="search" name="keyword" placeholder="카테고리 또는 키워드 검색">
			<button class="btn btn-primary">검색</button>
		</form>
	</section>

	<main class="container">

		<!-- 카테고리 바로가기 (대분류) -->
		<section class="main-section">
			<h2>카테고리</h2>

			<div class="grid grid-6">
				<c:forEach items="${clist}" var="category">
				<a class="card card-link category-card" href="#">
					<div class="category-icon"></div>
					${category.name}
				</a>
				</c:forEach>
			</div>
		</section>

		<!-- 인기 고수 -->
		<section class="main-section">
			<h2>인기 고수</h2>

			<div class="grid grid-4">
				<%-- TODO: 카테고리 이름 붙이기 (LISTAGG) --%>
				<c:forEach items="${expertList}" var="expert">
				<a class="card card-link expert-card" href="${path}/expert/view.do?expertSeq=${expert.expertSeq}">
					<div class="expert-thumb"></div>
					<div class="expert-info">
						<strong>${expert.name}</strong>
						<c:choose>
							<c:when test="${expert.reviewCount > 0}">
								<span class="message-info small">★${expert.averageRating} (${expert.reviewCount})</span>
							</c:when>
							<c:otherwise>
								<span class="message-info small">아직 리뷰가 없어요</span>
							</c:otherwise>
						</c:choose>
					</div>
				</a>
				</c:forEach>
			</div>
		</section>

		<!-- 최근 리뷰 -->
		<section class="main-section">
			<h2>최근 리뷰</h2>

			<div class="grid grid-3">
				<%-- TODO: <c:forEach>로 바꾼다. 링크는 리뷰를 받은 고수의 상세(②-04) --%>
				<a class="card card-link" href="#">
					<div class="review-stars">★★★★★</div>
					<p class="review-content">"에어컨에서 냄새가 완전히 사라졌어요!"</p>
					<span class="message-info small">고객2 · 고수2</span>
				</a>
				<a class="card card-link" href="#">
					<div class="review-stars">★★★★☆</div>
					<p class="review-content">"수업 시간을 유연하게 맞춰 주셔서 좋았어요."</p>
					<span class="message-info small">고객3 · 고수1</span>
				</a>
				<a class="card card-link" href="#">
					<div class="review-stars">★★★★★</div>
					<p class="review-content">"아이가 피아노를 좋아하게 됐어요."</p>
					<span class="message-info small">고객2 · 고수1</span>
				</a>
			</div>
		</section>

	</main>

	<script>

	</script>
</body>
</html>
