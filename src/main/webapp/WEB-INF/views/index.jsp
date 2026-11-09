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

		/* 리뷰가 길면 2줄까지만 보이고 ...으로 자른다 */
		.review-content {
			margin: 8px 0;
			display: -webkit-box;
			-webkit-line-clamp: 2;
			-webkit-box-orient: vertical;
			overflow: hidden;
		}

		/* 커뮤니티 최근 글: 제목 왼쪽, 바로가기 오른쪽 */
		.section-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

		.section-more {
			font-size: 14px;
			font-weight: 600;
		}

		/* 카드 대신 박스 하나에 글을 한 줄씩 (제목 · 작성자 · 작성일) */
		.board-box {
			padding: 6px 20px;
			border: 1px solid var(--color-border);
			border-radius: var(--radius);
		}

		.board-row {
			display: flex;
			align-items: center;
			gap: 16px;
			padding: 13px 0;
			color: var(--color-text);
		}

		.board-row + .board-row {
			border-top: 1px solid var(--color-border);
		}

		/* 줄 전체가 링크라 밑줄 대신 제목 색만 바꾼다 */
		.board-row:hover {
			text-decoration: none;
		}

		.board-row:hover .board-title {
			color: var(--color-primary);
		}

		/* 제목이 길면 한 줄로 자르고 ... */
		.board-title {
			flex: 1;
			min-width: 0;
			overflow: hidden;
			white-space: nowrap;
			text-overflow: ellipsis;
		}

		.board-writer,
		.board-date {
			flex: 0 0 90px;
			font-size: 14px;
			color: var(--color-text-light);
		}

		.board-date {
			text-align: right;
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

		<!-- 커뮤니티 최근 글 (⑥ 동네 게시판). 회원은 내 동네, 비회원은 서울 -->
		<section class="main-section">
			<div class="section-head">
				<h2>${boardRegionName} 커뮤니티 최근 글</h2>
				<a class="section-more" href="${path}/board/list.do?regionSeq=${boardRegionSeq}">커뮤니티 바로가기 →</a>
			</div>

			<c:choose>
				<c:when test="${empty boardList}">
					<p class="message-info small">아직 등록된 글이 없어요</p>
				</c:when>
				<c:otherwise>
					<div class="board-box">
						<c:forEach items="${boardList}" var="board">
						<a class="board-row" href="${path}/board/view.do?boardSeq=${board.boardSeq}">
							<span class="board-title"><c:out value="${board.subject}" /></span>
							<span class="board-writer"><c:out value="${board.writerName}" /></span>
							<span class="board-date">${board.regdate}</span>
						</a>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>
		</section>

		<!-- 최근 리뷰 -->
		<section class="main-section">
			<h2>최근 리뷰</h2>

			<c:choose>
				<c:when test="${empty reviewList}">
					<p class="message-info small">아직 등록된 리뷰가 없어요</p>
				</c:when>
				<c:otherwise>
					<div class="grid grid-3">
						<%-- 카드를 누르면 리뷰를 받은 고수의 상세(②-04)로 간다 --%>
						<c:forEach items="${reviewList}" var="review">
						<a class="card card-link" href="${path}/expert/view.do?expertSeq=${review.expertSeq}">
							<div class="review-stars">
								<c:forEach begin="1" end="5" var="i">${i <= review.rating ? '★' : '☆'}</c:forEach>
							</div>
							<p class="review-content">"${review.content}"</p>
							<span class="message-info small">${review.customerName} · ${review.expertName}</span>
						</a>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>
		</section>

	</main>

	<script>

	</script>
</body>
</html>
