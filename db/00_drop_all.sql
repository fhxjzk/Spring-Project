-- ============================================================
-- 00_drop_all.sql
-- 모든 테이블과 시퀀스를 지운다. (처음부터 다시 만들 때 실행)
--
-- 실행 순서: 00_drop_all.sql → 01 ~ 06 테이블 → dummy/01 ~ 06 더미 데이터
--
-- 테이블을 추가한 파트는 여기에 DROP 문을 추가한다.
-- FK 때문에 만든 순서의 "반대"로 지운다. (06 → 01 순서로 위에서부터 적는다)
-- 처음 실행할 때 "테이블 또는 뷰가 존재하지 않습니다" 오류는 무시해도 된다.
-- ============================================================

-- 06 ⑥ 검색·신고·커뮤니티
DROP TABLE tbl_report CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_expert_region CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_region CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_report;

-- 05 ⑤ 채팅·알림

-- 04 ④ 결제·거래·포인트 (tbl_member.point 칼럼은 tbl_member와 같이 지워진다)
DROP TABLE tbl_point_history CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_trade_file CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_trade CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_point_history;
DROP SEQUENCE seq_trade_file;
DROP SEQUENCE seq_trade;

-- 03 ③ 요청서·견적
DROP TABLE tbl_quote CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_request_file CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_request_answer CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_request CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_question_option CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_question CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_quote;
DROP SEQUENCE seq_request_file;
DROP SEQUENCE seq_request_answer;
DROP SEQUENCE seq_request;
DROP SEQUENCE seq_question_option;
DROP SEQUENCE seq_question;

-- 02 ② 고수·카테고리·리뷰
DROP TABLE tbl_wish CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_review CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_review;
DROP TABLE tbl_talent_portfolio CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_portfolio_image CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_portfolio_image;
DROP TABLE tbl_portfolio CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_portfolio;
DROP TABLE tbl_talent CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_talent;
DROP TABLE tbl_expert_career CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_career;
DROP TABLE tbl_expert_profile CASCADE CONSTRAINTS PURGE;
DROP TABLE tbl_category CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_category;

-- 01 ① 회원
DROP TABLE tbl_member CASCADE CONSTRAINTS PURGE;
DROP SEQUENCE seq_member;
