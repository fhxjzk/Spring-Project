-- ============================================================
-- 06_board.sql (⑥ 동네 커뮤니티 게시판 · 추가 구현)
--
-- 요구사항: B-09 동네 커뮤니티 게시판
--
-- 추가 구현이라 필수 기능인 06_report.sql 과 파일을 나눠 둔다.
-- 게시판을 빼게 되면 이 파일만 지우면 된다.
--
-- 실행 순서: 01 회원 → 06_report (tbl_region, tbl_report) → 06_board
-- ============================================================

CREATE TABLE tbl_board (
    board_seq    NUMBER          NOT NULL,
    member_seq   NUMBER          NOT NULL,                   -- 글쓴이
    region_seq   NUMBER          NOT NULL,                   -- 동네 (tbl_region 17개)
    subject      VARCHAR2(200)   NOT NULL,                   -- 제목
    content      VARCHAR2(4000)  NOT NULL,                   -- 내용
    readcount    NUMBER          DEFAULT 0 NOT NULL,         -- 조회수
    enabled      CHAR(1)         DEFAULT 'Y' NOT NULL,       -- Y: 사용, N: 삭제 또는 신고 처리로 숨김
    regdate      DATE            DEFAULT sysdate NOT NULL,
    moddate      DATE,                                       -- 수정일 (안 고쳤으면 비어 있다)
    CONSTRAINT pk_board PRIMARY KEY (board_seq),
    CONSTRAINT fk_board_member FOREIGN KEY (member_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT fk_board_region FOREIGN KEY (region_seq) REFERENCES tbl_region (region_seq),
    CONSTRAINT ck_board_enabled CHECK (enabled IN ('Y', 'N'))
);

CREATE SEQUENCE seq_board;

-- 목록은 "그 지역의 최신 글"로만 조회한다
CREATE INDEX idx_board_region ON tbl_board (region_seq, board_seq DESC);


-- ------------------------------------------------------------
-- 댓글 (B-09-11 ~ B-09-14)
-- 글을 지우거나 신고 처리로 숨기면 그 글의 댓글도 같이 안 보인다.
-- 댓글 행을 따로 지우지는 않는다. 글이 안 보이면 댓글도 볼 길이 없다.
-- ------------------------------------------------------------
CREATE TABLE tbl_board_comment (
    comment_seq  NUMBER          NOT NULL,
    board_seq    NUMBER          NOT NULL,                   -- 어느 글의 댓글인지
    member_seq   NUMBER          NOT NULL,                   -- 쓴 사람
    content      VARCHAR2(1000)  NOT NULL,                   -- 내용
    enabled      CHAR(1)         DEFAULT 'Y' NOT NULL,       -- Y: 사용, N: 삭제
    regdate      DATE            DEFAULT sysdate NOT NULL,
    moddate      DATE,                                       -- 수정일 (안 고쳤으면 비어 있다)
    CONSTRAINT pk_board_comment PRIMARY KEY (comment_seq),
    CONSTRAINT fk_bcomment_board FOREIGN KEY (board_seq) REFERENCES tbl_board (board_seq),
    CONSTRAINT fk_bcomment_member FOREIGN KEY (member_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT ck_bcomment_enabled CHECK (enabled IN ('Y', 'N'))
);

CREATE SEQUENCE seq_board_comment;

-- 댓글은 "그 글의 댓글"을 등록순으로만 조회한다
CREATE INDEX idx_bcomment_board ON tbl_board_comment (board_seq, comment_seq);

-- ------------------------------------------------------------
-- 게시글도 신고 대상에 넣는다 (B-09-09)
-- B-07 신고 접수와 E-02 관리자 처리를 그대로 쓴다. 새로 만드는 것은 없다.
-- 06_report.sql 의 tbl_report 가 먼저 만들어져 있어야 한다.
-- ------------------------------------------------------------
ALTER TABLE tbl_report DROP CONSTRAINT ck_report_target;
ALTER TABLE tbl_report ADD CONSTRAINT ck_report_target
    CHECK (target_type IN ('PROFILE', 'REQUEST', 'BOARD'));