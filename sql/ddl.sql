-- ============================================================
-- Union Backend - DDL (Final State)
-- All tables with columns merged from V1~V26 migrations
-- Database: PostgreSQL (union_integrated)
-- ============================================================
SET client_encoding TO 'UTF8';

-- =============================================
-- SCHEMAS
-- =============================================
CREATE SCHEMA IF NOT EXISTS common;
CREATE SCHEMA IF NOT EXISTS union_schema;
CREATE SCHEMA IF NOT EXISTS dataware_schema;


-- =============================================
-- COMMON SCHEMA
-- =============================================

CREATE TABLE common.admins (
    id          BIGSERIAL PRIMARY KEY,
    username    VARCHAR(255) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    role        VARCHAR(255) NOT NULL DEFAULT 'VIEWER',
    site        VARCHAR(255),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =============================================
-- UNION_SCHEMA
-- =============================================

CREATE TABLE union_schema.posts (
    id              BIGSERIAL PRIMARY KEY,
    title           VARCHAR(255) NOT NULL,
    slug            VARCHAR(255) UNIQUE,
    content         TEXT,
    excerpt         VARCHAR(255),
    category        VARCHAR(255) NOT NULL,
    thumbnail_url   VARCHAR(255),
    published       BOOLEAN DEFAULT FALSE,
    view_count      INTEGER DEFAULT 0,
    detail_json     TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE union_schema.inquiries (
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(255) NOT NULL,
    company         VARCHAR(255) NOT NULL,
    phone           VARCHAR(255) NOT NULL,
    email           VARCHAR(255) NOT NULL,
    message         TEXT,
    product         VARCHAR(255),
    status          VARCHAR(255) NOT NULL DEFAULT 'NEW',
    assignee        VARCHAR(255),
    consent_privacy BOOLEAN,
    file_url        VARCHAR(500),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE union_schema.customer_stories (
    id              BIGSERIAL PRIMARY KEY,
    company         VARCHAR(255) NOT NULL,
    slug            VARCHAR(255) UNIQUE,
    industry        VARCHAR(255),
    title           VARCHAR(255) NOT NULL,
    content         TEXT,
    thumbnail_url   VARCHAR(255),
    logo_url        VARCHAR(255),
    published       BOOLEAN DEFAULT FALSE,
    detail_json     TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE union_schema.client_logos (
    id           BIGSERIAL PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    logo_url     VARCHAR(255),
    sort_order   INTEGER,
    is_active    BOOLEAN DEFAULT TRUE,
    show_on_home BOOLEAN NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE union_schema.menu (
    id          BIGSERIAL PRIMARY KEY,
    parent_id   BIGINT REFERENCES union_schema.menu(id),
    name        VARCHAR(100) NOT NULL,
    url         VARCHAR(255),
    menu_type   VARCHAR(20) NOT NULL DEFAULT 'CONTENT'
                CHECK (menu_type IN ('CONTENT', 'BOARD', 'LINK')),
    sort_order  INTEGER DEFAULT 0,
    depth       INTEGER DEFAULT 0,
    is_exposed  BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE union_schema.content (
    id          BIGSERIAL PRIMARY KEY,
    menu_id     BIGINT REFERENCES union_schema.menu(id),
    region_key  VARCHAR(100) NOT NULL,
    title       VARCHAR(255),
    body_html   TEXT,
    updated_by  BIGINT,
    updated_at  TIMESTAMP DEFAULT NOW(),
    UNIQUE (menu_id, region_key)
);

CREATE TABLE union_schema.content_history (
    id          BIGSERIAL PRIMARY KEY,
    content_id  BIGINT REFERENCES union_schema.content(id),
    body_html   TEXT,
    edited_by   BIGINT,
    edited_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE union_schema.site_config (
    id           BIGSERIAL PRIMARY KEY,
    config_key   VARCHAR(100) NOT NULL UNIQUE,
    config_value TEXT NOT NULL DEFAULT '',
    description  VARCHAR(255),
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE union_schema.history (
    id          BIGSERIAL PRIMARY KEY,
    year        VARCHAR(10) NOT NULL,
    title       VARCHAR(255) NOT NULL,
    events      TEXT NOT NULL,
    sort_order  INTEGER DEFAULT 0,
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE union_schema.glossary (
    id          BIGSERIAL PRIMARY KEY,
    term        VARCHAR(50) NOT NULL,
    full_name   VARCHAR(255),
    definition  TEXT NOT NULL,
    category    VARCHAR(50),
    sort_order  INTEGER DEFAULT 0,
    is_active   BOOLEAN DEFAULT TRUE
);

CREATE TABLE union_schema.page_layout (
    id          BIGSERIAL PRIMARY KEY,
    page_key    VARCHAR(100) NOT NULL UNIQUE,
    title       VARCHAR(255),
    layout_json TEXT NOT NULL DEFAULT '{}',
    status      VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    updated_by  BIGINT,
    updated_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE union_schema.insights (
    id              BIGSERIAL PRIMARY KEY,
    title           VARCHAR(500) NOT NULL,
    summary         TEXT,
    source_name     VARCHAR(200),
    source_url      VARCHAR(1000) NOT NULL UNIQUE,
    thumbnail_url   VARCHAR(1000),
    published_at    TIMESTAMP,
    status          VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    site_id         VARCHAR(20) NOT NULL DEFAULT 'UNION',
    approved_at     TIMESTAMP,
    approved_by     VARCHAR(100),
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_insights_status ON union_schema.insights (status);
CREATE INDEX idx_insights_published_at ON union_schema.insights (published_at DESC);


-- =============================================
-- DATAWARE_SCHEMA
-- =============================================

CREATE TABLE dataware_schema.products (
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(255) NOT NULL,
    slug            VARCHAR(255) NOT NULL UNIQUE,
    category        VARCHAR(255) NOT NULL,
    subtitle        TEXT,
    description     TEXT,
    features        TEXT,
    icon_url        VARCHAR(255),
    thumbnail_url   VARCHAR(255),
    certification   VARCHAR(255),
    sort_order      INTEGER,
    published       BOOLEAN DEFAULT TRUE,
    detail_json     TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.posts (
    id              BIGSERIAL PRIMARY KEY,
    title           VARCHAR(255) NOT NULL,
    slug            VARCHAR(255) UNIQUE,
    content         TEXT,
    excerpt         VARCHAR(255),
    category        VARCHAR(255) NOT NULL,
    thumbnail_url   VARCHAR(255),
    published       BOOLEAN DEFAULT FALSE,
    view_count      INTEGER DEFAULT 0,
    detail_json     TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.inquiries (
    id                  BIGSERIAL PRIMARY KEY,
    name                VARCHAR(255) NOT NULL,
    company             VARCHAR(255) NOT NULL,
    phone               VARCHAR(255) NOT NULL,
    email               VARCHAR(255) NOT NULL,
    message             TEXT,
    product             VARCHAR(255),
    status              VARCHAR(255) NOT NULL DEFAULT 'NEW',
    assignee            VARCHAR(255),
    consent_privacy     BOOLEAN,
    consent_third_party BOOLEAN,
    file_url            VARCHAR(500),
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.customer_stories (
    id              BIGSERIAL PRIMARY KEY,
    company         VARCHAR(255) NOT NULL,
    slug            VARCHAR(255) UNIQUE,
    industry        VARCHAR(255),
    title           VARCHAR(255) NOT NULL,
    content         TEXT,
    thumbnail_url   VARCHAR(255),
    logo_url        VARCHAR(255),
    published       BOOLEAN DEFAULT FALSE,
    detail_json     TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.client_logos (
    id           BIGSERIAL PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    logo_url     VARCHAR(255),
    sort_order   INTEGER,
    is_active    BOOLEAN DEFAULT TRUE,
    show_on_home BOOLEAN NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.downloads (
    id                  BIGSERIAL PRIMARY KEY,
    name                VARCHAR(255) NOT NULL,
    company             VARCHAR(255) NOT NULL,
    phone               VARCHAR(255) NOT NULL,
    email               VARCHAR(255) NOT NULL,
    file_type           VARCHAR(255),
    consent_privacy     BOOLEAN,
    consent_third_party BOOLEAN,
    consent_marketing   BOOLEAN,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.educations (
    id                  BIGSERIAL PRIMARY KEY,
    name                VARCHAR(255) NOT NULL,
    company             VARCHAR(255) NOT NULL,
    phone               VARCHAR(255) NOT NULL,
    email               VARCHAR(255) NOT NULL,
    position            VARCHAR(255),
    preferred_date      VARCHAR(255),
    note                TEXT,
    consent_privacy     BOOLEAN,
    consent_third_party BOOLEAN,
    status              VARCHAR(255) NOT NULL DEFAULT 'NEW',
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.seminars (
    id                  BIGSERIAL PRIMARY KEY,
    name                VARCHAR(255) NOT NULL,
    company             VARCHAR(255) NOT NULL,
    phone               VARCHAR(255) NOT NULL,
    email               VARCHAR(255) NOT NULL,
    department          VARCHAR(255),
    preferred_date      VARCHAR(255),
    attendees           INTEGER,
    topic               TEXT,
    note                TEXT,
    consent_privacy     BOOLEAN,
    consent_third_party BOOLEAN,
    status              VARCHAR(255) NOT NULL DEFAULT 'NEW',
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.menu (
    id          BIGSERIAL PRIMARY KEY,
    parent_id   BIGINT REFERENCES dataware_schema.menu(id),
    name        VARCHAR(100) NOT NULL,
    url         VARCHAR(255),
    menu_type   VARCHAR(20) NOT NULL DEFAULT 'CONTENT'
                CHECK (menu_type IN ('CONTENT', 'BOARD', 'LINK')),
    sort_order  INTEGER DEFAULT 0,
    depth       INTEGER DEFAULT 0,
    is_exposed  BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE dataware_schema.content (
    id          BIGSERIAL PRIMARY KEY,
    menu_id     BIGINT REFERENCES dataware_schema.menu(id),
    region_key  VARCHAR(100) NOT NULL,
    title       VARCHAR(255),
    body_html   TEXT,
    updated_by  BIGINT,
    updated_at  TIMESTAMP DEFAULT NOW(),
    UNIQUE (menu_id, region_key)
);

CREATE TABLE dataware_schema.content_history (
    id          BIGSERIAL PRIMARY KEY,
    content_id  BIGINT REFERENCES dataware_schema.content(id),
    body_html   TEXT,
    edited_by   BIGINT,
    edited_at   TIMESTAMP DEFAULT NOW()
);

CREATE TABLE dataware_schema.site_config (
    id           BIGSERIAL PRIMARY KEY,
    config_key   VARCHAR(100) NOT NULL UNIQUE,
    config_value TEXT NOT NULL DEFAULT '',
    description  VARCHAR(255),
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.pricing_plans (
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    license_type    VARCHAR(100),
    price           INTEGER DEFAULT 0,
    original_price  INTEGER DEFAULT 0,
    price_display   VARCHAR(50),
    features        TEXT,
    badge           VARCHAR(50),
    is_popular      BOOLEAN DEFAULT FALSE,
    sort_order      INTEGER DEFAULT 0,
    is_active       BOOLEAN DEFAULT TRUE
);

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

CREATE TABLE dataware_schema.download_resources (
    id           BIGSERIAL PRIMARY KEY,
    title        VARCHAR(255) NOT NULL,
    description  TEXT,
    file_type    VARCHAR(50),
    thumbnail    VARCHAR(500),
    download_url VARCHAR(500),
    sort_order   INTEGER DEFAULT 0,
    is_active    BOOLEAN DEFAULT TRUE
);

CREATE TABLE dataware_schema.page_layout (
    id          BIGSERIAL PRIMARY KEY,
    page_key    VARCHAR(100) NOT NULL UNIQUE,
    title       VARCHAR(255),
    layout_json TEXT NOT NULL DEFAULT '{}',
    status      VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    updated_by  BIGINT,
    updated_at  TIMESTAMP DEFAULT NOW()
);
