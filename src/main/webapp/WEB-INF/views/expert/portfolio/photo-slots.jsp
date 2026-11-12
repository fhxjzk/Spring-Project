<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<%--
		portfolio/photo-slots.jsp: 포트폴리오 사진 칸 5개 (화면설계서 ②-08). 작성(add.jsp) · 수정(edit.jsp)이 같이 쓴다

		쓰는 법 — id 가 portfolioForm 인 form 안에서 한 줄 넣는다 (부모 JSP 에 c 태그 선언 필요)
			<%@ include file="/WEB-INF/views/expert/portfolio/photo-slots.jsp" %>
		부모 JSP 에 있어야 하는 값
			imgList : 지금 등록된 사진 (PortfolioImageDto 목록, slot 순서). 작성 화면에는 없다

		- [+ 사진 추가] 칸을 누르면 사진을 고른다 (여러 장 한 번에 골라도 된다). 사진마다 [× 삭제]가 있다
		- 5장을 채우면 [+ 사진 추가] 칸이 사라진다. 첫 번째 사진이 대표 사진이다
		- 파일 선택창 하나로는 "한 장만 빼기"가 안 돼서, 고른 사진을 JS 배열에 모아 두었다가 보낼 때 images 칸에 한 번에 넣는다
		- 수정에서 남긴 기존 사진은 keepImageSeqs 로 보낸다. 서버는 남긴 사진 → 새 사진 순서로 1번부터 다시 매긴다
		  (PortfolioService.edit). 사진은 1 ~ 5장이고, 서버에서도 장 수와 확장자를 한 번 더 확인한다
	--%>
	<style>
		/* 필수 입력 표시 (제목, 내용) */
		.required-mark {
			color: var(--color-danger);
		}

		.photo-head {
			display: flex;
			justify-content: space-between;
			align-items: baseline;
		}

		.photo-head small {
			font-weight: normal;
			color: var(--color-text-light);
		}

		.photo-count {
			font-size: 14px;
			font-weight: 700;
			color: var(--color-primary);
		}

		/* 사진 칸 5개 한 줄. 사진 · [+ 사진 추가] · 빈 칸 */
		.photo-slots {
			display: grid;
			grid-template-columns: repeat(5, minmax(0, 1fr));
			gap: 10px;
			margin-top: 8px;
		}

		.photo-slot {
			position: relative;
			display: flex;
			flex-direction: column;
			height: 140px;
			border: 1px solid var(--color-border);
			border-radius: 8px;
			overflow: hidden;
			background-color: var(--color-bg);
		}

		.photo-slot .photo-img {
			flex: 1;
			min-height: 0;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		.photo-slot img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		.photo-badge {
			position: absolute;
			top: 6px;
			left: 6px;
			padding: 2px 8px;
			border-radius: 999px;
			font-size: 12px;
			font-weight: 700;
			color: var(--color-primary);
			background-color: var(--color-bg);
		}

		.photo-del {
			padding: 6px 0;
			border: none;
			border-top: 1px solid var(--color-border);
			background: none;
			font-size: 13px;
			color: var(--color-text-light);
			cursor: pointer;
		}

		.photo-del:hover {
			color: var(--color-danger);
		}

		.photo-add,
		.photo-empty {
			align-items: center;
			justify-content: center;
			border-style: dashed;
		}

		.photo-add {
			font-size: 15px;
			font-weight: 700;
			color: var(--color-text-light);
			cursor: pointer;
		}

		.photo-add:hover {
			border-color: var(--color-primary);
			color: var(--color-primary);
		}

		.photo-empty {
			background-color: var(--color-bg-light);
		}
	</style>

	<div class="form-group">
		<div class="photo-head">
			<label>사진 <span class="required-mark">*</span> <small>(1 ~ 5장 · jpg, png)</small></label>
			<span class="photo-count" id="photoCount">0 / 5</span>
		</div>

		<div class="photo-slots" id="photoSlots"></div>
		<div class="form-hint">첫 번째 사진이 대표 사진(목록 썸네일)이 됩니다.</div>

		<%-- [+ 사진 추가]가 여는 선택창. 고른 파일은 JS 배열로 옮기고 비운다 (이 칸은 보내지 않는다) --%>
		<input type="file" id="photoPicker" accept="image/png,image/jpeg" multiple hidden>
		<%-- 실제로 서버에 보내는 칸. 등록할 때 JS 가 고른 사진을 채운다 --%>
		<input type="file" id="photoFiles" name="images" multiple hidden>
		<div id="photoKeep"></div>

		<%-- 지금 등록된 사진 (수정 화면). 파일 이름에 따옴표가 있어도 깨지지 않게 속성으로 넘기고 JS 에서 읽는다 --%>
		<c:forEach items="${imgList}" var="img">
			<span class="photo-init" hidden data-seq="${img.imageSeq}"
				data-src="${path}/resources/upload/portfolio/<c:out value='${img.fileName}' />"></span>
		</c:forEach>
	</div>

	<script>
		(function () {
			const MAX_PHOTOS = 5;

			// 칸에 들어갈 사진 목록. 기존 사진 { seq, src }, 새 사진 { file, src }
			const photos = $('.photo-init').map(function () {
				return { seq: $(this).data('seq'), src: $(this).attr('data-src') };
			}).get();

			const $slots = $('#photoSlots');

			function render() {

				$slots.empty();

				photos.forEach(function (photo, index) {

					const $slot = $('<div class="photo-slot">');
					const $img = $('<div class="photo-img">').append($('<img alt="">').attr('src', photo.src).on('error', function () { $(this).remove(); }));

					$slot.append($img);

					if (index === 0) {
						$slot.append('<span class="photo-badge">대표</span>');
					}

					$slot.append($('<button type="button" class="photo-del">× 삭제</button>').on('click', function () {
						photos.splice(index, 1);
						render();
					}));

					$slots.append($slot);
				});

				// 5장보다 적으면 [+ 사진 추가] 칸 하나, 나머지는 빈 칸
				if (photos.length < MAX_PHOTOS) {
					$slots.append($('<div class="photo-slot photo-add">+ 사진 추가</div>').on('click', function () {
						$('#photoPicker').click();
					}));
				}

				for (let i = photos.length + 1; i < MAX_PHOTOS; i++) {
					$slots.append('<div class="photo-slot photo-empty"></div>');
				}

				$('#photoCount').text(photos.length + ' / ' + MAX_PHOTOS);
			}

			// 사진 고르기: jpg, png 만, 5장까지만 담는다 (PortfolioService.IMAGE_EXT, MAX_IMAGES 와 같은 기준)
			$('#photoPicker').on('change', function () {

				const files = Array.from(this.files);
				$(this).val('');

				if (files.some(function (file) { return !/\.(jpe?g|png)$/i.test(file.name); })) {
					alert('사진은 jpg, png 파일만 올릴 수 있어요.');
					return;
				}

				if (photos.length + files.length > MAX_PHOTOS) {
					alert('사진은 최대 ' + MAX_PHOTOS + '장까지 올릴 수 있어요. 지금 ' + (MAX_PHOTOS - photos.length) + '장 더 올릴 수 있어요.');
					return;
				}

				files.forEach(function (file) {
					photos.push({ file: file, src: URL.createObjectURL(file) });
				});

				render();
			});

			// 보내기 직전: 새 사진은 images 칸에, 남긴 기존 사진 번호는 keepImageSeqs 로 넣는다
			// 사진은 1장 이상 필수다 (서버에서도 한 번 더 막는다)
			$('#portfolioForm').on('submit', function () {

				if (photos.length === 0) {
					alert('사진을 1장 이상 올려 주세요.');
					return false;
				}

				const dt = new DataTransfer();
				const $keep = $('#photoKeep').empty();

				photos.forEach(function (photo) {
					if (photo.file) {
						dt.items.add(photo.file);
					} else {
						$keep.append($('<input type="hidden" name="keepImageSeqs">').val(photo.seq));
					}
				});

				document.getElementById('photoFiles').files = dt.files;

				return true;
			});

			render();
		})();
	</script>
