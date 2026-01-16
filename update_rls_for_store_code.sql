-- 매장 코드로 매장 연결을 위한 RLS 정책 수정

-- 기존 UPDATE 정책 삭제
DROP POLICY IF EXISTS "사용자는 자신의 매장 정보를 수정할 수 있습니다" ON public.doozonku;

-- 새로운 UPDATE 정책 생성
-- 1. 자신의 매장 정보를 수정할 수 있음
-- 2. 매장 코드가 있고 user_id가 null이거나 자신의 user_id인 경우 수정 가능 (매장 연결)
CREATE POLICY "사용자는 자신의 매장 정보를 수정할 수 있습니다"
ON public.doozonku
FOR UPDATE
USING (
  auth.uid() = user_id 
  OR (
    store_code IS NOT NULL 
    AND (user_id IS NULL OR auth.uid() = user_id)
  )
)
WITH CHECK (
  auth.uid() = user_id 
  OR (
    store_code IS NOT NULL 
    AND (user_id IS NULL OR auth.uid() = user_id)
  )
);

-- 매장 코드로 매장을 조회할 수 있도록 정책 추가
-- (이미 "승인된 매장은 모두 볼 수 있습니다" 정책이 있지만, 
--  매장 코드로 조회할 때는 user_id가 null인 경우도 포함해야 함)
CREATE POLICY "사용자는 매장 코드로 매장을 조회할 수 있습니다"
ON public.doozonku
FOR SELECT
USING (
  checked = 'true' 
  OR auth.uid() = user_id
  OR (store_code IS NOT NULL AND user_id IS NULL)
);
