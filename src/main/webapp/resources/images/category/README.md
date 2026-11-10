# 카테고리 아이콘

메인 페이지 카테고리 카드(대분류)에 쓰는 아이콘.

**파일명 = `tbl_category.category_seq` (대분류 번호)**
`index.jsp`가 `${category.categorySeq}.svg`로 불러오고, 그 번호의 파일이 없으면 `default.svg`를 보여 준다.

| 파일 | 카테고리 | 아이콘 (Lucide) |
|---|---|---|
| 1.svg | 레슨 | `book-open-check` |
| 2.svg | 홈·리빙 | `house-heart` |
| 3.svg | 디자인·개발 | `palette` + `code-xml` 합침 |
| 4.svg | 이벤트 | `party-popper` |
| 5.svg | 건강·뷰티 | `heart-pulse` + `perfume-bottle` 합침 |
| 6.svg | 비즈니스·상담 | `briefcase-business` + `scroll-text` 합침 |
| default.svg | 아이콘 파일이 없는 카테고리 | `layout-grid` |

## 출처

- Lucide (https://lucide.dev), ISC 라이선스. 상업적 사용 가능, 출처 표기 의무 없음.
- 합친 아이콘(3, 5, 6)은 두 아이콘을 58%로 줄여 왼쪽 위·오른쪽 아래에 놓고, 겹치는 부분을 mask로 잘라 틈을 만들었다. (파일 안 주석 참고)

## 규칙

- 색은 메인 색(`--color-primary`, `#2f6fed`)을 파일에 직접 적었다. `<img>`로 넣으면 CSS 색이 SVG 안까지 전달되지 않기 때문이다. 메인 색을 바꾸면 이 파일들의 `stroke` / `fill` 값도 같이 바꾼다.
- 번호가 맞는 이유: `00_drop_all.sql`이 시퀀스까지 지우고, `dummy/02_expert_dummy.sql`이 대분류 6개를 맨 먼저 넣어서 1 ~ 6번이 된다. 더미 INSERT 순서를 바꾸면 아이콘이 어긋난다.
- 대분류를 새로 추가하면 그 `category_seq` 번호로 svg를 추가하고 이 표에 적는다. 같은 세트(Lucide, 24×24, 선 굵기 2)에서 고르면 모양이 맞는다.
