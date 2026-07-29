-- =============================================
-- site_config: 사이트별 전역 설정값 (key-value)
-- 대표전화, 주소, 푸터 정보 등 자주 바뀌는 설정
-- =============================================

CREATE TABLE union_schema.site_config (
    id          BIGSERIAL PRIMARY KEY,
    config_key  VARCHAR(100) NOT NULL UNIQUE,
    config_value TEXT NOT NULL DEFAULT '',
    description VARCHAR(255),
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.site_config (
    id          BIGSERIAL PRIMARY KEY,
    config_key  VARCHAR(100) NOT NULL UNIQUE,
    config_value TEXT NOT NULL DEFAULT '',
    description VARCHAR(255),
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
