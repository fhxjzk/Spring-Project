package com.project.app.report.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.app.notice.service.NotificationService;
import com.project.app.report.model.ReportDto;
import com.project.app.report.repository.ReportDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportService {

	private final ReportDao reportDao;
	private final NotificationService notificationService;	//⑤ 공통 알림 (E-02-06)

	//알림 내용에 넣을 처리 사유 최대 글자 수
	//tbl_notice.message 가 VARCHAR2(1000) 바이트라서 한글(3바이트)로 꽉 채워도 넘지 않게 자른다
	private static final int NOTICE_REASON_MAX = 200;

	//--- 신고 접수 (B-07) ---

	/**
	 * 신고 접수
	 * @return 1: 성공, 0: 실패, -1: 기타인데 상세 내용 없음, -2: 본인 신고, -3: 이미 신고함
	 */
	public int add(ReportDto dto) {

		//사유가 '기타'면 상세 내용을 반드시 써야 한다 (테이블 제약과 같은 규칙)
		if ("ETC".equals(dto.getReasonType())
				&& (dto.getReasonDetail() == null || dto.getReasonDetail().trim().isEmpty())) {
			return -1;
		}

		//본인은 신고할 수 없다
		if (isMyOwn(dto)) {
			return -2;
		}

		//같은 대상을 이미 신고해두고 아직 처리가 안 됐으면 또 못 한다
		if (reportDao.countDuplicate(dto.getReporterSeq(), dto.getTargetType(), dto.getTargetSeq()) > 0) {
			return -3;
		}

		return reportDao.add(dto);
	}

	//신고 대상이 신고한 본인인지
	private boolean isMyOwn(ReportDto dto) {

		if ("PROFILE".equals(dto.getTargetType())) {
			//고수 프로필 번호는 회원 번호와 같다
			return dto.getTargetSeq().equals(dto.getReporterSeq());
		}

		//게시글과 요청서는 쓴 사람을 조회해서 비교한다
		Long ownerSeq = null;

		if ("BOARD".equals(dto.getTargetType())) {
			ownerSeq = reportDao.getBoardOwner(dto.getTargetSeq());
		} else {
			ownerSeq = reportDao.getRequestOwner(dto.getTargetSeq());
		}

		return ownerSeq != null && ownerSeq.equals(dto.getReporterSeq());
	}

	//--- 관리자 신고 처리 (E-02) ---

	//status 가 비어 있으면 전체 목록
	public List<ReportDto> getList(String status) {

		return reportDao.getList(status);
	}

	public ReportDto getBySeq(Long reportSeq) {

		return reportDao.getBySeq(reportSeq);
	}

	//검토중으로 바꾸기
	public int review(Long reportSeq, Long adminSeq) {

		return reportDao.updateReviewing(reportSeq, adminSeq);
	}

	/**
	 * 신고 처리 (처리완료 / 반려)
	 * @return 1: 성공, 0: 실패, -1: 처리 사유 없음, -2: 이미 처리된 신고
	 */
	@Transactional
	public int process(Long reportSeq, String status, String processReason, Long adminSeq) {

		//처리할 때는 사유를 반드시 적는다 (E-02)
		if (processReason == null || processReason.trim().isEmpty()) {
			return -1;
		}

		//화면을 조작해서 엉뚱한 상태로 바꾸는 것을 막는다
		if (!"DONE".equals(status) && !"REJECTED".equals(status)) {
			return 0;
		}

		ReportDto report = reportDao.getBySeq(reportSeq);

		if (report == null) {
			return 0;
		}

		//이미 처리가 끝난 신고는 다시 처리하지 않는다
		if ("DONE".equals(report.getStatus()) || "REJECTED".equals(report.getStatus())) {
			return -2;
		}

		int result = reportDao.updateProcess(reportSeq, status, processReason, adminSeq);

		//처리완료면 신고 대상을 숨긴다 (E-02)
		//이미 진행 중인 거래는 그대로 진행한다. 여기서는 건드리지 않는다
		if (result > 0 && "DONE".equals(status)) {
			setHidden(report, "Y");
		}

		return result;
	}

	/**
	 * 처리 결과를 신고한 회원에게 알린다 (E-02-06)
	 *
	 * process() 안에서 부르지 않고, 처리가 끝난(DB에 확정된) 뒤에 컨트롤러가 따로 부른다.
	 * ⑤ 알림 저장 메서드에도 트랜잭션이 걸려 있어서, process() 안에서 부르다가 알림 저장이 실패하면
	 * 신고 처리까지 통째로 취소될 수 있기 때문이다.
	 * 알림이 실패해도 신고 처리는 그대로 두고 로그만 남긴다.
	 */
	public void notifyResult(Long reportSeq) {

		ReportDto report = reportDao.getBySeq(reportSeq);

		//처리완료 · 반려된 신고만 알린다
		if (report == null
				|| (!"DONE".equals(report.getStatus()) && !"REJECTED".equals(report.getStatus()))) {
			return;
		}

		try {
			notificationService.send(
					report.getReporterSeq(),
					report.getReporterId(),
					"REPORT",
					"신고 처리 결과",
					getResultMessage(report),
					report.getReportSeq());
		} catch (Exception e) {
			System.err.println("신고 처리 결과 알림 실패 (reportSeq=" + reportSeq + ")");
			e.printStackTrace();
		}
	}

	//예) 신고하신 게시글(동네 맛집 추천) 건이 처리완료되었습니다. 처리 사유: 욕설이 확인되어 숨김 처리했습니다.
	private String getResultMessage(ReportDto report) {

		String targetKind = "요청서";

		if ("PROFILE".equals(report.getTargetType())) {
			targetKind = "고수 프로필";
		} else if ("BOARD".equals(report.getTargetType())) {
			targetKind = "게시글";
		}

		String result = "DONE".equals(report.getStatus()) ? "처리완료" : "반려";

		String reason = report.getProcessReason();

		if (reason.length() > NOTICE_REASON_MAX) {
			reason = reason.substring(0, NOTICE_REASON_MAX) + "...";
		}

		//대상이 지워져서 이름을 못 찾으면 이름 없이 쓴다
		String target = targetKind;

		if (report.getTargetName() != null) {
			target += "(" + report.getTargetName() + ")";
		}

		return "신고하신 " + target + " 건이 " + result + "되었습니다. 처리 사유: " + reason;
	}

	//숨김 / 비공개 해제 (E-02)
	@Transactional
	public int unhide(Long reportSeq) {

		ReportDto report = reportDao.getBySeq(reportSeq);

		if (report == null) {
			return 0;
		}

		return setHidden(report, "N");
	}

	//신고 대상에 따라 고수 프로필 · 게시글 · 요청서의 숨김 상태를 바꾼다
	private int setHidden(ReportDto report, String hidden) {

		if ("PROFILE".equals(report.getTargetType())) {
			return reportDao.updateExpertHidden(report.getTargetSeq(), hidden);
		}

		if ("BOARD".equals(report.getTargetType())) {
			return reportDao.updateBoardHidden(report.getTargetSeq(), hidden);
		}

		return reportDao.updateRequestHidden(report.getTargetSeq(), hidden);
	}

}
