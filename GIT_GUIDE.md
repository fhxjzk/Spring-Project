# Git 사용 가이드

Git Bash로 커밋, push, pull, Pull Request까지 하는 방법이다. 명령어를 그대로 복사해서 쓰면 된다.
브랜치 규칙과 커밋 메시지 규칙은 [README의 GitHub 규칙](README.md#github-규칙)을 따른다.

## 용어

| 용어 | 뜻 |
| --- | --- |
| commit | 내 PC에 작업 내용을 저장하는 것 |
| push | 내 PC의 커밋을 GitHub에 올리는 것 |
| pull | GitHub의 최신 코드를 내 PC로 받는 것 |
| branch | 다른 사람 작업과 섞이지 않게 따로 작업하는 공간 |
| Pull Request (PR) | 내 브랜치를 `develop`에 합쳐 달라고 요청하는 것 |
| 충돌 (conflict) | 두 사람이 같은 파일의 같은 줄을 고쳐서 Git이 어느 쪽을 쓸지 모르는 상태 |

---

# 1. 처음 한 번만 할 것

## 1-1. Git 설정

수업 때 이미 설정했다면 아래 명령으로 확인만 한다.

```bash
git config --global --list
```

`user.name`, `user.email`, `core.autocrlf=true`, `core.quotepath=false`가 보이면 된다. 빠진 것이 있으면 그 줄만 실행한다. 이름과 이메일은 GitHub 계정과 같게 쓴다.

```bash
git config --global user.name "GitHub아이디"
git config --global user.email "GitHub에 등록한 이메일"
git config --global core.autocrlf true
git config --global core.quotepath false
```

**아래 설정은 수업 때 안 했으니 모두 새로 실행한다.**

```bash
git config --global pull.rebase false
```

| 설정 | 하는 일 |
| --- | --- |
| `core.autocrlf true` | Windows 줄바꿈 때문에 모든 줄이 바뀐 것처럼 보이는 문제를 막는다 |
| `core.quotepath false` | 한글 파일 이름이 `\354\232\224`처럼 깨져 보이지 않게 한다 |
| `pull.rebase false` | `git pull` 할 때 "divergent branches" 오류로 멈추지 않게 한다. pull로 받아 올 때 수업 때 배운 **merge** 방식으로 합친다 |

## 1-2. 저장소 받기 (clone)

> 경로에 한글과 띄어쓰기가 없는 폴더에 받는다. 예: `C:\workspace` (O) / `C:\내 문서` (X)

```bash
mkdir -p /c/workspace
cd /c/workspace
git clone https://github.com/fhxjzk/Spring-Project.git
cd Spring-Project
```

처음에 GitHub 로그인 창이 뜨면 **Sign in with your browser**를 눌러 브라우저로 로그인한다. 한 번 로그인하면 다음부터는 묻지 않는다. (Git Bash에서는 토큰을 만들 필요가 없다)

## 1-3. 프로젝트 폴더에서 Git Bash 열기

Git 명령은 **항상 프로젝트 폴더 안에서** 실행해야 한다. 둘 중 편한 방법을 쓴다.

- 파일 탐색기에서 `C:\workspace\Spring-Project` 폴더 빈 곳 우클릭 → **추가 옵션 표시** → **Open Git Bash here**
- Git Bash를 열고 `cd /c/workspace/Spring-Project`

제대로 열렸으면 입력줄 끝에 `(main)`이나 `(develop)`처럼 **현재 브랜치 이름**이 보인다.

---

# 2. 매일 작업 순서

## ① develop 최신 코드 받기

```bash
git switch develop
git pull origin develop
```

## ② 내 작업 브랜치 만들기

```bash
git switch -c feature/기능명
```

예: `git switch -c feature/request-form`

> 이미 만들어 둔 브랜치에서 이어서 작업할 때는 `-c` 없이 이동한 뒤 develop을 받아 온다.
> ```bash
> git switch feature/기능명
> git pull origin develop
> ```

## ③ 작업하기

STS에서 코드를 작성한다. Git Bash에서 pull로 코드를 받은 뒤에는 STS에서 프로젝트 우클릭 → **Refresh**(F5)를 해야 바뀐 파일이 보인다.

## ④ 바뀐 파일 확인

```bash
git status
```

- 빨간색 파일: 바뀌었지만 아직 커밋 대상에 안 넣은 파일
- 초록색 파일: 커밋 대상에 넣은 파일
- `target/`, `.settings/`, `.classpath` 같은 파일이 보이면 커밋하지 않는다

무엇을 고쳤는지 줄 단위로 보고 싶으면 `git diff`를 쓴다. (`q`를 누르면 빠져나온다)

## ⑤ 커밋할 파일 담기 (add)

```bash
git add 파일경로
```

예: `git add src/main/java/com/project/request/RequestController.java`

`git status`로 확인했을 때 커밋할 파일만 있으면 한 번에 담아도 된다.

```bash
git add .
```

## ⑥ 커밋

```bash
git commit -m "feat: 공개 요청서 작성 기능 추가"
```

커밋은 작은 단위로 자주 한다. 기능 하나가 다 끝날 때까지 기다리지 않아도 된다.

## ⑦ GitHub에 올리기 (push)

```bash
git push origin feature/기능명
```

## ⑧ Pull Request 올리기

1. GitHub 저장소에 들어가면 노란 박스에 **Compare & pull request** 버튼이 보인다. 누른다.
   (안 보이면 **Pull requests** 탭 → **New pull request**)
2. 위쪽 **base**를 `develop`으로, **compare**를 내 브랜치로 맞춘다. **base가 `main`이 아닌지 꼭 확인한다.**
3. 제목은 커밋 메시지 형식으로 쓴다. 예: `feat: 공개 요청서 작성 기능 추가`
4. 본문에 **무엇을 만들었는지**, **어떻게 확인했는지** 적는다.
5. 오른쪽 **Reviewers**에서 리뷰할 팀원을 고르고 **Create pull request**를 누른다.
6. 팀방에 PR 링크를 공유한다.

## ⑨ 리뷰하고 머지하기

**리뷰하는 사람**

1. PR의 **Files changed** 탭에서 바뀐 코드를 읽는다.
2. 궁금한 줄은 줄 번호 옆 **+** 를 눌러 댓글을 단다.
3. 오른쪽 위 **Review changes** → **Approve** → **Submit review**

**PR을 올린 사람**

1. Approve를 받으면 **Merge pull request** → **Confirm merge**
2. **Delete branch**를 눌러 GitHub의 브랜치를 지운다.

## ⑩ 머지 후 정리

```bash
git switch develop
git pull origin develop
git branch -d feature/기능명
```

다음 작업은 다시 ①부터 시작한다.

---

# 3. 작업 중간에 develop 받아 오기

작업이 며칠 걸리면 다른 사람 코드와 많이 벌어져서 나중에 충돌이 커진다. 하루에 한 번은 develop을 내 브랜치로 받아 온다.

```bash
git status
git add .
git commit -m "feat: 작업 중간 저장"
git pull origin develop
```

**받아 오기 전에 내 작업을 먼저 커밋해야 한다.** 커밋하지 않은 수정이 있으면 pull이 실패한다.

pull을 하면 vi 화면이 열릴 때가 있다. merge 커밋 메시지가 이미 적혀 있으니 고치지 않고 `Esc` → `:wq` → `Enter`로 저장하고 나오면 된다.

---

# 4. 충돌이 났을 때

pull을 했는데 아래처럼 나오면 충돌이다.

```
CONFLICT (content): Merge conflict in src/main/.../RequestMapper.xml
Automatic merge failed; fix conflicts and then commit the result.
```

## 해결 순서

1. `git status`로 충돌난 파일을 확인한다. (**both modified**라고 표시된다)
2. STS에서 그 파일을 열면 이런 표시가 있다.
   ```
   <<<<<<< HEAD
   내가 고친 코드
   =======
   다른 사람이 고친 코드
   >>>>>>> 커밋번호 또는 브랜치 이름
   ```
3. 두 코드를 보고 최종 코드만 남긴다. 둘 다 필요하면 둘 다 남긴다.
   `<<<<<<<`, `=======`, `>>>>>>>` 줄은 **반드시 지운다.**
4. 저장한 뒤 실행해서 잘 돌아가는지 확인한다.
5. 커밋하고 push한다.
   ```bash
   git add .
   git commit -m "fix: develop 병합 충돌 해결"
   git push origin feature/기능명
   ```

다른 사람이 작성한 코드라서 어느 쪽이 맞는지 모르겠으면 **혼자 고르지 말고 그 사람에게 물어본다.**

## PR 화면에 "This branch has conflicts"가 뜰 때

내 PC에서 [3. 작업 중간에 develop 받아 오기](#3-작업-중간에-develop-받아-오기)를 하고, 충돌을 위처럼 해결한 뒤 push한다. PR은 자동으로 갱신된다.

---

# 5. 실수했을 때

| 상황 | 명령 |
| --- | --- |
| `git add`를 잘못했다 (커밋 전) | `git restore --staged 파일경로` |
| 파일 수정을 처음 상태로 되돌리고 싶다 (커밋 전) | `git restore 파일경로` ⚠ 고친 내용이 사라진다 |
| 커밋 메시지를 잘못 썼다 (push 전) | `git commit --amend -m "새 메시지"` |
| 브랜치를 안 만들고 develop에서 작업했다 (커밋 전) | `git switch -c feature/기능명` → 고친 내용이 새 브랜치로 그대로 옮겨진다 |
| 브랜치를 안 만들고 develop에서 커밋했다 (push 전) | 팀에 바로 말한다. 혼자 해결하려다 커밋이 사라질 수 있다 |

> `git push --force`, `git reset --hard`는 다른 사람 작업이나 내 작업을 지울 수 있다. **쓰기 전에 꼭 팀에 먼저 물어본다.**

---

# 6. 자주 나는 오류

| 오류 메시지 | 원인 | 해결 |
| --- | --- | --- |
| `fatal: not a git repository` | 프로젝트 폴더가 아닌 곳에서 실행했다 | `cd /c/workspace/Spring-Project` |
| `Your local changes ... would be overwritten` | 커밋 안 한 수정이 있는데 pull이나 브랜치 이동을 했다 | 먼저 `git add .` → `git commit` |
| `! [rejected] ... (fetch first)` | GitHub에 내 PC에 없는 커밋이 있다 | `git pull origin 내브랜치` 후 다시 push |
| `fatal: Need to specify how to reconcile divergent branches` | pull 설정이 안 되어 있다 | `git config --global pull.rebase false` 후 다시 pull |
| pull이나 commit 뒤에 `~` 표시가 가득한 화면이 열렸다 | 커밋 메시지를 쓰라고 vi가 열렸다 | 메시지를 쓸 때는 `i` → 입력 → `Esc` → `:wq` → `Enter`. 그대로 두려면 `Esc` → `:wq` → `Enter` |
| vi에서 실수로 이상하게 입력했다 | | `Esc` → `:q!` → `Enter`로 저장하지 않고 나온다 |
| `warning: LF will be replaced by CRLF` | 줄바꿈 변환 안내 | 무시해도 된다 |
| 다른 GitHub 계정으로 로그인된다 | 예전에 로그인한 정보가 남아 있다 | Windows **자격 증명 관리자** → **Windows 자격 증명** → `git:https://github.com` 삭제 후 다시 push |
| `Permission denied` / `403` | 저장소 초대를 수락하지 않았다 | GitHub 알림이나 이메일에서 초대 수락 |

---

# 7. 참고: STS에서 커밋하기

커밋은 STS의 **Git Staging** 창으로 해도 된다. pull과 push는 Git Bash로 한다.

1. **Window → Show View → Other → Git → Git Staging**
2. **Unstaged Changes**에서 커밋할 파일을 **Staged Changes**로 끌어 옮긴다.
3. **Commit Message**에 메시지를 쓴다.
4. **Commit** 버튼을 누른다. (**Commit and Push**는 누르지 않는다)
5. Git Bash에서 `git push origin feature/기능명`

---

# 한 장 요약

```bash
# 시작
git switch develop
git pull origin develop
git switch -c feature/기능명

# 작업 후
git status
git add .
git commit -m "feat: 무엇을 했는지"
git push origin feature/기능명
# → GitHub에서 PR (base: develop)

# 머지 후
git switch develop
git pull origin develop
git branch -d feature/기능명
```
