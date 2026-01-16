-- 최대 6명까지 매장을 관리할 수 있도록 user_id_3, user_id_4, user_id_5, user_id_6 컬럼 추가
ALTER TABLE public.doozonku 
ADD COLUMN IF NOT EXISTS user_id_3 UUID,
ADD COLUMN IF NOT EXISTS user_id_4 UUID,
ADD COLUMN IF NOT EXISTS user_id_5 UUID,
ADD COLUMN IF NOT EXISTS user_id_6 UUID;

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS doozonku_user_id_3_idx ON public.doozonku(user_id_3);
CREATE INDEX IF NOT EXISTS doozonku_user_id_4_idx ON public.doozonku(user_id_4);
CREATE INDEX IF NOT EXISTS doozonku_user_id_5_idx ON public.doozonku(user_id_5);
CREATE INDEX IF NOT EXISTS doozonku_user_id_6_idx ON public.doozonku(user_id_6);

-- RLS 정책 수정: user_id부터 user_id_6까지 모두 포함
DROP POLICY IF EXISTS "사용자는 자신의 매장 정보를 조회할 수 있습니다" ON public.doozonku;
DROP POLICY IF EXISTS "사용자는 자신의 매장 정보를 수정할 수 있습니다" ON public.doozonku;

-- 조회 정책: user_id부터 user_id_6까지 자신인 경우 조회 가능
CREATE POLICY "사용자는 자신의 매장 정보를 조회할 수 있습니다"
ON public.doozonku
FOR SELECT
USING (
  auth.uid() = user_id 
  OR auth.uid() = user_id_2
  OR auth.uid() = user_id_3
  OR auth.uid() = user_id_4
  OR auth.uid() = user_id_5
  OR auth.uid() = user_id_6
);

-- 수정 정책: user_id부터 user_id_6까지 자신인 경우 수정 가능
CREATE POLICY "사용자는 자신의 매장 정보를 수정할 수 있습니다"
ON public.doozonku
FOR UPDATE
USING (
  auth.uid() = user_id 
  OR auth.uid() = user_id_2
  OR auth.uid() = user_id_3
  OR auth.uid() = user_id_4
  OR auth.uid() = user_id_5
  OR auth.uid() = user_id_6
  OR (
    store_code IS NOT NULL 
    AND (
      (user_id IS NULL AND user_id_2 IS NULL AND user_id_3 IS NULL 
       AND user_id_4 IS NULL AND user_id_5 IS NULL AND user_id_6 IS NULL)
      OR auth.uid() = user_id
      OR auth.uid() = user_id_2
      OR auth.uid() = user_id_3
      OR auth.uid() = user_id_4
      OR auth.uid() = user_id_5
      OR auth.uid() = user_id_6
    )
  )
)
WITH CHECK (
  auth.uid() = user_id 
  OR auth.uid() = user_id_2
  OR auth.uid() = user_id_3
  OR auth.uid() = user_id_4
  OR auth.uid() = user_id_5
  OR auth.uid() = user_id_6
  OR (
    store_code IS NOT NULL 
    AND (
      (user_id IS NULL AND user_id_2 IS NULL AND user_id_3 IS NULL 
       AND user_id_4 IS NULL AND user_id_5 IS NULL AND user_id_6 IS NULL)
      OR auth.uid() = user_id
      OR auth.uid() = user_id_2
      OR auth.uid() = user_id_3
      OR auth.uid() = user_id_4
      OR auth.uid() = user_id_5
      OR auth.uid() = user_id_6
    )
  )
);
