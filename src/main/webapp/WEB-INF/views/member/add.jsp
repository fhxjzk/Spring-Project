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

		.address-guide {
			margin-top: 6px;
			font-size: 14px;
		}

		.radio-group {
			gap: 8px;
		}

		.radio-group label {
			padding: 10px 16px;
			border: 1px solid var(--color-border);
			border-radius: var(--radius);
			cursor: pointer;
		}

		.radio-group label:has(input:checked) {
			color: var(--color-primary);
			font-weight: 600;
			background-color: color-mix(in srgb, var(--color-primary) 8%, transparent);
			border-color: var(--color-primary);
		}
	</style>
</head>
<body>
	<!-- member/add.jsp: 회원가입 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="form-box">
			<h2>회원가입</h2>

			<form method="POST" action="${path}/member/addok.do" id="joinForm">
				<div class="form-group">
					<label>가입 유형</label>
					<div class="radio-group">
						<label><input type="radio" name="role" value="ROLE_CUSTOMER" checked> 고객</label>
						<label><input type="radio" name="role" value="ROLE_EXPERT"> 고수</label>
					</div>
				</div>
				<div class="form-group">
					<label for="id">아이디</label>
					<input type="text" id="id" name="id" required maxlength="20" pattern="[A-Za-z0-9]{3,20}" title="영문과 숫자 3~20자로 입력해 주세요." placeholder="3~20자 영문/숫자">
				</div>
				<div class="form-group">
					<label for="pw">비밀번호</label>
					<input type="password" id="pw" name="pw" required minlength="8" placeholder="8자 이상">
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
					<label for="address">활동지역/주소</label>
					<div class="address-row">
						<input type="text" id="address" name="address" readonly maxlength="300" placeholder="주소 검색을 눌러 주세요">
						<button type="button" class="btn btn-primary" id="btnAddress">주소 검색</button>
					</div>
					<p class="address-guide" id="addressStatus"></p>
					<input type="hidden" id="latitude" name="latitude">
					<input type="hidden" id="longitude" name="longitude">
				</div>
				<button class="btn btn-primary btn-block">가입하기</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>

			<p class="form-footer">이미 회원이신가요? <a href="${path}/auth/login.do">로그인</a></p>
		</div>
	</main>

	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
	<script>

		//주소 검색 버튼 → 다음 우편번호 팝업
		$('#btnAddress').on('click', function() {
			new daum.Postcode({
				oncomplete: function(data) {
					//도로명 주소, 없으면 지번 주소
					const address = data.roadAddress || data.jibunAddress;

					$('#address').val(address);
					setCoords(address);
				}
			}).open();
		});

		//주소 → 위도·경도 (카카오맵 Geocoder)
		function setCoords(address) {

			//이전에 고른 주소의 좌표가 남지 않게 비운다
			$('#latitude, #longitude').val('');

			const geocoder = new kakao.maps.services.Geocoder();

			geocoder.addressSearch(address, function(result, status) {

				if (status === kakao.maps.services.Status.OK) {
					//y: 위도, x: 경도
					$('#latitude').val(result[0].y);
					$('#longitude').val(result[0].x);
					$('#addressStatus').text('✓ 위치가 확인되었습니다').css('color', 'var(--color-secondary)');
				} else {
					$('#address').val('');
					$('#addressStatus').text('위치를 찾지 못했습니다. 주소를 다시 골라 주세요.').css('color', 'var(--color-danger)');
				}
			});
		}

		//위치가 확인되지 않으면 가입을 막는다
		$('#joinForm').on('submit', function(e) {
			if (!$('#latitude').val() || !$('#longitude').val()) {
				alert('[주소 검색]으로 주소를 골라 주세요.');
				e.preventDefault();
			}
		});

	</script>
</body>
</html>
