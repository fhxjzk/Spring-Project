<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body>
	<!-- review/addok.jsp: 리뷰 작성 결과 (ReviewService.add 반환값) -->
	<script>

		<%-- 저장하면 거래 상세로 돌아간다. [리뷰 작성] 버튼은 이제 안 보인다 --%>
		<c:if test="${result == 1}">
		alert('리뷰를 등록했어요.');
		location.href = '${path}/trade/detail.do?tradeSeq=${tradeSeq}';
		</c:if>

		<c:if test="${result == 0}">
		alert('별점을 고르고 리뷰 내용을 입력해 주세요. (한글 약 660자까지)');
		history.back();
		</c:if>

		<%-- 남의 거래, 구매 확정 전, 이미 쓴 거래 (다른 창에서 먼저 등록했거나 두 번 누른 경우) --%>
		<c:if test="${result == -1}">
		alert('리뷰를 작성할 수 없는 거래예요. 이미 리뷰를 작성했는지 확인해 주세요.');
		location.href = '${path}/trade/mylist.do';
		</c:if>

	</script>
</body>
</html>
