<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.request-box {
			max-width: 640px;
		}

		.request-box h2 {
			margin-bottom: 8px;
		}

		.request-guide {
			margin: 0 0 24px;
			font-size: 14px;
			text-align: center;
			color: var(--color-text-light);
		}

		.category-row {
			display: flex;
			gap: 12px;
		}

		.category-row select {
			flex: 1;
		}

		.question-list {
			margin-bottom: 18px;
		}

		.question-list:empty {
			display: none;
		}

		.question {
			padding: 16px;
			margin-bottom: 12px;
			border: 1px solid var(--color-border);
			border-radius: var(--radius);
		}

		.question-title {
			margin-bottom: 10px;
			font-weight: 600;
		}

		.question-title .mark {
			margin-left: 4px;
			color: var(--color-danger);
		}

		.question .radio-group {
			flex-wrap: wrap;
			gap: 10px 20px;
		}

		.question textarea {
			width: 100%;
		}

		.required-mark {
			margin-left: 4px;
			color: var(--color-danger);
		}

		.hint {
			margin-top: 6px;
			font-size: 13px;
			color: var(--color-text-light);
		}

		.file-list {
			margin: 8px 0 0;
			padding: 0;
			font-size: 14px;
			list-style: none;
			color: var(--color-text-light);
		}
	</style>
</head>
<body>
	<!-- request/add.jsp: 요청서 작성 (C-01-a 공개 요청, C-01-b 지정 요청: expertSeq가 있으면 지정 요청) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="form-box request-box">
			<h2>요청서 작성</h2>
			<c:if test="${empty expertSeq}">
			<p class="request-guide">등록하면 해당 카테고리 고수들에게 공개되고, 48시간 동안 견적을 받을 수 있어요.</p>
			</c:if>
			<c:if test="${not empty expertSeq}">
			<p class="request-guide"><strong><c:out value="${expertName}" /></strong> 고수에게만 보내는 요청서예요. 48시간 안에 고수가 응답하지 않으면 만료돼요.</p>
			</c:if>

			<form id="requestForm" method="POST" enctype="multipart/form-data"
				action="${path}/request/addok.do?${_csrf.parameterName}=${_csrf.token}">

				<div class="form-group">
					<label>서비스 카테고리<span class="required-mark">*</span></label>

					<%-- 공개 요청: 대분류를 고르면 소분류를 불러온다 --%>
					<c:if test="${empty expertSeq}">
					<div class="category-row">
						<select id="parentSeq">
							<option value="">대분류 선택</option>
							<c:forEach items="${parentList}" var="category">
							<option value="${category.categorySeq}"><c:out value="${category.name}" /></option>
							</c:forEach>
						</select>
						<select id="categorySeq" name="categorySeq" disabled>
							<option value="">소분류 선택</option>
						</select>
					</div>
					</c:if>

					<%-- 지정 요청: 그 고수가 제공하는 서비스 중에서 고른다 --%>
					<c:if test="${not empty expertSeq}">
					<input type="hidden" name="expertSeq" value="${expertSeq}">
					<select id="categorySeq" name="categorySeq">
						<option value="">서비스 선택</option>
						<c:forEach items="${categoryList}" var="category">
						<option value="${category.categorySeq}"><c:out value="${category.name}" /></option>
						</c:forEach>
					</select>
					</c:if>
				</div>

				<div id="questionList" class="question-list"></div>

				<div class="form-group">
					<label for="address">지역<span class="required-mark">*</span></label>
					<input type="text" id="address" name="address" maxlength="100" value="<c:out value='${address}' />" placeholder="예) 서울 강남구">
					<c:choose>
						<c:when test="${empty expertSeq}"><p class="hint">여러 고수가 보는 정보라서 구·동까지만 적어 주세요. 가입 주소의 시·군·구가 기본으로 들어가 있어요.</p></c:when>
						<c:otherwise><p class="hint">구·동까지만 적어 주세요. 자세한 주소는 거래가 정해진 뒤 고수에게 알려 주면 돼요. 가입 주소의 시·군·구가 기본으로 들어가 있어요.</p></c:otherwise>
					</c:choose>
				</div>

				<div class="form-group">
					<label for="wishDate">희망 일정</label>
					<input type="date" id="wishDate" name="wishDate">
				</div>

				<div class="form-group">
					<label for="budget">예산 (원)</label>
					<input type="number" id="budget" name="budget" min="1" step="1" placeholder="예) 100000">
				</div>

				<div class="form-group">
					<label for="files">참고 이미지</label>
					<input type="file" id="files" name="files" multiple accept=".jpg,.jpeg,.png,.gif">
					<p class="hint">원하는 스타일의 이미지가 있으면 첨부해 주세요. (jpg, png, gif)</p>
					<ul id="fileList" class="file-list"></ul>
				</div>

				<button class="btn btn-primary btn-block">요청서 등록</button>
			</form>
		</div>
	</main>

	<script>

		//희망 일정은 오늘부터 고를 수 있다
		(function () {
			const now = new Date();
			const today = new Date(now.getTime() - now.getTimezoneOffset() * 60000).toISOString().substring(0, 10);
			$('#wishDate').attr('min', today);
		})();

		//대분류를 고르면 소분류를 불러온다
		$('#parentSeq').change(function () {

			const $child = $('#categorySeq');

			$child.empty().append($('<option>').val('').text('소분류 선택')).prop('disabled', true);
			$('#questionList').empty();

			if (!$(this).val()) {
				return;
			}

			$.ajax({
				type: 'GET',
				url: path + '/request/category.do',
				data: { parentSeq: $(this).val() },
				dataType: 'json',
				success: function (list) {
					$(list).each(function (index, item) {
						$child.append($('<option>').val(item.categorySeq).text(item.name));
					});
					$child.prop('disabled', list.length == 0);
				},
				error: function () {
					alert('카테고리를 불러오지 못했습니다.');
				}
			});
		});

		//소분류를 고르면 그 카테고리의 질문을 불러온다
		$('#categorySeq').change(function () {

			const $list = $('#questionList').empty();

			if (!$(this).val()) {
				return;
			}

			$.ajax({
				type: 'GET',
				url: path + '/request/question.do',
				data: { categorySeq: $(this).val() },
				dataType: 'json',
				success: function (list) {
					$(list).each(function (index, question) {
						$list.append(makeQuestion(question));
					});
				},
				error: function () {
					alert('질문을 불러오지 못했습니다.');
				}
			});
		});

		//질문 하나를 화면에 그린다 (객관식 하나: 라디오, 여러 개: 체크박스, 주관식: 글상자)
		function makeQuestion(question) {

			const name = 'q' + question.questionSeq;
			const $box = $('<div>').addClass('question')
						.attr('data-name', name)
						.attr('data-type', question.questionType)
						.attr('data-required', question.required);

			const $title = $('<div>').addClass('question-title').text(question.content);

			if (question.required == 'Y') {
				$title.append($('<span>').addClass('mark').text('*'));
			}

			$box.append($title);

			if (question.questionType == 'TEXT') {
				$box.append($('<textarea>').attr('name', name).attr('maxlength', 300));
				return $box;
			}

			const $group = $('<div>').addClass('radio-group');
			const inputType = question.questionType == 'MULTI' ? 'checkbox' : 'radio';

			$(question.options).each(function (index, option) {
				const $input = $('<input>').attr('type', inputType).attr('name', name).val(option.optionSeq);
				$group.append($('<label>').append($input).append(document.createTextNode(option.content)));
			});

			$box.append($group);

			return $box;
		}

		//고른 파일 이름 보여 주기
		$('#files').change(function () {

			const $list = $('#fileList').empty();

			$(this.files).each(function (index, file) {
				$list.append($('<li>').text(file.name));
			});
		});

		//등록 전에 필수 항목 확인
		$('#requestForm').submit(function () {

			if (!$('#categorySeq').val()) {
				alert('서비스 카테고리를 선택해 주세요.');
				return false;
			}

			let ok = true;

			$('#questionList .question').each(function () {

				if ($(this).data('required') != 'Y') {
					return;
				}

				const name = $(this).data('name');
				const answered = $(this).data('type') == 'TEXT'
								? $(this).find('textarea').val().trim() != ''
								: $(this).find('input[name="' + name + '"]:checked').length > 0;

				if (!answered) {
					alert('필수 질문에 답해 주세요.\n- ' + $(this).find('.question-title').contents().first().text());
					ok = false;
					return false;
				}
			});

			if (!ok) {
				return false;
			}

			if ($('#address').val().trim() == '') {
				alert('지역을 입력해 주세요.');
				$('#address').focus();
				return false;
			}

			for (const file of $('#files')[0].files) {
				if (!/\.(jpe?g|png|gif)$/i.test(file.name)) {
					alert('참고 이미지는 jpg, png, gif 파일만 첨부할 수 있습니다.');
					return false;
				}
			}

			//등록 버튼을 두 번 눌러 요청서가 두 개 생기지 않게, 보내는 중에는 버튼을 막는다
			if ($(this).data('sending')) {
				return false;
			}

			$(this).data('sending', true);
			$(this).find('button').prop('disabled', true).text('등록하는 중...');
		});

		//뒤로 가기로 이 화면에 돌아오면 버튼을 다시 쓸 수 있게 한다
		$(window).on('pageshow', function () {
			$('#requestForm').data('sending', false).find('button').prop('disabled', false).text('요청서 등록');
		});

	</script>
</body>
</html>
