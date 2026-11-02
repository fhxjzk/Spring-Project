-- ============================================================
-- 03_request.sql (③ 요청서·견적)
--
-- 요구사항: C-01-a~d 요청서, C-02 견적 확인·고수 선택, D-02 견적 전달, E-04 질문 항목 관리
--
-- 고수를 가리키는 expert_seq 의 값은 tbl_member.member_seq 와 같다. (02_expert.sql 규칙)
-- tbl_category 는 ② 담당이라 category_seq 의 FK 는 ② 테이블이 develop에 합쳐진 뒤에 추가한다.
-- ============================================================

-- 요청서 질문 항목 (E-04)
-- 이미 쓴 요청서의 답변이 남아 있어야 하므로 지우지 않고 enabled = 'N' 으로 바꾼다.
CREATE TABLE tbl_question (
    question_seq    NUMBER          NOT NULL,
    category_seq    NUMBER          NOT NULL,                   -- ② tbl_category 참조 예정
    content         VARCHAR2(500)   NOT NULL,
    question_type   VARCHAR2(20)    NOT NULL,                   -- SINGLE: 객관식 하나, MULTI: 객관식 여러 개, TEXT: 주관식
    required        CHAR(1)         DEFAULT 'Y' NOT NULL,
    sort_order      NUMBER          DEFAULT 0 NOT NULL,
    enabled         CHAR(1)         DEFAULT 'Y' NOT NULL,
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_question PRIMARY KEY (question_seq),
    CONSTRAINT ck_question_type CHECK (question_type IN ('SINGLE', 'MULTI', 'TEXT')),
    CONSTRAINT ck_question_required CHECK (required IN ('Y', 'N')),
    CONSTRAINT ck_question_enabled CHECK (enabled IN ('Y', 'N'))
);

CREATE SEQUENCE seq_question;

-- 객관식 질문의 보기 (E-04)
CREATE TABLE tbl_question_option (
    option_seq      NUMBER          NOT NULL,
    question_seq    NUMBER          NOT NULL,
    content         VARCHAR2(300)   NOT NULL,
    sort_order      NUMBER          DEFAULT 0 NOT NULL,
    enabled         CHAR(1)         DEFAULT 'Y' NOT NULL,
    CONSTRAINT pk_question_option PRIMARY KEY (option_seq),
    CONSTRAINT fk_question_option_question FOREIGN KEY (question_seq) REFERENCES tbl_question (question_seq),
    CONSTRAINT ck_question_option_enabled CHECK (enabled IN ('Y', 'N'))
);

CREATE SEQUENCE seq_question_option;

-- 요청서 (C-01-a 공개 요청, C-01-b 지정 요청, C-01-d 내 요청서 관리)
-- expert_seq 가 비어 있으면 공개 요청, 값이 있으면 그 고수에게 보낸 지정 요청이다.
-- 상태: OPEN 모집 중 / CLOSED 견적 마감 / SELECTED 선택 완료 / CANCELED 취소 / REJECTED 거절 / EXPIRED 만료
--   CANCELED 는 고객이 선택 전에 취소한 경우와, 선택 완료 후 거래가 취소된 경우(C-03-c) 모두 해당한다.
CREATE TABLE tbl_request (
    request_seq     NUMBER          NOT NULL,
    customer_seq    NUMBER          NOT NULL,                   -- 요청서를 쓴 고객
    expert_seq      NUMBER,                                     -- 지정 요청한 고수 (공개 요청은 NULL)
    category_seq    NUMBER          NOT NULL,                   -- ② tbl_category 참조 예정
    address         VARCHAR2(300)   NOT NULL,                   -- 요청 지역
    wish_date       DATE,                                       -- 희망 일정
    budget          NUMBER,                                     -- 예산 (원)
    content         VARCHAR2(4000),                             -- 추가 요청 사항
    status          VARCHAR2(20)    DEFAULT 'OPEN' NOT NULL,
    hidden          CHAR(1)         DEFAULT 'N' NOT NULL,       -- 신고 처리로 비공개 (E-02)
    quote_count     NUMBER          DEFAULT 0 NOT NULL,         -- 받은 견적 수
    quote_deadline  DATE            NOT NULL,                   -- 견적 마감 (등록 + 48시간)
    select_deadline DATE,                                       -- 고수 선택 마감 (견적 마감 + 7일, 마감될 때 채운다)
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_request PRIMARY KEY (request_seq),
    CONSTRAINT fk_request_customer FOREIGN KEY (customer_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT fk_request_expert FOREIGN KEY (expert_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT ck_request_status CHECK (status IN ('OPEN', 'CLOSED', 'SELECTED', 'CANCELED', 'REJECTED', 'EXPIRED')),
    CONSTRAINT ck_request_hidden CHECK (hidden IN ('Y', 'N')),
    CONSTRAINT ck_request_quote_count CHECK (quote_count BETWEEN 0 AND 5)
);

CREATE SEQUENCE seq_request;

-- 요청서의 질문 답변 (C-01-a)
-- 객관식은 option_seq, 주관식은 answer 에 저장한다. 여러 개 고르면 행이 여러 개다.
CREATE TABLE tbl_request_answer (
    answer_seq      NUMBER          NOT NULL,
    request_seq     NUMBER          NOT NULL,
    question_seq    NUMBER          NOT NULL,
    option_seq      NUMBER,
    answer          VARCHAR2(1000),
    CONSTRAINT pk_request_answer PRIMARY KEY (answer_seq),
    CONSTRAINT fk_request_answer_request FOREIGN KEY (request_seq) REFERENCES tbl_request (request_seq),
    CONSTRAINT fk_request_answer_question FOREIGN KEY (question_seq) REFERENCES tbl_question (question_seq),
    CONSTRAINT fk_request_answer_option FOREIGN KEY (option_seq) REFERENCES tbl_question_option (option_seq)
);

CREATE SEQUENCE seq_request_answer;

-- 요청서 참고 이미지 (C-01-c)
CREATE TABLE tbl_request_file (
    file_seq        NUMBER          NOT NULL,
    request_seq     NUMBER          NOT NULL,
    org_filename    VARCHAR2(300)   NOT NULL,                   -- 사용자가 올린 원래 파일 이름
    save_filename   VARCHAR2(300)   NOT NULL,                   -- 저장한 파일 이름 (UUID_원래이름)
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_request_file PRIMARY KEY (file_seq),
    CONSTRAINT fk_request_file_request FOREIGN KEY (request_seq) REFERENCES tbl_request (request_seq)
);

CREATE SEQUENCE seq_request_file;

-- 견적 (D-02 견적 전달, C-02 고수 선택)
-- 상태: WAITING 대기 / SELECTED 선택됨 / UNSELECTED 미선택
--   결제가 끝나야 SELECTED 가 되고, 나머지 견적은 UNSELECTED 가 된다. (C-03-a)
CREATE TABLE tbl_quote (
    quote_seq       NUMBER          NOT NULL,
    request_seq     NUMBER          NOT NULL,
    expert_seq      NUMBER          NOT NULL,                   -- 견적을 보낸 고수
    price           NUMBER          NOT NULL,                   -- 견적 금액 (원)
    work_days       NUMBER          NOT NULL,                   -- 예상 작업 기간 (일)
    content         VARCHAR2(4000)  NOT NULL,                   -- 견적 설명
    status          VARCHAR2(20)    DEFAULT 'WAITING' NOT NULL,
    regdate         DATE            DEFAULT sysdate NOT NULL,
    CONSTRAINT pk_quote PRIMARY KEY (quote_seq),
    CONSTRAINT fk_quote_request FOREIGN KEY (request_seq) REFERENCES tbl_request (request_seq),
    CONSTRAINT fk_quote_expert FOREIGN KEY (expert_seq) REFERENCES tbl_member (member_seq),
    CONSTRAINT uq_quote_request_expert UNIQUE (request_seq, expert_seq),
    CONSTRAINT ck_quote_status CHECK (status IN ('WAITING', 'SELECTED', 'UNSELECTED')),
    CONSTRAINT ck_quote_price CHECK (price > 0),
    CONSTRAINT ck_quote_work_days CHECK (work_days > 0)
);

CREATE SEQUENCE seq_quote;

-- ② tbl_category 가 develop에 합쳐지면 아래 FK 를 이 파일 CREATE 문에 넣는다.
-- CONSTRAINT fk_question_category FOREIGN KEY (category_seq) REFERENCES tbl_category (category_seq)
-- CONSTRAINT fk_request_category FOREIGN KEY (category_seq) REFERENCES tbl_category (category_seq)
