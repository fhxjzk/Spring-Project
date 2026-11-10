<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<%--
		review/item.jsp: 리뷰 한 줄 (별점 · 작성자 · 작성일 · 내용 · 고수 답변)

		쓰는 법 — <c:forEach items="..." var="review"> 안에서 이 줄을 넣는다 (부모 JSP에 c, fmt 태그 선언 필요)
			<%@ include file="/WEB-INF/views/review/item.jsp" %>
		부모 JSP 에 있어야 하는 값
			review    : ReviewDto (forEach 의 var)
			isOwner   : 이 리뷰를 받은 고수 본인이 보고 있는지 → 답변 입력 칸을 보일지
			isHidden  : 신고 처리로 숨김된 고수인지 → 숨김이면 답변 입력 칸을 안 보인다
			replyFrom : 'list' 면 답변 후 리뷰 전체보기로, 없으면 고수 상세로 돌아간다 (review/replyok.jsp)
		CSS·JS(checkReply)는 review/item-head.jsp 에 있다
	--%>
	<div class="review-item">
		<div class="review-head">
			<span class="review-stars"><c:forEach begin="1" end="5" var="i">${i <= review.rating ? '★' : '☆'}</c:forEach></span>
			<strong class="small"><c:out value="${review.customerName}" /></strong>
			<span class="review-date message-info small"><fmt:formatDate value="${review.regdate}" pattern="yyyy-MM-dd" /></span>
		</div>
		<p class="review-body small"><c:out value="${review.content}" /></p>

		<%-- 고수 답변 (②-06). 답변이 있으면 누구에게나 보이고, 없으면 본인 고수에게만 입력 칸이 보인다.
		     등록한 답변은 수정할 수 없어서 수정 버튼이 없다 (ReviewMapper.addReply 의 reply is null 조건) --%>
		<c:choose>
			<c:when test="${not empty review.reply}">
				<div class="review-reply">
					<strong>고수 답변</strong>
					<span class="message-info small"><fmt:formatDate value="${review.replyDate}" pattern="yyyy-MM-dd" /></span>
					<p class="small"><c:out value="${review.reply}" /></p>
				</div>
			</c:when>

			<%-- 숨김 처리된 고수는 답변할 수 없다 (서비스 등록·수정과 같은 기준) --%>
			<c:when test="${isOwner and not isHidden}">
				<form class="reply-form" method="POST" action="${path}/review/replyok.do"
						onsubmit="return checkReply(this);">
					<textarea name="reply" rows="3" placeholder="고객에게 답변을 남겨 보세요."></textarea>
					<div class="reply-form-footer">
						<span class="message-info small">등록한 답변은 수정할 수 없어요</span>
						<button class="btn btn-primary btn-sm">답변 등록</button>
					</div>
					<input type="hidden" name="reviewSeq" value="${review.reviewSeq}">
					<c:if test="${replyFrom eq 'list'}">
						<input type="hidden" name="from" value="list">
					</c:if>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				</form>
			</c:when>
		</c:choose>
	</div>
