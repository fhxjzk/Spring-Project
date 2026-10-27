<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

	<!-- header.jsp: 모든 페이지의 <body> 첫 줄에 include 한다 -->
	<header class="site-header">
		<h1 class="main"><a href="${path}/index.do">재능 거래 플랫폼</a></h1>
		<ul>
			<li><a href="${path}/index.do">홈</a></li>

			<%--
				파트별 메뉴는 기능이 만들어지면 담당자에게 요청해서 추가한다. 예)
				<li><a href="${path}/search/list.do">고수 찾기</a></li>
			--%>

			<sec:authorize access="hasRole('ROLE_CUSTOMER')">
			<%-- 고객 메뉴 (예: 내 요청서, 내 거래) --%>
			</sec:authorize>

			<sec:authorize access="hasRole('ROLE_EXPERT')">
			<%-- 고수 메뉴 (예: 받은 요청서, 내 견적) --%>
			</sec:authorize>

			<sec:authorize access="hasRole('ROLE_ADMIN')">
			<li><a href="${path}/admin/index.do">관리자</a></li>
			</sec:authorize>

			<li class="divider"></li>

			<sec:authorize access="isAnonymous()">
			<li><a href="${path}/member/add.do">회원가입</a></li>
			<li><a href="${path}/auth/login.do">로그인</a></li>
			</sec:authorize>

			<sec:authorize access="isAuthenticated()">
			<li><span><sec:authentication property="principal.dto.name" />님</span></li>
			<li><a href="${path}/auth/logout.do">로그아웃</a></li>
			</sec:authorize>
		</ul>
	</header>
