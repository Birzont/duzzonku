# 배포 문제 해결 가이드

## 문제: config.js가 404 에러로 나타남

### 확인 사항

#### 1. GitHub Secrets 설정 확인

GitHub 저장소에서 다음을 확인하세요:

1. **Settings** → **Secrets and variables** → **Actions** 이동
2. 다음 4개의 Secret이 모두 설정되어 있는지 확인:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `NAVER_MAP_CLIENT_ID`
   - `ADMIN_EMAIL`

**중요**: Secret 이름이 정확히 일치해야 합니다 (대소문자 구분).

#### 2. GitHub Pages 설정 확인

1. **Settings** → **Pages** 이동
2. **Source**가 **"GitHub Actions"**로 설정되어 있는지 확인
3. **"Deploy from a branch"**가 아닌 **"GitHub Actions"**여야 합니다

#### 3. GitHub Actions 워크플로우 실행 확인

1. GitHub 저장소의 **Actions** 탭으로 이동
2. 최근 워크플로우 실행 내역 확인
3. 워크플로우가 실패했다면:
   - 로그를 확인하여 에러 메시지 확인
   - Secrets가 설정되지 않았다면 "secret not found" 같은 에러가 나타남

#### 4. 워크플로우 수동 실행

1. **Actions** 탭으로 이동
2. 왼쪽 사이드바에서 **"Deploy to GitHub Pages"** 워크플로우 선택
3. **"Run workflow"** 버튼 클릭
4. **"Run workflow"** 확인

### 해결 방법

#### 방법 1: Secrets 재설정

Secrets가 제대로 설정되지 않았을 수 있습니다:

1. **Settings** → **Secrets and variables** → **Actions**
2. 각 Secret을 삭제하고 다시 생성
3. 값이 정확한지 확인:
   - `SUPABASE_URL`: `https://snukwjcvhsnfybcfacsw.supabase.co` (슬래시 없이)
   - `SUPABASE_ANON_KEY`: Supabase Dashboard에서 복사한 전체 키
   - `NAVER_MAP_CLIENT_ID`: 네이버 클라우드 플랫폼의 클라이언트 ID
   - `ADMIN_EMAIL`: `samuelthegalaxys@gmail.com`

#### 방법 2: 워크플로우 재실행

1. 코드에 작은 변경사항 추가 (예: 주석 추가)
2. 커밋하고 푸시
3. 또는 Actions 탭에서 수동으로 워크플로우 실행

#### 방법 3: 배포 확인

워크플로우가 성공적으로 완료된 후:

1. **Settings** → **Pages**에서 배포 URL 확인
2. 브라우저에서 `https://birzont.github.io/duzzonku/config.js` 직접 접속
3. 파일 내용이 보이면 성공, 404면 실패

### 디버깅

#### 브라우저 콘솔 확인

1. 배포된 페이지 열기
2. F12로 개발자 도구 열기
3. **Console** 탭에서 에러 메시지 확인
4. **Network** 탭에서 `config.js` 요청 확인:
   - 404 에러: 파일이 생성되지 않음
   - 200 OK: 파일은 있지만 내용이 비어있을 수 있음

#### GitHub Actions 로그 확인

1. **Actions** 탭 → 최근 워크플로우 실행 클릭
2. **"Create config.js from secrets"** 단계 클릭
3. 로그에서 다음 확인:
   - `config.js created successfully` 메시지가 있는지
   - `ERROR: config.js was not created!` 메시지가 있는지
   - Secrets 값이 제대로 치환되었는지 (실제 값은 마스킹됨)

### 예상되는 에러 메시지

#### "secret not found" 또는 "secret is empty"
- GitHub Secrets가 설정되지 않았거나 이름이 잘못됨
- 해결: Secrets 재설정

#### "config.js was not created!"
- 파일 생성 단계에서 실패
- 해결: 워크플로우 로그 전체 확인

#### "Deploy to GitHub Pages" 워크플로우가 보이지 않음
- `.github/workflows/deploy.yml` 파일이 없거나 잘못된 위치에 있음
- 해결: 파일이 `main` 브랜치에 있는지 확인

### 추가 확인 사항

1. **브랜치 확인**: `main` 브랜치에 푸시했는지 확인
2. **파일 위치 확인**: `.github/workflows/deploy.yml` 파일이 올바른 위치에 있는지 확인
3. **권한 확인**: GitHub Pages가 활성화되어 있는지 확인

### 여전히 문제가 있다면

1. GitHub Actions 로그 전체를 확인
2. `config.js` 파일이 실제로 생성되었는지 확인 (워크플로우의 "Verify config.js" 단계 확인)
3. 배포된 사이트의 소스 코드 확인 (우클릭 → 페이지 소스 보기)
