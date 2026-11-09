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
		.myview {
			max-width: 760px;
		}

		.myview-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
			gap: 12px;
			margin-bottom: 16px;
		}

		.myview section {
			margin-bottom: 28px;
		}

		.myview h3 {
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

		.quote {
			margin-bottom: 12px;
		}

		.quote-head {
			display: flex;
			justify-content: space-between;
			margin-bottom: 8px;
			font-weight: 600;
		}

		.quote-content {
			white-space: pre-wrap;
		}

		.quote-foot {
			display: flex;
			align-items: center;
			gap: 10px;
			margin-top: 12px;
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
	<!-- request/myview.jsp: 내 요청서 상세 (C-01-d) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container myview">
		<div class="myview-head">
			<h2><c:out value="${dto.categoryName}" /> 요청서 <span class="sub">${dto.requestSeq}번</span></h2>
			<a class="btn btn-sm" href="${path}/request/mylist.do">목록</a>
		</div>

		<c:if test="${not empty msg}">
		<p class="message-info"><c:out value="${msg}" /></p>
		</c:if>

		<c:if test="${dto.hidden eq 'Y'}">
		<p class="message-error">신고 처리로 비공개된 요청서입니다. 고수에게 보이지 않고 견적을 받을 수 없어요.</p>
		</c:if>

		<!-- 요청 정보 -->
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
							<c:when test="${empty dto.expertSeq}">공개 요청</c:when>
							<c:otherwise>지정 요청 (<c:out value="${dto.expertName}" /> 고수)</c:otherwise>
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
				<c:if test="${not empty dto.selectDeadline}">
				<tr>
					<th>고수 선택 마감</th>
					<td>${dto.selectDeadline}</td>
				</tr>
				</c:if>
				<c:if test="${not empty dto.remainText}">
				<tr>
					<th>남은 시간</th>
					<td>
						<strong>${dto.remainText}</strong>
					</td>
				</tr>
				</c:if>
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

		<!-- 받은 견적 + 고수 선택 (C-02). 선택하면 ④ 거래의 결제 화면으로 넘어간다 -->
		<section>
			<h3>받은 견적 <span class="sub">${dto.quoteCount}개</span></h3>

			<%-- 고수를 고를 수 있는 때: 모집 중이거나, 견적 마감이고 고수 선택 마감 전 --%>
			<c:set var="selectable" value="${dto.status eq 'OPEN' or (dto.status eq 'CLOSED' and dto.remainMinutes gt 0)}" />

			<c:choose>
				<c:when test="${empty quoteList}">
				<p class="empty">아직 받은 견적이 없습니다.</p>
				</c:when>
				<c:otherwise>
				<c:forEach var="q" items="${quoteList}">
				<div class="card quote">
					<div class="quote-head">
						<a href="${path}/expert/view.do?expertSeq=${q.expertSeq}"><c:out value="${q.expertName}" /> 고수</a>
						<span>
							<c:choose>
								<c:when test="${q.status eq 'SELECTED'}"><span class="badge badge-success">선택됨</span></c:when>
								<c:when test="${q.status eq 'UNSELECTED'}"><span class="badge">미선택</span></c:when>
								<c:otherwise><span class="badge badge-primary">대기</span></c:otherwise>
							</c:choose>
						</span>
					</div>
					<p><fmt:formatNumber value="${q.price}" />원 · 작업 기간 ${q.workDays}일 <span class="sub">(${q.regdate})</span></p>
					<p class="quote-content"><c:out value="${q.content}" /></p>

					<%-- 이 견적으로 결제했으면 거래 화면으로 간다 (진행 상황, 구매 확정, 거래 취소는 거래 화면에서) --%>
					<c:if test="${not empty q.tradeSeq}">
					<div class="quote-foot">
						<a class="btn btn-primary btn-sm" href="${path}/trade/detail.do?tradeSeq=${q.tradeSeq}">거래 보기</a>
						<span class="sub">진행 상황과 구매 확정은 거래 화면에서 할 수 있어요.</span>
					</div>
					</c:if>

					<c:if test="${selectable and q.status eq 'WAITING'}">
					<div class="quote-foot">
						<c:choose>
							<c:when test="${q.expertHidden eq 'Y'}">
							<span class="badge">선택 불가</span>
							<span class="sub">신고 처리로 숨김 상태인 고수예요.</span>
							</c:when>
							<c:otherwise>
							<a class="btn btn-primary btn-sm" href="${path}/trade/pay.do?quoteSeq=${q.quoteSeq}">이 고수 선택</a>
							<span class="sub">결제 화면으로 넘어가요. 결제해야 선택이 끝나요.</span>
							</c:otherwise>
						</c:choose>
					</div>
					</c:if>
				</div>
				</c:forEach>
				</c:otherwise>
			</c:choose>
		</section>

		<!-- 취소: 고수를 고르기 전(모집 중·견적 마감)에만 -->
		<c:if test="${dto.status eq 'OPEN' or dto.status eq 'CLOSED'}">
		<form id="cancelForm" method="POST" action="${path}/request/cancel.do">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<input type="hidden" name="requestSeq" value="${dto.requestSeq}">
			<button class="btn btn-danger">요청서 취소</button>
			<p class="sub">등록한 요청서는 수정할 수 없어요. 내용을 바꾸려면 취소하고 다시 작성해 주세요.</p>
		</form>
		</c:if>
	</main>

	<script>

		//취소하면 되돌릴 수 없으니 한 번 더 묻는다
		$('#cancelForm').submit(function () {
			return confirm('요청서를 취소할까요?\n받은 견적은 모두 미선택으로 바뀌고 되돌릴 수 없습니다.');
		});

	</script>
</body>
</html>
