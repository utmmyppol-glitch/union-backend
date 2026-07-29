-- =============================================
-- page_layout: Puck 페이지 빌더 JSON 저장
-- 각 페이지의 블록 레이아웃을 JSON으로 관리
-- =============================================

CREATE TABLE union_schema.page_layout (
    id          BIGSERIAL PRIMARY KEY,
    page_key    VARCHAR(100) NOT NULL UNIQUE,
    title       VARCHAR(255),
    layout_json TEXT NOT NULL DEFAULT '{}',
    updated_by  BIGINT,
    updated_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE dataware_schema.page_layout (
    id          BIGSERIAL PRIMARY KEY,
    page_key    VARCHAR(100) NOT NULL UNIQUE,
    title       VARCHAR(255),
    layout_json TEXT NOT NULL DEFAULT '{}',
    updated_by  BIGINT,
    updated_at  TIMESTAMP DEFAULT NOW()
);
