-- ============================================================
-- 02_expert.sql (② 고수·카테고리·리뷰)
--
-- 고수의 주소·좌표(위도·경도)는 tbl_member에 저장한다. (① 담당)
-- 고수를 가리키는 칼럼은 expert_seq를 쓰고, 값은 tbl_member.member_seq와 같다.
-- ============================================================

-- 서비스 카테고리 (E-03)
-- parent_seq가 비어 있으면 대분류, 값이 있으면 그 대분류의 소분류
CREATE TABLE tbl_category (
    category_seq    NUMBER          NOT NULL,
    parent_seq      NUMBER,
    name            VARCHAR2(50)    NOT NULL,
    sort_order      NUMBER          DEFAULT 0 NOT NULL,
    enabled         CHAR(1)         DEFAULT 'Y' NOT NULL,       -- Y: 사용, N: 사용 안 함
    CONSTRAINT pk_category PRIMARY KEY (category_seq),
    CONSTRAINT fk_category_parent FOREIGN KEY (parent_seq) REFERENCES tbl_category (category_seq),
    CONSTRAINT ck_category_enabled CHECK (enabled IN ('Y', 'N'))
);

CREATE SEQUENCE seq_category;

-- 고수 프로필 (D-01-a)
-- 회원 한 명당 프로필 하나. PK가 곧 회원 번호라서 시퀀스가 없다.
CREATE TABLE tbl_expert_profile (
    expert_seq      NUMBER          NOT NULL,                   -- tbl_member.member_seq
    intro           VARCHAR2(2000)  NOT NULL,                   -- 고수 소개
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_expert_profile PRIMARY KEY (expert_seq),
    CONSTRAINT fk_expert_profile_member FOREIGN KEY (expert_seq) REFERENCES tbl_member (member_seq)
);

-- 고수 경력 (D-01-a)
CREATE TABLE tbl_expert_career (
    career_seq      NUMBER          NOT NULL,
    expert_seq      NUMBER          NOT NULL,
    title           VARCHAR2(100)   NOT NULL,                   -- 회사·활동 이름
    start_date      DATE            NOT NULL,
    end_date        DATE,                                       -- 비어 있으면 현재 진행 중
    description     VARCHAR2(1000),
    CONSTRAINT pk_expert_career PRIMARY KEY (career_seq),
    CONSTRAINT fk_expert_career_expert FOREIGN KEY (expert_seq) REFERENCES tbl_expert_profile (expert_seq)
);

CREATE SEQUENCE seq_career;

-- 고수가 제공하는 서비스 (D-01-b)
-- 고수가 받는 요청서 카테고리(D-02)도 이 테이블의 category_seq로 알아낸다.
CREATE TABLE tbl_talent (
    talent_seq      NUMBER          NOT NULL,
    expert_seq      NUMBER          NOT NULL,
    category_seq    NUMBER          NOT NULL,
    title           VARCHAR2(100)   NOT NULL,
    content         VARCHAR2(4000)  NOT NULL,
    price           NUMBER          NOT NULL,
    enabled         CHAR(1)         DEFAULT 'Y' NOT NULL,       -- Y: 사용, N: 삭제
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_talent PRIMARY KEY (talent_seq),
    CONSTRAINT fk_talent_expert FOREIGN KEY (expert_seq) REFERENCES tbl_expert_profile (expert_seq),
    CONSTRAINT fk_talent_category FOREIGN KEY (category_seq) REFERENCES tbl_category (category_seq),
    CONSTRAINT ck_talent_price CHECK (price >= 0),
    CONSTRAINT ck_talent_enabled CHECK (enabled IN ('Y', 'N'))
);

CREATE SEQUENCE seq_talent;

-- 포트폴리오 사진 (D-01-a, D-01-b)
-- talent_seq가 비어 있으면 프로필 전체 포트폴리오, 값이 있으면 그 서비스의 사진
CREATE TABLE tbl_portfolio (
    portfolio_seq   NUMBER          NOT NULL,
    expert_seq      NUMBER          NOT NULL,
    talent_seq      NUMBER,
    file_name       VARCHAR2(200)   NOT NULL,                   -- 서버에 저장한 파일 이름
    origin_name     VARCHAR2(200)   NOT NULL,                   -- 업로드한 원래 파일 이름
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_portfolio PRIMARY KEY (portfolio_seq),
    CONSTRAINT fk_portfolio_expert FOREIGN KEY (expert_seq) REFERENCES tbl_expert_profile (expert_seq),
    CONSTRAINT fk_portfolio_talent FOREIGN KEY (talent_seq) REFERENCES tbl_talent (talent_seq)
);

CREATE SEQUENCE seq_portfolio;

-- 리뷰·별점 (C-04), 고수 답변 (D-04)
-- 평균 별점은 저장하지 않고 AVG(rating)으로 계산한다.
CREATE TABLE tbl_review (
    review_seq      NUMBER          NOT NULL,
    trade_seq       NUMBER          NOT NULL,                   -- 거래 하나에 리뷰 하나
    customer_seq    NUMBER          NOT NULL,                   -- 작성한 고객 (tbl_member.member_seq)
    expert_seq      NUMBER          NOT NULL,
    rating          NUMBER(1)       NOT NULL,                   -- 1 ~ 5
    content         VARCHAR2(2000)  NOT NULL,
    reply           VARCHAR2(2000),                             -- 고수 답변
    reply_date      DATE,
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_review PRIMARY KEY (review_seq),
    CONSTRAINT uq_review_trade UNIQUE (trade_seq),
    -- TODO: ④ tbl_trade가 02보다 나중에 만들어져서 여기서는 FK를 걸 수 없다. 04_trade.sql에서 추가하기로 정하면 옮긴다.
    -- CONSTRAINT fk_review_trade FOREIGN KEY (trade_seq) REFERENCES tbl_trade (trade_seq),
    CONSTRAINT fk_review_customer FOREIGN KEY (customer_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT fk_review_expert FOREIGN KEY (expert_seq) REFERENCES tbl_expert_profile (expert_seq),
    CONSTRAINT ck_review_rating CHECK (rating BETWEEN 1 AND 5)
);

CREATE SEQUENCE seq_review;

-- 찜하기 (추가 기능)
CREATE TABLE tbl_wish (
    member_seq      NUMBER          NOT NULL,                   -- 찜한 회원
    expert_seq      NUMBER          NOT NULL,
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_wish PRIMARY KEY (member_seq, expert_seq),
    CONSTRAINT fk_wish_member FOREIGN KEY (member_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT fk_wish_expert FOREIGN KEY (expert_seq) REFERENCES tbl_expert_profile (expert_seq)
);
