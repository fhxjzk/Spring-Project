-- ============================================================
-- 06_report.sql (⑥ 검색·신고·DB)
--
-- 요구사항: B-04 고수 검색·지도 조회, B-07 신고, E-02 신고 검토·처리
--
-- tbl_region 의 INSERT 는 더미 데이터가 아니라 화면 드롭다운에 쓰는
-- 기준 데이터(코드값)라서 이 파일에 함께 둔다.
-- tbl_category 는 ② 담당(E-03 카테고리 관리)이라 여기에 없다.
-- ============================================================

-- 지역 (검색 드롭다운용 · 시도 17개)
-- 좌표는 각 시청·도청 기준 대략값. 지도 중심과 거리 계산에 쓴다.
CREATE TABLE tbl_region (
    region_seq   NUMBER          NOT NULL,
    region_name  VARCHAR2(90)    NOT NULL,
    center_lat   NUMBER(10,7)    NOT NULL,                   -- 지역 중심 위도
    center_lng   NUMBER(10,7)    NOT NULL,                   -- 지역 중심 경도
    CONSTRAINT pk_region PRIMARY KEY (region_seq),
    CONSTRAINT uq_region_name UNIQUE (region_name)
);

-- 고수 활동지역 (고수 한 명이 여러 지역 가능)
CREATE TABLE tbl_expert_region (
    expert_seq   NUMBER          NOT NULL,                   -- ② tbl_expert_profile.expert_seq
    region_seq   NUMBER          NOT NULL,
    CONSTRAINT pk_expert_region PRIMARY KEY (expert_seq, region_seq),
    CONSTRAINT fk_expert_region_region FOREIGN KEY (region_seq)
        REFERENCES tbl_region(region_seq),
    CONSTRAINT fk_expert_region_expert FOREIGN KEY (expert_seq)
        REFERENCES tbl_expert_profile(expert_seq)
);

-- 신고 (B-07 접수 · E-02 검토·처리)
-- 회원이 쓴 신고 사유(reason_detail)와 관리자가 쓴 처리 사유(process_reason)는
-- 요구분석서 E-02 제약 4에 따라 따로 관리한다.
CREATE TABLE tbl_report (
    report_seq      NUMBER          NOT NULL,
    reporter_seq    NUMBER          NOT NULL,                -- 신고한 회원
    target_type     VARCHAR2(20)    NOT NULL,                -- PROFILE / REQUEST
    target_seq      NUMBER          NOT NULL,                -- 신고 대상 번호
    reason_type     VARCHAR2(20)    NOT NULL,                -- ABUSE / FALSE_INFO / FRAUD / ETC
    reason_detail   VARCHAR2(4000),                          -- 회원이 쓴 상세 내용
    status          VARCHAR2(20)    DEFAULT 'RECEIVED' NOT NULL,
    process_reason  VARCHAR2(4000),                          -- 관리자가 쓴 처리 사유
    admin_seq       NUMBER,                                  -- 처리한 관리자
    regdate         DATE            DEFAULT sysdate NOT NULL,
    process_date    DATE,
    CONSTRAINT pk_report PRIMARY KEY (report_seq),
    CONSTRAINT fk_report_reporter FOREIGN KEY (reporter_seq) REFERENCES tbl_member(member_seq),
    CONSTRAINT fk_report_admin FOREIGN KEY (admin_seq) REFERENCES tbl_member(member_seq),
    CONSTRAINT ck_report_target CHECK (target_type IN ('PROFILE', 'REQUEST')),
    CONSTRAINT ck_report_reason CHECK (reason_type IN ('ABUSE', 'FALSE_INFO', 'FRAUD', 'ETC')),
    CONSTRAINT ck_report_status CHECK (status IN ('RECEIVED', 'REVIEWING', 'DONE', 'REJECTED')),
    CONSTRAINT ck_report_etc CHECK (reason_type <> 'ETC' OR reason_detail IS NOT NULL)
);

CREATE SEQUENCE seq_report;

-- ------------------------------------------------------------
-- 지역 기준 데이터
-- 화면의 "전국"은 지역을 고르지 않은 상태로 처리한다. (0번 행을 두지 않는다)
-- 전국에서 활동하는 고수는 tbl_expert_region 에 17개 지역을 모두 등록한다.
-- ------------------------------------------------------------
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (1,  '서울', 37.5665, 126.9780);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (2,  '경기', 37.2636, 127.0286);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (3,  '인천', 37.4563, 126.7052);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (4,  '세종', 36.4800, 127.2890);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (5,  '강원', 37.8813, 127.7300);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (6,  '충북', 36.6424, 127.4890);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (7,  '충남', 36.6588, 126.6728);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (8,  '대전', 36.3504, 127.3845);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (9,  '경북', 36.5684, 128.7294);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (10, '대구', 35.8714, 128.6014);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (11, '전북', 35.8242, 127.1480);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (12, '전남', 34.8161, 126.4630);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (13, '광주', 35.1595, 126.8526);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (14, '경남', 35.2280, 128.6811);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (15, '울산', 35.5384, 129.3114);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (16, '부산', 35.1796, 129.0756);
INSERT INTO tbl_region (region_seq, region_name, center_lat, center_lng) VALUES (17, '제주', 33.4996, 126.5312);

COMMIT;
