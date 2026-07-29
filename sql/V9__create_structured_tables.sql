-- =============================================
-- 배치4: 구조화 리스트 전용 테이블
-- union: history, partners, glossary
-- dataware: pricing_plans, education_sessions, download_resources
-- =============================================

-- UNION — 연혁
CREATE TABLE union_schema.history (
    id          BIGSERIAL PRIMARY KEY,
    year        VARCHAR(10) NOT NULL,
    title       VARCHAR(255) NOT NULL,
    events      TEXT NOT NULL,           -- JSON array: ["이벤트1", "이벤트2"]
    sort_order  INTEGER DEFAULT 0,
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT NOW()
);

-- UNION — 파트너
CREATE TABLE union_schema.partners (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    role        VARCHAR(255),
    logo_url    VARCHAR(500),
    website_url VARCHAR(500),
    sort_order  INTEGER DEFAULT 0,
    is_active   BOOLEAN DEFAULT TRUE
);

-- UNION — 용어사전
CREATE TABLE union_schema.glossary (
    id          BIGSERIAL PRIMARY KEY,
    term        VARCHAR(50) NOT NULL,
    full_name   VARCHAR(255),
    definition  TEXT NOT NULL,
    category    VARCHAR(50),
    sort_order  INTEGER DEFAULT 0,
    is_active   BOOLEAN DEFAULT TRUE
);

-- DATAWARE — 가격 플랜
CREATE TABLE dataware_schema.pricing_plans (
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    license_type    VARCHAR(100),
    price           INTEGER DEFAULT 0,
    original_price  INTEGER DEFAULT 0,
    price_display   VARCHAR(50),
    features        TEXT,                  -- JSON array
    badge           VARCHAR(50),
    is_popular      BOOLEAN DEFAULT FALSE,
    sort_order      INTEGER DEFAULT 0,
    is_active       BOOLEAN DEFAULT TRUE
);

-- DATAWARE — 교육 세션
CREATE TABLE dataware_schema.education_sessions (
    id          BIGSERIAL PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    date        VARCHAR(100),
    thumbnail   VARCHAR(500),
    tag         VARCHAR(50),
    status      VARCHAR(50) DEFAULT 'OPEN',
    description TEXT,
    location    VARCHAR(255),
    sort_order  INTEGER DEFAULT 0,
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT NOW()
);

-- DATAWARE — 다운로드 자료
CREATE TABLE dataware_schema.download_resources (
    id          BIGSERIAL PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    file_type   VARCHAR(50),
    thumbnail   VARCHAR(500),
    download_url VARCHAR(500),
    sort_order  INTEGER DEFAULT 0,
    is_active   BOOLEAN DEFAULT TRUE
);
