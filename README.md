# 동네 기반 재능 거래 플랫폼

숨고처럼 고객이 요청서를 올리면 고수들이 견적을 보내고, 고객이 고수를 골라 안전결제로 거래하는 재능 거래 플랫폼입니다.

- 기간: 3주
- 인원: 6명
- 팀: (조 이름)

## 팀원

| 이름 | GitHub | 담당 |
| --- | --- | --- |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |

## 개발 환경

**팀원 모두 아래 버전을 똑같이 맞춘다.** 버전이 다르면 다른 사람 PC에서 프로젝트가 안 돌아갈 수 있다.

| 구분 | 버전 |
| --- | --- |
| OS | Windows 11 |
| IDE | STS 3.9.x (Eclipse) |
| JDK | 11 |
| Spring Framework | 5.3.39 |
| WAS | Apache Tomcat 9.0 |
| DB | Oracle XE (XEPDB1) |
| 기타 | MyBatis, Spring Security, Lombok, REST + Ajax, WebSocket, FileUpload, Kakao Map API |

> 기본 프로젝트는 수업 때 만든 ToyProject 설정을 바탕으로 한다. 기본 프로젝트를 올린 뒤 버전이 바뀌면 이 표를 고친다.

---

# 처음 시작하기 (팀원 각자 한 번만)

STS 설정 파일은 저장소에 올리지 않으므로 **각자 PC에서 한 번씩** 설정해야 한다.
수업 때 이미 해 둔 항목은 맞게 되어 있는지만 확인하고 넘어가면 된다.

## 1. Git 사용자 정보 등록

커밋에 내 이름이 남도록 Git Bash에서 한 번 실행한다. GitHub 계정과 같은 이메일을 쓴다.

```bash
git config --global user.name "GitHub아이디"
git config --global user.email "GitHub에 등록한 이메일"
```

## 2. STS 인코딩을 UTF-8로 (한글 깨짐 방지)

1. **Window → Preferences → General → Workspace**
   - **Text file encoding → Other → UTF-8**
2. **Window → Preferences → Web**
   - **CSS Files**, **HTML Files**, **JSP Files** 각각 **Encoding → ISO 10646/Unicode(UTF-8)**

## 3. JDK 11 확인

1. **Window → Preferences → Java → Installed JREs**에 JDK 11이 있고 체크되어 있는지 확인한다.
2. **Window → Preferences → Java → Compiler**에서 **Compiler compliance level**이 **11**인지 확인한다.

## 4. Tomcat 9 서버 등록

1. 아래쪽 **Servers** 탭 → **No servers are available. Click this link...** 클릭
   (탭이 없으면 **Window → Show View → Other → Server → Servers**)
2. **Apache → Tomcat v9.0 Server** 선택 → **Next**
3. **Tomcat installation directory**에 Tomcat 9 설치 폴더를 지정 → **Finish**

## 5. Lombok 설치

수업 때 설치했다면 넘어간다. 안 되어 있으면 Getter, Setter 관련 빨간 줄이 생긴다.

1. lombok.jar를 더블클릭하거나 `java -jar lombok.jar` 실행
2. **Specify location**에서 `STS.exe`를 선택 → **Install / Update**
3. STS 재시작

## 6. 저장소 받기

> **경로에 한글과 띄어쓰기가 없는 폴더에 받는다.** Tomcat, Maven이 한글·띄어쓰기 경로에서 오류를 낼 수 있다.
> 예: `C:\workspace\Spring-Project` (O) / `C:\내 문서\스프링 프로젝트` (X)

STS에서:

1. **File → Import → Git → Projects from Git → Next**
2. **Clone URI** 선택 → URI에 아래 주소 입력 → 로그인 정보 입력(7번 참고)
   ```
   https://github.com/fhxjzk/Spring-Project.git
   ```
3. 브랜치는 `main`, `develop` 둘 다 체크
4. **Directory**를 위 예시처럼 영어 경로로 지정 → **Next**
5. **Import existing Eclipse projects**가 안 되면 **Cancel**로 닫고 7번으로 넘어간다
   (`.project` 파일을 올리지 않기 때문에 정상이다)

또는 Git Bash에서:

```bash
cd C:/workspace
git clone https://github.com/fhxjzk/Spring-Project.git
```

## 7. STS에서 프로젝트 불러오기

기본 프로젝트가 저장소에 올라온 뒤에 한다.

1. **File → Import → Maven → Existing Maven Projects → Next**
2. **Root Directory**에 받은 폴더 선택 → `pom.xml`이 체크된 것 확인 → **Finish**
3. 프로젝트 우클릭 → **Maven → Update Project → OK**
4. 프로젝트 우클릭 → **Run As → Run on Server → Tomcat v9.0** 으로 실행되는지 확인

## 8. GitHub 로그인 (Personal Access Token)

STS나 Git Bash에서 처음 push할 때 GitHub 로그인을 묻는다.
**비밀번호 자리에는 GitHub 비밀번호가 아니라 토큰을 넣는다.**

1. GitHub → 오른쪽 위 프로필 → **Settings → Developer settings → Personal access tokens → Tokens (classic)**
2. **Generate new token (classic)** → **repo** 체크 → 만료일 설정 → **Generate token**
3. 나온 토큰을 복사해서 따로 저장해 둔다 (다시 볼 수 없음)

## 9. 프로젝트용 Oracle 계정 만들기

수업 계정과 섞이지 않게 프로젝트용 계정을 새로 만든다. SQL Developer에서 **SYSTEM**(관리자) 계정으로 접속해 실행한다.
계정 이름과 비밀번호는 팀에서 하나로 정해서 모두 똑같이 쓴다.

```sql
ALTER SESSION SET CONTAINER = XEPDB1;

CREATE USER 계정이름 IDENTIFIED BY 비밀번호;
GRANT CONNECT, RESOURCE TO 계정이름;
ALTER USER 계정이름 QUOTA UNLIMITED ON USERS;
```

테이블 생성 SQL(DDL)은 ERD가 확정되면 저장소에 올린다. 각자 그 파일을 실행해서 같은 테이블을 만든다.

## 10. 비밀 정보 파일 만들기

기본 프로젝트가 올라오면 `secret.properties.example` 파일이 생긴다.
이 파일을 복사해서 이름을 `secret.properties`로 바꾸고, DB 비밀번호와 API 키를 적는다.
`secret.properties`는 `.gitignore`에 들어 있어서 GitHub에 올라가지 않는다.

---

# GitHub 규칙

## 브랜치

| 브랜치 | 용도 |
| --- | --- |
| `main` | 발표·배포용. 완성된 코드만 들어간다 |
| `develop` | 개발 통합용. 모든 기능이 여기로 모인다 |
| `feature/기능명` | 각자 작업용. 예: `feature/quote`, `feature/payment` |

- `main`, `develop`에는 직접 push하지 않는다. 반드시 Pull Request로 합친다.
- 브랜치 이름은 영어 소문자와 `-`만 쓴다. 예: `feature/request-form`
- 브랜치 하나에는 기능 하나만 작업한다.

## 작업 순서

1. `develop`으로 이동해서 최신 코드를 받는다.
   ```bash
   git checkout develop
   git pull origin develop
   ```
2. 내 작업 브랜치를 만든다.
   ```bash
   git checkout -b feature/기능명
   ```
3. 작업하고 커밋한다. (STS에서는 **Git Staging** 창 사용)
4. 내 브랜치를 push한다.
   ```bash
   git push origin feature/기능명
   ```
5. GitHub에서 **Compare & pull request** → base를 `develop`으로 바꾸고 PR을 올린다.
6. 팀원 1명이 확인하고 **Approve**하면 머지한다.
7. 머지가 끝나면 다시 1번부터 시작한다. 다 쓴 브랜치는 지운다.

작업이 며칠 걸리면, 다른 사람 코드와 많이 벌어지지 않게 중간중간 `develop`을 내 브랜치로 받아 온다.

```bash
git checkout feature/기능명
git pull origin develop
```

## 커밋 메시지

`머리말: 무엇을 했는지` 형식으로 쓴다.

| 머리말 | 뜻 | 예시 |
| --- | --- | --- |
| `feat` | 기능 추가 | `feat: 견적 발송 기능 추가` |
| `fix` | 버그 수정 | `fix: 견적 5개 초과 저장 오류 수정` |
| `refactor` | 동작은 그대로, 코드 정리 | `refactor: 결제 서비스 메서드 분리` |
| `style` | 화면 디자인, 코드 줄맞춤 | `style: 견적 목록 화면 정렬` |
| `docs` | 문서 | `docs: README 실행 방법 추가` |
| `chore` | 설정, 라이브러리 | `chore: pom.xml에 jackson 추가` |

## Pull Request

- 제목은 커밋 메시지와 같은 형식으로 쓴다.
- 본문에 **무엇을 만들었는지**, **어떻게 확인했는지** 적는다.
- 리뷰어는 코드를 읽어 보고, 이해가 안 되는 부분은 댓글로 물어본다.
- 충돌이 나면 PR을 올린 사람이 해결한다. 어려우면 팀에 바로 공유한다.

## 꼭 지킬 것

1. **API 키, DB 비밀번호는 절대 올리지 않는다.**
   `secret.properties`에만 적고, 값이 비어 있는 `secret.properties.example`만 올린다.
2. **공용 설정 파일은 담당자만 수정한다.**
   `pom.xml`, `web.xml`, `root-context.xml`, `servlet-context.xml`, `security-context.xml`은 여러 명이 동시에 고치면 충돌이 잘 난다. 고칠 게 있으면 담당자에게 요청한다.
   - 담당자: (이름)
3. **작업 시작 전에 항상 `develop`을 pull 받는다.**
4. **커밋 전에 바뀐 파일 목록을 확인한다.** `target/`, `.settings/`, `.classpath` 같은 파일이 보이면 빼고 커밋한다.
5. **DB 테이블을 바꿀 때는 팀에 먼저 말한다.** ERD 확정 뒤에는 팀 합의 없이 테이블을 바꾸지 않는다.
6. **다른 사람 브랜치에는 push하지 않는다.**
