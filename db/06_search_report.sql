CREATE TABLE tbl_category (
    category_id    NUMBER PRIMARY KEY,
    category_name  VARCHAR2(50) NOT NULL,
    parent_id      NUMBER,
    CONSTRAINT fk_category_parent FOREIGN KEY (parent_id) REFERENCES tbl_category(category_id)
);
CREATE TABLE tbl_region (
    region_id    NUMBER PRIMARY KEY,
    region_name  VARCHAR2(30) NOT NULL
);
CREATE TABLE tbl_expert_region (
    expert_id   NUMBER NOT NULL,
    region_id   NUMBER NOT NULL,
    PRIMARY KEY (expert_id, region_id),
    CONSTRAINT fk_er_region FOREIGN KEY (region_id) REFERENCES tbl_region(region_id)
);
CREATE TABLE tbl_report (
    report_id       NUMBER PRIMARY KEY,
    reporter_id     VARCHAR2(50) NOT NULL,
    target_type     VARCHAR2(20) NOT NULL,
    target_id       NUMBER NOT NULL,
    reason_type     VARCHAR2(30) NOT NULL,
    reason_detail   VARCHAR2(500),
    status          VARCHAR2(20) DEFAULT '대기',
    reg_date        DATE DEFAULT SYSDATE,
    process_date    DATE
);
CREATE SEQUENCE seq_report_id START WITH 1 INCREMENT BY 1 NOCACHE;