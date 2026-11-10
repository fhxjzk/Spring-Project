<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<%@ include file="/WEB-INF/views/review/item-head.jsp" %>
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

		/* 프로필 사진이 있으면 칸을 꽉 채우고, 없거나 파일이 없으면(onerror) 배경색만 남긴다 */
		.expert-photo img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
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

		.small {
			font-size: 14px;
		}

		/* 신고 처리(숨김) 고수 안내 */
		.hidden-notice {
			margin-bottom: 24px;
			padding: 14px 18px;
			border: 1px solid var(--color-danger);
			border-radius: 8px;
			background-color: color-mix(in srgb, var(--color-danger) 8%, var(--color-bg));
			color: var(--color-danger);
		}

		.hidden-notice strong {
			display: block;
		}

		/* 섹션 제목 오른쪽에 버튼 */
		.section-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 12px;
		}

		.section-head h3 {
			margin: 0;
		}

		.btn:disabled {
			opacity: 0.5;
			cursor: not-allowed;
		}
	</style>
</head>
<body>
	<!-- view.jsp: 고수 상세 (화면설계서 ②-04) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<c:if test="${isHidden}">
			<div class="hidden-notice">
				<strong>신고 처리된 고수입니다.</strong>
				<span class="small">운영 정책에 따라 검색과 메인에 노출되지 않으며, 요청을 보낼 수 없습니다.</span>
			</div>
		</c:if>

		<div class="expert-layout">

			<!-- 왼쪽: 프로필 요약 -->
			<aside class="card expert-side">
				<div class="expert-photo">
					<c:if test="${not empty edto.profileImage}">
						<img src="${path}/resources/upload/profile/<c:out value='${edto.profileImage}' />" alt="" onerror="this.remove()">
					</c:if>
				</div>

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
						<%-- 숨김 고수는 요청하기, 수정하기 둘 다 막는다 --%>
						<c:when test="${isHidden}">
							<button type="button" class="btn btn-block" disabled>${isOwner ? '수정할 수 없어요' : '요청할 수 없어요'}</button>
						</c:when>
						<%-- 본인이면 요청하기 대신 프로필 수정(②-02). 내 프로필만 고치므로 번호를 넘기지 않는다 --%>
						<c:when test="${isOwner}">
							<a class="btn btn-primary btn-block" href="${path}/expert/edit.do">프로필 수정</a>
						</c:when>
						<c:otherwise>
							<a class="btn btn-primary btn-block" href="${path}/request/add.do?expertSeq=${edto.expertSeq}">요청하기</a>
						</c:otherwise>
					</c:choose>
					<c:if test="${!isOwner}">
						<div class="expert-side-footer">
							<a class="message-info" href="#" onclick="openReportModal('PROFILE', ${edto.expertSeq}); return false;">신고하기</a>
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
					<div class="section-head">
						<h3>제공 서비스</h3>
						<%-- 본인 프로필에서만 보인다. 숨김 고수는 등록도 막는다 (서버 add.do 에서도 한 번 더 막는다) --%>
						<c:if test="${isOwner and not isHidden}">
							<a class="btn btn-sm" href="${path}/expert/talent/add.do">+ 추가</a>
						</c:if>
					</div>
					<c:choose>
						<%-- 본인에게는 서비스가 있어야 견적을 받을 수 있다고 알려 준다 (서비스 카테고리가 받는 요청서의 기준, D-02) --%>
						<c:when test="${empty talentList and isOwner}">
							<p class="message-info small">서비스를 등록해야 견적을 받을 수 있어요</p>
						</c:when>
						<c:when test="${empty talentList}">
							<p class="message-info small">등록된 서비스가 없어요</p>
						</c:when>
						<c:otherwise>
							<div class="grid-3">
								<c:forEach items="${talentList}" var="talent">
								<a class="card card-link" href="${path}/expert/talent/view.do?talentSeq=${talent.talentSeq}">
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
								</a>
								</c:forEach>
							</div>
						</c:otherwise>
					</c:choose>
				</section>

				<section class="card">
					<div class="section-head">
						<h3>포트폴리오 <small>${fn:length(portfolioList)}개</small></h3>
						<%-- 본인 프로필에서만 보인다. 숨김 고수는 작성도 막는다 (서버 add.do 에서도 한 번 더 막는다) --%>
						<c:if test="${isOwner and not isHidden}">
							<a class="btn btn-sm" href="${path}/expert/portfolio/add.do">+ 추가</a>
						</c:if>
					</div>
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
										<%-- 제목에 넣은 태그나 스크립트가 실행되지 않도록(XSS) c:out 으로 이스케이프한다 --%>
										<strong><c:out value="${portfolio.title}" /></strong>
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

					<%-- 최근 5개만 보여 준다. 나머지는 리뷰 전체보기에서 보고 답변한다 --%>
					<c:choose>
						<c:when test="${empty reviewList}">
							<p class="message-info small">아직 리뷰가 없어요</p>
						</c:when>
						<c:otherwise>
							<c:forEach items="${reviewList}" var="review">
								<%@ include file="/WEB-INF/views/review/item.jsp" %>
							</c:forEach>
							<div class="expert-side-footer">
								<a class="message-info" href="${path}/review/list.do?expertSeq=${edto.expertSeq}">리뷰 전체보기 (${rsdto.reviewCount}) →</a>
							</div>
						</c:otherwise>
					</c:choose>
				</section>

			</div>
		</div>
	</main>

	<%@ include file="/WEB-INF/views/report/modal.jsp" %>
</body>
</html>
