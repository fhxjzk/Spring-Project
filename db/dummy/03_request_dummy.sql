-- ============================================================
-- dummy/03_request_dummy.sql (③ 요청서·견적)
--
-- 회원 번호는 dummy/01_member_dummy.sql 기준이다.
--   2 ~ 4  customer1 ~ 3      고객
--   5 ~ 7  expert1 ~ 3        고수
--
-- category_seq 는 ② 카테고리 더미가 나오기 전이라 임시로 1, 2 를 쓴다.
-- ② 더미가 합쳐지면 실제 소분류 번호로 바꾼다.
--
-- 00_drop_all.sql로 지운 뒤 실행해야 번호가 아래와 같이 나온다.
-- ④ 거래 더미는 선택된 견적 4번(요청서 4번)을 쓰면 된다.
--
--   요청서  상태        고객        종류
--   1       OPEN        customer1   공개 요청, 견적 2개 (견적 1, 2)
--   2       CLOSED      customer2   공개 요청, 견적 1개 (견적 3)
--   3       OPEN        customer3   expert1 지정 요청, 견적 없음
--   4       SELECTED    customer1   공개 요청, 견적 4 선택됨 / 견적 5 미선택
--   5       CANCELED    customer2   공개 요청, 고객이 선택 전에 취소
-- ============================================================

-- 질문 항목 (카테고리 1)
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 1, '레슨 경험이 있나요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 1, '원하는 레슨 요일을 모두 골라 주세요.', 'MULTI', 'Y', 2);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 1, '고수에게 전하고 싶은 말이 있나요?', 'TEXT', 'N', 3);

-- 보기 (질문 1: 1~3, 질문 2: 4~7)
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 1, '처음이에요', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 1, '1년 미만', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 1, '1년 이상', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 2, '평일 오전', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 2, '평일 오후', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 2, '평일 저녁', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 2, '주말', 4);

-- 요청서
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 2, NULL, 1, '서울 강남구', sysdate + 7, 50000, '기초부터 배우고 싶어요.', 'OPEN', 2, sysdate + 1, NULL, sysdate - 1);
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 3, NULL, 1, '서울 서초구', sysdate + 10, 80000, '주 2회 레슨 원해요.', 'CLOSED', 1, sysdate - 1, sysdate + 6, sysdate - 3);
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 4, 5, 2, '서울 마포구', sysdate + 5, 120000, '고수님께 직접 요청드려요.', 'OPEN', 0, sysdate + 2, NULL, sysdate);
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 2, NULL, 2, '서울 송파구', sysdate + 3, 100000, '이번 주 안에 가능하면 좋겠어요.', 'SELECTED', 2, sysdate - 3, sysdate + 4, sysdate - 5);
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 3, NULL, 2, '서울 용산구', NULL, NULL, '일정이 바뀌어서 취소합니다.', 'CANCELED', 0, sysdate - 2, NULL, sysdate - 4);

-- 요청서 1의 답변 (질문 1: 처음이에요 / 질문 2: 평일 저녁, 주말 / 질문 3: 주관식)
INSERT INTO tbl_request_answer (answer_seq, request_seq, question_seq, option_seq, answer) VALUES (seq_request_answer.nextval, 1, 1, 1, NULL);
INSERT INTO tbl_request_answer (answer_seq, request_seq, question_seq, option_seq, answer) VALUES (seq_request_answer.nextval, 1, 2, 6, NULL);
INSERT INTO tbl_request_answer (answer_seq, request_seq, question_seq, option_seq, answer) VALUES (seq_request_answer.nextval, 1, 2, 7, NULL);
INSERT INTO tbl_request_answer (answer_seq, request_seq, question_seq, option_seq, answer) VALUES (seq_request_answer.nextval, 1, 3, NULL, '천천히 알려 주시면 좋겠어요.');

-- 요청서 1의 참고 이미지
INSERT INTO tbl_request_file (file_seq, request_seq, org_filename, save_filename) VALUES (seq_request_file.nextval, 1, 'sample.jpg', '3f2a9c1e-0000-4000-8000-000000000001_sample.jpg');

-- 견적
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, 1, 5, 50000, 30, '주 1회, 한 달 과정으로 진행합니다.', 'WAITING', sysdate - 0.5);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, 1, 6, 45000, 30, '기초 교재 포함입니다.', 'WAITING', sysdate - 0.2);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, 2, 7, 80000, 14, '주 2회 가능합니다.', 'WAITING', sysdate - 2);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, 4, 6, 95000, 3, '이번 주 안에 끝낼 수 있습니다.', 'SELECTED', sysdate - 4);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, 4, 7, 110000, 5, '꼼꼼하게 진행합니다.', 'UNSELECTED', sysdate - 4);

COMMIT;
