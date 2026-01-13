# 두바이쫀득쿠키(두쫀쿠) 파는곳 지도 서비스

실시간으로 두바이쫀득쿠키 판매처와 재고를 확인할 수 있는 지도 기반 웹 서비스입니다.

## 🚀 주요 기능

- **실시간 재고 확인**: 지도에서 각 매장의 쿠키 재고를 실시간으로 확인
- **매장 검색**: 매장명, 주소로 판매처 검색
- **판매자 등록**: 판매자가 직접 매장 정보와 재고를 관리
- **관리자 승인**: 관리자가 매장 등록 요청을 검토하고 승인

## 📋 페이지 구성

### 1. index.html - 메인 지도 페이지
- Google Maps 기반 지도
- 커스텀 마커로 매장 위치 표시
- 재고 수량에 따른 색상 구분:
  - 0개: 검정색
  - 1-29개: 노란색  
  - 30개 이상: 초록색 (#a5d184)
- 검색 기능
- 매장 정보 팝업

### 2. login.html - 로그인 및 매장 관리
- 구글 OAuth 로그인
- 이메일 회원가입/로그인
- 실시간 재고 관리 (+/- 버튼)
- 매장 정보 등록/수정
- 대표 사진 업로드
- 사업자등록증 업로드

### 3. admin.html - 관리자 페이지
- 매장 등록 요청 목록
- 승인/거절 기능
- 사업자등록증 확인

## 🛠 설정 방법

### 1. Supabase 설정

#### 데이터베이스 테이블 생성
```sql
CREATE TABLE doozonku (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  location TEXT,
  subject TEXT,
  img TEXT,
  plaintext TEXT,
  number INTEGER DEFAULT 0,
  url TEXT,
  address TEXT,
  checked TEXT DEFAULT 'false',
  gov TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX idx_doozonku_checked ON doozonku(checked);
CREATE INDEX idx_doozonku_user_id ON doozonku(user_id);
```

#### Storage 버킷 생성
1. Supabase 대시보드에서 Storage 메뉴로 이동
2. 새 버킷 생성: `images`
3. 버킷을 Public으로 설정

#### RLS (Row Level Security) 정책 설정
```sql
-- 승인된 매장은 모두 볼 수 있음
CREATE POLICY "Anyone can view approved stores"
ON doozonku FOR SELECT
USING (checked = 'true');

-- 사용자는 자신의 매장만 수정 가능
CREATE POLICY "Users can update their own store"
ON doozonku FOR UPDATE
USING (auth.uid() = user_id);

-- 사용자는 자신의 매장 등록 가능
CREATE POLICY "Users can insert their own store"
ON doozonku FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- 관리자는 모든 매장 조회 가능
CREATE POLICY "Admin can view all stores"
ON doozonku FOR SELECT
TO authenticated
USING (
  auth.jwt() ->> 'email' = 'samuelthegalaxys@gmail.com'
);

-- 관리자는 모든 매장 업데이트/삭제 가능
CREATE POLICY "Admin can update all stores"
ON doozonku FOR UPDATE
TO authenticated
USING (
  auth.jwt() ->> 'email' = 'samuelthegalaxys@gmail.com'
);

CREATE POLICY "Admin can delete stores"
ON doozonku FOR DELETE
TO authenticated
USING (
  auth.jwt() ->> 'email' = 'samuelthegalaxys@gmail.com'
);
```

#### Google OAuth 설정
1. Supabase 대시보드 > Authentication > Providers
2. Google 활성화
3. Google Cloud Console에서 OAuth 2.0 클라이언트 ID 생성
4. 승인된 리디렉션 URI 추가: `https://[YOUR-PROJECT-ID].supabase.co/auth/v1/callback`

### 2. 네이버 지도 API 설정

1. [네이버 클라우드 플랫폼](https://console.ncloud.com/) 접속
2. AI·NAVER API > Application 등록
3. Maps > Web Dynamic Map 선택
4. Web 서비스 URL에 `http://localhost:8000` 추가
5. 생성된 클라이언트 ID 복사

자세한 가이드는 `NAVER_MAP_SETUP.md` 파일 참고

### 3. config.js 설정

`config.js` 파일을 열고 다음 값들을 입력하세요:

```javascript
// Supabase 설정
const SUPABASE_URL = 'https://xxxxx.supabase.co'; // Supabase 프로젝트 URL
const SUPABASE_ANON_KEY = 'your-anon-key-here'; // Supabase anon/public key

// 네이버 지도 API 클라이언트 ID
const NAVER_MAP_CLIENT_ID = 'your-naver-client-id';

// 관리자 이메일
const ADMIN_EMAIL = 'samuelthegalaxys@gmail.com';
```

### 4. 마커 이미지 준비

프로젝트 루트 디렉토리에 `doozonku.png` 파일을 추가하세요.
- 권장 크기: 40x40 픽셀
- 투명 배경 PNG 포맷
- 쿠키 또는 관련 아이콘 이미지

## 🌐 로컬 실행

정적 파일 서버를 사용하여 실행:

```bash
# Python 3
python -m http.server 8000

# Node.js (http-server 설치 필요)
npx http-server -p 8000

# PHP
php -S localhost:8000
```

브라우저에서 `http://localhost:8000` 접속

## 📂 파일 구조

```
doozonku/
├── index.html          # 메인 지도 페이지
├── login.html          # 로그인 및 매장 관리 페이지
├── admin.html          # 관리자 페이지
├── styles.css          # 스타일시트
├── config.js           # 설정 파일 (API 키 등)
├── doozonku.png        # 마커 이미지
└── README.md           # 이 파일
```

## 🔒 보안 주의사항

1. **config.js를 .gitignore에 추가**: API 키가 포함되어 있으므로 저장소에 커밋하지 마세요
2. **Google Maps API 키 제한**: HTTP 리퍼러 제한을 설정하여 다른 도메인에서 사용 불가하도록 설정
3. **Supabase RLS 정책**: 위에서 제공한 RLS 정책을 반드시 설정하세요
4. **HTTPS 사용**: 프로덕션 환경에서는 반드시 HTTPS를 사용하세요

## 🚀 배포

### Netlify / Vercel 배포

1. GitHub 저장소에 코드 푸시 (config.js 제외)
2. Netlify 또는 Vercel에서 저장소 연결
3. 환경 변수 설정:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `GOOGLE_MAPS_API_KEY`
4. 빌드 설정 없이 바로 배포

### GitHub Pages 배포

1. config.js를 설정한 후 저장소에 푸시
2. Settings > Pages에서 브랜치 선택
3. 배포 완료!

## 📱 기능 설명

### 재고 색상 시스템

- **검정색 (0개)**: 품절
- **노란색 (1-29개)**: 소량 재고
- **초록색 (30개+)**: 충분한 재고

### 매장 등록 프로세스

1. 판매자가 login.html에서 회원가입/로그인
2. 매장 정보 입력 및 사업자등록증 업로드
3. 관리자(samuelthegalaxys@gmail.com)가 admin.html에서 승인
4. 승인된 매장이 지도에 표시됨

## 🐛 문제 해결

### 네이버 지도가 표시되지 않는 경우
- config.js의 클라이언트 ID가 올바른지 확인
- 네이버 클라우드 콘솔에서 Web Dynamic Map이 활성화되어 있는지 확인
- Web 서비스 URL에 `http://localhost:8000`이 등록되어 있는지 확인
- 브라우저 콘솔에서 오류 메시지 확인

### Supabase 연결 오류
- config.js의 SUPABASE_URL과 SUPABASE_ANON_KEY 확인
- Supabase 프로젝트가 활성화되어 있는지 확인
- 네트워크 연결 상태 확인

### 이미지 업로드 실패
- Supabase Storage에 `images` 버킷이 생성되어 있는지 확인
- 버킷이 Public으로 설정되어 있는지 확인
- 파일 크기 제한 확인 (기본 50MB)

## 📄 라이선스

MIT License

## 👨‍💻 개발자

Samuel Galaxy
