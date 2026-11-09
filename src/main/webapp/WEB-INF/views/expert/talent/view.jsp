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
		.talent-back {
			display: inline-block;
			margin-bottom: 12px;
			font-size: 14px;
		}

		/* 왼쪽 고수 요약은 고정 너비, 오른쪽 본문은 남은 공간 전부 */
		.talent-layout {
			display: flex;
			gap: 24px;
			align-items: flex-start;
		}

		.talent-side {
			flex: 0 0 280px;
			padding: 0;
			overflow: hidden;
		}

		.talent-photo {
			height: 200px;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		/* 고수 프로필 사진. 없거나 파일이 없으면(onerror) 배경색만 남긴다 */
		.talent-photo img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		/* 수정 아래 삭제 버튼 (form 이라 따로 간격을 준다) */
		.talent-del {
			margin-top: 8px;
		}

		.talent-side-body {
			padding: 18px;
		}

		.talent-name {
			display: block;
			font-size: 20px;
		}

		.talent-rating {
			margin: 4px 0 16px;
			font-size: 14px;
		}

		.talent-main {
			flex: 1;
			min-width: 0;
		}

		.talent-main h2 {
			margin-bottom: 6px;
		}

		.talent-main h3 {
			margin-top: 0;
		}

		.talent-price {
			margin-top: 12px;
			font-size: 20px;
			font-weight: 700;
			color: var(--color-primary);
		}

		/* 줄바꿈을 입력한 그대로 보여 준다 */
		.talent-content {
			margin: 0;
			white-space: pre-wrap;
			line-height: 1.7;
		}

		/* 포트폴리오 카드 가로 3칸 */
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

		.small {
			font-size: 14px;
		}

		.btn:disabled {
			opacity: 0.5;
			cursor: not-allowed;
		}
	</style>
</head>
<body>
	<!-- view.jsp: 서비스 상세 (화면설계서 ②-10) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<a class="talent-back" href="${path}/expert/view.do?expertSeq=${tdto.expertSeq}">← <c:out value="${edto.name}" /> 님의 고수 상세로 돌아가기</a>

		<div class="talent-layout">

			<!-- 왼쪽: 고수 요약 -->
			<aside class="card talent-side">
				<div class="talent-photo">
					<c:if test="${not empty edto.profileImage}">
						<img src="${path}/resources/upload/profile/<c:out value='${edto.profileImage}' />" alt="" onerror="this.remove()">
					</c:if>
				</div>

				<div class="talent-side-body">
					<strong class="talent-name"><c:out value="${edto.name}" /></strong>
					<div class="talent-rating message-info">
						<c:choose>
							<c:when test="${rsdto.reviewCount > 0}">
								★${rsdto.averageRating} (${rsdto.reviewCount})
							</c:when>
							<c:otherwise>
								아직 리뷰가 없어요
							</c:otherwise>
						</c:choose>
					</div>

					<c:choose>
						<%-- 숨김 고수는 고수 상세와 똑같이 요청하기, 수정하기 둘 다 막는다 --%>
						<c:when test="${isHidden}">
							<button type="button" class="btn btn-block" disabled>${isOwner ? '수정할 수 없어요' : '요청할 수 없어요'}</button>
						</c:when>
						<c:when test="${isOwner}">
							<a class="btn btn-primary btn-block" href="${path}/expert/talent/edit.do?talentSeq=${tdto.talentSeq}">수정</a>
							<%-- 지우는 동작이라 링크(GET)가 아니라 POST form 으로 보낸다. 삭제 후 내 고수 상세로 돌아간다 --%>
							<form class="talent-del" method="POST" action="${path}/expert/talent/delok.do"
								onsubmit="return confirm('이 서비스를 삭제할까요? 고수 상세와 검색에서 더 이상 보이지 않아요.');">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
								<input type="hidden" name="talentSeq" value="${tdto.talentSeq}">
								<button class="btn btn-danger btn-block">삭제</button>
							</form>
						</c:when>
						<c:otherwise>
							<a class="btn btn-primary btn-block" href="${path}/request/add.do?expertSeq=${tdto.expertSeq}">요청하기</a>
						</c:otherwise>
					</c:choose>
				</div>
			</aside>

			<!-- 오른쪽: 서비스 내용 -->
			<div class="talent-main">

				<section class="card">
					<h2><c:out value="${tdto.title}" /></h2>
					<div class="message-info">
						<%-- 대분류는 left join 이라 비어 있을 수 있다 --%>
						<c:if test="${not empty tdto.parentCategoryName}"><c:out value="${tdto.parentCategoryName}" /> · </c:if>
						<c:out value="${tdto.categoryName}" />
					</div>
					<div class="talent-price"><fmt:formatNumber value="${tdto.price}" pattern="#,###" />원</div>
				</section>

				<section class="card">
					<h3>서비스 소개</h3>
					<p class="talent-content"><c:out value="${tdto.content}" /></p>
				</section>

				<section class="card">
					<h3>포트폴리오 <small>${fn:length(plist)}개</small></h3>
					<c:choose>
						<c:when test="${empty plist}">
							<p class="message-info small">연결된 포트폴리오가 없어요</p>
						</c:when>
						<c:otherwise>
							<div class="grid-3">
								<%-- 고수가 고른 순서(slot 1 ~ 3)대로 온다 --%>
								<c:forEach items="${plist}" var="portfolio">
								<a class="card card-link" href="${path}/expert/portfolio/view.do?portfolioSeq=${portfolio.portfolioSeq}">
									<div class="thumb">
										<c:if test="${not empty portfolio.thumbnail}">
											<img src="${path}/resources/upload/portfolio/<c:out value='${portfolio.thumbnail}' />" alt="" onerror="this.remove()">
										</c:if>
									</div>
									<div class="thumb-info">
										<strong><c:out value="${portfolio.title}" /></strong>
										<span class="message-info small">사진 ${portfolio.imageCount}장</span>
									</div>
								</a>
								</c:forEach>
							</div>
						</c:otherwise>
					</c:choose>
				</section>

			</div>
		</div>
	</main>
</body>
</html>
