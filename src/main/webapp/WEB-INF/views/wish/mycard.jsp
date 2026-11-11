<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

	<%--
		wish/mycard.jsp: 마이페이지 "찜한 고수" 카드의 내용만 (HTML 조각, WishController.mycard)
		완성된 화면이 아니라 wish/mypage-card.jsp 가 불러와서 카드 안에 끼워 넣는다. CSS 도 그쪽에 있다
		previewList : 최근에 찜한 고수 최대 3명 (ExpertCardDto)
		total       : 찜한 고수 전체 수
	--%>
	<%-- asset.jsp 를 안 거치는 조각이라 path 를 여기서 만든다 --%>
	<c:set var="path" value="${pageContext.request.contextPath}" />
	<div class="wish-card-head">
		<h2>찜한 고수 <span class="wish-card-total">${total}명</span></h2>
		<c:if test="${total > 0}">
			<a class="message-info small" href="${path}/wish/mylist.do">전체 보기 →</a>
		</c:if>
	</div>

	<c:choose>
		<c:when test="${total == 0}">
			<p class="message-info small">아직 찜한 고수가 없어요. 고수 상세에서 ♡ 를 눌러 찜해 보세요.</p>
		</c:when>
		<c:otherwise>
			<div class="wish-card-grid">
				<c:forEach items="${previewList}" var="expert">
				<a class="wish-mini" href="${path}/expert/view.do?expertSeq=${expert.expertSeq}">
					<%-- 사진이 없거나 파일을 못 찾으면(onerror) 배경색만 남는다 --%>
					<div class="wish-mini-photo">
						<c:if test="${not empty expert.profileImage}">
							<img src="${path}/resources/upload/profile/<c:out value='${expert.profileImage}' />" alt="" onerror="this.remove()">
						</c:if>
					</div>
					<strong><c:out value="${expert.name}" /></strong>
					<c:if test="${not empty expert.categoryNames}">
						<span class="wish-mini-category message-info small"><c:out value="${expert.categoryNames}" /></span>
					</c:if>
					<span class="message-info small">
						<c:choose>
							<c:when test="${expert.reviewCount > 0}">★${expert.averageRating}</c:when>
							<c:otherwise>리뷰 없음</c:otherwise>
						</c:choose>
						· <span class="wish-mini-heart">♡</span> <fmt:formatNumber value="${expert.wishCount}" />
					</span>
				</a>
				</c:forEach>

				<%-- 4명 이상이면 네 번째 칸에 나머지 수. 누르면 전체 목록 --%>
				<c:if test="${total > 3}">
				<a class="wish-mini wish-mini-more" href="${path}/wish/mylist.do">+${total - 3}명 더</a>
				</c:if>
			</div>
		</c:otherwise>
	</c:choose>
