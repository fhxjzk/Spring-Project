<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<%@ include file="/WEB-INF/views/review/item-head.jsp" %>
	<style>
		.review-page {
			max-width: 760px;
			margin: 0 auto;
		}

		/* 제목 왼쪽, 고수 상세로 돌아가기 오른쪽 */
		.review-page-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

		.review-summary {
			margin: -8px 0 16px;
		}

		.review-summary .review-stars {
			margin-right: 4px;
		}
	</style>
</head>
<body>
	<!-- review/list.jsp: 리뷰 전체보기. 한 고수가 받은 리뷰 전부와 고수 답변 (화면설계서 ②-04, ②-06) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="review-page">
			<div class="review-page-head">
				<h2><c:out value="${edto.name}" /> 고수의 리뷰</h2>
				<a class="message-info small" href="${path}/expert/view.do?expertSeq=${edto.expertSeq}">고수 상세로 →</a>
			</div>

			<p class="review-summary">
				<c:choose>
					<c:when test="${rsdto.reviewCount > 0}">
						<span class="review-stars">★</span><strong>${rsdto.averageRating}</strong>
						<span class="message-info small">리뷰 ${rsdto.reviewCount}개</span>
					</c:when>
					<c:otherwise>
						<span class="message-info small">아직 리뷰가 없어요</span>
					</c:otherwise>
				</c:choose>
			</p>

			<c:if test="${not empty reviewList}">
				<section class="card">
					<%-- 답변 칸에서 답변하면 이 화면으로 돌아온다 (review/replyok.jsp) --%>
					<c:set var="replyFrom" value="list" />
					<c:forEach items="${reviewList}" var="review">
						<%@ include file="/WEB-INF/views/review/item.jsp" %>
					</c:forEach>
				</section>
			</c:if>
		</div>
	</main>
</body>
</html>
