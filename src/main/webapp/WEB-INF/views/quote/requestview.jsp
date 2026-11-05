<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.requestview {
			max-width: 760px;
		}

		.requestview-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
			gap: 12px;
			margin-bottom: 16px;
		}

		.requestview section {
			margin-bottom: 28px;
		}

		.requestview h3 {
			margin-bottom: 12px;
		}

		.info th {
			width: 120px;
			text-align: left;
			color: var(--color-text-light);
		}

		.images {
			display: flex;
			flex-wrap: wrap;
			gap: 10px;
		}

		.images img {
			width: 140px;
			height: 140px;
			object-fit: cover;
			border: 1px solid var(--color-border);
			border-radius: var(--radius);
		}

		.quote-content {
			white-space: pre-wrap;
		}

		.quote-form textarea {
			width: 100%;
			min-height: 140px;
		}

		.reject-box {
			margin-top: 16px;
		}

		.sub {
			font-size: 13px;
			color: var(--color-text-light);
		}

		.empty {
			color: var(--color-text-light);
		}
	</style>
</head>
<body>
	<!-- quote/requestview.jsp: 요청서 상세 + 견적 보내기·지정 요청 거절 (D-02) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container requestview">
		<div class="requestview-head">
			<h2><c:out value="${dto.categoryName}" /> 요청서 <span class="sub">${dto.requestSeq}번</span></h2>
			<div>
				<a class="btn btn-sm" href="${path}/quote/request.do<c:if test="${not empty dto.expertSeq}">?type=designated</c:if>">목록</a>
				<%-- 요청서 신고 (⑥ B-07): 모달과 서버가 로그인·본인·중복 신고를 막는다 --%>
				<button type="button" class="btn btn-sm" onclick="openReportModal('REQUEST', ${dto.requestSeq});">신고하기</button>
			</div>
		</div>

		<c:if test="${not empty msg}">
		<p class="message-info"><c:out value="${msg}" /></p>
		</c:if>

		<!-- 요청 정보 (고객 이름·연락처는 보여 주지 않는다) -->
		<section>
			<h3>요청 정보</h3>
			<table class="table info">
				<tr>
					<th>상태</th>
					<td>
						<c:choose>
							<c:when test="${dto.status eq 'OPEN'}"><span class="badge badge-primary">모집 중</span></c:when>
							<c:when test="${dto.status eq 'CLOSED'}"><span class="badge badge-warning">견적 마감</span></c:when>
							<c:when test="${dto.status eq 'SELECTED'}"><span class="badge badge-success">선택 완료</span></c:when>
							<c:when test="${dto.status eq 'CANCELED'}"><span class="badge">취소</span></c:when>
							<c:when test="${dto.status eq 'REJECTED'}"><span class="badge badge-danger">거절</span></c:when>
							<c:otherwise><span class="badge">만료</span></c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th>종류</th>
					<td>
						<c:choose>
							<c:when test="${empty dto.expertSeq}">공개 요청 <span class="sub">(받은 견적 ${dto.quoteCount} / 5)</span></c:when>
							<c:otherwise>나에게 보낸 지정 요청</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th>지역</th>
					<td><c:out value="${dto.address}" /></td>
				</tr>
				<tr>
					<th>희망 일정</th>
					<td><c:out value="${dto.wishDate}" default="협의" /></td>
				</tr>
				<tr>
					<th>예산</th>
					<td>
						<c:choose>
							<c:when test="${empty dto.budget}">협의</c:when>
							<c:otherwise><fmt:formatNumber value="${dto.budget}" />원</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th>견적 마감</th>
					<td>${dto.quoteDeadline}</td>
				</tr>
				<tr>
					<th>등록일</th>
					<td>${dto.regdate}</td>
				</tr>
			</table>
		</section>

		<!-- 질문 답변 -->
		<section>
			<h3>질문 답변</h3>
			<c:choose>
				<c:when test="${empty answerList}">
				<p class="empty">답변한 질문이 없습니다.</p>
				</c:when>
				<c:otherwise>
				<table class="table info">
					<c:forEach var="a" items="${answerList}">
					<tr>
						<th><c:out value="${a.question}" /></th>
						<td><c:out value="${a.answer}" /></td>
					</tr>
					</c:forEach>
				</table>
				</c:otherwise>
			</c:choose>
		</section>

		<!-- 참고 이미지 -->
		<c:if test="${not empty fileList}">
		<section>
			<h3>참고 이미지</h3>
			<div class="images">
				<c:forEach var="f" items="${fileList}">
				<a href="${path}/resources/upload/request/${f.saveFilename}" target="_blank">
					<img src="${path}/resources/upload/request/${f.saveFilename}" alt="<c:out value='${f.orgFilename}' />">
				</a>
				</c:forEach>
			</div>
		</section>
		</c:if>

		<!-- 견적 -->
		<section>
			<h3>견적</h3>
			<c:choose>

				<%-- 이미 보낸 견적이 있으면 보여 주기만 한다 --%>
				<c:when test="${not empty myQuote}">
				<div class="card">
					<p>
						<c:choose>
							<c:when test="${myQuote.status eq 'SELECTED'}"><span class="badge badge-success">선택됨</span></c:when>
							<c:when test="${myQuote.status eq 'UNSELECTED'}"><span class="badge">미선택</span></c:when>
							<c:otherwise><span class="badge badge-primary">대기</span></c:otherwise>
						</c:choose>
						<span class="sub">${myQuote.regdate}에 보냄</span>
					</p>
					<p><fmt:formatNumber value="${myQuote.price}" />원 · 작업 기간 ${myQuote.workDays}일</p>
					<p class="quote-content"><c:out value="${myQuote.content}" /></p>
				</div>
				</c:when>

				<%-- 견적을 보낼 수 없는 경우 --%>
				<c:when test="${dto.status ne 'OPEN' or dto.remainMinutes le 0}">
				<p class="empty">견적을 받는 기간이 끝난 요청서입니다.</p>
				</c:when>
				<c:when test="${not activeExpert}">
				<p class="message-error">신고 처리로 숨김 상태라 새 견적을 보낼 수 없습니다.</p>
				</c:when>

				<%-- 견적 작성 --%>
				<c:otherwise>
				<form id="quoteForm" class="quote-form" method="POST" action="${path}/quote/addok.do">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<input type="hidden" name="requestSeq" value="${dto.requestSeq}">

					<div class="form-group">
						<label for="price">견적 금액 (원)</label>
						<input type="number" id="price" name="price" min="1" max="100000000" step="1" required placeholder="예) 100000">
					</div>

					<div class="form-group">
						<label for="workDays">예상 작업 기간 (일)</label>
						<input type="number" id="workDays" name="workDays" min="1" max="365" step="1" required placeholder="예) 7">
					</div>

					<div class="form-group">
						<label for="content">견적 설명</label>
						<textarea id="content" name="content" maxlength="1000" required placeholder="작업 방식, 포함 내용, 일정 등을 적어 주세요."></textarea>
					</div>

					<button class="btn btn-primary btn-block">견적 보내기</button>
				</form>

				<%-- 지정 요청은 거절할 수 있다 --%>
				<c:if test="${not empty dto.expertSeq}">
				<form id="rejectForm" class="reject-box" method="POST" action="${path}/quote/rejectok.do">
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<input type="hidden" name="requestSeq" value="${dto.requestSeq}">
					<button class="btn btn-danger btn-block">요청 거절</button>
				</form>
				</c:if>
				</c:otherwise>

			</c:choose>
		</section>
	</main>

	<script>

		//설명이 공백뿐이면 보내지 않는다. 보낸 견적은 수정할 수 없으니 한 번 더 묻는다
		$('#quoteForm').submit(function () {

			if ($('#content').val().trim() == '') {
				alert('견적 설명을 입력해 주세요.');
				$('#content').focus();
				return false;
			}

			return confirm('견적을 보낼까요?\n보낸 견적은 수정할 수 없습니다.');
		});

		//거절하면 되돌릴 수 없으니 한 번 더 묻는다
		$('#rejectForm').submit(function () {
			return confirm('이 요청을 거절할까요?\n거절하면 되돌릴 수 없습니다.');
		});

	</script>

	<%@ include file="/WEB-INF/views/report/modal.jsp" %>
</body>
</html>
