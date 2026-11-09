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
			width: 240px;
		}
		.admin-content {
			overflow-x: auto;
		}
		.table td, .table th {
			white-space: nowrap;
			vertical-align: middle;
		}
		.table td.question {
			white-space: normal;
			min-width: 260px;
		}
		.table tr.off td {
			color: var(--color-text-light);
		}
		.table form {
			display: inline;
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
	<!-- admin/question/list.jsp: 요청서 질문 목록 (③ E-04) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>요청서 질문 관리 <small>Question</small></h2>

			<c:if test="${not empty msg}">
			<p class="message-info"><c:out value="${msg}" /></p>
			</c:if>

			<%-- 카테고리를 고르면 바로 다시 불러온다. 질문은 소분류에 붙는다 --%>
			<form id="searchForm" class="card filter" method="get" action="${path}/admin/question/list.do">
				<div class="form-group">
					<label for="categorySeq">카테고리</label>
					<select id="categorySeq" name="categorySeq" onchange="document.getElementById('searchForm').submit();">
						<c:forEach var="c" items="${categoryList}" varStatus="s">
							<c:if test="${s.first or c.parentSeq ne categoryList[s.index - 1].parentSeq}">
								<c:if test="${not s.first}"></optgroup></c:if>
								<optgroup label="<c:out value='${c.parentName}' />">
							</c:if>
							<option value="${c.categorySeq}" ${c.categorySeq eq category.categorySeq ? 'selected' : ''}>
								<c:out value="${c.name}" /><c:if test="${c.enabled eq 'N'}"> (사용 안 하는 카테고리)</c:if>
							</option>
							<c:if test="${s.last}"></optgroup></c:if>
						</c:forEach>
					</select>
				</div>
				<c:if test="${not empty category}">
				<a class="btn btn-primary" href="${path}/admin/question/add.do?categorySeq=${category.categorySeq}">질문 등록</a>
				</c:if>
			</form>

			<p class="guide">
				고객이 요청서를 쓸 때 <b>사용</b> 중인 질문이 순서대로 나옵니다.
				질문은 지우지 않고 <b>사용 안 함</b>으로 바꿉니다. 이미 쓴 요청서의 답변은 그대로 남습니다.
			</p>

			<c:if test="${not empty category}">
			<div class="card">
				<table class="table">
					<thead>
						<tr>
							<th>순서</th>
							<th>질문</th>
							<th>유형</th>
							<th>필수</th>
							<th>보기</th>
							<th>답변한 요청서</th>
							<th>상태</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="q" items="${list}">
						<tr class="${q.enabled eq 'N' ? 'off' : ''}">
							<td>${q.sortOrder}</td>
							<td class="question"><c:out value="${q.content}" /></td>
							<td>
								<c:choose>
									<c:when test="${q.questionType eq 'SINGLE'}">객관식 (하나)</c:when>
									<c:when test="${q.questionType eq 'MULTI'}">객관식 (여러 개)</c:when>
									<c:otherwise>주관식</c:otherwise>
								</c:choose>
							</td>
							<td>${q.required eq 'Y' ? '필수' : '선택'}</td>
							<td>
								<c:choose>
									<c:when test="${q.questionType eq 'TEXT'}">-</c:when>
									<c:otherwise>${q.optionCount}개</c:otherwise>
								</c:choose>
							</td>
							<td>${q.answerCount}건</td>
							<td>
								<c:choose>
									<c:when test="${q.enabled eq 'Y'}"><span class="badge badge-success">사용</span></c:when>
									<c:otherwise><span class="badge">사용 안 함</span></c:otherwise>
								</c:choose>
							</td>
							<td>
								<a class="btn btn-sm" href="${path}/admin/question/edit.do?questionSeq=${q.questionSeq}">수정</a>
								<form method="POST" action="${path}/admin/question/enable.do">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
									<input type="hidden" name="questionSeq" value="${q.questionSeq}">
									<input type="hidden" name="categorySeq" value="${category.categorySeq}">
									<c:choose>
										<c:when test="${q.enabled eq 'Y'}">
										<input type="hidden" name="enabled" value="N">
										<button class="btn btn-sm btn-danger" onclick="return confirm('이 질문을 사용 안 함으로 바꿀까요?\n새 요청서에는 나오지 않지만, 이미 쓴 요청서의 답변은 남습니다.');">사용 안 함</button>
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
							<td colspan="8" class="empty">등록된 질문이 없습니다.</td>
						</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			</c:if>
		</main>
	</div>
</body>
</html>
