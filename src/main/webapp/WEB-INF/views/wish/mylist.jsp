<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.wish-page {
			max-width: 760px;
			margin: 0 auto;
		}

		.wish-count-total {
			margin-left: 4px;
			font-size: 16px;
			font-weight: normal;
			color: var(--color-text-light);
		}

		/* 고수 한 줄: 사진 · 이름과 정보 · 하트 */
		.wish-item {
			display: flex;
			align-items: center;
			gap: 14px;
		}

		.wish-item + .wish-item {
			margin-top: 12px;
			padding-top: 12px;
			border-top: 1px solid var(--color-border);
		}

		/* 사진이 없거나 파일을 못 찾으면(onerror) 배경색만 남는다. 메인 인기 고수와 같은 방식 */
		.wish-photo {
			flex: 0 0 52px;
			height: 52px;
			border-radius: 50%;
			overflow: hidden;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		.wish-photo img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		/* 사진과 이름을 눌러 고수 상세로 간다 */
		.wish-link {
			display: flex;
			align-items: center;
			gap: 14px;
			flex: 1;
			min-width: 0;
			color: inherit;
			text-decoration: none;
		}

		.wish-info {
			min-width: 0;
		}

		.wish-info strong {
			display: block;
		}

		/* 소분류가 많으면 한 줄에서 ...으로 자른다 */
		.wish-category {
			display: block;
			overflow: hidden;
			white-space: nowrap;
			text-overflow: ellipsis;
		}

		.wish-heart {
			color: var(--color-danger);
		}

		/* 찜 해제 버튼 (♥) */
		.unwish-btn {
			flex-shrink: 0;
			padding: 4px 10px;
			border: 1px solid var(--color-danger);
			border-radius: 999px;
			background: none;
			font-size: 18px;
			line-height: 1;
			color: var(--color-danger);
			cursor: pointer;
		}

		.empty {
			color: var(--color-text-light);
			text-align: center;
		}
	</style>
</head>
<body>
	<!-- wish/mylist.jsp: 내가 찜한 고수 (찜하기, 추가 기능) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="wish-page">
			<h2>찜한 고수 <span class="wish-count-total" id="wishTotal">${fn:length(wishList)}명</span></h2>

			<section class="card" id="wishCard">
				<c:forEach items="${wishList}" var="expert">
				<div class="wish-item">
					<a class="wish-link" href="${path}/expert/view.do?expertSeq=${expert.expertSeq}">
						<div class="wish-photo">
							<c:if test="${not empty expert.profileImage}">
								<img src="${path}/resources/upload/profile/<c:out value='${expert.profileImage}' />" alt="" onerror="this.remove()">
							</c:if>
						</div>
						<div class="wish-info">
							<strong><c:out value="${expert.name}" /></strong>
							<c:if test="${not empty expert.categoryNames}">
								<span class="wish-category message-info small"><c:out value="${expert.categoryNames}" /></span>
							</c:if>
							<span class="message-info small">
								<c:choose>
									<c:when test="${expert.reviewCount > 0}">★${expert.averageRating} (${expert.reviewCount})</c:when>
									<c:otherwise>아직 리뷰가 없어요</c:otherwise>
								</c:choose>
								· <span class="wish-heart">♡</span> <fmt:formatNumber value="${expert.wishCount}" />
							</span>
						</div>
					</a>
					<button type="button" class="unwish-btn" title="찜 해제" onclick="unwish(this, ${expert.expertSeq});">♥</button>
				</div>
				</c:forEach>

				<p class="empty" id="wishEmpty" ${empty wishList ? '' : 'hidden'}>
					아직 찜한 고수가 없어요. 고수 상세에서 ♡ 를 눌러 찜해 보세요.
				</p>
			</section>
		</div>
	</main>

	<script>
		// 찜 해제 (WishController.delete). 다른 창에서 먼저 해제했어도 결과는 같으니 그 줄을 지운다
		function unwish(btn, expertSeq) {

			if (!confirm('찜을 해제할까요?')) {
				return;
			}

			btn.disabled = true;

			$.post('${path}/wish/delete.do', { expertSeq: expertSeq })
				.done(function (res) {

					// 로그인이 풀렸으면 JSON 대신 로그인 화면(HTML)이 온다
					if (typeof res !== 'object') {
						alert('로그인이 풀렸어요. 다시 로그인해 주세요.');
						location.href = '${path}/auth/login.do';
						return;
					}

					if (!res.success) {
						alert(res.message);
						btn.disabled = false;
						return;
					}

					$(btn).closest('.wish-item').remove();

					const left = $('#wishCard .wish-item').length;
					$('#wishTotal').text(left + '명');
					$('#wishEmpty').prop('hidden', left > 0);
				})
				.fail(function () {
					alert('찜을 해제하지 못했어요. 잠시 후 다시 시도해 주세요.');
					btn.disabled = false;
				});
		}
	</script>
</body>
</html>
