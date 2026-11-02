<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

		/* 사진이 있으면 칸을 꽉 채우고, 파일이 없으면(onerror) img를 지워서 배경색만 남긴다 */
		.thumb img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
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

					<strong class="expert-name">${edto.name}</strong>
				<c:choose>
					<c:when test="${rsdto.reviewCount > 0}">
						★${rsdto.averageRating} (${rsdto.reviewCount})
					</c:when>
					<c:otherwise>
						아직 리뷰가 없어요
					</c:otherwise>
				</c:choose>
					<dl class="expert-meta">
						<dt>서비스 위치</dt>
						<dd>${edto.serviceAddress}</dd>
						<dt>활동 가능 지역</dt>
						<dd>
							<c:choose>
								<c:when test="${empty regionNameList}">-</c:when>
								<c:otherwise>
									<%-- 3개까지만 쓰고, 4개 이상이면 뒤에 ... (end는 0부터 세서 2 = 3개) --%>
									<c:forEach items="${regionNameList}" var="regionName" end="2" varStatus="status">
										${regionName}<c:if test="${not status.last}"> · </c:if>
									</c:forEach>
									<c:if test="${fn:length(regionNameList) > 3}"> ...</c:if>
								</c:otherwise>
							</c:choose>
						</dd>
					</dl>

					<c:choose>
						<c:when test="${isOwner}">
							<a class="btn btn-primary btn-block" href="#">수정하기</a>
						</c:when>
						<c:otherwise>
							<a class="btn btn-primary btn-block" href="#">요청하기</a>
						</c:otherwise>
					</c:choose>
					<c:if test="${!isOwner}">
						<div class="expert-side-footer">
							<a class="message-info" href="#">신고하기</a>
						</div>
					</c:if>
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
					<c:choose>
						<c:when test="${empty careerList}">
							<p class="message-info small">등록된 경력이 없어요</p>
						</c:when>
						<c:otherwise>
							<table class="table">
								<thead>
									<tr>
										<th style="width: 40%;">기간</th>
										<th>내용</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${careerList}" var="career">
									<tr>
										<td>
											<%-- yyyy.MM: MM은 대문자 (소문자 mm은 분) --%>
											<fmt:formatDate value="${career.startDate}" pattern="yyyy.MM" />
											~
											<c:choose>
												<c:when test="${empty career.endDate}">진행 중</c:when>
												<c:otherwise><fmt:formatDate value="${career.endDate}" pattern="yyyy.MM" /></c:otherwise>
											</c:choose>
										</td>
										<td>
											${career.title}
											<c:if test="${not empty career.description}">
												<div class="message-info small">${career.description}</div>
											</c:if>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</c:otherwise>
					</c:choose>
				</section>

				<section class="card">
					<h3>제공 서비스</h3>
					<c:choose>
						<c:when test="${empty talentList}">
							<p class="message-info small">등록된 서비스가 없어요</p>
						</c:when>
						<c:otherwise>
							<div class="grid-3">
								<%-- TODO: 서비스 상세 화면이 생기면 a 태그로 바꾸고 링크 걸기 --%>
								<c:forEach items="${talentList}" var="talent">
								<div class="card card-link">
									<div class="thumb">
										<c:if test="${not empty talent.thumbnail}">
											<img src="${path}/resources/upload/portfolio/${talent.thumbnail}" alt="" onerror="this.remove()">
										</c:if>
									</div>
									<div class="thumb-info">
										<strong>${talent.title}</strong>
										<span class="message-info small">
											${talent.parentCategoryName} · ${talent.categoryName}
											· <fmt:formatNumber value="${talent.price}" pattern="#,###" />원
										</span>
									</div>
								</div>
								</c:forEach>
							</div>
						</c:otherwise>
					</c:choose>
				</section>

				<section class="card">
					<h3>포트폴리오 <small>${fn:length(portfolioList)}개</small></h3>
					<c:choose>
						<c:when test="${empty portfolioList}">
							<p class="message-info small">등록된 포트폴리오가 없어요</p>
						</c:when>
						<c:otherwise>
							<div class="grid-3">
								<%-- TODO: 포트폴리오 상세(②-09) 화면을 만들면 이 주소로 연결된다 --%>
								<c:forEach items="${portfolioList}" var="portfolio">
								<a class="card card-link" href="${path}/expert/portfolio/view.do?portfolioSeq=${portfolio.portfolioSeq}">
									<div class="thumb">
										<c:if test="${not empty portfolio.thumbnail}">
											<img src="${path}/resources/upload/portfolio/${portfolio.thumbnail}" alt="" onerror="this.remove()">
										</c:if>
									</div>
									<div class="thumb-info">
										<strong>${portfolio.title}</strong>
										<span class="message-info small">사진 ${portfolio.imageCount}장</span>
									</div>
								</a>
								</c:forEach>
							</div>
						</c:otherwise>
					</c:choose>
				</section>

				<section class="card">
					<h3>리뷰</h3>
					<div class="expert-side-footer">
							<a class="message-info" href="#">전체보기</a>
						</div>
					<c:forEach items="${reviewList}" var="review">
					<%-- TODO: <c:forEach>로 바꾼다. tbl_review --%>
					<%-- TODO: reviewDto 수정하기, 리뷰한 사람 이름 가져와야함 --%>
					<div class="review-item">
						<div>
							<span class="review-stars">
								<c:forEach begin="1" end="5" var="i">
									${i <= review.rating ? '★' : '☆'}
								</c:forEach>
							</span>
							${review.customerName}
						</div>
						<div class="message-info small">${review.content}</div>
					</div>
					</c:forEach>
				</section>

			</div>
		</div>
	</main>

	<script>
	</script>
</body>
</html>
