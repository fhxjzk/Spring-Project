-- ============================================================
-- 01_member.sql (① 회원·공통)
--
-- 기본 프로젝트의 로그인에 필요한 최소 칼럼만 있다.
-- 주소, 좌표(위도·경도) 등 회원가입 요구사항(A-01) 칼럼은 ① 담당자가 추가한다.
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
