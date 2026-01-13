# Supabase 설정 가이드

## 1. 테이블 생성 (doozonku)

Supabase Dashboard > SQL Editor에서 다음 SQL을 실행하세요:

```sql
-- doozonku 테이블 생성
CREATE TABLE IF NOT EXISTS public.doozonku (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    user_id UUID NOT NULL,
    location TEXT NOT NULL,
    address TEXT NOT NULL,
    subject TEXT NOT NULL,
    plaintext TEXT,
    url TEXT,
    img TEXT,
    gov TEXT,
    number INTEGER DEFAULT 0,
    checked TEXT DEFAULT 'false'
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS doozonku_user_id_idx ON public.doozonku(user_id);
CREATE INDEX IF NOT EXISTS doozonku_checked_idx ON public.doozonku(checked);
```

## 2. Row Level Security (RLS) 정책 설정

### RLS 활성화
```sql
ALTER TABLE public.doozonku ENABLE ROW LEVEL SECURITY;
```

### 정책 생성
```sql
-- 사용자는 자신의 데이터를 조회할 수 있습니다
CREATE POLICY "사용자는 자신의 매장 정보를 조회할 수 있습니다"
ON public.doozonku
FOR SELECT
USING (auth.uid() = user_id);

-- 사용자는 자신의 데이터를 삽입할 수 있습니다
CREATE POLICY "사용자는 매장 정보를 등록할 수 있습니다"
ON public.doozonku
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- 사용자는 자신의 데이터를 업데이트할 수 있습니다
CREATE POLICY "사용자는 자신의 매장 정보를 수정할 수 있습니다"
ON public.doozonku
FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- 사용자는 자신의 데이터를 삭제할 수 있습니다
CREATE POLICY "사용자는 자신의 매장 정보를 삭제할 수 있습니다"
ON public.doozonku
FOR DELETE
USING (auth.uid() = user_id);

-- 모든 사용자는 승인된 매장을 볼 수 있습니다 (지도용)
CREATE POLICY "승인된 매장은 모두 볼 수 있습니다"
ON public.doozonku
FOR SELECT
USING (checked = 'true');
```

## 3. Storage 버킷 생성

### 3.1 버킷 생성
1. Supabase Dashboard > Storage로 이동
2. "New bucket" 클릭
3. 버킷 이름: `images`
4. Public bucket: **체크** (공개 버킷으로 설정)
5. "Create bucket" 클릭

### 3.2 Storage 정책 설정

Storage > images 버킷 > Policies에서 다음 정책을 추가하세요:

#### SQL Editor에서 실행:
```sql
-- 인증된 사용자는 이미지를 업로드할 수 있습니다
CREATE POLICY "인증된 사용자는 이미지를 업로드할 수 있습니다"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'images');

-- 모든 사용자는 이미지를 볼 수 있습니다
CREATE POLICY "모든 사용자는 이미지를 볼 수 있습니다"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'images');

-- 사용자는 자신의 이미지를 업데이트할 수 있습니다
CREATE POLICY "사용자는 자신의 이미지를 업데이트할 수 있습니다"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'images');

-- 사용자는 자신의 이미지를 삭제할 수 있습니다
CREATE POLICY "사용자는 자신의 이미지를 삭제할 수 있습니다"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'images');
```

## 4. Authentication 설정

### 4.1 Email 인증 활성화
1. Supabase Dashboard > Authentication > Providers
2. Email 제공자가 활성화되어 있는지 확인

### 4.2 Google OAuth 설정 (선택사항)
1. Authentication > Providers > Google
2. Enable 체크
3. Google Cloud Console에서 OAuth 2.0 클라이언트 ID 생성
4. Client ID와 Client Secret 입력
5. Redirect URL을 Google Cloud Console에 추가

## 5. 설정 확인

모든 설정이 완료되면:

1. 브라우저에서 `login.html`을 새로고침
2. 회원가입 또는 로그인 시도
3. 매장 정보 등록 테스트
4. 개발자 도구 콘솔에서 오류 메시지 확인

## 문제 해결

### "relation public.doozonku does not exist" 오류
- 1단계 SQL을 다시 실행하여 테이블 생성

### "new row violates row-level security policy" 오류
- 2단계 RLS 정책을 다시 확인

### "The resource you are looking for could not be found" (Storage)
- 3단계 버킷이 올바르게 생성되었는지 확인
- 버킷 이름이 정확히 `images`인지 확인

### "permission denied for bucket" 오류
- 3.2단계 Storage 정책이 올바르게 설정되었는지 확인
- 버킷이 Public으로 설정되었는지 확인

## 추가 정보

- Supabase 공식 문서: https://supabase.com/docs
- RLS 가이드: https://supabase.com/docs/guides/auth/row-level-security
- Storage 가이드: https://supabase.com/docs/guides/storage
