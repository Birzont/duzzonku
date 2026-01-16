-- doozonku 테이블에 store_code 컬럼 추가
ALTER TABLE public.doozonku 
ADD COLUMN IF NOT EXISTS store_code TEXT UNIQUE;

-- 인덱스 생성 (매장 코드로 빠른 검색)
CREATE INDEX IF NOT EXISTS doozonku_store_code_idx ON public.doozonku(store_code);

-- 기존 매장에 대한 매장 코드 생성 함수 (선택사항)
-- 관리자가 직접 매장 코드를 설정할 수 있도록 함
