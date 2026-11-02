
-- ============================================================
-- 05_chat.sql
-- 채팅방 / 채팅 메시지 / 알림 테이블
--
-- 신규 DB 설치용 SQL
-- 기존 데이터가 있는 DB에서는 실행하지 말 것
--
-- 실행 순서:
-- 01 회원 → 03 요청/견적 → 04 거래 → 05 채팅/알림
--
-- 기존 채팅 메시지 및 알림 데이터 보존 필요
-- ============================================================


-- ============================================================
-- 1. 채팅방 테이블
-- 거래 하나당 채팅방 하나
-- ============================================================

CREATE TABLE tbl_chat_room (
    chat_room_seq NUMBER(19) PRIMARY KEY,
    trade_seq NUMBER(19) NOT NULL,
    customer_seq NUMBER(19) NOT NULL,
    expert_seq NUMBER(19) NOT NULL,
    regdate DATE DEFAULT SYSDATE NOT NULL,

    CONSTRAINT uq_chat_room_trade
        UNIQUE (trade_seq),

    CONSTRAINT fk_chat_room_trade
        FOREIGN KEY (trade_seq)
        REFERENCES tbl_trade (trade_seq),

    CONSTRAINT fk_chat_room_customer
        FOREIGN KEY (customer_seq)
        REFERENCES tbl_member (member_seq),

    CONSTRAINT fk_chat_room_expert
        FOREIGN KEY (expert_seq)
        REFERENCES tbl_member (member_seq),

    CONSTRAINT ck_chat_room_members
        CHECK (customer_seq <> expert_seq)
);

CREATE SEQUENCE seq_chat_room
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


-- ============================================================
-- 2. 채팅 메시지 테이블
-- ============================================================

CREATE TABLE tbl_chat_message (
    chat_message_seq NUMBER(19) PRIMARY KEY,
    chat_room_seq NUMBER(19) NOT NULL,
    sender_seq NUMBER(19) NOT NULL,
    content VARCHAR2(4000) NOT NULL,
    regdate DATE DEFAULT SYSDATE NOT NULL,

    CONSTRAINT fk_chat_message_room
        FOREIGN KEY (chat_room_seq)
        REFERENCES tbl_chat_room (chat_room_seq),

    CONSTRAINT fk_chat_message_sender
        FOREIGN KEY (sender_seq)
        REFERENCES tbl_member (member_seq)
);

CREATE SEQUENCE seq_chat_message
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE INDEX idx_chat_message_room
ON tbl_chat_message (
    chat_room_seq,
    chat_message_seq
);


-- ============================================================
-- 3. 알림 테이블
-- 기존 NoticeMapper.xml과 CREATED_AT 컬럼 통일
-- ============================================================

CREATE TABLE tbl_notice (
    notice_seq NUMBER(19) PRIMARY KEY,
    receiver_seq NUMBER(19) NOT NULL,
    notification_type VARCHAR2(50) NOT NULL,
    title VARCHAR2(200) NOT NULL,
    message VARCHAR2(1000) NOT NULL,
    reference_id NUMBER(19),
    is_read CHAR(1) DEFAULT 'N' NOT NULL,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT fk_notice_receiver
        FOREIGN KEY (receiver_seq)
        REFERENCES tbl_member (member_seq),

    CONSTRAINT ck_notice_read
        CHECK (is_read IN ('Y', 'N'))
);

CREATE SEQUENCE seq_notice
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE INDEX idx_notice_receiver
ON tbl_notice (
    receiver_seq,
    created_at DESC
);
