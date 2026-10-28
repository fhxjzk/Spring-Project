<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<!-- admin-menu.jsp: 관리자 페이지 왼쪽 메뉴. 아직 만들지 않은 화면은 404가 난다 -->
	<nav class="admin-menu">
		<ul>
			<li><a href="${path}/admin/index.do">관리자 홈</a></li>
			<li><a href="${path}/admin/member/list.do">회원 관리</a></li>			<%-- ① E-01 --%>
			<li><a href="${path}/admin/report/list.do">신고 관리</a></li>			<%-- ⑥ E-02 --%>
			<li><a href="${path}/admin/category/list.do">카테고리 관리</a></li>		<%-- ② E-03 --%>
			<li><a href="${path}/admin/question/list.do">요청서 질문 관리</a></li>	<%-- ③ E-04 --%>
			<li><a href="${path}/admin/stats/index.do">통계</a></li>				<%-- ④ E-05 --%>
		</ul>
	</nav>
