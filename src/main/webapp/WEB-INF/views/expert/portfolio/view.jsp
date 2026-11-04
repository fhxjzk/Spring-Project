<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		/* 글 폭을 좁혀서 읽기 편하게 */
		.portfolio {
			max-width: 820px;
			margin: 0 auto;
		}

		.portfolio-back {
			display: inline-block;
			margin-bottom: 12px;
			font-size: 14px;
		}

		.portfolio-head h2 {
			margin: 0 0 6px;
		}

		/* 큰 사진 1장 + 아래 작은 사진 줄 */
		.photo-main {
			height: 420px;
			border-radius: 8px;
			overflow: hidden;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		/* 사진이 있으면 칸을 꽉 채우고, 파일이 없으면(onerror) img를 지워서 배경색만 남긴다 */
		.photo-main img,
		.photo-thumbs img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		.photo-thumbs {
			display: grid;
			grid-template-columns: repeat(5, 1fr);
			gap: 8px;
			margin-top: 8px;
		}

		.photo-thumbs button {
			height: 80px;
			padding: 0;
			border: 2px solid transparent;
			border-radius: 6px;
			overflow: hidden;
			cursor: pointer;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		.photo-thumbs button.active {
			border-color: var(--color-primary);
		}

		/* 줄바꿈을 입력한 그대로 보여 준다 */
		.portfolio-content {
			margin: 0;
			white-space: pre-wrap;
			line-height: 1.7;
		}

		.portfolio-buttons {
			margin-top: 16px;
			text-align: right;
		}

		/* form 은 줄을 바꾸니까 수정하기 버튼 옆에 나란히 놓는다 */
		.portfolio-del {
			display: inline-block;
		}

		.small {
			font-size: 14px;
		}
	</style>
</head>
<body>
	<!-- view.jsp: 포트폴리오 상세 (화면설계서 ②-09) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="portfolio">

			<a class="portfolio-back" href="${path}/expert/view.do?expertSeq=${pdto.expertSeq}">← ${pdto.name} 고수 프로필로</a>

			<section class="card portfolio-head">
				<%-- 제목에 넣은 태그나 스크립트가 실행되지 않도록(XSS) c:out 으로 이스케이프한다 --%>
				<h2><c:out value="${pdto.title}" /></h2>
				<span class="message-info small">
					${pdto.name} · <fmt:formatDate value="${pdto.regdate}" pattern="yyyy.MM.dd" />
				</span>
			</section>

			<section class="card">
				<c:choose>
					<c:when test="${empty imgList}">
						<p class="message-info small">등록된 사진이 없어요</p>
					</c:when>
					<c:otherwise>
						<%-- 처음에는 slot 1 (대표 사진)을 크게 보여 준다 --%>
						<div class="photo-main">
							<%-- 원본 파일 이름에 큰따옴표가 있으면 alt 속성이 끊기므로 c:out 으로 이스케이프한다 --%>
							<img id="photoMain" src="${path}/resources/upload/portfolio/${imgList[0].fileName}" alt="<c:out value='${imgList[0].originName}' />" onerror="this.remove()">
						</div>

						<%-- 사진이 2장 이상일 때만 아래 줄을 만든다. 누르면 위 큰 사진이 바뀐다 --%>
						<c:if test="${imgList.size() > 1}">
							<div class="photo-thumbs">
								<c:forEach items="${imgList}" var="img" varStatus="status">
									<button type="button" class="${status.first ? 'active' : ''}"
										data-src="${path}/resources/upload/portfolio/${img.fileName}">
										<%-- 원본 파일 이름에 큰따옴표가 있으면 alt 속성이 끊기므로 c:out 으로 이스케이프한다 --%>
										<img src="${path}/resources/upload/portfolio/${img.fileName}" alt="<c:out value='${img.originName}' />" onerror="this.remove()">
									</button>
								</c:forEach>
							</div>
						</c:if>
					</c:otherwise>
				</c:choose>
			</section>

			<section class="card">
				<%-- 내용에 넣은 태그나 스크립트가 실행되지 않도록(XSS) c:out 으로 이스케이프한다 --%>
				<p class="portfolio-content"><c:out value="${pdto.content}" /></p>
			</section>

			<%-- isOwner: 컨트롤러에서 본인 확인 결과를 넘겨야 보인다 --%>
			<c:if test="${isOwner}">
				<div class="portfolio-buttons">
					<a class="btn" href="${path}/expert/portfolio/edit.do?portfolioSeq=${pdto.portfolioSeq}">수정하기</a>
					<%-- 지우는 동작이라 링크(GET)가 아니라 POST form 으로 보낸다 --%>
					<form class="portfolio-del" method="POST" action="${path}/expert/portfolio/delok.do"
						onsubmit="return confirm('이 포트폴리오를 삭제할까요? 사진도 함께 지워지고, 되돌릴 수 없어요.');">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						<input type="hidden" name="portfolioSeq" value="${pdto.portfolioSeq}">
						<button class="btn btn-danger">삭제하기</button>
					</form>
				</div>
			</c:if>

		</div>
	</main>

	<script>
		//작은 사진을 누르면 큰 사진을 바꾸고, 누른 칸에 테두리 표시
		$('.photo-thumbs button').on('click', function () {

			$('#photoMain').attr('src', $(this).data('src'));

			$('.photo-thumbs button').removeClass('active');
			$(this).addClass('active');
		});
	</script>
</body>
</html>
