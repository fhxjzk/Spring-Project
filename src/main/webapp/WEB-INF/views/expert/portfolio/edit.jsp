<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.portfolio-form {
			max-width: 720px;
			margin: 0 auto;
		}

		.form-hint {
			margin-top: 4px;
			font-size: 13px;
			color: var(--color-text-light);
		}

		/* 사진 미리보기: 5칸, 첫 번째가 대표 사진 */
		.preview {
			display: grid;
			grid-template-columns: repeat(5, 1fr);
			gap: 8px;
			margin-top: 10px;
		}

		.preview-item {
			position: relative;
			height: 100px;
			border-radius: 6px;
			overflow: hidden;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		.preview-item img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		.preview-item span {
			position: absolute;
			top: 4px;
			left: 4px;
			padding: 1px 6px;
			border-radius: 4px;
			font-size: 12px;
			color: #fff;
			background-color: var(--color-primary);
		}

		.form-buttons {
			text-align: right;
		}
	</style>
</head>
<body>
	<!-- edit.jsp: 포트폴리오 수정 (화면설계서 ②-08) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="portfolio-form">
			<h2>포트폴리오 수정</h2>

			<%-- 파일 업로드 form 은 CSRF 토큰을 action 뒤에 붙인다 (CONVENTION.md) --%>
			<form class="card" id="portfolioForm" method="POST" enctype="multipart/form-data"
				action="${path}/expert/portfolio/editok.do?${_csrf.parameterName}=${_csrf.token}">

				<%-- 어떤 글을 고치는지. 바꿔서 보낼 수 있으니 컨트롤러에서 내 글인지 다시 확인한다 --%>
				<input type="hidden" name="portfolioSeq" value="${pdto.portfolioSeq}">

				<div class="form-group">
					<label for="title">제목</label>
					<%-- 제목에 큰따옴표가 있으면 value 속성이 거기서 끊겨 제목칸이 비거나 잘린다. c:out 으로 이스케이프한다 --%>
					<input type="text" id="title" name="title" maxlength="100" value="<c:out value='${pdto.title}' />" required>
				</div>

				<div class="form-group">
					<label for="content">내용</label>
					<%-- textarea 는 value 속성이 없어서 태그 사이에 넣는다 (사이에 공백, 줄바꿈이 있으면 그대로 들어간다) --%>
					<%-- 내용에 </textarea> 가 있으면 입력칸이 거기서 닫혀 폼이 깨진다. c:out 으로 이스케이프한다 --%>
					<textarea id="content" name="content" rows="10" maxlength="4000" required><c:out value="${pdto.content}" /></textarea>
				</div>

				<div class="form-group">
					<label for="images">사진</label>
					<input type="file" id="images" name="images" accept="image/png,image/jpeg" multiple>
					<div class="form-hint">
						새 사진을 고르지 않으면 지금 사진이 그대로 남아요.
						새로 고르면 지금 사진은 전부 지워지고 고른 사진으로 바뀝니다. (jpg, png 최대 5장, 첫 번째가 대표 사진)
					</div>

					<%-- 처음에는 지금 등록된 사진을 보여 주고, 새로 고르면 고른 사진으로 바꿔 그린다 --%>
					<div class="preview" id="preview">
						<c:forEach items="${imgList}" var="img" varStatus="status">
							<div class="preview-item">
								<%-- 원본 파일 이름에 큰따옴표가 있으면 alt 속성이 끊기므로 c:out 으로 이스케이프한다 --%>
								<img src="${path}/resources/upload/portfolio/${img.fileName}" alt="<c:out value='${img.originName}' />" onerror="this.remove()">
								<c:if test="${status.first}"><span>대표</span></c:if>
							</div>
						</c:forEach>
					</div>
				</div>

				<div class="form-buttons">
					<a class="btn" href="${path}/expert/portfolio/view.do?portfolioSeq=${pdto.portfolioSeq}">취소</a>
					<button class="btn btn-primary">수정하기</button>
				</div>
			</form>
		</div>
	</main>

	<script>
		const MAX_IMAGES = 5;

		//처음 화면의 미리보기(지금 사진)를 기억해 둔다. 고른 걸 취소하면 다시 보여 준다
		const originalPreview = $('#preview').html();

		$('#images').on('change', function () {

			if (this.files.length > MAX_IMAGES) {
				alert('사진은 최대 ' + MAX_IMAGES + '장까지 올릴 수 있어요.');
				$(this).val('');
			}

			//jpg, png 만 받는다 (PortfolioService.IMAGE_EXT 와 같은 기준). 지우면 아래에서 지금 사진 미리보기로 돌아간다
			if (Array.from(this.files).some(function (file) { return !/\.(jpe?g|png)$/i.test(file.name); })) {
				alert('사진은 jpg, png 파일만 올릴 수 있어요.');
				$(this).val('');
			}

			if (this.files.length === 0) {
				$('#preview').html(originalPreview);
				return;
			}

			$('#preview').empty();

			$.each(this.files, function (index, file) {

				const item = $('<div class="preview-item">');

				item.append($('<img>').attr('src', URL.createObjectURL(file)));

				if (index === 0) {
					item.append('<span>대표</span>');
				}

				$('#preview').append(item);
			});
		});
	</script>
</body>
</html>
