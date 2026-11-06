<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<%--
		expert/talent/form.jsp: 서비스 등록(add.jsp), 수정(edit.jsp)이 같이 쓰는 입력칸

		쓰는 법 — form 태그 안에서 이 줄을 넣는다
		  <%@ include file="/WEB-INF/views/expert/talent/form.jsp" %>

		받는 값
		  topCategoryList : 대분류 목록
		  portfolioList   : 고를 수 있는 내 포트폴리오
		  tdto, plist     : 수정 화면에서만 온다. 등록 화면에서는 비어 있어서 입력칸도 비어 있다
	--%>

	<style>
		.category-row {
			display: grid;
			grid-template-columns: 1fr 1fr;
			gap: 16px;
		}

		.price-input {
			max-width: 300px;
		}

		.picker-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 6px;
			font-weight: 600;
		}

		.picker-head small {
			font-weight: 400;
			color: var(--color-text-light);
		}

		#pickerCount {
			color: var(--color-primary);
		}

		/* 포트폴리오 카드 가로 4칸 */
		.picker {
			display: grid;
			grid-template-columns: repeat(4, 1fr);
			gap: 12px;
		}

		/* common.css 의 button 은 높이 40px 이라 카드 모양으로 다시 잡는다 */
		.picker-item {
			position: relative;
			display: block;
			height: auto;
			padding: 0;
			overflow: hidden;
			text-align: left;
			font-weight: 400;
			border-radius: var(--radius);
		}

		.picker-item.selected {
			border: 2px solid var(--color-primary);
		}

		.picker-item:disabled {
			opacity: 0.5;
			cursor: not-allowed;
		}

		/* 고른 순서 번호. 고르지 않은 카드는 글자가 비어 있어서 숨긴다 */
		.picker-no {
			position: absolute;
			top: 6px;
			right: 6px;
			width: 24px;
			height: 24px;
			line-height: 24px;
			text-align: center;
			font-size: 13px;
			font-weight: 700;
			color: #ffffff;
			background-color: var(--color-primary);
			border-radius: 50%;
		}

		.picker-no:empty {
			display: none;
		}

		.picker-thumb {
			display: block;
			height: 90px;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		/* 사진이 있으면 칸을 꽉 채우고, 파일이 없으면(onerror) img를 지워서 배경색만 남긴다 */
		.picker-thumb img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		.picker-info {
			display: block;
			padding: 10px 12px;
		}

		.picker-info strong {
			display: block;
			overflow: hidden;
			white-space: nowrap;
			text-overflow: ellipsis;
		}

		.picker-new {
			display: flex;
			align-items: center;
			justify-content: center;
			min-height: 120px;
			font-size: 14px;
			color: var(--color-text-light);
			border: 1px dashed var(--color-border);
			border-radius: var(--radius);
		}

		.form-hint {
			margin-top: 6px;
			font-size: 13px;
			color: var(--color-text-light);
		}
	</style>

	<div class="category-row">
		<div class="form-group">
			<%-- 대분류는 소분류를 고르는 데만 쓰고 서버로 보내지 않아서 name 이 없다 --%>
			<label for="parentSeq">카테고리 (대분류)</label>
			<select id="parentSeq" required>
				<option value="">대분류 선택</option>
				<c:forEach items="${topCategoryList}" var="category">
					<option value="${category.categorySeq}" ${category.categorySeq == tdto.parentCategorySeq ? 'selected' : ''}><c:out value="${category.name}" /></option>
				</c:forEach>
			</select>
		</div>

		<div class="form-group">
			<label for="categorySeq">소분류</label>
			<select id="categorySeq" name="categorySeq" required disabled>
				<option value="">소분류 선택</option>
			</select>
		</div>
	</div>

	<div class="form-group">
		<label for="title">제목</label>
		<%-- 제목에 큰따옴표가 있어도 value 속성이 끊기지 않게 c:out 으로 이스케이프한다 --%>
		<input type="text" id="title" name="title" maxlength="100" placeholder="예: 기초 피아노 1:1 과외" value="<c:out value='${tdto.title}' />" required>
	</div>

	<div class="form-group">
		<label for="content">소개</label>
		<%-- textarea 는 태그 사이의 공백, 줄바꿈도 값이 되니까 붙여 쓴다 --%>
		<textarea id="content" name="content" rows="6" maxlength="4000" required><c:out value="${tdto.content}" /></textarea>
	</div>

	<div class="form-group price-input">
		<label for="price">가격 (원)</label>
		<%-- DTO 의 price 가 int 라서 int 범위를 넘지 못하게 한다 --%>
		<input type="number" id="price" name="price" min="0" max="2147483647" step="1" value="${tdto.price}" required>
	</div>

	<div class="form-group">
		<div class="picker-head">
			<span>포트폴리오 연결 <small>(내 포트폴리오에서 최대 3개 선택)</small></span>
			<span id="pickerCount"></span>
		</div>

		<div class="picker">
			<c:forEach items="${portfolioList}" var="portfolio">
				<%-- type="button" 이 없으면 눌렀을 때 폼이 제출된다 --%>
				<button type="button" class="picker-item" data-seq="${portfolio.portfolioSeq}">
					<span class="picker-no"></span>
					<span class="picker-thumb">
						<c:if test="${not empty portfolio.thumbnail}">
							<img src="${path}/resources/upload/portfolio/<c:out value='${portfolio.thumbnail}' />" alt="" onerror="this.remove()">
						</c:if>
					</span>
					<span class="picker-info">
						<strong><c:out value="${portfolio.title}" /></strong>
						<span class="message-info">사진 ${portfolio.imageCount}장</span>
					</span>
				</button>
			</c:forEach>

			<a class="picker-new" href="${path}/expert/portfolio/add.do">+ 새 포트폴리오 작성</a>
		</div>

		<div class="form-hint">고른 순서(1~3)대로 서비스 상세에 표시됩니다. 3개를 고르면 나머지는 선택할 수 없습니다.</div>

		<%-- 제출할 때 고른 순서대로 hidden input 을 만들어 넣는 자리 --%>
		<div id="portfolioInputs"></div>
	</div>

	<script>
		const MAX_PORTFOLIOS = 3;

		//고른 포트폴리오 번호. 체크박스는 화면 순서로 전송돼서 고른 순서를 지키려고 배열에 직접 쌓는다
		//수정 화면에서는 이미 연결한 포트폴리오가 slot 순서대로 들어 있다
		const selected = [<c:forEach items="${plist}" var="portfolio" varStatus="status">'${portfolio.portfolioSeq}'<c:if test="${not status.last}">,</c:if></c:forEach>];

		//selected 배열을 보고 카드의 선택 표시, 순서 번호, 비활성화를 다시 그린다
		function renderPicker() {

			$('.picker-item').each(function () {

				const index = selected.indexOf(String($(this).data('seq')));

				$(this).toggleClass('selected', index >= 0);
				$(this).find('.picker-no').text(index >= 0 ? index + 1 : '');

				//3개를 고르면 고르지 않은 카드만 막는다. 고른 카드는 눌러서 뺄 수 있어야 한다
				$(this).prop('disabled', index < 0 && selected.length >= MAX_PORTFOLIOS);
			});

			$('#pickerCount').text(selected.length + ' / ' + MAX_PORTFOLIOS + ' 선택');
		}

		//소분류 목록 불러오기. ③이 만든 /request/category.do 를 그대로 쓴다
		function loadChildCategory(parentSeq, categorySeq) {

			const $child = $('#categorySeq');

			$child.empty().append($('<option>').val('').text('소분류 선택')).prop('disabled', true);

			if (!parentSeq) {
				return;
			}

			$.ajax({
				type: 'GET',
				url: path + '/request/category.do',
				data: { parentSeq: parentSeq },
				dataType: 'json',
				success: function (list) {

					$(list).each(function (index, item) {
						$child.append($('<option>').val(item.categorySeq).text(item.name));
					});

					$child.prop('disabled', list.length == 0);

					//수정 화면: 옵션을 다 넣은 뒤에 지금 소분류를 골라 둔다
					if (categorySeq) {
						$child.val(categorySeq);
					}
				},
				error: function () {
					alert('카테고리를 불러오지 못했습니다.');
				}
			});
		}

		$('#parentSeq').change(function () {
			loadChildCategory($(this).val());
		});

		//카드를 누르면 고르거나 뺀다. 빼면 뒤의 번호가 한 칸씩 당겨진다
		$('.picker-item').click(function () {

			const seq = String($(this).data('seq'));
			const index = selected.indexOf(seq);

			if (index >= 0) {
				selected.splice(index, 1);
			} else if (selected.length < MAX_PORTFOLIOS) {
				selected.push(seq);
			}

			renderPicker();
		});

		//제출 직전에 고른 순서대로 hidden input 을 만든다. 서버는 이 순서를 slot 1 ~ 3 으로 저장한다
		$('#talentForm').submit(function () {

			const $inputs = $('#portfolioInputs').empty();

			$.each(selected, function (index, seq) {
				$inputs.append($('<input>').attr({ type: 'hidden', name: 'portfolioSeqs', value: seq }));
			});
		});

		renderPicker();

		//수정 화면: 대분류가 골라져 있으면 소분류 목록을 불러와 지금 소분류까지 골라 둔다
		loadChildCategory($('#parentSeq').val(), '${tdto.categorySeq}');
	</script>
