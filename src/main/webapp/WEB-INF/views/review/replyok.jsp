<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body>
	<!-- review/replyok.jsp: 리뷰 답변 결과 (ReviewService.addReply 반환값) -->
	<script>

		<%-- 저장하면 내 고수 상세로 돌아간다. 답변 칸 대신 등록한 답변이 보인다 --%>
		<c:if test="${result == 1}">
		alert('답변을 등록했어요.');
		location.href = '${path}/expert/view.do?expertSeq=${expertSeq}';
		</c:if>

		<c:if test="${result == 0}">
		alert('답변 내용을 입력해 주세요. (한글 약 660자까지)');
		history.back();
		</c:if>

		<%-- 이미 답변한 리뷰(다른 창에서 먼저 등록), 내가 받은 리뷰가 아님, 숨김 처리된 고수 --%>
		<c:if test="${result == -1}">
		alert('답변을 등록할 수 없어요. 이미 답변한 리뷰인지 확인해 주세요. 등록한 답변은 수정할 수 없어요.');
		location.href = '${path}/expert/view.do?expertSeq=${expertSeq}';
		</c:if>

	</script>
</body>
</html>
