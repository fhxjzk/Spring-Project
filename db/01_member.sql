-- ============================================================
-- 01_member.sql (① 회원·공통)
--
-- 로그인에 필요한 칼럼 + 회원가입 요구사항(A-01)의 위치 칼럼.

-- ============================================================

CREATE TABLE tbl_member (
    member_seq  NUMBER          NOT NULL,
    id          VARCHAR2(50)    NOT NULL,
    pw          VARCHAR2(100)   NOT NULL,                       -- BCrypt 암호화 값
    name        VARCHAR2(50)    NOT NULL,
    email       VARCHAR2(100)   NOT NULL,
    role        VARCHAR2(20)    DEFAULT 'ROLE_CUSTOMER' NOT NULL,
    enabled     CHAR(1)         DEFAULT 'Y' NOT NULL,           -- Y: 사용, N: 탈퇴
    regdate     DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_member PRIMARY KEY (member_seq),
    CONSTRAINT uq_member_id UNIQUE (id),
    CONSTRAINT ck_member_role CHECK (role IN ('ROLE_CUSTOMER', 'ROLE_EXPERT', 'ROLE_ADMIN')),
    CONSTRAINT ck_member_enabled CHECK (enabled IN ('Y', 'N'))
);

CREATE SEQUENCE seq_member;
