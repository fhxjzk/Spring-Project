<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		.question-form {
			max-width: 720px;
		}
		.question-form textarea {
			width: 100%;
			min-height: 80px;
		}
		.question-form .inline {
			display: flex;
			gap: 24px;
		}
		.question-form .inline .form-group {
			flex: 1;
		}
		.option-row {
			display: flex;
			gap: 8px;
			align-items: center;
			margin-bottom: 8px;
		}
		.option-row input[type=text] {
			flex: 1;
		}
		.option-row select {
			width: 120px;
		}
		.option-row .used {
			font-size: 12px;
			color: var(--color-text-light);
			white-space: nowrap;
		}
		.sub {
			font-size: 13px;
			color: var(--color-text-light);
		}
		.buttons {
			display: flex;
			gap: 8px;
			margin-top: 20px;
		}
	</style>
</head>
<body>
	<!-- admin/question/form.jsp: 요청서 질문 등록·수정 (③ E-04). dto 가 있으면 수정 -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<c:set var="editMode" value="${not empty dto}" />
	<c:set var="typeLocked" value="${editMode and dto.answerCount gt 0}" />
	<c:set var="type" value="${editMode ? dto.questionType : 'SINGLE'}" />

	<div class="admin-layout">
		<%@ include file="/WEB-INF/views/inc/admin-menu.jsp" %>

		<main class="admin-content">
			<h2>질문 ${editMode ? '수정' : '등록'} <small>Question</small></h2>

			<p class="sub">
				카테고리:
				<c:choose>
					<c:when test="${editMode}"><c:out value="${dto.categoryName}" /></c:when>
					<c:otherwise><c:out value="${category.parentName} > ${category.name}" /></c:otherwise>
				</c:choose>
				<c:if test="${editMode}"> · 이 질문에 답한 요청서 ${dto.answerCount}건</c:if>
			</p>

			<c:if test="${not empty msg}">
			<p class="message-info"><c:out value="${msg}" /></p>
			</c:if>

			<form id="questionForm" class="card question-form" method="POST"
					action="${path}/admin/question/${editMode ? 'editok' : 'addok'}.do">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<c:choose>
					<c:when test="${editMode}"><input type="hidden" name="questionSeq" value="${dto.questionSeq}"></c:when>
					<c:otherwise><input type="hidden" name="categorySeq" value="${category.categorySeq}"></c:otherwise>
				</c:choose>

				<div class="form-group">
					<label for="content">질문 내용</label>
					<textarea id="content" name="content" maxlength="160" required placeholder="예) 레슨 경험이 있나요?"><c:out value="${dto.content}" /></textarea>
				</div>

				<div class="form-group">
					<label>유형</label>
					<div class="radio-group">
						<label><input type="radio" name="questionType" value="SINGLE" ${type eq 'SINGLE' ? 'checked' : ''} ${typeLocked ? 'disabled' : ''}> 객관식 (하나 고르기)</label>
						<label><input type="radio" name="questionType" value="MULTI" ${type eq 'MULTI' ? 'checked' : ''} ${typeLocked ? 'disabled' : ''}> 객관식 (여러 개 고르기)</label>
						<label><input type="radio" name="questionType" value="TEXT" ${type eq 'TEXT' ? 'checked' : ''} ${typeLocked ? 'disabled' : ''}> 주관식</label>
					</div>
					<c:if test="${typeLocked}">
					<%-- disabled 는 전송되지 않으므로 지금 유형을 따로 보낸다 --%>
					<input type="hidden" name="questionType" value="${dto.questionType}">
					<p class="sub">이미 답변이 달린 질문이라 유형을 바꿀 수 없습니다.</p>
					</c:if>
				</div>

				<div class="inline">
					<div class="form-group">
						<label for="required">필수 여부</label>
						<select id="required" name="required">
							<option value="Y" ${dto.required ne 'N' ? 'selected' : ''}>필수</option>
							<option value="N" ${dto.required eq 'N' ? 'selected' : ''}>선택</option>
						</select>
					</div>
					<div class="form-group">
						<label for="sortOrder">순서 (작을수록 먼저)</label>
						<input type="number" id="sortOrder" name="sortOrder" min="0" max="999" step="1" required value="${editMode ? dto.sortOrder : 1}">
					</div>
				</div>

				<%-- 객관식 보기. 주관식을 고르면 숨긴다 --%>
				<div id="optionBox" class="form-group">
					<label>보기 <span class="sub">(사용하는 보기 2개 이상)</span></label>
					<div id="optionList">
						<c:forEach var="o" items="${dto.options}">
						<div class="option-row">
							<input type="hidden" name="optionSeq" value="${o.optionSeq}">
							<input type="text" name="optionContent" maxlength="100" value="<c:out value='${o.content}' />" ${o.answerCount gt 0 ? 'readonly' : ''}>
							<select name="optionEnabled">
								<option value="Y" ${o.enabled eq 'Y' ? 'selected' : ''}>사용</option>
								<option value="N" ${o.enabled eq 'N' ? 'selected' : ''}>사용 안 함</option>
							</select>
							<c:if test="${o.answerCount gt 0}"><span class="used">${o.answerCount}번 선택됨</span></c:if>
						</div>
						</c:forEach>
					</div>
					<button type="button" class="btn btn-sm" id="addOption">+ 보기 추가</button>
					<c:if test="${editMode}">
					<p class="sub">이미 고른 사람이 있는 보기는 내용을 바꿀 수 없습니다. 사용 안 함으로 바꾸고 새 보기를 추가하세요.</p>
					</c:if>
				</div>

				<div class="buttons">
					<button class="btn btn-primary">${editMode ? '수정' : '등록'}</button>
					<a class="btn" href="${path}/admin/question/list.do?categorySeq=${editMode ? dto.categorySeq : category.categorySeq}">목록</a>
				</div>
			</form>
		</main>
	</div>

	<%-- 새 보기 줄. 번호가 없으면 서버가 새 보기로 저장한다 --%>
	<template id="optionTemplate">
		<div class="option-row">
			<input type="hidden" name="optionSeq" value="">
			<input type="text" name="optionContent" maxlength="100" placeholder="보기 내용">
			<input type="hidden" name="optionEnabled" value="Y">
			<button type="button" class="btn btn-sm remove-option">삭제</button>
		</div>
	</template>

	<script>

		function addOptionRow() {
			$('#optionList').append($('#optionTemplate').html());
		}

		function currentType() {
			return $('input[name=questionType]:checked').val();
		}

		//주관식이면 보기 칸을 숨긴다
		function toggleOptionBox() {
			$('#optionBox').toggle(currentType() != 'TEXT');
		}

		//등록 화면은 빈 보기 두 줄로 시작한다
		if ($('#optionList .option-row').length == 0) {
			addOptionRow();
			addOptionRow();
		}

		toggleOptionBox();

		$('input[name=questionType]').change(toggleOptionBox);

		$('#addOption').click(function () {
			if ($('#optionList .option-row').length >= 20) {
				alert('보기는 20개까지 넣을 수 있습니다.');
				return;
			}
			addOptionRow();
		});

		//새로 추가한 줄만 지울 수 있다 (저장된 보기는 사용 안 함으로 바꾼다)
		$('#optionList').on('click', '.remove-option', function () {
			$(this).closest('.option-row').remove();
		});

		$('#questionForm').submit(function () {

			if ($('#content').val().trim() == '') {
				alert('질문 내용을 입력해 주세요.');
				$('#content').focus();
				return false;
			}

			if (currentType() != 'TEXT') {

				let count = 0;
				let emptySaved = false;

				$('#optionList .option-row').each(function () {

					const content = $(this).find('input[name=optionContent]').val().trim();
					const saved = $(this).find('input[name=optionSeq]').val() != '';
					const enabled = $(this).find('[name=optionEnabled]').val() == 'Y';

					if (saved && content == '') {
						emptySaved = true;
					}
					if (content != '' && enabled) {
						count++;
					}
				});

				if (emptySaved) {
					alert('저장된 보기의 내용은 비울 수 없습니다. 쓰지 않으려면 사용 안 함으로 바꿔 주세요.');
					return false;
				}

				if (count < 2) {
					alert('객관식 질문은 사용하는 보기가 2개 이상 있어야 합니다.');
					return false;
				}
			}

			return true;
		});

	</script>
</body>
</html>
