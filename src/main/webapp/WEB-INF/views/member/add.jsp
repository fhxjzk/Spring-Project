<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.address-row {
			display: flex;
			gap: 8px;
		}

		.address-row .btn {
			height: 44px;
			flex-shrink: 0;
		}
	</style>
</head>
<body>
	<!-- member/add.jsp: 회원가입 (주소, 좌표 등 A-01 항목은 ① 담당자가 추가) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="form-box">
			<h2>회원가입</h2>

			<form method="POST" action="${path}/member/addok.do">
				<div class="form-group">
					<label>가입 유형</label>
					<div class="radio-group">
						<label><input type="radio" name="role" value="ROLE_CUSTOMER" checked> 고객</label>
						<label><input type="radio" name="role" value="ROLE_EXPERT"> 고수</label>
					</div>
				</div>
				<div class="form-group">
					<label for="id">아이디</label>
					<input type="text" id="id" name="id" required maxlength="50">
				</div>
				<div class="form-group">
					<label for="pw">비밀번호</label>
					<input type="password" id="pw" name="pw" required>
				</div>
				<div class="form-group">
					<label for="name">이름</label>
					<input type="text" id="name" name="name" required maxlength="50">
				</div>
				<div class="form-group">
					<label for="email">이메일</label>
					<input type="email" id="email" name="email" required maxlength="100">
				</div>
				<div class="form-group">
					<label for="address">주소</label>
					<div class="address-row">
						<input type="text" id="address" name="address" readonly maxlength="300" placeholder="주소 검색을 눌러 주세요">
						<button type="button" class="btn" id="btnAddress">주소 검색</button>
					</div>
				</div>
				<button class="btn btn-primary btn-block">가입하기</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>

			<p class="form-footer">이미 회원이신가요? <a href="${path}/auth/login.do">로그인</a></p>
		</div>
	</main>

	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>

		//주소 검색 버튼 → 다음 우편번호 팝업
		$('#btnAddress').on('click', function() {
			new daum.Postcode({
				oncomplete: function(data) {
					//도로명 주소, 없으면 지번 주소
					$('#address').val(data.roadAddress || data.jibunAddress);
				}
			}).open();
		});

	</script>
</body>
</html>
