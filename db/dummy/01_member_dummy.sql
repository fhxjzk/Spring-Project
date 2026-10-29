-- ============================================================
-- dummy/01_member_dummy.sql (회원·공통)
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

INSERT INTO tbl_member (member_seq, id, pw, name, email, role, address, latitude, longitude) VALUES (seq_member.nextval, 'customer1', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고객1', 'customer1@test.com', 'ROLE_CUSTOMER', '서울 강남구 테헤란로 152', 37.5000690, 127.0364560);
INSERT INTO tbl_member (member_seq, id, pw, name, email, role, address, latitude, longitude) VALUES (seq_member.nextval, 'customer2', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고객2', 'customer2@test.com', 'ROLE_CUSTOMER', '서울 마포구 양화로 160', 37.5572000, 126.9245000);
INSERT INTO tbl_member (member_seq, id, pw, name, email, role, address, latitude, longitude) VALUES (seq_member.nextval, 'customer3', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고객3', 'customer3@test.com', 'ROLE_CUSTOMER', '서울 송파구 올림픽로 300', 37.5126000, 127.1025000);

INSERT INTO tbl_member (member_seq, id, pw, name, email, role, address, latitude, longitude) VALUES (seq_member.nextval, 'expert1', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고수1', 'expert1@test.com', 'ROLE_EXPERT', '서울 강남구 강남대로 396', 37.4979000, 127.0276000);
INSERT INTO tbl_member (member_seq, id, pw, name, email, role, address, latitude, longitude) VALUES (seq_member.nextval, 'expert2', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고수2', 'expert2@test.com', 'ROLE_EXPERT', '서울 용산구 한강대로 405', 37.5547000, 126.9707000);
INSERT INTO tbl_member (member_seq, id, pw, name, email, role, address, latitude, longitude) VALUES (seq_member.nextval, 'expert3', '$2a$10$eTdtvYdo62mVseiilZ7RFeOx7ATX1L4wNEt0h/G/CuwFaIEdjbvkC', '고수3', 'expert3@test.com', 'ROLE_EXPERT', '경기 성남시 분당구 판교역로 160', 37.3948000, 127.1112000);

COMMIT;
