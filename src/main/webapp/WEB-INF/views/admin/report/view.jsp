<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.view-table th {
			width: 140px;
			text-align: left;
			white-space: nowrap;
		}
		.process-box {
			margin-top: 24px;
		}
		.btn-group {
			margin-top: 12px;
		}
		.btn-group button {
			margin-right: 6px;
		}
	</style>
</head>
<body>
	<!-- admin/report/view.jsp: 관리자 신고 상세·처리 (⑥ E-02) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>신고 상세 <small>Report</small></h2>

			<%-- 처리하고 돌아왔을 때 결과 메시지 --%>
			<c:if test="${not empty msg}">
				<p class="message-info">${msg}</p>
			</c:if>

			<table class="table view-table">
				<tbody>
					<tr>
						<th>신고 번호</th>
						<td>${report.reportSeq}</td>
					</tr>
					<tr>
						<th>신고 대상</th>
						<td>
							<c:choose>
								<c:when test="${report.targetType eq 'PROFILE'}">고수 프로필</c:when>
								<c:otherwise>요청서</c:otherwise>
							</c:choose>
							${report.targetSeq}번
						</td>
					</tr>
					<tr>
						<th>사유</th>
						<td>
							<c:choose>
								<c:when test="${report.reasonType eq 'ABUSE'}">욕설</c:when>
								<c:when test="${report.reasonType eq 'FALSE_INFO'}">허위정보</c:when>
								<c:when test="${report.reasonType eq 'FRAUD'}">사기의심</c:when>
								<c:otherwise>기타</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th>상세 내용</th>
						<td><c:out value="${report.reasonDetail}" /></td>
					</tr>
					<tr>
						<th>신고자</th>
						<td><c:out value="${report.reporterId}" /></td>
					</tr>
					<tr>
						<th>신고일</th>
						<td>${report.regdate}</td>
					</tr>
					<tr>
						<th>상태</th>
						<td>
							<c:choose>
								<c:when test="${report.status eq 'RECEIVED'}"><span class="badge badge-primary">접수</span></c:when>
								<c:when test="${report.status eq 'REVIEWING'}"><span class="badge badge-warning">검토중</span></c:when>
								<c:when test="${report.status eq 'DONE'}"><span class="badge badge-success">처리완료</span></c:when>
								<c:otherwise><span class="badge badge-danger">반려</span></c:otherwise>
							</c:choose>
						</td>
					</tr>

					<%-- 처리가 끝난 신고만 아래 세 줄이 보인다 --%>
					<c:if test="${not empty report.processDate}">
					<tr>
						<th>처리 관리자</th>
						<td><c:out value="${report.adminId}" /></td>
					</tr>
					<tr>
						<th>처리일</th>
						<td>${report.processDate}</td>
					</tr>
					<tr>
						<th>처리 사유</th>
						<td><c:out value="${report.processReason}" /></td>
					</tr>
					</c:if>
				</tbody>
			</table>

			<%-- 아직 처리가 끝나지 않은 신고만 처리할 수 있다 --%>
			<c:if test="${report.status ne 'DONE' and report.status ne 'REJECTED'}">
			<div class="process-box">

				<c:if test="${report.status eq 'RECEIVED'}">
				<form method="POST" action="${path}/admin/report/review.do">
					<input type="hidden" name="reportSeq" value="${report.reportSeq}">
					<button class="btn btn-sm">검토중으로 변경</button>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				</form>
				</c:if>

				<form method="POST" action="${path}/admin/report/process.do" id="processForm">
					<input type="hidden" name="reportSeq" value="${report.reportSeq}">
					<div class="form-group">
						<label for="processReason">처리 사유 (필수)</label>
						<textarea id="processReason" name="processReason" rows="4" required></textarea>
					</div>
					<div class="btn-group">
						<button class="btn btn-primary" name="status" value="DONE">처리완료 (대상 숨김)</button>
						<button class="btn btn-danger" name="status" value="REJECTED">반려</button>
					</div>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				</form>

			</div>
			</c:if>

			<%-- 처리완료된 신고는 숨김을 다시 풀 수 있다 --%>
			<c:if test="${report.status eq 'DONE'}">
			<div class="process-box">
				<form method="POST" action="${path}/admin/report/unhide.do">
					<input type="hidden" name="reportSeq" value="${report.reportSeq}">
					<button class="btn btn-sm">숨김 해제</button>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				</form>
			</div>
			</c:if>

			<p class="process-box">
				<a class="btn btn-sm" href="${path}/admin/report/list.do">목록으로</a>
			</p>
		</main>
	</div>

	<script>
		$('#processForm').on('submit', function() {

			return confirm('처리하시겠습니까? 처리한 뒤에는 바꿀 수 없습니다.');
		});
	</script>
</body>
</html>