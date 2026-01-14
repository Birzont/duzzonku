# 네이버 지도 API 인증 실패 해결 가이드

## 🔍 현재 오류
```
NAVER Maps JavaScript API v3 네이버 지도 Open API 인증이 실패하였습니다.
Error Code: 200 / Authentication Failed
Client ID: xz4giv1ste
URI: http://localhost:8000/
```

## ✅ 체크리스트

### 1. 네이버 클라우드 플랫폼 콘솔 확인

#### A. Application 상태 확인
1. [네이버 클라우드 플랫폼 콘솔](https://console.ncloud.com/) 접속
2. **AI·NAVER API** → **Application** 클릭
3. 클라이언트 ID `xz4giv1ste`가 있는 애플리케이션 찾기
4. **상태**가 **활성**인지 확인

#### B. 서비스 선택 확인
1. 애플리케이션 클릭 → **서비스** 탭
2. 다음이 **체크**되어 있는지 확인:
   - ✅ **Maps** → **Web Dynamic Map**

#### C. Web 서비스 URL 확인 (중요!)
1. **서비스 환경** 탭 클릭
2. **Web 서비스 URL** 섹션 확인
3. 다음 중 하나가 **정확히** 등록되어 있어야 함:
   ```
   http://localhost:8000
   ```
   또는
   ```
   http://localhost:*
   ```
   또는
   ```
   http://127.0.0.1:8000
   ```

   ⚠️ **주의사항:**
   - 슬래시(`/`)가 있으면 안 됨: `http://localhost:8000/` ❌
   - 포트 번호가 정확해야 함: `8000`
   - `http://`로 시작해야 함 (https 아님)

### 2. 클라이언트 ID 확인

1. **인증 정보** 탭 클릭
2. **Client ID**가 `xz4giv1ste`와 정확히 일치하는지 확인
3. **Client Secret**은 필요 없음 (지도 API는 Client ID만 사용)

### 3. 브라우저 확인

#### A. 하드 리프레시
- Mac: `Cmd + Shift + R`
- Windows: `Ctrl + Shift + R`

#### B. 캐시 삭제
1. 개발자 도구 열기 (F12)
2. Network 탭 → **Disable cache** 체크
3. 페이지 새로고침

#### C. 콘솔 확인
1. 개발자 도구 (F12) → **Console** 탭
2. 다음 메시지 확인:
   ```
   네이버 지도 클라이언트 ID: xz4giv1ste
   현재 URL: http://localhost:8000/
   ```

### 4. URL 형식 문제 해결

오류 메시지에서 URI가 `http://localhost:8000/`로 표시되는데, 네이버 클라우드 콘솔에 등록된 URL과 정확히 일치해야 합니다.

#### 해결 방법 A: 콘솔에 슬래시 포함하여 등록
1. 네이버 클라우드 콘솔 → Application → 서비스 환경
2. Web 서비스 URL에 다음 추가:
   ```
   http://localhost:8000/
   ```
   (슬래시 포함)

#### 해결 방법 B: 와일드카드 사용
1. Web 서비스 URL에 다음 추가:
   ```
   http://localhost:*
   ```
   (모든 포트 허용)

### 5. Application 재생성 (최후의 수단)

위 방법들이 모두 실패하면:

1. 기존 Application 삭제
2. 새로 Application 등록
3. **Application 이름**: "두쫀쿠지도"
4. **서비스 선택**: Maps → Web Dynamic Map ✅
5. **Web 서비스 URL**: `http://localhost:8000` (슬래시 없이)
6. **등록** 후 새 Client ID 복사
7. `config.js`에 새 Client ID 입력

## 🔧 추가 디버깅

브라우저 콘솔에서 다음 명령어로 확인:

```javascript
// 클라이언트 ID 확인
console.log('Client ID:', NAVER_MAP_CLIENT_ID);

// 현재 URL 확인
console.log('Current URL:', window.location.href);

// 네이버 지도 객체 확인
console.log('naver.maps:', typeof naver !== 'undefined' ? naver.maps : 'not loaded');
```

## 📞 네이버 클라우드 플랫폼 지원

위 방법으로 해결되지 않으면:
- [네이버 클라우드 플랫폼 고객센터](https://www.ncloud.com/support/question)
- 또는 Application 상세 페이지의 **문의하기** 기능 사용

## 💡 가장 흔한 원인

1. **Web 서비스 URL 불일치** (80%)
   - 콘솔: `http://localhost:8000`
   - 실제: `http://localhost:8000/` (슬래시 차이)
   - 해결: 와일드카드 `http://localhost:*` 사용

2. **Web Dynamic Map 미선택** (15%)
   - 해결: 서비스 탭에서 Web Dynamic Map 체크 확인

3. **Application 비활성화** (5%)
   - 해결: Application 상태가 "활성"인지 확인
