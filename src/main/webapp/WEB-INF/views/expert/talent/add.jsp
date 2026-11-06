<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.form-buttons {
			text-align: right;
		}

		/* form 은 줄을 바꾸니까 수정 버튼 옆에 나란히 놓는다 */
		.talent-del {
			display: inline-block;
		}

		.talent-buttons {
			white-space: nowrap;
			text-align: right;
		}
	</style>
</head>
<body>
	<!-- add.jsp: 제공 서비스 등록 + 등록된 서비스 목록 (화면설계서 ②-03) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<form class="card" id="talentForm" method="POST" action="${path}/expert/talent/addok.do">
			<h2>서비스 등록</h2>

			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

			<%@ include file="/WEB-INF/views/expert/talent/form.jsp" %>

			<div class="form-buttons">
				<a class="btn" href="${path}/expert/view.do?expertSeq=${expertSeq}">내 프로필로</a>
				<button class="btn btn-primary">등록</button>
			</div>
		</form>

		<section class="card">
			<h3>등록된 서비스</h3>

			<c:choose>
				<c:when test="${empty talentList}">
					<p class="message-info">등록된 서비스가 없어요</p>
				</c:when>
				<c:otherwise>
					<table class="table">
						<thead>
							<tr>
								<th>제목</th>
								<th>카테고리</th>
								<th>가격</th>
								<th>연결 포트폴리오</th>
								<th>상태</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${talentList}" var="talent">
							<tr>
								<td><a href="${path}/expert/talent/view.do?talentSeq=${talent.talentSeq}"><c:out value="${talent.title}" /></a></td>
								<td><c:out value="${talent.parentCategoryName}" /> · <c:out value="${talent.categoryName}" /></td>
								<td><fmt:formatNumber value="${talent.price}" pattern="#,###" />원</td>
								<td>${talent.portfolioCount}개</td>
								<%-- 삭제한 서비스는 목록에 안 나와서 여기 나오는 것은 전부 사용 중이다 --%>
								<td><span class="badge badge-success">사용</span></td>
								<td class="talent-buttons">
									<a class="btn btn-sm" href="${path}/expert/talent/edit.do?talentSeq=${talent.talentSeq}">수정</a>
									<%-- 지우는 동작이라 링크(GET)가 아니라 POST form 으로 보낸다 --%>
									<form class="talent-del" method="POST" action="${path}/expert/talent/delok.do"
										onsubmit="return confirm('이 서비스를 삭제할까요? 고수 상세와 검색에서 보이지 않게 됩니다.');">
										<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
										<input type="hidden" name="talentSeq" value="${talent.talentSeq}">
										<button class="btn btn-sm btn-danger">삭제</button>
									</form>
								</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:otherwise>
			</c:choose>
		</section>
	</main>
</body>
</html>
