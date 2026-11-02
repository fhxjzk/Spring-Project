-- ============================================================
-- 01_member.sql (① 회원·공통)
--
-- 로그인에 필요한 칼럼 + 회원가입 요구사항(A-01)의 위치 칼럼.

-- ============================================================


CREATE TABLE tbl_member (
    member_seq      NUMBER          NOT NULL,
    id              VARCHAR2(50)    NOT NULL,
    pw              VARCHAR2(100)   NOT NULL,                       -- BCrypt 암호화 값
    name            VARCHAR2(50)    NOT NULL,
    email           VARCHAR2(100)   NOT NULL,
    role            VARCHAR2(20)    DEFAULT 'ROLE_CUSTOMER' NOT NULL,
    address         VARCHAR2(300),                                  -- 기본 주소 (관리자는 비움)
    latitude        NUMBER(10, 7),                                  -- 위도
    longitude       NUMBER(10, 7),                                  -- 경도
    enabled         CHAR(1)         DEFAULT 'Y' NOT NULL,           -- Y: 사용, N: 탈퇴
    regdate         DATE            DEFAULT sysdate NOT NULL,       -- 가입일
    moddate         DATE            DEFAULT sysdate NOT NULL,       -- 정보 수정일
    withdraw_date   DATE,                                           -- 탈퇴일
    last_login_date DATE,                                           -- 마지막 로그인 일시
    CONSTRAINT pk_member PRIMARY KEY (member_seq),
    CONSTRAINT uq_member_id UNIQUE (id),
    CONSTRAINT uq_member_email UNIQUE (email),
    CONSTRAINT ck_member_role CHECK (role IN ('ROLE_CUSTOMER', 'ROLE_EXPERT', 'ROLE_ADMIN')),
    CONSTRAINT ck_member_enabled CHECK (enabled IN ('Y', 'N')),
    CONSTRAINT ck_member_latitude CHECK (latitude BETWEEN -90 AND 90),
    CONSTRAINT ck_member_longitude CHECK (longitude BETWEEN -180 AND 180)
);

CREATE SEQUENCE seq_member;