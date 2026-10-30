-- ============================================================
-- dummy/02_expert_dummy.sql (② 고수·카테고리·리뷰)
--
-- dummy/01_member_dummy.sql 다음에 실행한다.
-- 회원 번호는 dummy/01_member_dummy.sql 기준이다.
--   2 ~ 4  customer1 ~ 3      고객
--   5 ~ 7  expert1 ~ 3        고수
--
-- 00_drop_all.sql로 지운 뒤 실행해야 번호가 아래와 같이 나온다.
-- 리뷰(tbl_review)는 거래가 있어야 해서 dummy/04_trade_dummy.sql 끝에 있다.
--
-- 카테고리 (대분류 1 ~ 6, 소분류 7 ~ 29) - 기능범위정리 문서의 서비스 카테고리 기준
--   1 레슨           7 피아노        8 영어 회화     9 코딩 과외     10 골프
--   2 홈·리빙        11 청소         12 가전 수리    13 소규모 집수리 14 방역
--   3 디자인·개발    15 로고 디자인  16 영상 편집    17 웹·앱 개발   18 일러스트
--   4 이벤트         19 사진 촬영    20 행사 MC      21 축가
--   5 건강·뷰티      22 PT           23 필라테스     24 메이크업     25 헤어
--   6 비즈니스·상담  26 세무 상담    27 노무 상담    28 법률 상담    29 번역
--   요청서·서비스는 소분류 번호(7 ~ 29)를 쓴다.
--
-- 서비스 (tbl_talent)
--   1 ~ 3  expert1   피아노 레슨 2개, 영어 회화 1개
--   4 ~ 5  expert2   청소, 가전 수리
--   6 ~ 9  expert3   웹·앱 개발, 로고 디자인, 일러스트 커미션, 영상 편집(9번은 삭제된 서비스, enabled = 'N')
--
-- 포트폴리오 글 (tbl_portfolio)
--   1 ~ 3  expert1   3번은 어느 서비스에도 연결하지 않았다.
--   4 ~ 5  expert2
--   6 ~ 8  expert3
--   2번 서비스는 포트폴리오 3개(최대)를 연결해 두었다.
--
-- expert3(7번)은 hidden = 'Y'(신고 처리로 숨김)라 검색·메인에는 expert1, expert2만 나온다.
-- 숨김을 풀고 테스트하려면: UPDATE tbl_expert_profile SET hidden = 'N' WHERE expert_seq = 7;
--
-- 포트폴리오 사진 파일은 서버에 없다. 화면에서 이미지가 깨지면 기본 이미지로 보여준다.
-- 서비스 제공 위치의 좌표는 대략값이다.
-- ============================================================

-- 카테고리 - 대분류
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, NULL, '레슨', 1);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, NULL, '홈·리빙', 2);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, NULL, '디자인·개발', 3);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, NULL, '이벤트', 4);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, NULL, '건강·뷰티', 5);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, NULL, '비즈니스·상담', 6);

-- 카테고리 - 소분류
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 1, '피아노', 1);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 1, '영어 회화', 2);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 1, '코딩 과외', 3);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 1, '골프', 4);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 2, '청소', 1);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 2, '가전 수리', 2);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 2, '소규모 집수리', 3);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 2, '방역', 4);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 3, '로고 디자인', 1);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 3, '영상 편집', 2);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 3, '웹·앱 개발', 3);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 3, '일러스트', 4);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 4, '사진 촬영', 1);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 4, '행사 MC', 2);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 4, '축가', 3);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 5, 'PT', 1);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 5, '필라테스', 2);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 5, '메이크업', 3);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 5, '헤어', 4);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 6, '세무 상담', 1);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 6, '노무 상담', 2);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 6, '법률 상담', 3);
INSERT INTO tbl_category (category_seq, parent_seq, name, sort_order) VALUES (seq_category.nextval, 6, '번역', 4);

-- 고수 프로필 (expert_seq = 회원 번호)
INSERT INTO tbl_expert_profile (expert_seq, intro, service_address, service_latitude, service_longitude, regdate) VALUES (5, '10년 경력의 피아노 강사입니다. 초급부터 입시까지 맞춤 지도하고, 직장인 영어 회화 수업도 합니다.', '서울 강남구 강남대로 396', 37.4979000, 127.0276000, sysdate - 60);
INSERT INTO tbl_expert_profile (expert_seq, intro, service_address, service_latitude, service_longitude, regdate) VALUES (6, '입주 청소와 에어컨·세탁기 분해 청소를 전문으로 합니다. 친환경 세제만 사용합니다.', '서울 마포구 양화로 45', 37.5495000, 126.9139000, sysdate - 55);
-- expert3은 ⑥ 신고 더미에서 "프로필을 비공개 처리했습니다"로 처리완료된 고수라 hidden = 'Y'로 맞춘다.
INSERT INTO tbl_expert_profile (expert_seq, intro, service_address, service_latitude, service_longitude, regdate, hidden) VALUES (7, '웹 개발과 브랜드 디자인을 함께 하는 프리랜서입니다. 캐릭터 일러스트 커미션도 받습니다.', '경기 성남시 분당구 판교역로 160', 37.3948000, 127.1112000, sysdate - 50, 'Y');

-- 경력 (end_date가 NULL이면 진행 중)
INSERT INTO tbl_expert_career (career_seq, expert_seq, title, start_date, end_date, description) VALUES (seq_career.nextval, 5, 'OO음악학원 강사', TO_DATE('2016-03-01', 'YYYY-MM-DD'), NULL, '초등부·입시반 피아노 지도');
INSERT INTO tbl_expert_career (career_seq, expert_seq, title, start_date, end_date, description) VALUES (seq_career.nextval, 5, '△△문화센터 피아노 강사', TO_DATE('2014-03-01', 'YYYY-MM-DD'), TO_DATE('2016-02-28', 'YYYY-MM-DD'), '성인 취미반 운영');
INSERT INTO tbl_expert_career (career_seq, expert_seq, title, start_date, end_date, description) VALUES (seq_career.nextval, 6, '클린홈 청소 대표', TO_DATE('2019-05-01', 'YYYY-MM-DD'), NULL, '입주·이사 청소 누적 800건');
INSERT INTO tbl_expert_career (career_seq, expert_seq, title, start_date, end_date, description) VALUES (seq_career.nextval, 7, '프리랜서 웹 개발자', TO_DATE('2021-01-01', 'YYYY-MM-DD'), NULL, '소상공인 홈페이지 40건 제작');
INSERT INTO tbl_expert_career (career_seq, expert_seq, title, start_date, end_date, description) VALUES (seq_career.nextval, 7, '□□디자인 스튜디오', TO_DATE('2018-03-01', 'YYYY-MM-DD'), TO_DATE('2020-12-31', 'YYYY-MM-DD'), '브랜드 로고·패키지 디자인');

-- 서비스 (category_seq = 소분류)
INSERT INTO tbl_talent (talent_seq, expert_seq, category_seq, title, content, price, enabled, regdate) VALUES (seq_talent.nextval, 5, 7, '기초 피아노 1:1 레슨', '악보 읽기부터 차근차근 배우는 주 1회 1:1 레슨입니다.', 50000, 'Y', sysdate - 58);
INSERT INTO tbl_talent (talent_seq, expert_seq, category_seq, title, content, price, enabled, regdate) VALUES (seq_talent.nextval, 5, 7, '입시 피아노 집중반', '예중·예고 입시곡 선정부터 실기 리허설까지 지도합니다.', 80000, 'Y', sysdate - 57);
INSERT INTO tbl_talent (talent_seq, expert_seq, category_seq, title, content, price, enabled, regdate) VALUES (seq_talent.nextval, 5, 8, '직장인 영어 회화', '퇴근 후 저녁 시간에 하는 실전 회화 수업입니다.', 40000, 'Y', sysdate - 40);
INSERT INTO tbl_talent (talent_seq, expert_seq, category_seq, title, content, price, enabled, regdate) VALUES (seq_talent.nextval, 6, 11, '원룸·투룸 입주 청소', '입주 전 주방·욕실·창틀까지 꼼꼼하게 청소합니다.', 150000, 'Y', sysdate - 54);
INSERT INTO tbl_talent (talent_seq, expert_seq, category_seq, title, content, price, enabled, regdate) VALUES (seq_talent.nextval, 6, 12, '에어컨 분해 청소', '벽걸이·스탠드 에어컨을 분해해서 세척합니다.', 90000, 'Y', sysdate - 50);
INSERT INTO tbl_talent (talent_seq, expert_seq, category_seq, title, content, price, enabled, regdate) VALUES (seq_talent.nextval, 7, 17, '반응형 웹사이트 제작', '모바일까지 맞춘 5페이지 이내 홈페이지를 만들어 드립니다.', 500000, 'Y', sysdate - 49);
INSERT INTO tbl_talent (talent_seq, expert_seq, category_seq, title, content, price, enabled, regdate) VALUES (seq_talent.nextval, 7, 15, '브랜드 로고 디자인', '시안 3개 제공, 수정 2회까지 포함입니다.', 200000, 'Y', sysdate - 45);
INSERT INTO tbl_talent (talent_seq, expert_seq, category_seq, title, content, price, enabled, regdate) VALUES (seq_talent.nextval, 7, 18, '캐릭터 일러스트 커미션', '원하는 스타일의 참고 이미지를 보내 주시면 캐릭터를 그려 드립니다.', 60000, 'Y', sysdate - 30);
INSERT INTO tbl_talent (talent_seq, expert_seq, category_seq, title, content, price, enabled, regdate) VALUES (seq_talent.nextval, 7, 16, '유튜브 영상 편집', '지금은 받지 않는 서비스입니다.', 70000, 'N', sysdate - 44);

-- 포트폴리오 글
INSERT INTO tbl_portfolio (portfolio_seq, expert_seq, title, content, regdate) VALUES (seq_portfolio.nextval, 5, '입시 대비 레슨 기록', '예중·예고 입시를 준비한 학생들과 1년 동안 진행한 레슨 기록입니다.', sysdate - 56);
INSERT INTO tbl_portfolio (portfolio_seq, expert_seq, title, content, regdate) VALUES (seq_portfolio.nextval, 5, '초등부 발표회', '학원 초등부 학생들의 연말 발표회 사진입니다.', sysdate - 45);
INSERT INTO tbl_portfolio (portfolio_seq, expert_seq, title, content, regdate) VALUES (seq_portfolio.nextval, 5, '성인 취미반 연주', '성인 취미반 수강생들의 첫 연주회입니다.', sysdate - 35);
INSERT INTO tbl_portfolio (portfolio_seq, expert_seq, title, content, regdate) VALUES (seq_portfolio.nextval, 6, '입주 청소 전후 비교', '30평 아파트 입주 청소 전후 사진입니다.', sysdate - 52);
INSERT INTO tbl_portfolio (portfolio_seq, expert_seq, title, content, regdate) VALUES (seq_portfolio.nextval, 6, '에어컨 분해 세척 과정', '분해부터 조립까지 단계별 사진입니다.', sysdate - 48);
INSERT INTO tbl_portfolio (portfolio_seq, expert_seq, title, content, regdate) VALUES (seq_portfolio.nextval, 7, '카페 브랜드 웹사이트', '동네 카페의 메뉴·예약 페이지를 반응형으로 만들었습니다.', sysdate - 47);
INSERT INTO tbl_portfolio (portfolio_seq, expert_seq, title, content, regdate) VALUES (seq_portfolio.nextval, 7, '로고 작업 모음', '최근 1년 동안 작업한 소상공인 로고입니다.', sysdate - 43);
INSERT INTO tbl_portfolio (portfolio_seq, expert_seq, title, content, regdate) VALUES (seq_portfolio.nextval, 7, '캐릭터 일러스트', '반려동물 캐릭터 커미션 작업입니다.', sysdate - 28);

-- 포트폴리오 사진 (slot 1이 대표 사진, 글 하나에 최대 5장)
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 1, 'a1000000-0000-4000-8000-000000000001_lesson1.jpg', 'lesson1.jpg', 1);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 1, 'a1000000-0000-4000-8000-000000000002_lesson2.jpg', 'lesson2.jpg', 2);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 1, 'a1000000-0000-4000-8000-000000000003_lesson3.jpg', 'lesson3.jpg', 3);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 1, 'a1000000-0000-4000-8000-000000000004_lesson4.jpg', 'lesson4.jpg', 4);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 1, 'a1000000-0000-4000-8000-000000000005_lesson5.jpg', 'lesson5.jpg', 5);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 2, 'a1000000-0000-4000-8000-000000000006_recital1.jpg', 'recital1.jpg', 1);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 2, 'a1000000-0000-4000-8000-000000000007_recital2.jpg', 'recital2.jpg', 2);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 2, 'a1000000-0000-4000-8000-000000000008_recital3.jpg', 'recital3.jpg', 3);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 3, 'a1000000-0000-4000-8000-000000000009_adult1.jpg', 'adult1.jpg', 1);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 3, 'a1000000-0000-4000-8000-000000000010_adult2.jpg', 'adult2.jpg', 2);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 4, 'a1000000-0000-4000-8000-000000000011_before.jpg', 'before.jpg', 1);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 4, 'a1000000-0000-4000-8000-000000000012_after.jpg', 'after.jpg', 2);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 5, 'a1000000-0000-4000-8000-000000000013_aircon1.jpg', 'aircon1.jpg', 1);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 5, 'a1000000-0000-4000-8000-000000000014_aircon2.jpg', 'aircon2.jpg', 2);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 6, 'a1000000-0000-4000-8000-000000000015_cafe1.jpg', 'cafe1.jpg', 1);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 6, 'a1000000-0000-4000-8000-000000000016_cafe2.jpg', 'cafe2.jpg', 2);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 6, 'a1000000-0000-4000-8000-000000000017_cafe3.jpg', 'cafe3.jpg', 3);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 7, 'a1000000-0000-4000-8000-000000000018_logo1.png', 'logo1.png', 1);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 7, 'a1000000-0000-4000-8000-000000000019_logo2.png', 'logo2.png', 2);
INSERT INTO tbl_portfolio_image (image_seq, portfolio_seq, file_name, origin_name, slot) VALUES (seq_portfolio_image.nextval, 8, 'a1000000-0000-4000-8000-000000000020_character.png', 'character.png', 1);

-- 서비스에 연결한 포트폴리오 (slot = 보여주는 순서, 서비스 하나에 최대 3개)
INSERT INTO tbl_talent_portfolio (talent_seq, portfolio_seq, slot) VALUES (1, 2, 1);
INSERT INTO tbl_talent_portfolio (talent_seq, portfolio_seq, slot) VALUES (2, 1, 1);
INSERT INTO tbl_talent_portfolio (talent_seq, portfolio_seq, slot) VALUES (2, 2, 2);
INSERT INTO tbl_talent_portfolio (talent_seq, portfolio_seq, slot) VALUES (2, 3, 3);
INSERT INTO tbl_talent_portfolio (talent_seq, portfolio_seq, slot) VALUES (4, 4, 1);
INSERT INTO tbl_talent_portfolio (talent_seq, portfolio_seq, slot) VALUES (5, 5, 1);
INSERT INTO tbl_talent_portfolio (talent_seq, portfolio_seq, slot) VALUES (6, 6, 1);
INSERT INTO tbl_talent_portfolio (talent_seq, portfolio_seq, slot) VALUES (7, 7, 1);
INSERT INTO tbl_talent_portfolio (talent_seq, portfolio_seq, slot) VALUES (8, 8, 1);

-- 찜하기 (고객 → 고수)
INSERT INTO tbl_wish (member_seq, expert_seq, regdate) VALUES (2, 5, sysdate - 20);
INSERT INTO tbl_wish (member_seq, expert_seq, regdate) VALUES (2, 7, sysdate - 12);
INSERT INTO tbl_wish (member_seq, expert_seq, regdate) VALUES (3, 5, sysdate - 9);
INSERT INTO tbl_wish (member_seq, expert_seq, regdate) VALUES (4, 6, sysdate - 3);

COMMIT;
