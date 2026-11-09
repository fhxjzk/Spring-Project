<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.toprow {
			display: flex;
			justify-content: space-between;
			align-items: flex-end;
			gap: 12px;
			flex-wrap: wrap;
			margin-bottom: 14px;
		}
		.toprow .f {
			display: flex;
			flex-direction: column;
			gap: 5px;
		}
		.toprow label {
			font-size: 12px;
			font-weight: 600;
			color: var(--color-text-light);
		}
		.toprow select {
			width: 160px;
		}
		.searchrow {
			display: flex;
			gap: 8px;
			margin-bottom: 14px;
			flex-wrap: wrap;
		}
		.searchrow select {
			width: 110px;
		}
		.searchrow input {
			flex: 1;
			min-width: 180px;
		}
		.table td.num, .table th.num {
			text-align: right;
			width: 70px;
		}
		.table td.w, .table th.w {
			width: 110px;
			white-space: nowrap;
		}
		.table a {
			color: var(--color-text);
			text-decoration: none;
		}
		.table a:hover {
			color: var(--color-primary);
			text-decoration: underline;
		}
		.paging {
			display: flex;
			justify-content: center;
			gap: 6px;
			margin-top: 20px;
		}
		.paging a, .paging span {
			min-width: 32px;
			height: 32px;
			line-height: 30px;
			text-align: center;
			border: 1px solid var(--color-border);
			border-radius: 6px;
			font-size: 13px;
			color: var(--color-text);
			text-decoration: none;
			background: #fff;
			padding: 0 8px;
		}
		.paging .on {
			background: var(--color-primary);
			border-color: var(--color-primary);
			color: #fff;
			font-weight: 700;
		}
	</style>
</head>
<body>
	<!-- board/list.jsp: 동네 게시판 글 목록 (⑥ B-09-01, B-09-02) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>동네 이야기 <small>Community</small></h2>

		<%-- 등록·수정·삭제하고 돌아왔을 때, 또는 볼 수 없는 글을 열었을 때 나오는 안내 --%>
		<c:if test="${not empty msg}">
			<p class="message-info"><c:out value="${msg}" /></p>
		</c:if>

		<div class="toprow">
			<%-- 지역을 바꾸면 그 동네 글만 보인다. 고수 검색과 같은 17개 목록이다 --%>
			<div class="f">
				<label for="regionSeq">지역</label>
				<select id="regionSeq" onchange="moveRegion(this.value)">
					<c:forEach var="region" items="${regionList}">
						<option value="${region.regionSeq}"
							${page.regionSeq eq region.regionSeq ? 'selected' : ''}>${region.regionName}</option>
					</c:forEach>
				</select>
			</div>

			<%-- 비회원이 눌렀을 때는 로그인 화면으로 바로 보내지 않고 먼저 안내한다 (신고하기와 같은 방식) --%>
			<sec:authorize access="isAuthenticated()">
				<a class="btn btn-primary" href="${path}/board/add.do">글쓰기</a>
			</sec:authorize>
			<sec:authorize access="!isAuthenticated()">
				<button type="button" class="btn btn-primary" onclick="needLogin()">글쓰기</button>
			</sec:authorize>
		</div>

		<%-- 검색 (B-09-10). 고른 지역 안에서만 찾는다 --%>
		<form class="searchrow" method="get" action="${path}/board/list.do">
			<input type="hidden" name="regionSeq" value="${page.regionSeq}">

			<select name="searchType">
				<option value="subject" ${page.searchType eq 'subject' ? 'selected' : ''}>제목</option>
				<option value="content" ${page.searchType eq 'content' ? 'selected' : ''}>내용</option>
				<option value="writer" ${page.searchType eq 'writer' ? 'selected' : ''}>작성자</option>
			</select>

			<input type="text" name="keyword" maxlength="50"
				value="<c:out value='${page.keyword}' />" placeholder="검색어를 입력해주세요">

			<button type="submit" class="btn">검색</button>

			<c:if test="${page.searching}">
				<a class="btn" href="${path}/board/list.do?regionSeq=${page.regionSeq}">검색 취소</a>
			</c:if>
		</form>

		<table class="table">
			<thead>
				<tr>
					<th>제목</th>
					<th class="w">작성자</th>
					<th class="w">작성일</th>
					<th class="num">조회</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="dto" items="${list}">
				<tr>
					<td>
						<a href="${path}/board/view.do?boardSeq=${dto.boardSeq}&page=${page.page}">
							<c:out value="${dto.subject}" />
						</a>
					</td>
					<td><c:out value="${dto.writerName}" /></td>
					<td>${dto.regdate}</td>
					<td class="num">${dto.readcount}</td>
				</tr>
				</c:forEach>

				<c:if test="${empty list}">
				<tr>
					<td colspan="4" style="text-align:center; padding:40px 0;">
						<c:choose>
							<c:when test="${page.searching}">
								<p class="message-info">검색 결과가 없습니다.</p>
							</c:when>
							<c:otherwise>
								<p class="message-info">아직 이 동네에 올라온 글이 없습니다. 첫 글을 남겨보세요.</p>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				</c:if>
			</tbody>
		</table>

		<%-- 페이지 번호. 숫자는 BoardPageDto 가 계산해서 넘겨준다 --%>
		<c:if test="${not empty list}">
		<div class="paging">
			<c:if test="${page.hasPrev}">
				<a href="${path}/board/list.do?regionSeq=${page.regionSeq}&page=${page.startPage - 1}&searchType=${page.searchType}&keyword=${fn:escapeXml(page.keyword)}">이전</a>
			</c:if>

			<c:forEach var="i" begin="${page.startPage}" end="${page.endPage}">
				<c:choose>
					<c:when test="${i eq page.page}"><span class="on">${i}</span></c:when>
					<c:otherwise>
						<a href="${path}/board/list.do?regionSeq=${page.regionSeq}&page=${i}&searchType=${page.searchType}&keyword=${fn:escapeXml(page.keyword)}">${i}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>

			<c:if test="${page.hasNext}">
				<a href="${path}/board/list.do?regionSeq=${page.regionSeq}&page=${page.endPage + 1}&searchType=${page.searchType}&keyword=${fn:escapeXml(page.keyword)}">다음</a>
			</c:if>
		</div>
		</c:if>
	</main>

	<script>
		//비회원이 글쓰기를 눌렀을 때. 로그인 화면으로 보낸다 (B-09-03)
		function needLogin() {

			if (confirm('글쓰기는 로그인 후에 할 수 있습니다.\n로그인 화면으로 이동하시겠습니까?')) {
				location.href = path + '/auth/login.do';
			}
		}

		//지역을 바꾸면 1페이지부터 다시 본다
		function moveRegion(regionSeq) {

			location.href = path + '/board/list.do?regionSeq=' + regionSeq;
		}
	</script>
</body>
</html>