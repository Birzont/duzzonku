# 네이버 지도 API 설정 가이드

## 📌 왜 네이버 지도?

- ✅ **한국 지도에 최적화** (정확도 높음)
- ✅ **간단한 설정** (Google Maps보다 쉬움)
- ✅ **무료 한도 충분** (일 300,000건까지 무료)
- ✅ **결제 정보 불필요** (무료 범위 내)

## 🚀 설정 방법

### 1단계: 네이버 클라우드 플랫폼 회원가입

1. [네이버 클라우드 플랫폼](https://www.ncloud.com/) 접속
2. 우측 상단 **회원가입** 클릭
3. 네이버 계정으로 로그인 (또는 신규 가입)

### 2단계: 콘솔 접속

1. [네이버 클라우드 플랫폼 콘솔](https://console.ncloud.com/) 접속
2. 로그인

### 3단계: Application 등록

1. 좌측 메뉴에서 **Services** 클릭
2. **AI·NAVER API** 선택
3. **Application 등록** 버튼 클릭

### 4단계: 애플리케이션 정보 입력

1. **Application 이름**: 원하는 이름 입력 (예: "두쫀쿠 지도")
2. **Service 선택**:
   - **Maps** 카테고리에서
   - ✅ **Web Dynamic Map** 체크
3. **서비스 환경 등록**:
   - **Web 서비스 URL**에 다음 추가:
     ```
     http://localhost:8000
     http://127.0.0.1:8000
     ```
   - 나중에 실제 배포 도메인도 추가 (예: `https://yourdomain.com`)
   - **도로명주소 검색(지오코딩)** 도 이 URL에서만 동작**하므로**, 사용 중인 접속 주소를 꼭 넣어두세요.

4. **등록** 버튼 클릭

### 5단계: 클라이언트 ID 복사

1. 등록된 애플리케이션 목록에서 방금 만든 앱 클릭
2. **인증 정보** 탭에서
3. **Client ID** 복사 (예: `abc123def456`)

### 6단계: config.js 설정

`config.js` 파일을 열고 클라이언트 ID 입력:

```javascript
const NAVER_MAP_CLIENT_ID = 'abc123def456'; // 복사한 클라이언트 ID
```

## ✅ 완료!

1. 브라우저에서 `http://localhost:8000` 접속
2. 지도가 정상적으로 표시되는지 확인

## 📊 사용량 확인

1. 네이버 클라우드 플랫폼 콘솔
2. **AI·NAVER API** > **Application**
3. 등록한 앱 선택 → **사용량 통계** 확인

## 💰 요금 정책

### 무료 한도 (충분합니다!)
- **Web Dynamic Map**: 일 300,000건
- 초과 시: 1,000건당 3원

### 예상 사용량
- 일반 웹사이트: 일 1,000 ~ 10,000건
- 트래픽이 많은 사이트: 일 50,000건

→ 대부분의 경우 **무료**로 사용 가능! 🎉

## 🔧 문제 해결

### "주소를 찾을 수 없습니다" (지오코딩 실패)

1. **Web 서비스 URL 확인**
   - 네이버 클라우드 플랫폼 콘솔 → Application → 해당 앱
   - **인증 정보** → **Web 서비스 URL**에 **지금 접속 중인 페이지의 출처**가 들어가 있어야 합니다.
   - 예: `http://localhost:8000` 이나 `http://127.0.0.1:5500` (Live Server 사용 시) 등
   - 저장 후 잠시 기다렸다가 다시 시도하세요.

### "지도를 불러올 수 없습니다" 오류

1. **클라이언트 ID 확인**
   - config.js의 ID가 정확한지 확인

2. **서비스 환경 확인**
   - 네이버 클라우드 콘솔에서
   - Application > 인증 정보 > Web 서비스 URL
   - `http://localhost:8000` 추가되어 있는지 확인

3. **Web Dynamic Map 활성화 확인**
   - Application 설정에서
   - Maps > Web Dynamic Map이 체크되어 있는지 확인

### 하드 리프레시
브라우저 캐시 삭제:
- Mac: `Cmd + Shift + R`
- Windows: `Ctrl + Shift + R`

## 📚 참고 문서

- [네이버 지도 API 문서](https://navermaps.github.io/maps.js.ncp/)
- [네이버 클라우드 플랫폼 가이드](https://guide.ncloud-docs.com/docs/naveropenapiv3-maps-overview)
- [API 사용 예제](https://navermaps.github.io/maps.js.ncp/docs/tutorial-digest.example.html)

## 🎯 다음 단계

배포 시 실제 도메인 추가:
1. 네이버 클라우드 콘솔 > Application
2. Web 서비스 URL에 실제 도메인 추가
3. 예: `https://yourdomain.com`, `https://www.yourdomain.com`
