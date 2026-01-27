# GitHub Actions를 통한 보안 배포 설정 가이드

이 가이드는 GitHub Pages에 배포할 때 `config.js` 파일을 안전하게 생성하는 방법을 설명합니다.

## 문제점

- `config.js` 파일에는 Supabase 키와 네이버 지도 API 키가 포함되어 있습니다.
- 이 파일을 Git에 직접 커밋하면 보안 위험이 있습니다.
- 하지만 GitHub Pages에 배포하려면 이 파일이 필요합니다.

## 해결 방법

GitHub Actions를 사용하여 배포 시에만 `config.js` 파일을 생성합니다. 이렇게 하면:
- ✅ Git 히스토리에 실제 키가 남지 않습니다.
- ✅ 배포된 사이트에는 정상적으로 `config.js`가 포함됩니다.
- ✅ 보안적으로 깔끔합니다.

## 설정 단계

### 1. GitHub Secrets 설정

GitHub 저장소에서 다음 Secrets를 추가하세요:

1. GitHub 저장소 페이지로 이동
2. **Settings** > **Secrets and variables** > **Actions** 클릭
3. **New repository secret** 클릭하여 다음 4개의 Secret 추가:

   - **이름**: `SUPABASE_URL`
     **값**: `https://snukwjcvhsnfybcfacsw.supabase.co` (실제 Supabase 프로젝트 URL)

   - **이름**: `SUPABASE_ANON_KEY`
     **값**: Supabase Dashboard > Settings > API > anon/public key

   - **이름**: `NAVER_MAP_CLIENT_ID`
     **값**: 네이버 클라우드 플랫폼에서 발급받은 클라이언트 ID

   - **이름**: `ADMIN_EMAIL`
     **값**: `samuelthegalaxys@gmail.com` (관리자 이메일)

### 2. GitHub Pages 설정

1. GitHub 저장소 페이지로 이동
2. **Settings** > **Pages** 클릭
3. **Source**를 **GitHub Actions**로 변경
4. 저장

### 3. 워크플로우 확인

`.github/workflows/deploy.yml` 파일이 이미 생성되어 있습니다. 이 파일은:
- `main` 브랜치에 푸시될 때마다 자동 실행
- GitHub Secrets에서 값을 읽어 `config.js` 생성
- GitHub Pages에 배포

### 4. 배포 테스트

1. 코드를 커밋하고 푸시:
   ```bash
   git add .
   git commit -m "Add GitHub Actions workflow"
   git push origin main
   ```

2. GitHub 저장소의 **Actions** 탭에서 워크플로우 실행 확인

3. 배포 완료 후 `https://birzont.github.io/duzzonku/config.js` 접속하여 파일이 정상적으로 생성되었는지 확인

## 보안 참고사항

### Supabase Anon Key

- Supabase의 `anon` 키는 **브라우저에 노출되는 것이 정상**입니다.
- 보안은 **Row Level Security (RLS)** 정책으로 관리합니다.
- 하지만 Git 히스토리에 남기지 않는 것이 좋은 관행입니다.

### 네이버 지도 API 키

- 네이버 지도 API 클라이언트 ID도 **브라우저에 노출되는 것이 정상**입니다.
- 보안은 **네이버 콘솔에서 도메인 제한**으로 관리합니다.
- Git 히스토리에 남기지 않는 것이 좋습니다.

## 문제 해결

### 워크플로우가 실행되지 않음

- GitHub Pages 설정에서 Source가 **GitHub Actions**로 설정되어 있는지 확인
- `.github/workflows/deploy.yml` 파일이 올바른 위치에 있는지 확인

### config.js가 생성되지 않음

- GitHub Secrets가 올바르게 설정되었는지 확인
- 워크플로우 로그에서 에러 메시지 확인 (Actions 탭 > 워크플로우 실행 > 로그)

### 배포 후에도 404 에러

- 배포가 완료되었는지 확인 (보통 1-2분 소요)
- 브라우저 캐시 삭제 후 다시 시도
- `https://birzont.github.io/duzzonku/config.js` 직접 접속하여 파일 확인

## 로컬 개발

로컬에서 개발할 때는:
- `config.js` 파일을 직접 사용합니다 (`.gitignore`에 의해 Git에 포함되지 않음)
- `config.example.js`를 참고하여 `config.js`를 생성하세요

## 추가 정보

- [GitHub Actions 문서](https://docs.github.com/en/actions)
- [GitHub Pages 문서](https://docs.github.com/en/pages)
- [Supabase 보안 가이드](https://supabase.com/docs/guides/auth/row-level-security)
