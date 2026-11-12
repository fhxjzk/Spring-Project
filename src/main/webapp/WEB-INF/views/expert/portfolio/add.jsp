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

		/* 고른 사진 미리보기: 5칸, 첫 번째가 대표 사진 */
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
	<!-- add.jsp: 포트폴리오 작성 (화면설계서 ②-08) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="portfolio-form">
			<h2>포트폴리오 작성</h2>

			<%-- 파일 업로드 form 은 CSRF 토큰을 action 뒤에 붙인다 (CONVENTION.md)
			     작성자 번호는 폼에 넣지 않는다 (컨트롤러에서 로그인 정보로 꺼낸다) --%>
			<form class="card" id="portfolioForm" method="POST" enctype="multipart/form-data"
				action="${path}/expert/portfolio/addok.do?${_csrf.parameterName}=${_csrf.token}">

				<div class="form-group">
					<label for="title">제목</label>
					<input type="text" id="title" name="title" maxlength="100" required>
				</div>

				<div class="form-group">
					<label for="content">내용</label>
					<textarea id="content" name="content" rows="10" maxlength="4000" required></textarea>
				</div>

				<div class="form-group">
					<label for="images">사진</label>
					<input type="file" id="images" name="images" accept="image/png,image/jpeg" multiple>
					<div class="form-hint">jpg, png 파일을 최대 5장까지 올릴 수 있어요. 첫 번째 사진이 대표 사진이 됩니다.</div>
					<div class="preview" id="preview"></div>
				</div>

				<div class="form-buttons">
					<a class="btn" href="${path}/expert/view.do?expertSeq=${expertSeq}">취소</a>
					<button class="btn btn-primary">등록하기</button>
				</div>
			</form>
		</div>
	</main>

	<script>
		const MAX_IMAGES = 5;

		//사진을 고르면 5장이 넘는지 확인하고, 미리보기를 그린다 (서버에서도 한 번 더 막는다)
		$('#images').on('change', function () {

			$('#preview').empty();

			if (this.files.length > MAX_IMAGES) {
				alert('사진은 최대 ' + MAX_IMAGES + '장까지 올릴 수 있어요.');
				$(this).val('');
				return;
			}

			//jpg, png 만 받는다 (PortfolioService.IMAGE_EXT 와 같은 기준)
			if (Array.from(this.files).some(function (file) { return !/\.(jpe?g|png)$/i.test(file.name); })) {
				alert('사진은 jpg, png 파일만 올릴 수 있어요.');
				$(this).val('');
				return;
			}

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
