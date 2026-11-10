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
		.review-form {
			max-width: 640px;
			margin: 0 auto;
		}

		/* 어떤 거래의 리뷰인지: 서비스 · 고수 · 금액 · 구매 확정일 */
		.trade-summary {
			display: grid;
			grid-template-columns: 90px 1fr;
			row-gap: 8px;
			margin: 0;
		}

		.trade-summary dt {
			color: var(--color-text-light);
		}

		.trade-summary dd {
			margin: 0;
			font-weight: 600;
		}

		/* 별점: 라디오 5개를 별 모양 label 로 보여 준다.
		   HTML 은 5 → 1 순서로 쓰고 row-reverse 로 뒤집어서, 화면에는 1 → 5 로 보인다.
		   이렇게 해야 "고른 별과 그 왼쪽 별"을 CSS 의 ~ (뒤에 오는 형제) 선택자로 칠할 수 있다 */
		.star-input {
			display: inline-flex;
			flex-direction: row-reverse;
			gap: 4px;
		}

		/* 라디오 동그라미는 숨기고, 키보드(방향키)로는 그대로 고를 수 있게 둔다 */
		.star-input input {
			position: absolute;
			opacity: 0;
			width: 0;
			height: 0;
		}

		.star-input label {
			font-size: 34px;
			line-height: 1;
			color: var(--color-border);
			cursor: pointer;
		}

		/* 고른 별 + 그 왼쪽 별들, 마우스를 올린 별 + 그 왼쪽 별들 */
		.star-input input:checked ~ label,
		.star-input label:hover,
		.star-input label:hover ~ label {
			color: var(--color-warning);
		}

		/* 키보드로 고를 때 어디에 있는지 보이게 */
		.star-input input:focus-visible + label {
			outline: 2px solid var(--color-primary);
			outline-offset: 2px;
		}

		.star-text {
			margin-left: 10px;
			color: var(--color-text-light);
		}

		.content-count {
			margin: 6px 0 0;
			text-align: right;
			font-size: 14px;
			color: var(--color-text-light);
		}

		.content-count.over {
			color: var(--color-danger);
		}

		.form-buttons {
			display: flex;
			justify-content: flex-end;
			gap: 8px;
		}
	</style>
</head>
<body>
	<!-- review/add.jsp: 리뷰·별점 작성 (화면설계서 ②-05) -->
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<div class="review-form">
			<h2>리뷰 작성</h2>

			<%-- 어떤 거래의 리뷰인지 --%>
			<div class="card">
				<dl class="trade-summary">
					<dt>서비스</dt>
					<dd><c:out value="${trade.serviceName}" /></dd>
					<dt>고수</dt>
					<dd><c:out value="${trade.expertName}" /></dd>
					<dt>금액</dt>
					<dd><fmt:formatNumber value="${trade.price}" />원</dd>
					<dt>구매 확정</dt>
					<dd>${fn:substring(trade.confirmDate, 0, 10)}</dd>
				</dl>
			</div>

			<%-- 거래 번호만 hidden 으로 보낸다. 작성자·고수 번호는 서버가 로그인 정보와 거래 정보로 채운다 --%>
			<form id="reviewForm" class="card" method="POST" action="${path}/review/addok.do">

				<div class="form-group">
					<label>별점</label>
					<div>
						<span class="star-input">
							<input type="radio" id="star5" name="rating" value="5"><label for="star5" title="5점">★</label>
							<input type="radio" id="star4" name="rating" value="4"><label for="star4" title="4점">★</label>
							<input type="radio" id="star3" name="rating" value="3"><label for="star3" title="3점">★</label>
							<input type="radio" id="star2" name="rating" value="2"><label for="star2" title="2점">★</label>
							<input type="radio" id="star1" name="rating" value="1"><label for="star1" title="1점">★</label>
						</span>
						<span class="star-text" id="starText">별을 눌러 주세요</span>
					</div>
				</div>

				<div class="form-group">
					<label for="content">리뷰 내용</label>
					<textarea id="content" name="content" rows="8"
						placeholder="서비스는 어땠나요? 다른 고객에게 도움이 되도록 솔직하게 남겨 주세요."></textarea>
					<p class="content-count" id="contentCount">0 / 2000 byte (한글 약 660자)</p>
				</div>

				<p class="message-info small">등록한 리뷰는 수정하거나 삭제할 수 없어요.</p>

				<div class="form-buttons">
					<a class="btn" href="${path}/trade/detail.do?tradeSeq=${trade.tradeSeq}">취소</a>
					<button class="btn btn-primary">리뷰 등록</button>
				</div>

				<input type="hidden" name="tradeSeq" value="${trade.tradeSeq}">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			</form>
		</div>
	</main>

	<script>
		const MAX_BYTES = 2000;	// tbl_review.content VARCHAR2(2000), 바이트 기준

		const form = document.getElementById('reviewForm');
		const content = document.getElementById('content');
		const contentCount = document.getElementById('contentCount');
		const starText = document.getElementById('starText');

		// 서버(오라클)와 같은 UTF-8 기준으로 바이트를 센다. 한글 한 글자 = 3바이트
		function byteLength(text) {
			return new TextEncoder().encode(text).length;
		}

		// 별을 고르면 옆에 "4점" 처럼 보여 준다
		form.querySelectorAll('input[name="rating"]').forEach(radio => {
			radio.addEventListener('change', () => {
				starText.textContent = radio.value + '점';
			});
		});

		// 입력할 때마다 바이트 수를 보여 주고, 넘으면 빨간색
		content.addEventListener('input', () => {
			const bytes = byteLength(content.value.trim());
			contentCount.textContent = bytes + ' / ' + MAX_BYTES + ' byte (한글 약 660자)';
			contentCount.classList.toggle('over', bytes > MAX_BYTES);
		});

		// 등록 전 확인. 서버(ReviewService.add)에서도 같은 조건으로 한 번 더 확인한다
		form.addEventListener('submit', e => {

			if (!form.querySelector('input[name="rating"]:checked')) {
				alert('별점을 골라 주세요.');
				e.preventDefault();
				return;
			}

			const text = content.value.trim();

			if (text === '') {
				alert('리뷰 내용을 입력해 주세요.');
				content.focus();
				e.preventDefault();
				return;
			}

			if (byteLength(text) > MAX_BYTES) {
				alert('리뷰 내용이 너무 길어요. (한글 약 660자까지)');
				content.focus();
				e.preventDefault();
				return;
			}

			if (!confirm('리뷰를 등록할까요? 등록한 리뷰는 수정하거나 삭제할 수 없어요.')) {
				e.preventDefault();
			}
		});
	</script>
</body>
</html>
