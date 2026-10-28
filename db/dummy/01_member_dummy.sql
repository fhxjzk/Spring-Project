-- ============================================================
-- dummy/01_member_dummy.sql (① 회원·공통)
--
-- 테스트 계정. 비밀번호는 모두 1111
-- 00_drop_all.sql로 지운 뒤 실행해야 회원 번호가 아래와 같이 나온다.
-- 다른 파트 더미 데이터는 이 번호를 FK로 쓴다.
--
--   1      admin              관리자
--   2 ~ 4  customer1 ~ 3      고객
--   5 ~ 7  expert1 ~ 3        고수
-- ============================================================

INSERT INTO tbl_member (member_seq, id, pw, name, email, role) VALUES (seq_member.nextval, 'admin', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '관리자', 'admin@test.com', 'ROLE_ADMIN');

INSERT INTO tbl_member (member_seq, id, pw, name, email, role) VALUES (seq_member.nextval, 'customer1', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고객일', 'customer1@test.com', 'ROLE_CUSTOMER');
INSERT INTO tbl_member (member_seq, id, pw, name, email, role) VALUES (seq_member.nextval, 'customer2', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고객이', 'customer2@test.com', 'ROLE_CUSTOMER');
INSERT INTO tbl_member (member_seq, id, pw, name, email, role) VALUES (seq_member.nextval, 'customer3', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고객삼', 'customer3@test.com', 'ROLE_CUSTOMER');

INSERT INTO tbl_member (member_seq, id, pw, name, email, role) VALUES (seq_member.nextval, 'expert1', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고수일', 'expert1@test.com', 'ROLE_EXPERT');
INSERT INTO tbl_member (member_seq, id, pw, name, email, role) VALUES (seq_member.nextval, 'expert2', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고수이', 'expert2@test.com', 'ROLE_EXPERT');
INSERT INTO tbl_member (member_seq, id, pw, name, email, role) VALUES (seq_member.nextval, 'expert3', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고수삼', 'expert3@test.com', 'ROLE_EXPERT');

COMMIT;
