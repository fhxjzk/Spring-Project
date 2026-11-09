-- ============================================================
-- 06_board_dummy.sql (⑥ 동네 커뮤니티 게시판)
--
-- 회원 번호는 CONVENTION.md 더미 규칙을 따른다.
--   1 = admin(관리자), 2~4 = customer1~3(고객), 5~7 = expert1~3(고수)
-- 지역 번호는 06_report.sql 의 tbl_region 을 따른다. 1 = 서울, 2 = 경기, 3 = 인천
--
-- 글 8건. 서울 4 · 경기 2 · 인천 1 · 숨김 1.
-- 숨김 글(8번)은 신고가 처리완료되어 enabled = 'N' 이 된 글이다.
-- ============================================================

-- 서울
INSERT INTO tbl_board (board_seq, member_seq, region_seq, subject, content, readcount, enabled, regdate, moddate)
VALUES (seq_board.NEXTVAL, 2, 1, '이사 청소 업체 추천 좀',
    '이번 주말에 이사하는데 입주 청소를 맡기려고 합니다.' || chr(10) ||
    '근처에서 해보신 분 계시면 추천 좀 부탁드려요. 가격도 궁금합니다.',
    12, 'Y', sysdate - 0.2, NULL);

INSERT INTO tbl_board (board_seq, member_seq, region_seq, subject, content, readcount, enabled, regdate, moddate)
VALUES (seq_board.NEXTVAL, 3, 1, '강남쪽 피아노 레슨 어디가 좋나요',
    '아이가 피아노를 배우고 싶다는데 주변에 괜찮은 선생님 계실까요?' || chr(10) ||
    '초등학생이고 처음 배웁니다.',
    8, 'Y', sysdate - 1.1, NULL);

INSERT INTO tbl_board (board_seq, member_seq, region_seq, subject, content, readcount, enabled, regdate, moddate)
VALUES (seq_board.NEXTVAL, 5, 1, '에어컨 청소 얼마쯤 하나요',
    '벽걸이 두 대인데 요즘 시세가 어느 정도인지 궁금합니다.',
    21, 'Y', sysdate - 2.3, sysdate - 2.1);

INSERT INTO tbl_board (board_seq, member_seq, region_seq, subject, content, readcount, enabled, regdate, moddate)
VALUES (seq_board.NEXTVAL, 4, 1, '도배 잘하는 분 아시는 분',
    '방 두 개만 새로 하려고 하는데 혹시 해보신 분 계신가요?',
    5, 'Y', sysdate - 3.4, NULL);

-- 경기
INSERT INTO tbl_board (board_seq, member_seq, region_seq, subject, content, readcount, enabled, regdate, moddate)
VALUES (seq_board.NEXTVAL, 2, 2, '분당 쪽 영어 과외 구해요',
    '중학생 영어 회화 위주로 봐주실 분 찾습니다. 주 2회 생각하고 있습니다.',
    9, 'Y', sysdate - 0.7, NULL);

INSERT INTO tbl_board (board_seq, member_seq, region_seq, subject, content, readcount, enabled, regdate, moddate)
VALUES (seq_board.NEXTVAL, 6, 2, '이번 주말 이사 도와주실 분',
    '원룸이라 짐이 많지는 않습니다. 반나절이면 끝날 것 같아요.',
    3, 'Y', sysdate - 4.2, NULL);

-- 인천
INSERT INTO tbl_board (board_seq, member_seq, region_seq, subject, content, readcount, enabled, regdate, moddate)
VALUES (seq_board.NEXTVAL, 3, 3, '송도에 필라테스 추천해주세요',
    '처음 해보는데 1:1 로 알려주시는 곳이 좋을까요?',
    7, 'Y', sysdate - 1.8, NULL);

-- 숨김 (신고 처리완료된 글)
INSERT INTO tbl_board (board_seq, member_seq, region_seq, subject, content, readcount, enabled, regdate, moddate)
VALUES (seq_board.NEXTVAL, 7, 1, '★★ 최저가 보장 ★★ 지금 바로 연락주세요',
    '전화번호 010-0000-0000 으로 연락주시면 어떤 작업이든 싸게 해드립니다.',
    31, 'N', sysdate - 5.5, NULL);

-- ------------------------------------------------------------
-- 게시글 신고 (B-09-09)
-- tbl_report 를 그대로 쓴다. target_type = 'BOARD', target_seq = 글 번호
-- 8번 글은 처리완료되어 위에서 enabled = 'N' 으로 들어가 있다.
-- ------------------------------------------------------------

-- 처리완료 (DONE)
INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 2, 'BOARD', 8, 'ETC', '광고 글입니다. 전화번호를 적어두고 영업하고 있어요.',
    'DONE', '광고성 글로 확인되어 비공개 처리했습니다.', 1, sysdate - 5.2, sysdate - 5.0);

-- 접수 (RECEIVED)
INSERT INTO tbl_report (report_seq, reporter_seq, target_type, target_seq, reason_type, reason_detail, status, process_reason, admin_seq, regdate, process_date)
VALUES (seq_report.NEXTVAL, 4, 'BOARD', 3, 'FALSE_INFO', '시세를 일부러 낮게 말하는 것 같습니다.',
    'RECEIVED', NULL, NULL, sysdate - 1.5, NULL);


-- ------------------------------------------------------------
-- 댓글 (B-09-11 ~ B-09-14)
-- 1번 글에 3개, 3번 글에 2개, 4번 글에 1개.
-- 3번 글에는 지운 댓글(enabled = 'N') 을 하나 넣어 두었다.
-- ------------------------------------------------------------

-- 1번 글 — 이사 청소 업체 추천 좀 (글쓴이 2번)
INSERT INTO tbl_board_comment (comment_seq, board_seq, member_seq, content, enabled, regdate, moddate)
VALUES (seq_board_comment.NEXTVAL, 1, 3, '저는 지난달에 8만원 정도 냈어요.', 'Y', sysdate - 0.4, NULL);

INSERT INTO tbl_board_comment (comment_seq, board_seq, member_seq, content, enabled, regdate, moddate)
VALUES (seq_board_comment.NEXTVAL, 1, 5, '평수에 따라 달라서 두세 곳 비교해보시는 게 좋습니다.', 'Y', sysdate - 0.3, NULL);

INSERT INTO tbl_board_comment (comment_seq, board_seq, member_seq, content, enabled, regdate, moddate)
VALUES (seq_board_comment.NEXTVAL, 1, 2, '감사합니다. 세 군데 받아볼게요.', 'Y', sysdate - 0.2, sysdate - 0.1);

-- 3번 글 — 에어컨 청소 얼마쯤 하나요 (글쓴이 5번)
INSERT INTO tbl_board_comment (comment_seq, board_seq, member_seq, content, enabled, regdate, moddate)
VALUES (seq_board_comment.NEXTVAL, 3, 4, '벽걸이는 대당 5만원 안팎입니다.', 'Y', sysdate - 2.1, NULL);

INSERT INTO tbl_board_comment (comment_seq, board_seq, member_seq, content, enabled, regdate, moddate)
VALUES (seq_board_comment.NEXTVAL, 3, 6, '광고성 댓글이라 지워진 것', 'N', sysdate - 2.0, NULL);

-- 4번 글 — 도배 잘하는 분 아시는 분 (글쓴이 4번)
INSERT INTO tbl_board_comment (comment_seq, board_seq, member_seq, content, enabled, regdate, moddate)
VALUES (seq_board_comment.NEXTVAL, 4, 2, '저도 같은 고민 중이라 댓글 기다려봅니다.', 'Y', sysdate - 3.1, NULL);

COMMIT;