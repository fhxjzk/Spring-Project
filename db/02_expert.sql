-- ============================================================
-- 02_expert.sql (② 고수·카테고리·리뷰)
--
-- 고수의 "서비스 제공 위치"(주소·좌표)는 tbl_member가 아니라
-- tbl_expert_profile에 별도로 저장한다. (② 담당)
--   - tbl_member.address/latitude/longitude  : 가입 시 받는 기본 위치 (거주지 느낌,
--     B-04 검색의 기본 검색 기준 위치)
--   - tbl_expert_profile.service_address 등  : 고수가 실제 서비스를 제공하는 위치
--     (D-01-a에서 등록, B-04 거리 필터·지도 표시에 실제로 쓰이는 값)
-- 두 값은 의미가 달라 같은 칼럼을 공유하지 않는다. (회원가입 때는 집 주소를 쓰고,
-- 고수가 프로필을 등록할 때 영업 위치를 따로 입력받는 식)
--
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
-- service_address/service_latitude/service_longitude 는 고수가 서비스를 제공하는
-- 활동지역·기준 지점 좌표다. tbl_member의 address/latitude/longitude(거주지 느낌,
-- 가입 시 기본 검색 기준 위치)와는 다른 값이라 이름을 구분했다.
CREATE TABLE tbl_expert_profile (
    expert_seq          NUMBER          NOT NULL,                   -- tbl_member.member_seq
    intro               VARCHAR2(2000)  NOT NULL,                   -- 고수 소개
    service_address     VARCHAR2(300)   NOT NULL,                   -- 서비스 제공 위치 주소(활동지역)
    service_latitude    NUMBER(10, 7)   NOT NULL,                   -- 서비스 제공 위치 위도
    service_longitude   NUMBER(10, 7)   NOT NULL,                   -- 서비스 제공 위치 경도
    regdate             DATE            DEFAULT sysdate NOT NULL,
    hidden              CHAR(1)         DEFAULT 'N'     NOT NULL,   -- 신고 처리로 숨김(Y/N) (E-02)
    CONSTRAINT pk_expert_profile PRIMARY KEY (expert_seq),
    CONSTRAINT fk_expert_profile_member FOREIGN KEY (expert_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT ck_expert_profile_hidden CHECK (hidden IN ('Y', 'N'))
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

-- 포트폴리오 글 (D-01-a)
-- 게시글처럼 제목·내용·사진 여러 장으로 작성한다.
-- 거래·리뷰가 참조하지 않아서 실제로 지운다. (사진·서비스 연결도 같이 지워진다)
CREATE TABLE tbl_portfolio (
    portfolio_seq   NUMBER          NOT NULL,
    expert_seq      NUMBER          NOT NULL,
    title           VARCHAR2(100)   NOT NULL,
    content         VARCHAR2(4000)  NOT NULL,
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_portfolio PRIMARY KEY (portfolio_seq),
    CONSTRAINT fk_portfolio_expert FOREIGN KEY (expert_seq) REFERENCES tbl_expert_profile (expert_seq)
);

CREATE SEQUENCE seq_portfolio;

-- 포트폴리오 글에 올린 사진
-- 글 하나에 최대 5장. slot은 1 ~ 5만 쓸 수 있고 한 글에서 겹칠 수 없다.
-- 글을 지워도 서버에 저장한 파일은 남으니, 글을 지우기 전에 파일도 지운다.
CREATE TABLE tbl_portfolio_image (
    image_seq       NUMBER          NOT NULL,
    portfolio_seq   NUMBER          NOT NULL,
    file_name       VARCHAR2(200)   NOT NULL,                   -- 서버에 저장한 파일 이름
    origin_name     VARCHAR2(200)   NOT NULL,                   -- 업로드한 원래 파일 이름
    slot            NUMBER(1)       NOT NULL,                   -- 1 ~ 5, 보여주는 순서 (1이 대표 사진)
    CONSTRAINT pk_portfolio_image PRIMARY KEY (image_seq),
    CONSTRAINT uq_portfolio_image_slot UNIQUE (portfolio_seq, slot),
    CONSTRAINT ck_portfolio_image_slot CHECK (slot BETWEEN 1 AND 5),
    CONSTRAINT fk_portfolio_image_portfolio FOREIGN KEY (portfolio_seq) REFERENCES tbl_portfolio (portfolio_seq) ON DELETE CASCADE
);

CREATE SEQUENCE seq_portfolio_image;

-- 서비스에 연결한 포트폴리오 글 (D-01-b)
-- 서비스 하나에 최대 3개. slot은 1 ~ 3만 쓸 수 있고 한 서비스에서 겹칠 수 없다.
CREATE TABLE tbl_talent_portfolio (
    talent_seq      NUMBER          NOT NULL,
    portfolio_seq   NUMBER          NOT NULL,
    slot            NUMBER(1)       NOT NULL,                   -- 1 ~ 3, 보여주는 순서
    CONSTRAINT pk_talent_portfolio PRIMARY KEY (talent_seq, portfolio_seq),
    CONSTRAINT uq_talent_portfolio_slot UNIQUE (talent_seq, slot),
    CONSTRAINT ck_talent_portfolio_slot CHECK (slot BETWEEN 1 AND 3),
    CONSTRAINT fk_talent_portfolio_talent FOREIGN KEY (talent_seq) REFERENCES tbl_talent (talent_seq),
    CONSTRAINT fk_talent_portfolio_portfolio FOREIGN KEY (portfolio_seq) REFERENCES tbl_portfolio (portfolio_seq) ON DELETE CASCADE
);

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
