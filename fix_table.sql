-- doozonku 테이블에 user_id 컬럼 추가
ALTER TABLE public.doozonku 
ADD COLUMN IF NOT EXISTS user_id UUID;

-- 인덱스 생성 (성능 향상)
CREATE INDEX IF NOT EXISTS doozonku_user_id_idx ON public.doozonku(user_id);

-- RLS 정책 추가 (아직 없다면)
ALTER TABLE public.doozonku ENABLE ROW LEVEL SECURITY;

-- 기존 정책 삭제 (있다면)
DROP POLICY IF EXISTS "사용자는 자신의 매장 정보를 조회할 수 있습니다" ON public.doozonku;
DROP POLICY IF EXISTS "사용자는 매장 정보를 등록할 수 있습니다" ON public.doozonku;
DROP POLICY IF EXISTS "사용자는 자신의 매장 정보를 수정할 수 있습니다" ON public.doozonku;
DROP POLICY IF EXISTS "사용자는 자신의 매장 정보를 삭제할 수 있습니다" ON public.doozonku;
DROP POLICY IF EXISTS "승인된 매장은 모두 볼 수 있습니다" ON public.doozonku;

-- 새 정책 생성
-- 1. 사용자는 자신의 데이터를 조회할 수 있습니다
CREATE POLICY "사용자는 자신의 매장 정보를 조회할 수 있습니다"
ON public.doozonku
FOR SELECT
USING (auth.uid() = user_id);

-- 2. 사용자는 자신의 데이터를 삽입할 수 있습니다
CREATE POLICY "사용자는 매장 정보를 등록할 수 있습니다"
ON public.doozonku
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- 3. 사용자는 자신의 데이터를 업데이트할 수 있습니다
CREATE POLICY "사용자는 자신의 매장 정보를 수정할 수 있습니다"
ON public.doozonku
FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- 4. 사용자는 자신의 데이터를 삭제할 수 있습니다
CREATE POLICY "사용자는 자신의 매장 정보를 삭제할 수 있습니다"
ON public.doozonku
FOR DELETE
USING (auth.uid() = user_id);

-- 5. 모든 사용자는 승인된 매장을 볼 수 있습니다 (지도용)
CREATE POLICY "승인된 매장은 모두 볼 수 있습니다"
ON public.doozonku
FOR SELECT
USING (checked = 'true');
