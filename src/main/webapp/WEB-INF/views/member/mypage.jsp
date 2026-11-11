<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
	
		body {
			background-color: var(--color-bg-light);
		}
		.table-card {
			overflow-x: auto;
		}
		.table td, .table th {
			white-space: nowrap;
		}
		.address-row {
			display: flex;
			gap: 8px;
		}

		.address-row input {
			flex: 1;
			min-width: 0;
		}

		.address-row .btn {
			height: 44px;
			flex-shrink: 0;
		}

		.address-guide {
			margin-top: 6px;
			font-size: 14px;
			color: var(--color-text-light);
		}

		.btn-area {
			display: flex;
			gap: 8px;
			margin-top: 16px;
		}
		.btn-stop {
			color: var(--color-danger);
			border-color: var(--color-danger);
		}
		#wishMypageCard {
			margin-block: 16px;
		}
	</style>
</head>
<body>
	<!-- member/mypage.jsp: 마이페이지 (① B-02-a) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<%-- 정보 수정 후 결과 문구 --%>
		<c:if test="${not empty msg}">
			<p class="message-info"><c:out value="${msg}" /></p>
		</c:if>

		<div class="card table-card">
			<h2>내 정보</h2>

			<table class="table">
				<thead>
					<tr>
						<th>아이디</th>
						<th>이름</th>
						<th>이메일</th>
						<th>활동지역</th>
						<th>가입일</th>
						<th>구분</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><c:out value="${member.id}" /></td>
						<td><c:out value="${member.name}" /></td>
						<td><c:out value="${member.email}" /></td>
						<td><c:out value="${member.address}" default="-" /></td>
						<td><c:out value="${member.regdate}" /></td>
						<td>
							<c:choose>
								<c:when test="${member.role eq 'ROLE_ADMIN'}"><span class="badge badge-danger">관리자</span></c:when>
								<c:when test="${member.role eq 'ROLE_EXPERT'}"><span class="badge badge-warning">고수</span></c:when>
								<c:otherwise><span class="badge badge-primary">고객</span></c:otherwise>
							</c:choose>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

		<%@ include file="/WEB-INF/views/wish/mypage-card.jsp" %>

		<div class="card">
			<h2>정보 수정</h2>

			<form id="editForm" method="POST" action="${path}/member/mypageok.do">
				<div class="form-group">
					<label for="name">이름</label>
					<input type="text" id="name" name="name" value="<c:out value='${member.name}' />" required maxlength="16">
				</div>

				<div class="form-group">
					<label for="email">이메일</label>
					<input type="email" id="email" name="email" value="<c:out value='${member.email}' />" required maxlength="100">
				</div>
				<div class="form-group">
					<label for="address">활동지역/주소</label>

					<div class="address-row">
						<input type="text"
							   id="address"
							   name="address"
							   value="<c:out value='${member.address}' />"
							   readonly
							   maxlength="100">

						<button type="button"
								class="btn"
								id="btnAddress">
							주소 변경
						</button>
					</div>

					<p id="addressStatus" class="address-guide" role="status">
						주소 변경을 누르면 주소 검색 창이 열립니다. 선택한 주소와 위치는 정보 수정을 누르면 함께 저장됩니다.
					</p>

					<%-- 주소를 변경하지 않아도 기존 좌표를 전송한다 --%>
					<input type="hidden"
						   id="latitude"
						   name="latitude"
						   value="<c:out value='${member.latitude}' />">

					<input type="hidden"
						   id="longitude"
						   name="longitude"
						   value="<c:out value='${member.longitude}' />">
				</div>

				<div class="form-group">
					<label for="pw">비밀번호 변경 (선택 입력)</label>
					
					<input type="password"
						id="pw"
						name="pw"
						minlength="8"
						autocomplete="new-password">
						
				</div>

				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>
		</div>

		<div class="btn-area">
			<button type="submit" class="btn btn-primary" form="editForm">정보 수정</button>
			<a class="btn btn-stop" href="${path}/member/withdraw.do">회원 탈퇴</a>
		</div>
	</main>

	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

	<c:if test="${not empty kakaoJsKey}">
		<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&amp;libraries=services"></script>
	</c:if>

	<script>
		//주소 변경 버튼 → 주소 검색 창
		$('#btnAddress').on('click', function() {

			if (typeof daum === 'undefined'
					|| typeof kakao === 'undefined'
					|| !kakao.maps
					|| !kakao.maps.services) {

				$('#addressStatus')
					.text('주소 검색을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.')
					.css('color', 'var(--color-danger)');

				return;
			}

			new daum.Postcode({
				oncomplete: function(data) {

					const address = data.roadAddress || data.jibunAddress;

					$('#address').val(address);
					setCoords(address);
				}
			}).open();
		});

		//주소 → 위도·경도
		function setCoords(address) {

			//새 주소의 좌표를 확인하기 전에 기존 좌표를 비운다
			$('#latitude, #longitude').val('');

			$('#addressStatus')
				.text('위치를 확인하고 있습니다.')
				.css('color', 'var(--color-primary)');

			const geocoder = new kakao.maps.services.Geocoder();

			geocoder.addressSearch(address, function(result, status) {

				//그사이 다른 주소를 선택했다면 이전 응답은 반영하지 않는다
				if ($('#address').val() !== address) {
					return;
				}

				if (status === kakao.maps.services.Status.OK
						&& result.length > 0) {

					//y: 위도, x: 경도
					$('#latitude').val(result[0].y);
					$('#longitude').val(result[0].x);

					$('#addressStatus')
						.text('✓ 위치가 확인되었습니다.')
						.css('color', 'var(--color-secondary)');

				} else {

					$('#address').val('');
					$('#latitude, #longitude').val('');

					$('#addressStatus')
						.text('위치를 찾지 못했습니다. 주소를 다시 선택해 주세요.')
						.css('color', 'var(--color-danger)');
				}
			});
		}
		
		//입력칸의 Enter로 폼이 제출되는 것을 막는다
		$('#editForm').on('keydown', 'input', function(e) {

			//한글 입력 중 조합을 완료하는 Enter는 방해하지 않는다
			if (e.originalEvent && e.originalEvent.isComposing) {
				return;
			}

			if (e.key === 'Enter') {
				e.preventDefault();
			}
		});
		
		//주소와 좌표가 확인돼야 수정 요청을 보낸다
		$('#editForm').on('submit', function(e) {

			if (!$('#address').val().trim()
					|| !$('#latitude').val()
					|| !$('#longitude').val()) {

				e.preventDefault();
				alert('주소 검색으로 위치를 확인해 주세요.');
			}
		});
	</script>
</body>
</html>