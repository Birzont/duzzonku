# Google OAuth 로그인 설정 가이드

구글 로그인을 활성화하기 위한 단계별 가이드입니다.

## 1. Google Cloud Console 설정

### 1.1 프로젝트 생성 또는 선택
1. [Google Cloud Console](https://console.cloud.










google.com/) 접속
2. 상단에서 프로젝트 선택 또는 새 프로젝트 생성

### 1.2 OAuth 동의 화면 설정
1. 왼쪽 메뉴 > **API 및 서비스** > **OAuth 동의 화면**
2. **외부** 선택 (내부는 Google Workspace 사용자만 가능)
3. **만들기** 클릭
4. 필수 정보 입력:
   - **앱 이름**: 두바이쫀득쿠키 (또는 원하는 이름)
   - **사용자 지원 이메일**: 본인 이메일
   - **앱 로고**: 선택사항
   - **앱 도메인**: 선택사항
   - **개발자 연락처 정보**: 본인 이메일
5. **저장 후 계속** 클릭

### 1.3 범위(Scopes) 설정
1. **범위** 탭에서 **저장 후 계속** 클릭 (기본 범위 사용)
2. 또는 필요한 범위 추가:
   - `openid`
   - `email`
   - `profile`

### 1.4 테스트 사용자 추가 (선택사항)
- 개발 중에는 테스트 사용자만 로그인 가능
- **테스트 사용자** 탭에서 이메일 추가
- 프로덕션으로 전환하면 모든 사용자 사용 가능

### 1.5 OAuth 2.0 클라이언트 ID 생성
1. 왼쪽 메뉴 > **API 및 서비스** > **사용자 인증 정보**
2. 상단 **+ 사용자 인증 정보 만들기** > **OAuth 클라이언트 ID**
3. **애플리케이션 유형**: **웹 애플리케이션** 선택
4. **이름**: 두쫀쿠 로그인 (또는 원하는 이름)
5. **승인된 자바스크립트 원본**:
   - 개발 환경: `http://localhost:8000`
   - 프로덕션 환경: 실제 도메인 추가 (예: `https://yourdomain.com`)
6. **승인된 리디렉션 URI**:
   - Supabase 콜백 URL 추가:
     ```
     https://[YOUR-PROJECT-ID].supabase.co/auth/v1/callback
     ```
   - 예시: `https://snukwjcvhsnfybcfacsw.supabase.co/auth/v1/callback`
7. **만들기** 클릭
8. **클라이언트 ID**와 **클라이언트 보안 비밀번호** 복사 (나중에 필요)

## 2. Supabase 설정

### 2.1 Google OAuth 활성화
1. [Supabase Dashboard](https://supabase.com/dashboard) 접속
2. 프로젝트 선택
3. 왼쪽 메뉴 > **Authentication** > **Providers**
4. **Google** 찾기
5. **Enable Google** 토글 활성화

### 2.2 Google OAuth 정보 입력
1. **Client ID (for OAuth)**: Google Cloud Console에서 복사한 클라이언트 ID 입력
2. **Client Secret (for OAuth)**: Google Cloud Console에서 복사한 클라이언트 보안 비밀번호 입력
3. **Save** 클릭

### 2.3 Site URL 확인
1. **Authentication** > **URL Configuration** 확인
2. **Site URL**이 올바른지 확인:
   - 개발 환경: `http://localhost:8000`
   - 프로덕션 환경: 실제 도메인

## 3. 코드 확인

현재 `login.html`에 이미 구글 로그인 함수가 구현되어 있습니다:

```javascript
async function signInWithGoogle() {
    try {
        const { data, error } = await supabaseClient.auth.signInWithOAuth({
            provider: 'google',
            options: {
                redirectTo: window.location.href
            }
        });
        if (error) throw error;
    } catch (error) {
        showAlert('loginView', error.message, 'error');
    }
}
```

## 4. 테스트

1. 브라우저에서 `login.html` 열기
2. **🔐 Google로 로그인** 버튼 클릭
3. Google 로그인 화면으로 리디렉션
4. Google 계정 선택 및 로그인
5. 권한 승인
6. 자동으로 대시보드로 리디렉션

## 5. 문제 해결

### "redirect_uri_mismatch" 오류
- Google Cloud Console의 **승인된 리디렉션 URI**에 Supabase 콜백 URL이 정확히 입력되었는지 확인
- URL 끝에 슬래시(`/`)가 있는지 확인

### "access_denied" 오류
- OAuth 동의 화면이 프로덕션으로 전환되지 않았고 테스트 사용자 목록에 없는 경우 발생
- 테스트 사용자 추가 또는 프로덕션으로 전환

### 로그인 후 대시보드로 이동하지 않음
- `window.location.href`가 올바른지 확인
- 브라우저 콘솔에서 오류 메시지 확인

### Supabase에서 Google Provider가 보이지 않음
- Supabase 프로젝트가 활성화되어 있는지 확인
- 다른 브라우저나 시크릿 모드에서 시도

## 6. 추가 참고사항

- **프로덕션 배포 시**: Google Cloud Console에서 실제 도메인을 승인된 자바스크립트 원본과 리디렉션 URI에 추가
- **보안**: 클라이언트 보안 비밀번호는 절대 공개 저장소에 커밋하지 마세요
- **사용자 정보**: Google 로그인 시 자동으로 이메일과 프로필 정보가 Supabase에 저장됩니다
