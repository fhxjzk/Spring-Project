<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<%--
		expert/form.jsp: 고수 프로필 작성(add.jsp), 수정(edit.jsp)이 같이 쓰는 입력칸 (화면설계서 ②-02)

		쓰는 법 — id="profileForm" 인 form 태그 안에서 이 줄을 넣는다 (부모 JSP에 c, fmt 태그 선언 필요)
		  <%@ include file="/WEB-INF/views/expert/form.jsp" %>

		받는 값
		  regionList   : 활동 가능 지역 17개 (체크박스)
		  kakaoJsKey   : 카카오맵 키 (주소 → 위도·경도, 지도 미리보기)
		  edto, careerList, myRegionSeqs : 수정 화면에서만 온다. 작성 화면에서는 비어 있어서 입력칸도 비어 있다

		경력 입력칸의 name 은 처음부터 정하지 않고, 저장 버튼을 누를 때 careerList[0].title 처럼 번호를 붙인다.
		줄을 넣고 지우다 보면 번호가 비거나 겹치기 때문이다.
	--%>

	<style>
		.form-hint {
			margin-top: 4px;
			font-size: 13px;
			color: var(--color-text-light);
		}

		/* 프로필 사진: 왼쪽 미리보기, 오른쪽 파일 선택 */
		.photo-row {
			display: flex;
			gap: 18px;
			align-items: center;
		}

		.photo-preview {
			flex: 0 0 120px;
			height: 120px;
			border-radius: 10px;
			overflow: hidden;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		.photo-preview img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		/* 경력 한 줄: 활동/회사명 | 시작 | 종료 */
		.career-row {
			padding: 14px;
			border: 1px solid var(--color-border);
			border-radius: 8px;
		}

		.career-row + .career-row {
			margin-top: 10px;
		}

		.career-grid {
			display: grid;
			grid-template-columns: 2fr 1fr 1fr;
			gap: 12px;
		}

		.career-row label {
			display: block;
			margin-bottom: 4px;
			font-size: 13px;
			font-weight: 600;
		}

		.career-row input,
		.career-row textarea {
			width: 100%;
		}

		.career-foot {
			display: flex;
			justify-content: flex-end;
			margin-top: 8px;
		}

		/* 주소 입력 + 검색 버튼 */
		.address-row {
			display: flex;
			gap: 8px;
		}

		.address-row .btn {
			flex-shrink: 0;
		}

		.map {
			height: 220px;
			margin-top: 10px;
			border-radius: 8px;
			background-color: color-mix(in srgb, var(--color-primary) 6%, var(--color-bg));
			display: flex;
			align-items: center;
			justify-content: center;
			font-size: 13px;
			color: var(--color-text-light);
		}

		/* 지역 체크박스 여러 개를 줄바꿈하며 나열 */
		.region-list {
			display: flex;
			flex-wrap: wrap;
			gap: 10px 18px;
			padding: 12px 14px;
			border: 1px solid var(--color-border);
			border-radius: 8px;
		}

		.region-list label {
			display: flex;
			align-items: center;
			gap: 6px;
			font-weight: 400;
		}
	</style>

	<section class="card">
		<h3>프로필 사진</h3>
		<div class="photo-row">
			<div class="photo-preview" id="photoPreview">
				<%-- 수정 화면이면 지금 사진을 보여 준다. 파일이 없으면(onerror) img를 지워서 배경색만 남긴다 --%>
				<c:if test="${not empty edto.profileImage}">
					<img src="${path}/resources/upload/profile/<c:out value='${edto.profileImage}' />" alt="" onerror="this.remove()">
				</c:if>
			</div>
			<div>
				<input type="file" id="imageFile" name="imageFile" accept="image/png,image/jpeg,image/gif">
				<div class="form-hint">
					jpg, png, gif 파일 1장. 올리지 않으면
					<c:choose>
						<c:when test="${not empty edto}">지금 사진을 그대로 둡니다.</c:when>
						<c:otherwise>기본 이미지로 보여줍니다.</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</section>

	<section class="card">
		<h3>소개</h3>
		<div class="form-group">
			<label for="intro">고수 소개</label>
			<%-- textarea 안의 값도 태그가 실행되지 않게 c:out 으로 출력한다 --%>
			<textarea id="intro" name="intro" rows="6" maxlength="2000" required><c:out value="${edto.intro}" /></textarea>
			<div class="form-hint">한글 약 660자까지 쓸 수 있어요.</div>
		</div>
	</section>

	<section class="card">
		<h3>경력</h3>

		<div id="careerBox">
			<%-- 수정 화면: 저장된 경력을 한 줄씩 채워서 보여 준다 --%>
			<c:forEach items="${careerList}" var="career">
				<div class="career-row">
					<div class="career-grid">
						<div>
							<label>활동/회사명</label>
							<input type="text" class="career-title" maxlength="100" value="<c:out value='${career.title}' />">
						</div>
						<div>
							<label>시작</label>
							<%-- input type="month" 는 2023-01 형식만 받는다. MM 은 대문자 (소문자 mm 은 분) --%>
							<input type="month" class="career-start" value="<fmt:formatDate value='${career.startDate}' pattern='yyyy-MM' />">
						</div>
						<div>
							<label>종료 (비우면 진행 중)</label>
							<input type="month" class="career-end" value="<fmt:formatDate value='${career.endDate}' pattern='yyyy-MM' />">
						</div>
					</div>
					<div class="form-group" style="margin: 10px 0 0;">
						<label>설명</label>
						<textarea class="career-desc" rows="2" maxlength="1000"><c:out value="${career.description}" /></textarea>
					</div>
					<div class="career-foot">
						<button type="button" class="btn btn-sm career-del">이 경력 삭제</button>
					</div>
				</div>
			</c:forEach>
		</div>

		<button type="button" class="btn btn-sm" id="btnCareerAdd" style="margin-top: 10px;">+ 경력 추가</button>
		<div class="form-hint">최대 20개까지 입력할 수 있어요. 비어 있는 줄은 저장하지 않아요.</div>

		<%-- [+ 경력 추가]를 누를 때 복사해서 쓰는 빈 줄. template 안의 내용은 화면에 보이지 않고 전송되지도 않는다 --%>
		<template id="careerTemplate">
			<div class="career-row">
				<div class="career-grid">
					<div>
						<label>활동/회사명</label>
						<input type="text" class="career-title" maxlength="100" placeholder="예: OO음악학원 강사">
					</div>
					<div>
						<label>시작</label>
						<input type="month" class="career-start">
					</div>
					<div>
						<label>종료 (비우면 진행 중)</label>
						<input type="month" class="career-end">
					</div>
				</div>
				<div class="form-group" style="margin: 10px 0 0;">
					<label>설명</label>
					<textarea class="career-desc" rows="2" maxlength="1000"></textarea>
				</div>
				<div class="career-foot">
					<button type="button" class="btn btn-sm career-del">이 경력 삭제</button>
				</div>
			</div>
		</template>
	</section>

	<section class="card">
		<h3>활동지역/주소</h3>

		<div class="form-group">
			<label for="serviceAddress">서비스 제공 위치</label>
			<div class="address-row">
				<input type="text" id="serviceAddress" name="serviceAddress" readonly maxlength="300"
					placeholder="주소 검색을 눌러 주세요" value="<c:out value='${edto.serviceAddress}' />">
				<button type="button" class="btn btn-primary" id="btnAddress">주소 검색</button>
			</div>
			<div class="form-hint" id="addressStatus">고수 상세와 지도 검색의 위치·거리 계산에 쓰여요. 가입 주소와는 따로 저장돼요.</div>
			<input type="hidden" id="serviceLatitude" name="serviceLatitude" value="${edto.serviceLatitude}">
			<input type="hidden" id="serviceLongitude" name="serviceLongitude" value="${edto.serviceLongitude}">
			<div class="map" id="map">주소를 고르면 지도에 위치가 표시돼요</div>
		</div>

		<div class="form-group">
			<label>활동 가능 지역 <span class="form-hint">(여러 개 선택)</span></label>
			<div class="region-list">
				<c:forEach items="${regionList}" var="region">
					<%-- 수정 화면이면 전에 체크한 지역에 checked 를 붙인다 --%>
					<c:set var="checked" value="" />
					<c:forEach items="${myRegionSeqs}" var="mySeq">
						<c:if test="${mySeq == region.regionSeq}"><c:set var="checked" value="checked" /></c:if>
					</c:forEach>
					<label><input type="checkbox" name="regionSeqs" value="${region.regionSeq}" ${checked}> ${region.regionName}</label>
				</c:forEach>
			</div>
		</div>
	</section>

	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
	<script>
		const MAX_CAREERS = 20;

		//===== 프로필 사진 =====

		//사진을 고르면 이미지 파일인지 확인하고 미리보기를 바꾼다 (서버에서도 한 번 더 막는다)
		$('#imageFile').on('change', function () {

			const file = this.files[0];

			if (!file) {
				return;
			}

			if (!/\.(jpe?g|png|gif)$/i.test(file.name)) {
				alert('jpg, png, gif 파일만 올릴 수 있어요.');
				$(this).val('');
				return;
			}

			$('#photoPreview').empty().append($('<img>').attr('src', URL.createObjectURL(file)));
		});

		//===== 경력 =====

		//[+ 경력 추가]: template 의 빈 줄을 복사해서 붙인다
		$('#btnCareerAdd').on('click', function () {

			if ($('#careerBox .career-row').length >= MAX_CAREERS) {
				alert('경력은 최대 ' + MAX_CAREERS + '개까지 입력할 수 있어요.');
				return;
			}

			$('#careerBox').append($('#careerTemplate').html());
		});

		//[이 경력 삭제]: 나중에 추가한 줄에도 동작하도록 부모(#careerBox)에 이벤트를 건다
		$('#careerBox').on('click', '.career-del', function () {
			$(this).closest('.career-row').remove();
		});

		//작성 화면은 경력 칸이 하나도 없으면 입력하기 어려워서 빈 줄 하나를 먼저 넣어 둔다
		if ($('#careerBox .career-row').length === 0) {
			$('#careerBox').append($('#careerTemplate').html());
		}

		//===== 주소 =====

		//[주소 검색] → 다음 우편번호 팝업 (회원가입과 같은 방식)
		$('#btnAddress').on('click', function () {
			new daum.Postcode({
				oncomplete: function (data) {
					//도로명 주소, 없으면 지번 주소
					const address = data.roadAddress || data.jibunAddress;

					$('#serviceAddress').val(address);
					setCoords(address);
				}
			}).open();
		});

		//주소 → 위도·경도 (카카오맵 Geocoder)
		function setCoords(address) {

			//이전에 고른 주소의 좌표가 남지 않게 비운다
			$('#serviceLatitude, #serviceLongitude').val('');

			if (typeof kakao === 'undefined') {
				$('#addressStatus').text('지도를 불러오지 못해 위치를 확인할 수 없어요. (secret.properties 의 kakao.js.key 확인)').css('color', 'var(--color-danger)');
				return;
			}

			const geocoder = new kakao.maps.services.Geocoder();

			geocoder.addressSearch(address, function (result, status) {

				if (status === kakao.maps.services.Status.OK) {
					//y: 위도, x: 경도
					$('#serviceLatitude').val(result[0].y);
					$('#serviceLongitude').val(result[0].x);
					$('#addressStatus').text('✓ 위치가 확인되었습니다').css('color', 'var(--color-secondary)');
					showMap(result[0].y, result[0].x);
				} else {
					$('#serviceAddress').val('');
					$('#addressStatus').text('위치를 찾지 못했습니다. 주소를 다시 골라 주세요.').css('color', 'var(--color-danger)');
				}
			});
		}

		//지도 미리보기에 마커 하나 찍기
		function showMap(lat, lng) {

			if (typeof kakao === 'undefined') {
				return;
			}

			const position = new kakao.maps.LatLng(lat, lng);
			const container = document.getElementById('map');

			$(container).empty();

			const map = new kakao.maps.Map(container, { center: position, level: 4 });
			new kakao.maps.Marker({ position: position, map: map });
		}

		//수정 화면: 저장된 위치를 처음부터 지도에 보여 준다
		if ($('#serviceLatitude').val() && $('#serviceLongitude').val()) {
			showMap($('#serviceLatitude').val(), $('#serviceLongitude').val());
		}

		//===== 저장 =====

		//한글은 3바이트라서 DB 컬럼 크기(바이트)와 맞춰 본다
		function byteLength(value) {
			return new TextEncoder().encode(value).length;
		}

		$('#profileForm').on('submit', function (e) {

			if (!$.trim($('#intro').val())) {
				alert('고수 소개를 입력해 주세요.');
				e.preventDefault();
				return;
			}

			if (byteLength($.trim($('#intro').val())) > 2000) {
				alert('고수 소개가 너무 길어요. (한글 약 660자까지)');
				e.preventDefault();
				return;
			}

			if (!$('#serviceLatitude').val() || !$('#serviceLongitude').val()) {
				alert('[주소 검색]으로 서비스 제공 위치를 골라 주세요.');
				e.preventDefault();
				return;
			}

			//경력: 통째로 빈 줄은 지우고, 남은 줄에 0부터 번호를 붙여 name 을 단다
			let index = 0;
			let message = '';

			$('#careerBox .career-row').each(function () {

				const row = $(this);
				const title = $.trim(row.find('.career-title').val());
				const start = row.find('.career-start').val();
				const end = row.find('.career-end').val();
				const desc = $.trim(row.find('.career-desc').val());

				if (!title && !start && !end && !desc) {
					row.remove();
					return;
				}

				if (!title || !start) {
					message = '경력의 활동/회사명과 시작 연월을 입력해 주세요.';
				} else if (byteLength(title) > 100 || byteLength(desc) > 1000) {
					message = '경력 내용이 너무 길어요. (활동/회사명은 한글 약 33자, 설명은 약 330자까지)';
				} else if (end && end < start) {
					//"2023-01" 처럼 같은 형식이라 글자 비교로 앞뒤를 알 수 있다
					message = '경력의 종료 연월이 시작보다 빠를 수 없어요.';
				}

				const prefix = 'careerList[' + index + '].';
				row.find('.career-title').attr('name', prefix + 'title');
				row.find('.career-start').attr('name', prefix + 'startDate');
				row.find('.career-end').attr('name', prefix + 'endDate');
				row.find('.career-desc').attr('name', prefix + 'description');
				index++;
			});

			if (message) {
				alert(message);
				e.preventDefault();
			}
		});
	</script>
