<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

	<%--
		wish/mypage-card.jsp: 마이페이지에 넣는 "찜한 고수" 카드 (찜하기, ② 담당)

		쓰는 법 — member/mypage.jsp 의 [내 정보] 카드와 [정보 수정] 카드 사이에 한 줄 넣는다
			<%@ include file="/WEB-INF/views/wish/mypage-card.jsp" %>

		- 고객 계정에만 보인다. 고수 · 관리자는 찜 기능이 없어서 아무것도 그리지 않는다
		- 마이페이지 컨트롤러는 아무것도 넘기지 않아도 된다.
		  화면이 뜬 뒤 /wish/mycard.do (wish/mycard.jsp) 를 불러와서 이 카드 안에 넣는다
	--%>
	<sec:authorize access="hasRole('ROLE_CUSTOMER')">
	<style>
		/* 제목 왼쪽, 전체 보기 오른쪽 */
		.wish-card-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

		.wish-card-total {
			margin-left: 4px;
			font-size: 15px;
			font-weight: normal;
			color: var(--color-text-light);
		}

		/* 미니 카드 4칸 (최근 3명 + "+N명 더"). 좁은 화면에서는 2칸 */
		.wish-card-grid {
			display: grid;
			grid-template-columns: repeat(4, minmax(0, 1fr));
			gap: 10px;
		}

		@media (max-width: 600px) {
			.wish-card-grid {
				grid-template-columns: repeat(2, minmax(0, 1fr));
			}
		}

		.wish-mini {
			display: flex;
			flex-direction: column;
			align-items: center;
			gap: 2px;
			padding: 12px 8px;
			border: 1px solid var(--color-border);
			border-radius: 8px;
			color: inherit;
			text-align: center;
			text-decoration: none;
		}

		.wish-mini:hover {
			border-color: var(--color-primary);
		}

		.wish-mini-photo {
			width: 48px;
			height: 48px;
			margin-bottom: 6px;
			border-radius: 50%;
			overflow: hidden;
			background-color: color-mix(in srgb, var(--color-primary) 10%, var(--color-bg));
		}

		.wish-mini-photo img {
			display: block;
			width: 100%;
			height: 100%;
			object-fit: cover;
		}

		/* 소분류가 많으면 한 줄에서 ...으로 자른다 */
		.wish-mini-category {
			max-width: 100%;
			overflow: hidden;
			white-space: nowrap;
			text-overflow: ellipsis;
		}

		.wish-mini-heart {
			color: var(--color-danger);
		}

		.wish-mini-more {
			justify-content: center;
			border-style: dashed;
			color: var(--color-text-light);
		}
	</style>

	<div class="card" id="wishMypageCard">
		<h2>찜한 고수</h2>
		<p class="message-info small">불러오는 중…</p>
	</div>

	<script>
		// 찜한 고수 카드 내용을 불러와서 끼워 넣는다 (WishController.mycard). 실패하면 전체 보기 링크만 남긴다
		$(function () {
			$('#wishMypageCard').load('${path}/wish/mycard.do', function (res, status) {
				if (status !== 'success') {
					$(this).html('<h2>찜한 고수</h2><a class="message-info small" href="${path}/wish/mylist.do">찜한 고수 보기 →</a>');
				}
			});
		});
	</script>
	</sec:authorize>
