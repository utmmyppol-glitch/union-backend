-- V16: 복잡한 구조 데이터를 JSON으로 저장할 detail_json 컬럼 추가

-- ── dataware_schema ──
ALTER TABLE dataware_schema.products
    ADD COLUMN detail_json TEXT;

ALTER TABLE dataware_schema.posts
    ADD COLUMN detail_json TEXT;

ALTER TABLE dataware_schema.customer_stories
    ADD COLUMN detail_json TEXT;

-- ── union_schema ──
ALTER TABLE union_schema.posts
    ADD COLUMN detail_json TEXT;

ALTER TABLE union_schema.customer_stories
    ADD COLUMN detail_json TEXT;
