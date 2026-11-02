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
		.search-bar {
			display: flex;
			gap: 12px;
			align-items: flex-end;
			flex-wrap: wrap;
		}
		.search-bar .f {
			display: flex;
			flex-direction: column;
			gap: 5px;
		}
		.search-bar label {
			font-size: 12px;
			font-weight: 600;
			color: var(--color-text-light);
		}
		.search-bar select,
		.search-bar input {
			height: 40px;
		}
		.f-category { width: 180px; }
		.f-region { width: 140px; }
		.f-distance { width: 130px; }
		.f-keyword { width: 200px; }

		.base-row {
			display: flex;
			gap: 8px;
			align-items: center;
			flex-wrap: wrap;
			margin-top: 12px;
		}
		/* 지금 어느 기준으로 검색 중인지 눈에 띄게 보여준다 */
		.base-label {
			padding: 5px 12px;
			border: 1px solid #bcd7f7;
			border-radius: 999px;
			background: #ebf4ff;
			font-size: 13px;
			font-weight: 600;
			color: #2b6cb0;
		}
		/* 지금 쓰고 있는 기준의 버튼을 진하게 칠한다 */
		.base-row .on {
			border-color: #2b6cb0;
			background: #2b6cb0;
			color: #fff;
		}

		.result-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-top: 24px;
		}
		.result-head .count {
			font-weight: 600;
		}

		.result-row {
			display: flex;
			gap: 16px;
			margin-top: 12px;
			align-items: flex-start;
		}
		/* 지도 + 범례를 위아래로 쌓는다 */
		.map-col {
			position: relative;
			flex: 1;
			display: flex;
			flex-direction: column;
			gap: 6px;
		}

		/* 마커를 누르면 지도 아래쪽에 뜨는 고수 카드 (B-04-07) */
		.map-card {
			position: absolute;
			right: 14px;
			bottom: 14px;
			left: 14px;
			z-index: 5;
			display: none;
			padding: 14px 40px 14px 16px;
			border-radius: var(--radius);
			background: #fff;
			box-shadow: 0 4px 16px rgba(0, 0, 0, .22);
			color: var(--color-text);
		}
		.map-card-body {
			display: block;
			color: var(--color-text);
		}
		.map-card-body:hover {
			text-decoration: none;
		}
		.map-card .name {
			font-size: 16px;
			font-weight: 700;
		}
		.map-card .meta {
			margin-top: 4px;
			font-size: 13px;
			color: var(--color-text-light);
		}
		.map-card .talent {
			margin-top: 6px;
			font-size: 13px;
		}
		/* 카드 닫기 X 버튼 */
		.map-card-close {
			position: absolute;
			top: 8px;
			right: 10px;
			padding: 2px 6px;
			border: 0;
			background: none;
			color: var(--color-text-light);
			font-size: 18px;
			line-height: 1;
			cursor: pointer;
		}
		.map-legend {
			display: flex;
			gap: 14px;
			font-size: 13px;
			color: var(--color-text-light);
		}
		.map-legend .dot {
			display: inline-block;
			width: 10px;
			height: 10px;
			margin-right: 5px;
			border-radius: 50%;
			vertical-align: middle;
		}
		.map-legend .dot-expert { background: #e74c3c; }
		.map-legend .dot-base { background: #1a73e8; }

		/* 지도에 찍는 내 위치 딱지. 고수 핀(빨강)과 확실히 구분되게 파란 알약으로 그린다 */
		.me-pin {
			display: flex;
			gap: 6px;
			align-items: center;
			padding: 5px 11px;
			border: 2px solid #fff;
			border-radius: 999px;
			background: #1a73e8;
			box-shadow: 0 2px 6px rgba(0, 0, 0, .35);
			font-size: 12px;
			font-weight: 700;
			color: #fff;
			white-space: nowrap;
		}
		.me-pin .me-dot {
			width: 8px;
			height: 8px;
			border-radius: 50%;
			background: #fff;
		}

		.map-area {
			flex: 1;
			min-height: 420px;
			border: 1px solid var(--color-border);
			border-radius: var(--radius);
			background: var(--color-bg-light);
			display: flex;
			align-items: center;
			justify-content: center;
			color: var(--color-text-light);
			font-size: 13px;
		}
		.expert-list {
			width: 340px;
		}
		.expert-card {
			display: block;
			padding: 14px 16px;
			border: 1px solid var(--color-border);
			border-radius: var(--radius);
			color: var(--color-text);
		}
		.expert-card + .expert-card {
			margin-top: 8px;
		}
		.expert-card:hover {
			background: var(--color-bg-light);
			text-decoration: none;
		}
		.expert-card .name {
			font-weight: 700;
		}
		.expert-card .meta {
			margin-top: 4px;
			font-size: 13px;
			color: var(--color-text-light);
		}
		.expert-card .talent {
			margin-top: 6px;
			font-size: 13px;
		}
		.empty-box {
			margin-top: 12px;
			padding: 32px 16px;
			text-align: center;
			border: 1px solid var(--color-border);
			border-radius: var(--radius);
		}
		.empty-box p {
			margin: 6px 0;
		}
		.more-row {
			margin-top: 12px;
			text-align: center;
		}
	</style>
</head>
<body>
	<!-- search/list.jsp: 고수 검색·지도 조회 (⑥ B-04) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>고수 찾기 <small>Search</small></h2>

		<%-- 검색 조건. GET으로 보내서 주소에 조건이 남게 한다 (새로고침해도 조건이 유지된다) --%>
		<form id="searchForm" method="GET" action="${path}/search/list.do">

			<%-- 기준 위치. GPS 버튼을 누르면 여기에 좌표가 채워진다 (B-04-04) --%>
			<input type="hidden" id="baseLat" name="baseLat" value="${param.baseLat}">
			<input type="hidden" id="baseLng" name="baseLng" value="${param.baseLng}">

			<div class="search-bar">
				<div class="f f-category">
					<label for="categorySeq">카테고리</label>
					<select id="categorySeq" name="categorySeq">
						<option value="">전체</option>
						<%-- 대분류 > 소분류 로 보여준다. 고수 서비스가 소분류에 달려 있다 --%>
						<c:forEach var="cg" items="${categoryList}">
							<option value="${cg.categorySeq}" ${search.categorySeq eq cg.categorySeq ? 'selected' : ''}>${cg.parentName} &gt; ${cg.name}</option>
						</c:forEach>
					</select>
				</div>

				<div class="f f-region">
					<label for="regionSeq">지역</label>
					<select id="regionSeq" name="regionSeq">
						<option value="">전국</option>
						<c:forEach var="rg" items="${regionList}">
							<option value="${rg.regionSeq}" ${search.regionSeq eq rg.regionSeq ? 'selected' : ''}>${rg.regionName}</option>
						</c:forEach>
					</select>
				</div>

				<div class="f f-distance">
					<label for="radiusKm">거리</label>
					<select id="radiusKm" name="radiusKm">
						<option value="">전체</option>
						<option value="5" ${search.radiusKm eq 5 ? 'selected' : ''}>5km 이내</option>
						<option value="10" ${search.radiusKm eq 10 ? 'selected' : ''}>10km 이내</option>
						<option value="20" ${search.radiusKm eq 20 ? 'selected' : ''}>20km 이내</option>
					</select>
				</div>

				<div class="f f-keyword">
					<label for="keyword">검색어</label>
					<input type="search" id="keyword" name="keyword" value="<c:out value='${search.keyword}' />" placeholder="고수 이름, 소개글">
				</div>

				<div class="f">
					<label>&nbsp;</label>
					<button type="submit" class="btn btn-primary">검색</button>
				</div>
			</div>

			<%-- 현재 기준 위치 표시 (화면설계서 ⑥-01) --%>
			<div class="base-row">
				<button type="button" class="btn btn-sm ${baseMode eq 'gps' ? 'on' : ''}" onclick="findByGps()">GPS로 내 위치 찾기</button>
				<button type="button" class="btn btn-sm ${baseMode eq 'member' ? 'on' : ''}" onclick="findByMyAddress()">내 등록 주소로 찾기</button>
				<span class="base-label">기준 위치 · <c:out value="${baseLabel}" /></span>
			</div>

			<div class="result-head">
				<span class="count">총 ${total}명</span>

				<%-- 정렬 (B-04-08). 고르면 바로 다시 검색한다 --%>
				<select name="sort" onchange="document.getElementById('searchForm').submit();" style="width:150px;">
					<option value="distance" ${search.sort eq 'distance' ? 'selected' : ''}>거리순</option>
					<option value="review" ${search.sort eq 'review' ? 'selected' : ''}>리뷰 많은순</option>
					<option value="rating" ${search.sort eq 'rating' ? 'selected' : ''}>평점순</option>
					<option value="recent" ${search.sort eq 'recent' ? 'selected' : ''}>최근활동순</option>
					<option value="hire" ${search.sort eq 'hire' ? 'selected' : ''}>고용순</option>
				</select>
			</div>

			<%-- 더보기는 한 번에 보여줄 개수를 늘리는 방식이다 (B-04-09) --%>
			<input type="hidden" id="size" name="size" value="${search.size}">
		</form>

		<c:choose>
			<%-- 결과 없음 안내·추천 (B-04-10) --%>
			<c:when test="${empty list}">
				<div class="empty-box">
					<p><strong>조건에 맞는 고수가 없습니다.</strong></p>
					<p class="base-label">거리 범위를 넓히거나 다른 카테고리로 찾아보세요.</p>
					<p>
						<c:if test="${not empty search.radiusKm}">
							<button type="button" class="btn btn-sm" onclick="widenDistance()">거리 넓혀서 다시 찾기</button>
						</c:if>
						<c:if test="${not empty search.categorySeq}">
							<button type="button" class="btn btn-sm" onclick="clearCategory()">카테고리 없이 찾기</button>
						</c:if>
					</p>
				</div>
			</c:when>

			<c:otherwise>
				<div class="result-row">
					<%-- 지도 마커 + 클러스터링 (B-04-06) --%>
					<div class="map-col">

						<%-- 지도에 뭐가 뭔지 알려준다 --%>
						<div class="map-legend">
							<span><i class="dot dot-expert"></i>고수</span>
							<span><i class="dot dot-base"></i>내 위치 (검색 기준)</span>
						</div>

						<div class="map-area" id="map"></div>

						<%-- 마커를 누르면 여기에 그 고수 내용이 채워진다 --%>
						<div class="map-card" id="mapCard">
							<a href="#" class="map-card-body" id="mapCardBody"></a>
							<button type="button" class="map-card-close" onclick="hideMapCard()">&times;</button>
						</div>
					</div>

					<div class="expert-list">
						<c:forEach var="e" items="${list}">
						<%-- 지도 스크립트가 아래 data-* 값을 읽어서 마커를 찍는다 --%>
						<a class="expert-card" href="${path}/expert/view.do?expertSeq=${e.expertSeq}"
								data-seq="${e.expertSeq}"
								data-lat="${e.serviceLatitude}"
								data-lng="${e.serviceLongitude}"
								data-name="<c:out value='${e.name}' />">
							<span class="name"><c:out value="${e.name}" /></span>
							<div class="meta">
								★ ${e.avgRating} (${e.reviewCount})
								<c:if test="${not empty e.distanceKm}"> &middot; ${e.distanceKm}km</c:if>
								<c:if test="${e.hireCount > 0}"> &middot; 고용 ${e.hireCount}회</c:if>
							</div>
							<div class="talent">
								<c:out value="${e.talentTitle}" default="등록한 서비스 없음" />
								<c:if test="${not empty e.price}">
									&middot; <fmt:formatNumber value="${e.price}" pattern="#,###" />원
								</c:if>
							</div>
							<div class="meta"><c:out value="${e.serviceAddress}" /></div>
						</a>
						</c:forEach>

						<c:if test="${hasMore}">
						<div class="more-row">
							<button type="button" class="btn btn-block" onclick="showMore()">더보기</button>
						</div>
						</c:if>
					</div>
				</div>
			</c:otherwise>
		</c:choose>
	</main>

	<script>
		const form = document.getElementById('searchForm');

		//지도 아래 고수 카드를 닫는다
		function hideMapCard() {

			$('#mapCard').hide();
		}

		//GPS로 내 위치 찾기 (B-04-04)
		function findByGps() {

			if (!navigator.geolocation) {
				alert('이 브라우저에서는 위치 찾기를 쓸 수 없습니다. 등록 주소로 검색합니다.');
				findByMyAddress();
				return;
			}

			navigator.geolocation.getCurrentPosition(
				function (pos) {

					$('#baseLat').val(pos.coords.latitude);
					$('#baseLng').val(pos.coords.longitude);

					form.submit();
				},
				function () {

					//위치 제공을 거절했거나 못 얻은 경우 (B-04-05)
					alert('위치를 가져오지 못했습니다. 등록 주소를 기준으로 검색합니다.');
					findByMyAddress();
				}
			);
		}

		//기준 위치를 비우면 서버가 등록 주소(비회원은 지역 중심)로 다시 잡는다 (B-04-05)
		function findByMyAddress() {

			$('#baseLat').val('');
			$('#baseLng').val('');

			form.submit();
		}

		//더보기 — 한 번에 보여줄 개수를 10개 늘려서 다시 조회한다 (B-04-09)
		function showMore() {

			$('#size').val(Number($('#size').val()) + 10);

			form.submit();
		}

		//결과가 없을 때 거리 조건을 푼다 (B-04-10)
		function widenDistance() {

			$('#radiusKm').val('');

			form.submit();
		}

		//결과가 없을 때 카테고리 조건을 푼다 (B-04-10)
		function clearCategory() {

			$('#categorySeq').val('');

			form.submit();
		}
	</script>

	<%-- 카카오맵 (B-04-06). 키는 secret.properties 에 있다 --%>
	<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=clusterer&autoload=false"></script>
	<script>
		//검색 기준 위치. 없으면 서울 시청
		const baseLat = ${empty search.baseLat ? 37.5665 : search.baseLat};
		const baseLng = ${empty search.baseLng ? 126.9780 : search.baseLng};

		kakao.maps.load(function () {

			const mapBox = document.getElementById('map');

			//결과가 0건이면 지도 영역 자체가 없다
			if (!mapBox) {
				return;
			}

			const map = new kakao.maps.Map(mapBox, {
				center: new kakao.maps.LatLng(baseLat, baseLng),
				level: 7
			});

			//마커가 많아지면 묶어서 보여준다 (클러스터링).
			//minLevel 을 낮게 두면 몇 명 안 되는데도 뭉쳐버려서 핀이 안 보인다.
			//시·도 단위까지 축소했을 때만 묶이도록 9로 둔다.
			const clusterer = new kakao.maps.MarkerClusterer({
				map: map,
				averageCenter: true,
				minLevel: 9
			});

			const bounds = new kakao.maps.LatLngBounds();
			const markers = [];

			//고수 핀을 빨간색으로 직접 그린다. 범례의 빨간 점과 색을 맞추기 위함이다.
			//그림 파일 주소를 가져다 쓰지 않고 글자로 적은 그림이라 깨질 일이 없다.
			const expertPin = new kakao.maps.MarkerImage(
				'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(
					'<svg xmlns="http://www.w3.org/2000/svg" width="30" height="42" viewBox="0 0 30 42">'
					+ '<path d="M15 1C7.8 1 2 6.8 2 14c0 9.8 13 27 13 27s13-17.2 13-27C28 6.8 22.2 1 15 1z"'
					+ ' fill="#e74c3c" stroke="#ffffff" stroke-width="2"/>'
					+ '<circle cx="15" cy="14" r="5" fill="#ffffff"/></svg>'),
				new kakao.maps.Size(30, 42),
				{ offset: new kakao.maps.Point(15, 42) }
			);

			//목록 카드에 적어둔 data-* 값을 읽어서 마커를 만든다
			$('.expert-card').each(function () {

				const card = $(this);
				const pos = new kakao.maps.LatLng(card.data('lat'), card.data('lng'));
				const marker = new kakao.maps.Marker({ position: pos, image: expertPin });

				//마커를 누르면 지도 아래에 그 고수 카드가 뜨고, 카드를 누르면 상세로 간다 (B-04-07)
				kakao.maps.event.addListener(marker, 'click', function () {

					//목록 카드 내용을 그대로 가져다 쓴다. 따로 데이터를 또 넘길 필요가 없다
					$('#mapCardBody').html(card.html()).attr('href', card.attr('href'));
					$('#mapCard').show();

					map.panTo(pos);
				});

				markers.push(marker);
				bounds.extend(pos);
			});

			clusterer.addMarkers(markers);

			//내 위치(검색 기준) 표시. 고수 마커(빨간 핀)와 구분되게 파란 딱지로 찍는다
			const basePos = new kakao.maps.LatLng(baseLat, baseLng);

			new kakao.maps.CustomOverlay({
				map: map,
				position: basePos,
				zIndex: 10,
				content: '<div class="me-pin"><span class="me-dot"></span>내 위치</div>'
			});

			//내 위치도 항상 같이 보이도록 지도 범위에 넣는다
			bounds.extend(basePos);

			//검색 결과가 다 보이도록 지도 범위를 맞춘다 (점을 다 넣은 뒤 맨 마지막에 한다)
			if (markers.length > 0) {
				map.setBounds(bounds);
			}
			
			//목록 카드에 마우스를 올리면 그 고수 위치로 지도를 옮긴다
			$('.expert-card').on('mouseenter', function () {

				map.panTo(new kakao.maps.LatLng($(this).data('lat'), $(this).data('lng')));
			});

			//지도 빈 곳을 누르면 카드를 닫는다
			kakao.maps.event.addListener(map, 'click', hideMapCard);
		});
	</script>
</body>
</html>
