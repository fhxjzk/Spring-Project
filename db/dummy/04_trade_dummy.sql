-- ============================================================
-- dummy/04_trade_dummy.sql (④ 결제·거래·통계)
--
-- dummy/01_member_dummy.sql, dummy/03_request_dummy.sql 다음에 실행한다.
-- 회원 번호 2~4 고객, 5~7 고수를 쓴다.
--
-- 거래는 선택된 견적이 있어야 하므로
--   14번 거래: ③ 더미의 요청서 4 / 견적 4 (선택됨)를 쓴다.
--   나머지 거래: 여기서 요청서(선택 완료, 취소된 거래는 취소)와 견적(선택됨)을 하나씩 만들고 바로 이어서 거래를 만든다.
--              요청서·견적 번호는 ③ 더미 다음 번호이고, seq_request.currval / seq_quote.currval로 가져온다.
-- category_seq는 ③ 더미와 같이 임시로 1, 2를 쓴다. (② 카테고리 더미가 합쳐지면 바꾼다)
--
-- 날짜는 sysdate 기준이라 언제 실행해도 최근 30일 안에 들어간다.
-- 포인트 내역의 잔액(balance)과 tbl_member.point는 서로 맞춰서 만들었다.
-- 7번 거래는 납품 후 7일이 지나서, 서버를 켜고 1분 뒤 자동 구매 확정된다. (스케줄러 확인용)
--
--   거래 번호  고객       고수     금액      상태
--   1        customer1  expert1  150,000   CONFIRMED
--   2        customer2  expert2  80,000    CONFIRMED
--   3        customer3  expert3  200,000   CONFIRMED
--   4        customer1  expert2  50,000    CONFIRMED
--   5        customer2  expert1  120,000   CONFIRMED
--   6        customer3  expert1  70,000    CONFIRMED
--   7        customer2  expert1  65,000    DELIVERED
--   8        customer1  expert3  300,000   CONFIRMED
--   9        customer3  expert3  75,000    CANCELED
--   10       customer2  expert2  90,000    CONFIRMED
--   11       customer3  expert3  60,000    CONFIRMED
--   12       customer1  expert1  110,000   DELIVERED
--   13       customer2  expert3  130,000   IN_PROGRESS
--   14       customer1  expert2  95,000    PAID
--   15       customer3  expert2  40,000    PAID
-- ============================================================

-- 거래 (+ 거래마다 요청서·견적)
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 2, NULL, 1, '서울 서초구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 26.50, sysdate - 28.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 5, 150000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 28.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 2, 5, 150000, 'CONFIRMED', sysdate - 27.00, sysdate - 26.00, sysdate - 24.00, sysdate - 23.00, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 3, NULL, 2, '서울 마포구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 25.50, sysdate - 27.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 6, 80000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 27.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 3, 6, 80000, 'CONFIRMED', sysdate - 26.00, sysdate - 25.00, sysdate - 22.00, sysdate - 21.00, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 4, NULL, 2, '서울 송파구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 24.50, sysdate - 26.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 7, 200000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 26.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 4, 7, 200000, 'CONFIRMED', sysdate - 25.00, sysdate - 24.00, sysdate - 20.00, sysdate - 19.00, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 2, NULL, 1, '서울 용산구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 21.50, sysdate - 23.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 6, 50000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 23.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 2, 6, 50000, 'CONFIRMED', sysdate - 22.00, sysdate - 21.00, sysdate - 18.00, sysdate - 16.00, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 3, NULL, 1, '서울 성동구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 19.50, sysdate - 21.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 5, 120000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 21.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 3, 5, 120000, 'CONFIRMED', sysdate - 20.00, sysdate - 19.00, sysdate - 15.00, sysdate - 13.00, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 4, NULL, 1, '서울 강남구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 16.50, sysdate - 18.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 5, 70000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 18.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 4, 5, 70000, 'CONFIRMED', sysdate - 17.00, sysdate - 16.00, sysdate - 12.00, sysdate - 10.00, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 3, NULL, 1, '서울 서초구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 14.50, sysdate - 16.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 5, 65000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 16.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 3, 5, 65000, 'DELIVERED', sysdate - 15.00, sysdate - 14.00, sysdate - 9.00, NULL, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 2, NULL, 2, '서울 마포구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 13.50, sysdate - 15.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 7, 300000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 15.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 2, 7, 300000, 'CONFIRMED', sysdate - 14.00, sysdate - 13.00, sysdate - 9.00, sysdate - 7.00, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 4, NULL, 2, '서울 송파구', '거래 더미용 요청서', 'CANCELED', 1, sysdate - 11.50, sysdate - 13.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 7, 75000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 13.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 4, 7, 75000, 'CANCELED', sysdate - 12.00, NULL, NULL, NULL, sysdate - 11.00);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 3, NULL, 1, '서울 용산구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 9.50, sysdate - 11.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 6, 90000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 11.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 3, 6, 90000, 'CONFIRMED', sysdate - 10.00, sysdate - 9.00, sysdate - 6.00, sysdate - 4.00, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 4, NULL, 2, '서울 성동구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 6.50, sysdate - 8.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 7, 60000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 8.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 4, 7, 60000, 'CONFIRMED', sysdate - 7.00, sysdate - 6.00, sysdate - 2.00, sysdate - 0.20, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 2, NULL, 1, '서울 강남구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 5.50, sysdate - 7.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 5, 110000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 7.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 2, 5, 110000, 'DELIVERED', sysdate - 6.00, sysdate - 5.00, sysdate - 2.00, NULL, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 3, NULL, 2, '서울 서초구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 3.50, sysdate - 5.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 7, 130000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 5.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 3, 7, 130000, 'IN_PROGRESS', sysdate - 4.00, sysdate - 3.00, NULL, NULL, NULL);

INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, 4, 4, 2, 6, 95000, 'PAID', sysdate - 3.50, NULL, NULL, NULL, NULL);

INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, content, status, quote_count, quote_deadline, regdate) VALUES (seq_request.nextval, 4, NULL, 1, '서울 송파구', '거래 더미용 요청서', 'SELECTED', 1, sysdate - 1.50, sysdate - 3.50);
INSERT INTO tbl_quote (quote_seq, request_seq, expert_seq, price, work_days, content, status, regdate) VALUES (seq_quote.nextval, seq_request.currval, 6, 40000, 7, '거래 더미용 견적', 'SELECTED', sysdate - 3.00);
INSERT INTO tbl_trade (trade_seq, request_seq, quote_seq, customer_seq, expert_seq, price, status, regdate, start_date, delivered_date, confirm_date, cancel_date) VALUES (seq_trade.nextval, seq_request.currval, seq_quote.currval, 4, 6, 40000, 'PAID', sysdate - 2.00, NULL, NULL, NULL, NULL);

-- 포인트 내역 (시간 순서)
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 2, 'CHARGE', 1000000, 1000000, NULL, sysdate - 29.50);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 3, 'CHARGE', 800000, 800000, NULL, sysdate - 29.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 4, 'CHARGE', 600000, 600000, NULL, sysdate - 28.50);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 2, 'PAY', -150000, 850000, 1, sysdate - 27.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 3, 'PAY', -80000, 720000, 2, sysdate - 26.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 4, 'PAY', -200000, 400000, 3, sysdate - 25.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 5, 'SETTLE', 150000, 150000, 1, sysdate - 23.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 2, 'PAY', -50000, 800000, 4, sysdate - 22.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 6, 'SETTLE', 80000, 80000, 2, sysdate - 21.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 3, 'PAY', -120000, 600000, 5, sysdate - 20.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 7, 'SETTLE', 200000, 200000, 3, sysdate - 19.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 4, 'PAY', -70000, 330000, 6, sysdate - 17.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 6, 'SETTLE', 50000, 130000, 4, sysdate - 16.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 3, 'PAY', -65000, 535000, 7, sysdate - 15.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 2, 'PAY', -300000, 500000, 8, sysdate - 14.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 5, 'SETTLE', 120000, 270000, 5, sysdate - 13.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 4, 'PAY', -75000, 255000, 9, sysdate - 12.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 4, 'REFUND', 75000, 330000, 9, sysdate - 11.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 5, 'SETTLE', 70000, 340000, 6, sysdate - 10.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 3, 'PAY', -90000, 445000, 10, sysdate - 10.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 7, 'SETTLE', 300000, 500000, 8, sysdate - 7.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 4, 'PAY', -60000, 270000, 11, sysdate - 7.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 2, 'PAY', -110000, 390000, 12, sysdate - 6.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 6, 'SETTLE', 90000, 220000, 10, sysdate - 4.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 3, 'PAY', -130000, 315000, 13, sysdate - 4.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 2, 'PAY', -95000, 295000, 14, sysdate - 3.50);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 4, 'PAY', -40000, 230000, 15, sysdate - 2.00);
INSERT INTO tbl_point_history (point_history_seq, member_seq, history_type, amount, balance, trade_seq, regdate) VALUES (seq_point_history.nextval, 7, 'SETTLE', 60000, 560000, 11, sysdate - 0.20);

-- 최종 잔액 (위 내역의 마지막 balance와 같다)
UPDATE tbl_member SET point = 295000 WHERE member_seq = 2;
UPDATE tbl_member SET point = 315000 WHERE member_seq = 3;
UPDATE tbl_member SET point = 230000 WHERE member_seq = 4;
UPDATE tbl_member SET point = 340000 WHERE member_seq = 5;
UPDATE tbl_member SET point = 220000 WHERE member_seq = 6;
UPDATE tbl_member SET point = 560000 WHERE member_seq = 7;

COMMIT;

-- ------------------------------------------------------------
-- ② 리뷰 더미 (② 담당)
-- 리뷰는 거래 번호(trade_seq)가 있어야 해서 02 더미가 아니라 거래 더미 다음인 여기에 둔다.
-- 구매 확정(CONFIRMED)된 거래만 리뷰를 쓸 수 있다. (C-04)
-- 11번 거래는 리뷰를 쓰지 않은 상태로 남겨서 '리뷰 작성' 버튼을 확인할 수 있게 했다.
--
--   리뷰  거래  고객       고수     별점  고수 답변
--   1     1     customer1  expert1  5     있음
--   2     2     customer2  expert2  4     있음
--   3     3     customer3  expert3  5     없음
--   4     4     customer1  expert2  3     있음
--   5     5     customer2  expert1  5     없음
--   6     6     customer3  expert1  4     있음
--   7     8     customer1  expert3  2     있음
--   8     10    customer2  expert2  5     없음
-- ------------------------------------------------------------
INSERT INTO tbl_review (review_seq, trade_seq, customer_seq, expert_seq, rating, content, reply, reply_date, regdate) VALUES (seq_review.nextval, 1, 2, 5, 5, '처음 배우는데도 꼼꼼하게 잘 가르쳐 주셨어요.', '열심히 따라와 주셔서 감사합니다!', sysdate - 22.00, sysdate - 22.50);
INSERT INTO tbl_review (review_seq, trade_seq, customer_seq, expert_seq, rating, content, reply, reply_date, regdate) VALUES (seq_review.nextval, 2, 3, 6, 4, '청소는 깔끔했는데 도착이 조금 늦었어요.', '늦어서 죄송합니다. 다음에는 시간을 꼭 지키겠습니다.', sysdate - 20.00, sysdate - 20.50);
INSERT INTO tbl_review (review_seq, trade_seq, customer_seq, expert_seq, rating, content, reply, reply_date, regdate) VALUES (seq_review.nextval, 3, 4, 7, 5, '요청한 기능을 전부 넣어 주시고 설명도 친절했어요.', NULL, NULL, sysdate - 18.50);
INSERT INTO tbl_review (review_seq, trade_seq, customer_seq, expert_seq, rating, content, reply, reply_date, regdate) VALUES (seq_review.nextval, 4, 2, 6, 3, '보통이었어요. 욕실 구석이 조금 덜 닦였어요.', '말씀해 주신 부분은 무료로 다시 청소해 드릴게요.', sysdate - 15.00, sysdate - 15.50);
INSERT INTO tbl_review (review_seq, trade_seq, customer_seq, expert_seq, rating, content, reply, reply_date, regdate) VALUES (seq_review.nextval, 5, 3, 5, 5, '아이가 피아노를 좋아하게 됐어요.', NULL, NULL, sysdate - 12.50);
INSERT INTO tbl_review (review_seq, trade_seq, customer_seq, expert_seq, rating, content, reply, reply_date, regdate) VALUES (seq_review.nextval, 6, 4, 5, 4, '수업 시간을 유연하게 맞춰 주셔서 좋았어요.', '편하실 때 언제든 연락 주세요.', sysdate - 9.00, sysdate - 9.50);
INSERT INTO tbl_review (review_seq, trade_seq, customer_seq, expert_seq, rating, content, reply, reply_date, regdate) VALUES (seq_review.nextval, 8, 2, 7, 2, '시안이 생각했던 느낌과 많이 달랐어요.', '기대에 못 미쳐 죄송합니다. 추가 수정은 채팅으로 말씀해 주세요.', sysdate - 6.00, sysdate - 6.50);
INSERT INTO tbl_review (review_seq, trade_seq, customer_seq, expert_seq, rating, content, reply, reply_date, regdate) VALUES (seq_review.nextval, 10, 3, 6, 5, '에어컨에서 냄새가 완전히 사라졌어요!', NULL, NULL, sysdate - 3.50);

COMMIT;
