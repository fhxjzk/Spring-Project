-- ============================================================
-- 06_report_dummy.sql (⑥ 검색·신고·DB)
--
-- 회원 번호는 CONVENTION.md 더미 규칙을 따른다.
--   1 = admin(관리자), 2~4 = customer1~3(고객), 5~7 = expert1~3(고수)
--
-- ============================================================

-- 신고 (신고자 = 고객 2~4, 대상 = 고수 프로필 5~7, 처리 관리자 = 1)
-- 상태별로 하나씩 들어 있어서 관리자 화면 필터를 바로 확인할 수 있다.


-- 접수 (RECEIVED) - 아직 검토 전
INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 2, 'PROFILE', 5, 'FALSE_INFO', '경력을 거짓으로 기재한 것 같습니다.', 'RECEIVED', NULL, NULL, sysdate - 5, NULL);

INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 3, 'PROFILE', 7, 'FALSE_INFO', '리뷰를 조작한 것으로 보입니다.', 'RECEIVED', NULL, NULL, sysdate - 1, NULL);

-- 검토중 (REVIEWING) - 관리자가 검토를 시작한 상태. 처리 사유는 아직 없다.
INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 3, 'PROFILE', 6, 'FRAUD', '작업 전에 선입금을 요구합니다.', 'REVIEWING', NULL, 1, sysdate - 7, NULL);

-- 처리완료 (DONE) - 처리 사유 필수
INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 4, 'PROFILE', 7, 'ABUSE', '채팅에서 욕설을 사용했습니다.', 'DONE', '욕설이 확인되어 프로필을 비공개 처리했습니다.', 1, sysdate - 10, sysdate - 8);

-- 반려 (REJECTED) - 처리 사유 필수
INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 2, 'PROFILE', 6, 'ETC', '프로필 사진이 본인이 아닌 것 같습니다.', 'REJECTED', '확인 결과 본인 사진이 맞아 반려합니다.', 1, sysdate - 15, sysdate - 12);

-- ------------------------------------------------------------
-- 요청서 신고 (신고자 = 고수 5~7, 대상 = ③ tbl_request 1~5)
-- 처리완료(DONE)면 해당 요청서를 비공개로 바꾼다. (E-02)
-- ------------------------------------------------------------

-- 접수 (RECEIVED)
INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 5, 'REQUEST', 1, 'FALSE_INFO', '예산과 요청 내용이 서로 맞지 않습니다.', 'RECEIVED', NULL, NULL, sysdate - 2, NULL);

-- 처리완료 (DONE) - 요청서를 비공개로 바꾼 건
INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 6, 'REQUEST', 4, 'FRAUD', '견적을 받은 뒤 외부 거래를 유도합니다.', 'DONE', '외부 거래 유도가 확인되어 요청서를 비공개 처리했습니다.', 1, sysdate - 6, sysdate - 4);

-- 반려 (REJECTED)
INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 7, 'REQUEST', 2, 'ETC', '같은 내용을 반복해서 올리는 것 같습니다.', 'REJECTED', '중복 등록으로 보기 어려워 반려합니다.', 1, sysdate - 9, sysdate - 7);

-- ------------------------------------------------------------
-- 고수 활동지역 (② tbl_expert_profile 의 고수 5 ~ 7)
--
-- 활동 가능 지역은 "거기까지 가서 일하는가"다. 등록 주소(거리 계산용)와 다르다.
--   5 피아노·영어 레슨  → 직접 가야 해서 수도권만
--   6 입주 청소·에어컨  → 장비를 들고 가야 해서 서울만
--   7 웹 개발·디자인    → 온라인으로 하니 전국 (17개 전부)
-- ------------------------------------------------------------

-- 고수1(5번) : 서울, 경기
INSERT INTO tbl_expert_region (expert_seq, region_seq) VALUES (5, 1);
INSERT INTO tbl_expert_region (expert_seq, region_seq) VALUES (5, 2);

-- 고수2(6번) : 서울
INSERT INTO tbl_expert_region (expert_seq, region_seq) VALUES (6, 1);

-- 고수3(7번) : 전국. 17개 지역을 모두 등록한다.
INSERT INTO tbl_expert_region (expert_seq, region_seq)
    SELECT 7, region_seq FROM tbl_region;

COMMIT;
