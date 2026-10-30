-- ============================================================
-- 04_trade.sql (④ 결제·거래·통계)
--
-- tbl_member.point   포인트 잔액 (① 회원 테이블에 칼럼만 추가)
-- tbl_trade          거래 (결제할 때 만들어진다)
-- tbl_trade_file     납품 결과물 파일
-- tbl_point_history  포인트 내역 (충전, 결제, 정산, 환불)
--
-- 거래 상태 (tbl_trade.status) - 순서도 "거래 상태 흐름"
--   PAID         결제 완료   고객 포인트를 플랫폼이 보관 중
--   IN_PROGRESS  진행 중     고수가 작업 시작
--   DELIVERED    납품 완료   고수가 작업 완료 (온라인 작업은 결과물 첨부)
--   CONFIRMED    구매 확정   고수에게 정산 (납품 후 7일이 지나면 자동)
--   CANCELED     취소        작업 시작 전 고객이 취소 → 포인트 환불
--
-- 포인트 내역 종류 (tbl_point_history.history_type)
--   CHARGE 충전(+), PAY 결제(-), SETTLE 정산(+), REFUND 환불(+)
-- ============================================================

-- 포인트 잔액. 회원 테이블은 ① 담당이라 여기서 칼럼만 추가한다.
ALTER TABLE tbl_member ADD point NUMBER DEFAULT 0 NOT NULL;
ALTER TABLE tbl_member ADD CONSTRAINT ck_member_point CHECK (point >= 0);

CREATE TABLE tbl_trade (
    trade_seq       NUMBER          NOT NULL,
    request_seq     NUMBER          NOT NULL,                       -- 요청서 (③)
    quote_seq       NUMBER          NOT NULL,                       -- 선택한 견적 (③)
    customer_seq    NUMBER          NOT NULL,                       -- 고객
    expert_seq      NUMBER          NOT NULL,                       -- 고수
    price           NUMBER          NOT NULL,                       -- 거래 금액 = 견적 금액
    status          VARCHAR2(20)    DEFAULT 'PAID' NOT NULL,
    regdate         DATE            DEFAULT sysdate NOT NULL,       -- 결제 (거래 생성)
    start_date      DATE,                                           -- 작업 시작
    delivered_date  DATE,                                           -- 납품 완료
    confirm_date    DATE,                                           -- 구매 확정
    cancel_date     DATE,                                           -- 취소
    CONSTRAINT pk_trade PRIMARY KEY (trade_seq),
    CONSTRAINT uq_trade_quote UNIQUE (quote_seq),
    CONSTRAINT fk_trade_customer FOREIGN KEY (customer_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT fk_trade_expert FOREIGN KEY (expert_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT ck_trade_price CHECK (price > 0),
    CONSTRAINT ck_trade_status CHECK (status IN ('PAID', 'IN_PROGRESS', 'DELIVERED', 'CONFIRMED', 'CANCELED'))
);

CREATE SEQUENCE seq_trade;

-- ③ 요청서·견적 FK (03_request.sql이 먼저 실행되어 있어야 한다)
ALTER TABLE tbl_trade ADD CONSTRAINT fk_trade_request FOREIGN KEY (request_seq) REFERENCES tbl_request (request_seq);
ALTER TABLE tbl_trade ADD CONSTRAINT fk_trade_quote FOREIGN KEY (quote_seq) REFERENCES tbl_quote (quote_seq);

-- ② 리뷰(tbl_review.trade_seq)의 FK. tbl_review는 02에서 만들어지는데 tbl_trade가 더 늦게 생겨서 여기서 건다.
-- ② 테이블이 develop에 합쳐지면 주석을 푼다.
-- ALTER TABLE tbl_review ADD CONSTRAINT fk_review_trade FOREIGN KEY (trade_seq) REFERENCES tbl_trade (trade_seq);

CREATE TABLE tbl_trade_file (
    trade_file_seq  NUMBER          NOT NULL,
    trade_seq       NUMBER          NOT NULL,
    orgname         VARCHAR2(300)   NOT NULL,                       -- 올린 파일 이름
    filename        VARCHAR2(400)   NOT NULL,                       -- 저장한 파일 이름 (UUID_원래이름)
    filesize        NUMBER          NOT NULL,                       -- 바이트
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_trade_file PRIMARY KEY (trade_file_seq),
    CONSTRAINT fk_trade_file_trade FOREIGN KEY (trade_seq) REFERENCES tbl_trade (trade_seq)
);

CREATE SEQUENCE seq_trade_file;

CREATE TABLE tbl_point_history (
    point_history_seq   NUMBER          NOT NULL,
    member_seq          NUMBER          NOT NULL,
    history_type        VARCHAR2(20)    NOT NULL,                   -- CHARGE, PAY, SETTLE, REFUND
    amount              NUMBER          NOT NULL,                   -- 들어오면 +, 나가면 -
    balance             NUMBER          NOT NULL,                   -- 처리 후 잔액
    trade_seq           NUMBER,                                     -- 관련 거래 (충전은 null)
    regdate             DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_point_history PRIMARY KEY (point_history_seq),
    CONSTRAINT fk_point_history_member FOREIGN KEY (member_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT fk_point_history_trade FOREIGN KEY (trade_seq) REFERENCES tbl_trade (trade_seq),
    CONSTRAINT ck_point_history_type CHECK (history_type IN ('CHARGE', 'PAY', 'SETTLE', 'REFUND'))
);

CREATE SEQUENCE seq_point_history;
