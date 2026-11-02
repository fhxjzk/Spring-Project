-- ============================================================
-- dummy/03_request_dummy.sql (③ 요청서·견적)
--
-- 회원 번호는 dummy/01_member_dummy.sql 기준이다.
--   2 ~ 4  customer1 ~ 3      고객
--   5 ~ 7  expert1 ~ 3        고수
--
-- category_seq 는 dummy/02_expert_dummy.sql 의 소분류 번호를 쓴다.
--   7 피아노  8 영어 회화  11 청소  12 가전 수리
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

-- 질문 항목 (카테고리 7 피아노)
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 7, '레슨 경험이 있나요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 7, '원하는 레슨 요일을 모두 골라 주세요.', 'MULTI', 'Y', 2);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 7, '고수에게 전하고 싶은 말이 있나요?', 'TEXT', 'N', 3);

-- 보기 (질문 1: 1~3, 질문 2: 4~7)
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 1, '처음이에요', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 1, '1년 미만', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 1, '1년 이상', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 2, '평일 오전', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 2, '평일 오후', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 2, '평일 저녁', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, 2, '주말', 4);

-- 질문 항목 (카테고리 8 ~ 29)
-- 소분류마다 필수 객관식 2개 + 선택 주관식 1개. 보기는 바로 위 질문(seq_question.currval)에 붙는다.

-- 8 영어 회화
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 8, '수업 목적이 무엇인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '일상 회화', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '비즈니스', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '여행', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '시험 대비', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 8, '현재 영어 실력은 어느 정도인가요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '처음이에요', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기초', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '중급 이상', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 8, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 9 코딩 과외
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 9, '배우고 싶은 분야를 골라 주세요.', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '코딩 기초', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '웹 개발', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '앱 개발', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '데이터 분석', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 9, '현재 수준은 어느 정도인가요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '처음이에요', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기초 문법은 알아요', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '프로젝트 경험이 있어요', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 9, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 10 골프
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 10, '원하는 레슨 장소를 골라 주세요.', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '실내 연습장', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '실외 연습장', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '필드', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 10, '골프를 친 지 얼마나 되었나요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '처음이에요', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '1년 미만', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '1년 이상', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 10, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 11 청소
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 11, '어떤 청소가 필요한가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '이사·입주 청소', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '거주 중 청소', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '사무실 청소', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 11, '청소할 공간의 크기는 어느 정도인가요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '10평 미만', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '10 ~ 20평', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '20 ~ 30평', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '30평 이상', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 11, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 12 가전 수리
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 12, '수리할 가전을 모두 골라 주세요.', 'MULTI', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '에어컨', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '세탁기', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '냉장고', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 12, '가전을 사용한 기간은 얼마나 되나요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '3년 미만', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '3 ~ 7년', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '7년 이상', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 12, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 13 소규모 집수리
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 13, '수리할 부분을 모두 골라 주세요.', 'MULTI', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '문·창문', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '수도·배관', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '전기·조명', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '벽·바닥', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 13, '건물 종류를 골라 주세요.', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '아파트', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '빌라', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '단독주택', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '상가', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 13, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 14 방역
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 14, '방역할 대상을 모두 골라 주세요.', 'MULTI', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '바퀴벌레', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '개미', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '쥐', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타 해충', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 14, '방역할 공간을 골라 주세요.', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '가정', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '음식점', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '사무실', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 14, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 15 로고 디자인
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 15, '어떤 업종의 로고인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '음식점·카페', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '쇼핑몰', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '회사·스타트업', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 15, '원하는 느낌을 모두 골라 주세요.', 'MULTI', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '심플한', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '귀여운', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '고급스러운', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '개성 있는', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 15, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 16 영상 편집
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 16, '어떤 영상인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '유튜브', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '광고·홍보', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '행사 기록', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 16, '완성 영상의 길이는 어느 정도인가요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '1분 미만', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '1 ~ 10분', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '10분 이상', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 16, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 17 웹·앱 개발
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 17, '무엇을 만들고 싶나요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '홈페이지', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '쇼핑몰', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '모바일 앱', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 17, '기획은 어디까지 되어 있나요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '아이디어만 있어요', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기획서가 있어요', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '디자인까지 있어요', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 17, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 18 일러스트
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 18, '그림을 어디에 쓰실 건가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '개인 소장', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '굿즈 제작', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '상업용', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 18, '원하는 그림체를 모두 골라 주세요.', 'MULTI', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '귀여운', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '실사풍', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '애니메이션풍', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '수채화풍', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 18, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 19 사진 촬영
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 19, '어떤 촬영인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '프로필', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '가족·커플', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '제품', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '행사', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 19, '촬영 장소를 골라 주세요.', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '스튜디오', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '야외', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '원하는 장소로 방문', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 19, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 20 행사 MC
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 20, '어떤 행사인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '결혼식', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '돌잔치', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '회사 행사', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 20, '참석 인원은 어느 정도인가요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '50명 미만', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '50 ~ 100명', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '100명 이상', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 20, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 21 축가
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 21, '어떤 행사인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '결혼식', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기념일·이벤트', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 21, '원하는 인원을 골라 주세요.', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '솔로', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '듀엣', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '3명 이상', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 21, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 22 PT
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 22, '운동 목적이 무엇인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '다이어트', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '근력 강화', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '체형 교정', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '재활', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 22, '운동 경험이 있나요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '처음이에요', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '1년 미만', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '1년 이상', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 22, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 23 필라테스
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 23, '필라테스를 하려는 목적이 무엇인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '자세 교정', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '체력 향상', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '재활', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '다이어트', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 23, '원하는 수업 방식을 골라 주세요.', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '1:1', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '2:1', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '그룹', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 23, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 24 메이크업
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 24, '어떤 일정을 위한 메이크업인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '웨딩', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '촬영', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '행사·모임', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 24, '받으실 장소를 골라 주세요.', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '고수의 샵으로 갈게요', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '원하는 장소로 와 주세요', 2);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 24, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 25 헤어
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 25, '어떤 일정을 위한 헤어인가요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '웨딩', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '촬영', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '행사·모임', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 25, '현재 머리 길이를 골라 주세요.', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '짧은 머리', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '중간 길이', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '긴 머리', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 25, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 26 세무 상담
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 26, '상담받을 분야를 골라 주세요.', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '종합소득세', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '부가가치세', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '양도·상속·증여세', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 26, '신고 대상을 골라 주세요.', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '개인', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '개인사업자', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '법인', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 26, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 27 노무 상담
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 27, '상담받을 분야를 골라 주세요.', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '임금·퇴직금', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '해고·징계', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '산업재해', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '4대보험', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 27, '상담받는 분은 누구인가요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '근로자', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '사업주', 2);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 27, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 28 법률 상담
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 28, '상담받을 분야를 골라 주세요.', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '민사', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '형사', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '가사(이혼·상속)', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '부동산', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 28, '원하는 상담 방식을 골라 주세요.', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '방문 상담', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '전화 상담', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '화상 상담', 3);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 28, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 29 번역
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 29, '어떤 언어로 번역하나요?', 'SINGLE', 'Y', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '영어', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '일본어', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '중국어', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '기타', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 29, '어떤 문서인가요?', 'SINGLE', 'Y', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '일반 문서', 1);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '계약서·법률 문서', 2);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '논문·기술 문서', 3);
INSERT INTO tbl_question_option (option_seq, question_seq, content, sort_order) VALUES (seq_question_option.nextval, seq_question.currval, '영상 자막', 4);
INSERT INTO tbl_question (question_seq, category_seq, content, question_type, required, sort_order) VALUES (seq_question.nextval, 29, '원하는 내용을 자세히 적어 주세요.', 'TEXT', 'N', 3);

-- 요청서
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 2, NULL, 7, '서울 강남구', sysdate + 7, 50000, '기초부터 배우고 싶어요.', 'OPEN', 2, sysdate + 1, NULL, sysdate - 1);
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 3, NULL, 7, '서울 서초구', sysdate + 10, 80000, '주 2회 레슨 원해요.', 'CLOSED', 1, sysdate - 1, sysdate + 6, sysdate - 3);
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 4, 5, 8, '서울 마포구', sysdate + 5, 120000, '고수님께 직접 요청드려요.', 'OPEN', 0, sysdate + 2, NULL, sysdate);
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 2, NULL, 11, '서울 송파구', sysdate + 3, 100000, '이번 주 안에 가능하면 좋겠어요.', 'SELECTED', 2, sysdate - 3, sysdate + 4, sysdate - 5);
INSERT INTO tbl_request (request_seq, customer_seq, expert_seq, category_seq, address, wish_date, budget, content, status, quote_count, quote_deadline, select_deadline, regdate)
VALUES (seq_request.nextval, 3, NULL, 12, '서울 용산구', NULL, NULL, '일정이 바뀌어서 취소합니다.', 'CANCELED', 0, sysdate - 2, NULL, sysdate - 4);

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
