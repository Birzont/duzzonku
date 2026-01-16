-- 두 명까지 매장을 관리할 수 있도록 user_id_2 컬럼 추가
ALTER TABLE public.doozonku 
ADD COLUMN IF NOT EXISTS user_id_2 UUID;

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS doozonku_user_id_2_idx ON public.doozonku(user_id_2);

-- RLS 정책 수정: user_id_2도 포함
DROP POLICY IF EXISTS "사용자는 자신의 매장 정보를 조회할 수 있습니다" ON public.doozonku;
DROP POLICY IF EXISTS "사용자는 자신의 매장 정보를 수정할 수 있습니다" ON public.doozonku;

-- 조회 정책: user_id 또는 user_id_2가 자신인 경우 조회 가능
CREATE POLICY "사용자는 자신의 매장 정보를 조회할 수 있습니다"
ON public.doozonku
FOR SELECT
USING (
  auth.uid() = user_id 
  OR auth.uid() = user_id_2
);

-- 수정 정책: user_id 또는 user_id_2가 자신인 경우 수정 가능
CREATE POLICY "사용자는 자신의 매장 정보를 수정할 수 있습니다"
ON public.doozonku
FOR UPDATE
USING (
  auth.uid() = user_id 
  OR auth.uid() = user_id_2
  OR (
    store_code IS NOT NULL 
    AND (
      (user_id IS NULL AND user_id_2 IS NULL)
      OR auth.uid() = user_id
      OR auth.uid() = user_id_2
    )
  )
)
WITH CHECK (
  auth.uid() = user_id 
  OR auth.uid() = user_id_2
  OR (
    store_code IS NOT NULL 
    AND (
      (user_id IS NULL AND user_id_2 IS NULL)
      OR auth.uid() = user_id
      OR auth.uid() = user_id_2
    )
  )
);
