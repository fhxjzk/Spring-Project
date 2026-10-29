-- ============================================================
-- 06_report_dummy.sql (⑥ 검색·신고·DB)
--
-- 회원 번호는 CONVENTION.md 더미 규칙을 따른다.
--   1 = admin(관리자), 2~4 = customer1~3(고객), 5~7 = expert1~3(고수)
--
-- 고수 활동지역(tbl_expert_region)은 ② tbl_expert 가 만들어진 뒤에 넣는다.
-- 지금 넣으면 ②의 고수 번호와 안 맞을 수 있다.
--
-- 요청서 신고(target_type = 'REQUEST')도 ③ tbl_request 더미 번호가
-- 정해진 뒤에 추가한다. 지금은 고수 프로필 신고만 넣는다.
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

COMMIT;
