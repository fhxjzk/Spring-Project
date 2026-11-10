
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

	<!-- header.jsp: 모든 페이지의 <body> 첫 줄에 include 한다 -->
	<header class="site-header">
		<div class="header-inner">

			<a class="logo" href="${path}/index.do">재능 거래 플랫폼</a>

			<nav class="main-nav">
				<ul>
					<%--
						파트별 메뉴는 기능이 만들어지면 담당자에게 요청해서 추가한다. 예)
						<li><a href="${path}/search/list.do">고수 찾기</a></li>
					--%>
					<li><a href="${path}/search/list.do">고수 찾기</a></li>

					<sec:authorize access="hasRole('ROLE_CUSTOMER')">
					<li><a href="${path}/request/mylist.do">요청서</a></li>
					</sec:authorize>

					<sec:authorize access="hasRole('ROLE_EXPERT')">
					<li><a href="${path}/quote/request.do">요청서</a></li>
					</sec:authorize>

					<li><a href="${path}/board/list.do">동네 이야기</a></li>

					<sec:authorize access="hasAnyRole('ROLE_CUSTOMER', 'ROLE_EXPERT')">
					<li><a href="${path}/chat/list">채팅</a></li>
					<li><a href="${path}/member/mypage.do">마이페이지</a></li>
					</sec:authorize>
					<sec:authorize access="hasRole('ROLE_ADMIN')">
					<li><a href="${path}/admin/index.do">관리자</a></li>
					</sec:authorize>
				</ul>
			</nav>

			<div class="header-actions">
				<sec:authorize access="isAnonymous()">
				<a class="btn btn-sm" href="${path}/auth/login.do">로그인</a>
				<a class="btn btn-sm btn-primary" href="${path}/member/add.do">회원가입</a>
				</sec:authorize>

				<sec:authorize access="isAuthenticated()">
				<sec:authorize access="hasRole('ROLE_CUSTOMER')"><span class="badge badge-primary">고객</span></sec:authorize>
				<sec:authorize access="hasRole('ROLE_EXPERT')"><span class="badge badge-warning">고수</span></sec:authorize>
				<sec:authorize access="hasRole('ROLE_ADMIN')"><span class="badge badge-danger">관리자</span></sec:authorize>
				<span class="user-name"><sec:authentication property="principal.dto.name" />님</span>

				<!-- 실시간 알림 버튼 -->
				<button type="button" id="notificationBell" class="btn btn-sm"
					aria-label="알림 목록" title="알림">
					🔔 <span id="notificationCount" hidden>0</span>
				</button>

				<!-- 알림 목록 -->
				<div id="notificationPanel" hidden>
					<strong>알림 목록</strong>
					<ul id="notificationList">
						<li>알림을 불러오는 중입니다.</li>
					</ul>
				</div>

				<a class="btn btn-sm" href="${path}/auth/logout.do">로그아웃</a>
				</sec:authorize>
			</div>

		</div>
	</header>

<!-- 알림 전용 CSS -->
<link rel="stylesheet" href="<c:url value='/resources/css/notification.css' />">

<!-- STOMP WebSocket 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.2.1/bundles/stomp.umd.min.js"></script>

<!-- 알림 전용 JavaScript -->
<script src="<c:url value='/resources/js/notification.js' />"></script>
