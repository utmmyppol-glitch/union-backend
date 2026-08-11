-- 문의 첨부파일 URL 컬럼 추가
ALTER TABLE union_schema.inquiries ADD COLUMN IF NOT EXISTS file_url VARCHAR(500);
ALTER TABLE dataware_schema.inquiries ADD COLUMN IF NOT EXISTS file_url VARCHAR(500);
