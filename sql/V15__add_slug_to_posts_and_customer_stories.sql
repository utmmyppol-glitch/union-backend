-- V15: posts, customer_stories 테이블에 slug 컬럼 추가 (양쪽 스키마)

-- ── union_schema ──
ALTER TABLE union_schema.posts
    ADD COLUMN slug VARCHAR(255) UNIQUE;

ALTER TABLE union_schema.customer_stories
    ADD COLUMN slug VARCHAR(255) UNIQUE;

-- ── dataware_schema ──
ALTER TABLE dataware_schema.posts
    ADD COLUMN slug VARCHAR(255) UNIQUE;

ALTER TABLE dataware_schema.customer_stories
    ADD COLUMN slug VARCHAR(255) UNIQUE;

-- 기존 데이터에 id 기반 임시 slug 생성
UPDATE union_schema.posts SET slug = 'post-' || id WHERE slug IS NULL;
UPDATE union_schema.customer_stories SET slug = 'story-' || id WHERE slug IS NULL;
UPDATE dataware_schema.posts SET slug = 'post-' || id WHERE slug IS NULL;
UPDATE dataware_schema.customer_stories SET slug = 'story-' || id WHERE slug IS NULL;
