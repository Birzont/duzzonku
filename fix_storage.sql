-- doozonku-uploads 버킷에 대한 Storage 정책 설정

-- 기존 정책 삭제 (있다면)
DROP POLICY IF EXISTS "인증된 사용자는 이미지를 업로드할 수 있습니다" ON storage.objects;
DROP POLICY IF EXISTS "모든 사용자는 이미지를 볼 수 있습니다" ON storage.objects;
DROP POLICY IF EXISTS "사용자는 자신의 이미지를 업데이트할 수 있습니다" ON storage.objects;
DROP POLICY IF EXISTS "사용자는 자신의 이미지를 삭제할 수 있습니다" ON storage.objects;

-- 새 정책 생성
-- 1. 인증된 사용자는 이미지를 업로드할 수 있습니다
CREATE POLICY "인증된 사용자는 이미지를 업로드할 수 있습니다"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'doozonku-uploads');

-- 2. 모든 사용자는 이미지를 볼 수 있습니다
CREATE POLICY "모든 사용자는 이미지를 볼 수 있습니다"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'doozonku-uploads');

-- 3. 사용자는 자신의 이미지를 업데이트할 수 있습니다
CREATE POLICY "사용자는 자신의 이미지를 업데이트할 수 있습니다"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'doozonku-uploads');

-- 4. 사용자는 자신의 이미지를 삭제할 수 있습니다
CREATE POLICY "사용자는 자신의 이미지를 삭제할 수 있습니다"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'doozonku-uploads');
