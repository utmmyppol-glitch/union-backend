-- page_layout에 status 컬럼 추가 (DRAFT/PUBLISHED)
ALTER TABLE union_schema.page_layout
    ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'DRAFT';

ALTER TABLE dataware_schema.page_layout
    ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'DRAFT';
