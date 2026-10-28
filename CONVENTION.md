# 코딩 규칙

모든 팀원이 같은 규칙으로 코드를 쓰기 위한 문서다. 기본 프로젝트의 **회원(member) 기능이 이 규칙대로 만든 예시**이니, 새 기능을 만들 때는 member 패키지를 복사해서 이름만 바꿔 시작하면 된다.

> 규칙을 바꾸고 싶으면 팀에 먼저 말하고 이 문서를 고친다.

## 한눈에 보기

| 항목 | 규칙 | 예시 |
| --- | --- | --- |
| 기본 패키지 | `com.project.app` | |
| 기능 패키지 | `com.project.app.기능.역할` | `com.project.app.request.controller` |
| 클래스 | 기능 + 역할 | `RequestController`, `RequestService`, `RequestDao`, `RequestMapper`, `RequestDto` |
| URL | `/기능/동작.do` | `/request/list.do`, `/request/addok.do` |
| 관리자 URL | `/admin/기능/동작.do` | `/admin/question/list.do` |
| JSP | `views/기능/동작.jsp` | `views/request/list.jsp` |
| Mapper XML | `resources/mappers/기능/XxxMapper.xml` | `mappers/request/RequestMapper.xml` |
| 테이블 | `tbl_` + 소문자 단수 | `tbl_request` |
| PK / 시퀀스 | `이름_seq` / `seq_이름` | `request_seq` / `seq_request` |
| DTO 필드 | 칼럼 이름을 camelCase로 | `request_seq` → `requestSeq` |

---

# 1. 파트별 이름

다른 파트와 겹치지 않도록 **자기 파트의 이름만** 쓴다. 기능이 더 필요하면 팀에 말하고 이 표에 추가한다.

| 파트 | 기능 패키지 · URL 앞부분 | DB 파일 |
| --- | --- | --- |
| ① 회원·공통 | `member`, `auth`, `admin` | `01_member.sql` |
| ② 고수·리뷰 | `expert`, `category`, `review` | `02_expert.sql` |
| ③ 요청서·견적 | `request`, `quote`, `question` | `03_request.sql` |
| ④ 결제·거래·통계 | `trade`, `point`, `stats` | `04_trade.sql` |
| ⑤ 채팅·알림 | `chat`, `notice` | `05_chat.sql` |
| ⑥ 검색·신고·DB | `search`, `report`, `board` | `06_report.sql` |

예를 들어 ③은 `com.project.app.request`, `/request/...`, `views/request/...`, `mappers/request/...`를 쓴다.

---

# 2. 폴더 구조

```
src/main/java/com/project/app
 ├─ MainController.java              메인(/index.do)
 ├─ auth/                            로그인, 권한 (Spring Security)
 ├─ admin/controller/                관리자 홈(/admin/index.do)
 └─ member/                          ← 예시 기능
     ├─ controller/MemberController.java
     ├─ service/MemberService.java
     ├─ repository/MemberDao.java
     ├─ mapper/MemberMapper.java      (인터페이스)
     └─ model/MemberDto.java

src/main/resources
 ├─ config/
 │   ├─ mybatis-config.xml
 │   ├─ secret.properties             ← 각자 만든다. GitHub에 안 올라감
 │   └─ secret.properties.example
 └─ mappers/member/MemberMapper.xml

src/main/webapp
 ├─ resources/
 │   ├─ css/common.css                공통 색상, 레이아웃
 │   ├─ js/common.js                  Ajax CSRF 자동 처리
 │   ├─ images/                       화면에 쓰는 이미지
 │   └─ upload/                       사용자가 올린 파일 (GitHub에 안 올라감)
 └─ WEB-INF/views/
     ├─ inc/asset.jsp, header.jsp, admin-menu.jsp
     ├─ index.jsp
     └─ member/add.jsp, addok.jsp

db/
 ├─ 00_drop_all.sql
 ├─ 01_member.sql
 └─ dummy/01_member_dummy.sql
```

---

# 3. Java

## 계층 구조

수업 때 ToyProject와 같은 구조다.

```
Controller → Service → Dao → Mapper(인터페이스) → Mapper XML(SQL)
```

| 계층 | 하는 일 |
| --- | --- |
| Controller | 요청 받기, 화면(JSP) 고르기. 비즈니스 로직은 넣지 않는다 |
| Service | 실제 로직. 검사, 계산, 여러 Dao 호출, `@Transactional` |
| Dao | Mapper 호출만 한다 |
| Mapper | SQL과 연결되는 인터페이스. **`@Mapper`를 꼭 붙인다** (없으면 등록되지 않는다) |
| Dto | 테이블 한 줄의 데이터 |

## 클래스 이름

- **기능 이름 + 역할**: `QuoteController`, `QuoteService`, `QuoteDao`, `QuoteMapper`, `QuoteDto`
- 관리자 화면 컨트롤러: **기능 이름 + AdminController** → `QuestionAdminController`
- **프로젝트 전체에서 클래스 이름이 겹치면 안 된다.** 패키지가 달라도 Spring과 MyBatis가 이름으로 구분해서 서버가 켜지지 않는다. 기능 이름을 앞에 붙이면 겹치지 않는다.

## DTO

- 필드 이름은 칼럼 이름을 camelCase로 바꾼다. `quote_count` → `quoteCount` (MyBatis가 자동으로 연결한다)
- 자료형

| 데이터 | 자료형 | 예시 |
| --- | --- | --- |
| 번호(PK, FK) | `Long` | `requestSeq`, `memberSeq` |
| 금액, 개수 | `Integer` (금액이 아주 크면 `Long`) | `price`, `quoteCount` |
| 날짜 | `String` | `regdate` |
| 상태 값, Y/N | `String` | `status`, `enabled` |

- Lombok `@Getter @Setter @ToString`을 쓴다.

## 자주 쓰는 코드

**의존성 주입**: 생성자 주입으로 통일한다.

```java
@Service
@RequiredArgsConstructor
public class QuoteService {

	private final QuoteDao quoteDao;

}
```

**로그인한 회원 번호 꺼내기**

```java
@PostMapping(value = "/addok.do")
public String addok(Model model, QuoteDto dto, Authentication auth) {

	Long memberSeq = ((CustomUser) auth.getPrincipal()).getMemberSeq();
	...
}
```

**트랜잭션**: 여러 테이블을 한 번에 바꾸는 Service 메서드에 붙인다. 중간에 예외가 나면 전부 취소된다.

```java
@Transactional
public int select(Long quoteSeq) { ... }
```

**스케줄러**: Service 메서드에 붙이면 정해진 시간마다 실행된다. (설정은 이미 되어 있다)

```java
@Scheduled(fixedDelay = 600000) // 10분마다
public void closeExpiredRequests() { ... }
```

---

# 4. URL

## 형식

`/기능/동작.do` — 동작 이름은 수업 때와 같이 쓴다.

| 동작 | 화면 | 처리 |
| --- | --- | --- |
| 목록 | `list.do` | |
| 상세 | `view.do` | |
| 쓰기 | `add.do` | `addok.do` |
| 수정 | `edit.do` | `editok.do` |
| 삭제 | `del.do` | `delok.do` |

## 권한 (security-context.xml)

| URL | 누가 들어갈 수 있나 |
| --- | --- |
| `/index.do`, `/auth/**`, `/member/add*.do` | 누구나 |
| `/**/list.do`, `/**/view.do` | **누구나** (로그인 안 해도 됨) |
| `/admin/**` | 관리자만 |
| 그 외 전부 | 로그인한 회원 |

- **로그인한 사람만 봐야 하는 목록은 `list.do`라고 짓지 않는다.** 예) 내 요청서 목록은 `/request/mylist.do`
- 고객만, 고수만 들어가야 하는 URL이 있으면 담당자에게 요청해서 `security-context.xml`에 추가한다.
- 관리자 화면은 `/admin/기능/...`으로 만들면 자동으로 관리자만 들어갈 수 있다.

## Ajax

- 데이터만 돌려주는 메서드는 `@ResponseBody`를 붙이고 객체를 반환한다. Jackson이 JSON으로 바꿔 준다.
- URL 규칙은 같다. 예) `/quote/count.do`

---

# 5. JSP와 화면

## 기본 틀

새 JSP는 이 틀에서 시작한다. (`member/add.jsp` 참고)

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/views/inc/asset.jsp" %>
	<style>
		/* 이 화면에만 쓰는 스타일 */
	</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/inc/header.jsp" %>

	<main class="container">
		<h2>제목</h2>
	</main>

	<script>
	</script>
</body>
</html>
```

## 지킬 것

- **주소는 항상 `${path}`로 시작한다.** `/app/...`처럼 직접 쓰면 PC마다 주소가 달라서 깨진다.
  - JSP: `<a href="${path}/request/list.do">`
  - JavaScript: `url: path + '/quote/count.do'` (`path` 변수는 asset.jsp에 있다)
  - JSP 안의 JavaScript에서 템플릿 문자열 `` `${변수}` ``를 쓰면 JSP가 먼저 EL로 바꿔 버려서 빈 값이 된다. `` `\${변수}` ``처럼 `\`를 붙인다.
- **POST form에는 CSRF 토큰을 넣는다.** 없으면 403 오류가 난다.
  ```jsp
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
  ```
  - 파일 업로드 form(`multipart/form-data`)은 action 뒤에 붙인다: `action="${path}/request/addok.do?${_csrf.parameterName}=${_csrf.token}"`
  - jQuery Ajax는 `common.js`가 자동으로 붙여 준다.
- **색은 `common.css`의 변수를 쓴다.** 예) `color: var(--color-primary);`
- 공통 메뉴(header.jsp), 관리자 메뉴(admin-menu.jsp), common.css를 바꾸려면 담당자에게 요청한다.

## 업로드 파일

- `resources/upload/기능/`에 저장한다. 예) `resources/upload/request/`
- 파일 이름은 `UUID_원래이름`으로 저장한다. 같은 이름 파일이 덮어써지지 않게 하기 위해서다.
- 폴더가 없으면 코드에서 만든다 (`mkdirs()`). upload 폴더는 GitHub에 올라가지 않는다.

---

# 6. Mapper XML

```xml
<mapper namespace="com.project.app.quote.mapper.QuoteMapper">

	<select id="list" parameterType="Long" resultType="QuoteDto">
		select quote_seq, request_seq, price, status, regdate
			from tbl_quote
				where request_seq = #{requestSeq}
	</select>

</mapper>
```

- `namespace`는 Mapper 인터페이스의 전체 이름과 같아야 한다.
- `id`는 Mapper 인터페이스의 메서드 이름과 같아야 한다.
- `resultType`, `parameterType`에는 클래스 이름만 쓴다. (`QuoteDto`)
- 비교 연산자 `<`는 XML에서 오류가 나니 `&lt;`로 쓰거나 `<![CDATA[ ... ]]>`로 감싼다.

---

# 7. DB

> ⑥ 담당자가 최종 확인한다. 바뀌면 이 절을 고친다.

## 이름

| 항목 | 규칙 | 예시 |
| --- | --- | --- |
| 테이블 | `tbl_` + 소문자 단수, 단어는 `_`로 | `tbl_request`, `tbl_request_answer` |
| 칼럼 | 소문자, 단어는 `_`로 | `quote_count`, `close_date` |
| PK | `테이블이름_seq` (`tbl_` 뺀 이름) | `request_seq` |
| 시퀀스 | `seq_테이블이름` | `seq_request` |
| FK | 참조하는 PK 이름 그대로 | `tbl_quote.request_seq` |
| FK (같은 테이블을 역할별로 참조) | `역할_seq` | `customer_seq`, `expert_seq` (둘 다 `tbl_member.member_seq` 참조) |
| 제약 조건 | `pk_`, `fk_`, `uq_`, `ck_` + 테이블 이름 | `pk_request`, `fk_quote_request` |

## 자료형과 값

| 데이터 | 자료형 | 비고 |
| --- | --- | --- |
| 번호 | `NUMBER` | |
| 금액, 개수 | `NUMBER` | |
| 짧은 글 | `VARCHAR2(n)` | 한글은 1글자에 3바이트. 이름 50자면 `VARCHAR2(150)` |
| 긴 글 | `VARCHAR2(4000)` 또는 `CLOB` | |
| 날짜 | `DATE` | 등록일 `regdate`, 수정일 `moddate`, 기본값 `sysdate` |
| 예/아니오 | `CHAR(1)` | `'Y'` / `'N'` + CHECK 제약 |
| 상태 값 | `VARCHAR2(20)` | **영문 대문자 코드** + CHECK 제약. 화면에서 한글로 바꿔 보여 준다 |

상태 값 예시 (각 파트가 테이블 정의서에 표로 적는다)

| 코드 | 화면 표시 |
| --- | --- |
| `OPEN` | 모집 중 |
| `CLOSED` | 견적 마감 |
| `SELECTED` | 선택 완료 |
| `CANCELED` | 취소 |
| `EXPIRED` | 만료 |

## 삭제

다른 테이블이 참조하는 데이터(회원, 요청서, 거래 등)는 **DELETE 하지 않고 상태만 바꾼다.** 예) 탈퇴 회원은 `enabled = 'N'`. 지우면 FK로 연결된 데이터가 같이 문제가 생긴다.

## SQL 파일

- 자기 파트 테이블은 `db/0번호_기능.sql`, 더미 데이터는 `db/dummy/0번호_기능_dummy.sql`에 쓴다.
- 테이블을 만들면 `00_drop_all.sql`에 DROP 문도 추가한다.
- **실행 순서**: `00_drop_all.sql` → `01` ~ `06` → `dummy/01` ~ `dummy/06`
  (FK 때문에 번호 순서대로 실행해야 한다. SQL Developer에서는 파일을 열고 **F5(스크립트 실행)**)
- CREATE 문 안에는 빈 줄을 넣지 않는다. SQL*Plus에서 문장이 끊긴다.
- 테이블을 바꿀 때는 팀에 먼저 말하고, 자기 CREATE 파일을 고친 뒤 공지한다. 팀원은 pull 받고 00부터 다시 실행한다.

## 더미 데이터 번호

다른 파트가 FK로 쓰므로 번호를 고정한다. (00부터 다시 실행해야 이 번호가 나온다)

| 회원 번호 | 아이디 | 권한 |
| --- | --- | --- |
| 1 | admin | 관리자 |
| 2 ~ 4 | customer1 ~ 3 | 고객 |
| 5 ~ 7 | expert1 ~ 3 | 고수 |

비밀번호는 모두 `1111`이다.
