<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.filter {
			display: flex;
			align-items: flex-end;
			justify-content: space-between;
			flex-wrap: wrap;
			gap: 12px;
		}
		.filter .form-group {
			margin-bottom: 0;
		}
		.filter label {
			font-size: 13px;
			color: var(--color-text-light);
		}
		.filter select {
			width: 200px;
		}
		/* 소분류 추가: 이름 칸 + 버튼 한 줄 */
		.add-form {
			display: flex;
			gap: 8px;
		}
		.add-form input[type=text] {
			width: 220px;
		}
		.admin-content {
			overflow-x: auto;
		}
		.table td, .table th {
			white-space: nowrap;
			vertical-align: middle;
		}
		.table td.name {
			white-space: normal;
			min-width: 160px;
		}
		.table tr.off td {
			color: var(--color-text-light);
		}
		.table form {
			display: inline;
		}
		/* ▲▼ 버튼: 작게, 못 누르는 쪽은 흐리게 */
		.move-btn {
			padding: 2px 8px;
		}
		.move-btn:disabled {
			opacity: 0.3;
			cursor: default;
		}
		.guide {
			font-size: 13px;
			color: var(--color-text-light);
		}
		.empty {
			color: var(--color-text-light);
			text-align: center;
		}
	</style>
</head>
<body>
	<!-- admin/category/list.jsp: 카테고리 관리 (② E-03, 화면설계서 ②-07) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>카테고리 관리 <small>Category</small></h2>

			<c:if test="${not empty msg}">
			<p class="message-info"><c:out value="${msg}" /></p>
			</c:if>

			<div class="card filter">
				<%-- 대분류를 고르면 바로 다시 불러온다 --%>
				<form id="searchForm" class="form-group" method="get" action="${path}/admin/category/list.do">
					<label for="parentSeq">대분류</label>
					<select id="parentSeq" name="parentSeq" onchange="document.getElementById('searchForm').submit();">
						<c:forEach var="t" items="${topList}">
							<option value="${t.categorySeq}" ${t.categorySeq eq top.categorySeq ? 'selected' : ''}>
								<c:out value="${t.name}" />
							</option>
						</c:forEach>
					</select>
				</form>

				<c:if test="${not empty top}">
				<form class="add-form" method="POST" action="${path}/admin/category/addok.do" onsubmit="return checkAdd(this);">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<input type="hidden" name="parentSeq" value="${top.categorySeq}">
					<input type="text" name="name" placeholder="새 소분류 이름" maxlength="16">
					<button class="btn btn-primary">소분류 추가</button>
				</form>
				</c:if>
			</div>

			<p class="guide">
				대분류는 메인 화면 카드라서 고정이고, 소분류만 추가 · 순서 변경 · 사용 안 함을 할 수 있습니다.<br>
				소분류는 지우지 않고 <b>사용 안 함</b>으로 바꿉니다. 새 서비스 · 요청서 · 검색에서는 고를 수 없고, 이미 등록된 서비스와 요청서는 그대로 남습니다.
				사용 안 함인 소분류의 서비스를 고수가 수정하면 다른 카테고리를 골라야 저장됩니다.
			</p>

			<c:if test="${not empty top}">
			<div class="card">
				<table class="table">
					<thead>
						<tr>
							<th>순서</th>
							<th>소분류</th>
							<th>서비스</th>
							<th>요청서</th>
							<th>상태</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="c" items="${list}" varStatus="s">
						<tr class="${c.enabled eq 'N' ? 'off' : ''}">
							<td>
								<%-- 한 칸 위로 / 아래로. 맨 위의 ▲, 맨 아래의 ▼ 는 못 누른다 --%>
								<form method="POST" action="${path}/admin/category/moveok.do">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
									<input type="hidden" name="categorySeq" value="${c.categorySeq}">
									<button class="btn btn-sm move-btn" name="direction" value="up" title="위로" ${s.first ? 'disabled' : ''}>▲</button>
									<button class="btn btn-sm move-btn" name="direction" value="down" title="아래로" ${s.last ? 'disabled' : ''}>▼</button>
								</form>
							</td>
							<td class="name"><c:out value="${c.name}" /></td>
							<td>${c.talentCount}개</td>
							<td>${c.requestCount}건</td>
							<td>
								<c:choose>
									<c:when test="${c.enabled eq 'Y'}"><span class="badge badge-success">사용</span></c:when>
									<c:otherwise><span class="badge">사용 안 함</span></c:otherwise>
								</c:choose>
							</td>
							<td>
								<form method="POST" action="${path}/admin/category/enableok.do">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
									<input type="hidden" name="categorySeq" value="${c.categorySeq}">
									<input type="hidden" name="parentSeq" value="${top.categorySeq}">
									<c:choose>
										<c:when test="${c.enabled eq 'Y'}">
										<input type="hidden" name="enabled" value="N">
										<button class="btn btn-sm btn-danger" onclick="return confirm('이 소분류를 사용 안 함으로 바꿀까요?\n새 서비스 · 요청서 · 검색에서 고를 수 없게 됩니다.\n이미 등록된 서비스와 요청서는 그대로 남습니다.');">사용 안 함</button>
										</c:when>
										<c:otherwise>
										<input type="hidden" name="enabled" value="Y">
										<button class="btn btn-sm">다시 사용</button>
										</c:otherwise>
									</c:choose>
								</form>
							</td>
						</tr>
						</c:forEach>
						<c:if test="${empty list}">
						<tr>
							<td colspan="6" class="empty">등록된 소분류가 없습니다.</td>
						</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			</c:if>
		</main>
	</div>

	<script>
		// 소분류 추가 전 확인. 서버(CategoryService.addSubCategory)에서도 같은 조건으로 한 번 더 확인한다
		function checkAdd(form) {

			const input = form.elements['name'];
			const name = input.value.trim();

			if (name === '') {
				alert('소분류 이름을 입력해 주세요.');
				input.focus();
				return false;
			}

			// tbl_category.name VARCHAR2(50) 은 바이트 기준. 한글 한 글자 = 3바이트
			if (new TextEncoder().encode(name).length > 50) {
				alert('소분류 이름이 너무 길어요. (한글 16자까지)');
				input.focus();
				return false;
			}

			return confirm('"' + name + '" 소분류를 추가할까요?');
		}
	</script>
</body>
</html>
