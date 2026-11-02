<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

	<%--
		report/modal.jsp: 신고 접수 모달 (⑥ B-07)

		쓰는 법 — 고수 프로필(②)이나 요청서 상세(③) 화면에서
		  1) </body> 바로 위에 이 줄을 넣는다
		     <%@ include file="/WEB-INF/views/report/modal.jsp" %>
		  2) 신고 버튼에서 아래 함수를 부른다
		     고수   : openReportModal('PROFILE', 고수번호)
		     요청서 : openReportModal('REQUEST', 요청서번호)
	--%>
	<div id="reportModal" class="report-modal">
		<div class="report-modal-box">
			<h3>신고하기</h3>

			<form id="reportForm">
				<input type="hidden" id="reportTargetType" name="targetType">
				<input type="hidden" id="reportTargetSeq" name="targetSeq">

				<div class="form-group">
					<label for="reasonType">신고 사유</label>
					<select id="reasonType" name="reasonType" required>
						<option value="">선택해주세요</option>
						<option value="ABUSE">욕설</option>
						<option value="FALSE_INFO">허위정보</option>
						<option value="FRAUD">사기의심</option>
						<option value="ETC">기타</option>
					</select>
				</div>

				<div class="form-group">
					<label for="reasonDetail">상세 내용</label>
					<textarea id="reasonDetail" name="reasonDetail" rows="4" maxlength="4000"></textarea>
				</div>

				<div class="report-modal-buttons">
					<button type="submit" class="btn btn-danger">신고하기</button>
					<button type="button" class="btn" onclick="closeReportModal()">취소</button>
				</div>
			</form>
		</div>
	</div>

	<style>
		.report-modal {
			display: none;
			position: fixed;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
			background: rgba(0, 0, 0, 0.4);
			z-index: 1000;
			align-items: center;
			justify-content: center;
		}
		.report-modal-box {
			background: #fff;
			border-radius: 8px;
			padding: 24px;
			width: 400px;
			max-width: 90%;
		}
		.report-modal-box h3 {
			margin-top: 0;
		}
		.report-modal-buttons {
			margin-top: 16px;
			text-align: right;
		}
		.report-modal-buttons button {
			margin-left: 6px;
		}
	</style>

	<script>
		//신고 모달 열기
		function openReportModal(targetType, targetSeq) {

			$('#reportForm')[0].reset();

			//reset 뒤에 넣어야 지워지지 않는다
			$('#reportTargetType').val(targetType);
			$('#reportTargetSeq').val(targetSeq);

			$('#reportModal').css('display', 'flex');
		}

		function closeReportModal() {

			$('#reportModal').hide();
		}

		$('#reportForm').on('submit', function (e) {

			e.preventDefault();

			//'기타'를 골랐으면 상세 내용을 반드시 써야 한다 (서버에서도 한 번 더 막는다)
			if ($('#reasonType').val() === 'ETC' && $('#reasonDetail').val().trim() === '') {
				alert('기타를 선택하셨으면 상세 내용을 입력해주세요.');
				$('#reasonDetail').focus();
				return;
			}

			$.ajax({
				url: path + '/report/add.do',
				type: 'POST',
				data: $(this).serialize(),
				success: function (res) {

					alert(res.message);

					if (res.success) {
						closeReportModal();
					}
				},
				error: function () {

					alert('신고하지 못했습니다. 로그인 상태를 확인해주세요.');
				}
			});
		});
	</script>