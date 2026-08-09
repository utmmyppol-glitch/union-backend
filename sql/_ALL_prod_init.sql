-- ============================================================
-- 통합 초기화 스크립트 (V1 ~ V26 순서대로 합침)
-- 대상: 비어있는 운영 DB(union_integrated) 최초 1회 실행용
-- ============================================================
SET client_encoding TO 'UTF8';

-- ===================== V1__init_schema.sql =====================
-- =============================================
-- Union Backend - Initial Schema Migration
-- Database: PostgreSQL (union_integrated)
-- =============================================

-- 1. Create Schemas
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

CREATE TABLE union_schema.banners (
    id          BIGSERIAL PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    image_url   VARCHAR(255),
    link_url    VARCHAR(255),
    position    VARCHAR(255) NOT NULL,
    is_active   BOOLEAN DEFAULT TRUE,
    sort_order  INTEGER,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE union_schema.posts (
    id              BIGSERIAL PRIMARY KEY,
    title           VARCHAR(255) NOT NULL,
    content         TEXT,
    excerpt         VARCHAR(255),
    category        VARCHAR(255) NOT NULL,
    thumbnail_url   VARCHAR(255),
    published       BOOLEAN DEFAULT FALSE,
    view_count      INTEGER DEFAULT 0,
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
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE union_schema.customer_stories (
    id              BIGSERIAL PRIMARY KEY,
    company         VARCHAR(255) NOT NULL,
    industry        VARCHAR(255),
    title           VARCHAR(255) NOT NULL,
    content         TEXT,
    thumbnail_url   VARCHAR(255),
    logo_url        VARCHAR(255),
    published       BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE union_schema.client_logos (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    logo_url    VARCHAR(255),
    sort_order  INTEGER,
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE union_schema.downloads (
    id                  BIGSERIAL PRIMARY KEY,
    name                VARCHAR(255) NOT NULL,
    company             VARCHAR(255) NOT NULL,
    phone               VARCHAR(255) NOT NULL,
    email               VARCHAR(255) NOT NULL,
    file_type           VARCHAR(255),
    consent_privacy     BOOLEAN,
    consent_marketing   BOOLEAN,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- DATAWARE_SCHEMA
-- =============================================

CREATE TABLE dataware_schema.banners (
    id          BIGSERIAL PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    image_url   VARCHAR(255),
    link_url    VARCHAR(255),
    position    VARCHAR(255) NOT NULL,
    is_active   BOOLEAN DEFAULT TRUE,
    sort_order  INTEGER,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.posts (
    id              BIGSERIAL PRIMARY KEY,
    title           VARCHAR(255) NOT NULL,
    content         TEXT,
    excerpt         VARCHAR(255),
    category        VARCHAR(255) NOT NULL,
    thumbnail_url   VARCHAR(255),
    published       BOOLEAN DEFAULT FALSE,
    view_count      INTEGER DEFAULT 0,
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
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.customer_stories (
    id              BIGSERIAL PRIMARY KEY,
    company         VARCHAR(255) NOT NULL,
    industry        VARCHAR(255),
    title           VARCHAR(255) NOT NULL,
    content         TEXT,
    thumbnail_url   VARCHAR(255),
    logo_url        VARCHAR(255),
    published       BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dataware_schema.client_logos (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    logo_url    VARCHAR(255),
    sort_order  INTEGER,
    is_active   BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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


-- ===================== V2__seed_data.sql =====================
-- =============================================
-- Union Backend - 초기 목업 데이터
-- 개발/테스트 환경용
-- =============================================

-- =============================================
-- COMMON - 관리자 계정
-- =============================================

INSERT INTO common.admins (username, password, role, site) VALUES
-- 비밀번호: admin123!
('admin', '$2a$10$uTmCLAca6WNYIWS951JeyuzqOmTl3YIm2Ob5EQkNyKwQMOdUNwQoS', 'SUPER', NULL);

-- =============================================
-- UNION_SCHEMA
-- =============================================

-- 배너
INSERT INTO union_schema.banners (title, image_url, link_url, position, is_active, sort_order) VALUES
('유니온시스템즈 메인 배너',      '/images/union/hero-1.jpg',  '/about',     'HERO',      true, 1),
('IT 인프라 솔루션 소개',          '/images/union/hero-2.jpg',  '/solutions', 'HERO',      true, 2),
('2026 하반기 프로모션',           '/images/union/promo-1.jpg', '/event',     'PROMOTION', true, 1),
('신규 고객 할인 이벤트',          '/images/union/popup-1.jpg', '/contact',   'POPUP',     true, 1);

-- 게시글
INSERT INTO union_schema.posts (title, content, excerpt, category, thumbnail_url, published, view_count) VALUES
('유니온시스템즈, 클라우드 전환 컨설팅 서비스 출시',
 '유니온시스템즈가 기업의 디지털 전환을 지원하는 클라우드 전환 컨설팅 서비스를 공식 출시했습니다. 온프레미스 환경에서 클라우드로의 안전한 마이그레이션을 지원합니다.',
 '클라우드 전환 컨설팅 서비스 출시 안내', 'NOTICE', '/images/union/post-1.jpg', true, 152),

('데이터 기반 의사결정의 중요성',
 '빅데이터 시대에 데이터 기반 의사결정이 왜 중요한지, 그리고 이를 위해 어떤 인프라가 필요한지 알아봅니다. 데이터 레이크, 데이터 웨어하우스, ETL 파이프라인 등 핵심 개념을 정리했습니다.',
 '데이터 기반 의사결정을 위한 인프라 가이드', 'INSIGHT', '/images/union/post-2.jpg', true, 89),

('2026 IT 트렌드 전망 리포트',
 'AI, 클라우드, 보안 등 2026년 주요 IT 트렌드를 분석한 리포트입니다. 기업이 주목해야 할 기술 변화와 대응 전략을 담았습니다.',
 '2026년 IT 트렌드 전망', 'INSIGHT', '/images/union/post-3.jpg', true, 210),

('유니온시스템즈 고객 감사 이벤트',
 '유니온시스템즈의 고객 여러분께 감사의 마음을 전합니다. 이벤트 기간 중 무료 인프라 점검 서비스를 제공합니다.',
 '고객 감사 이벤트 안내', 'EVENT', '/images/union/post-4.jpg', true, 67);

-- 문의
INSERT INTO union_schema.inquiries (name, company, phone, email, message, product, status, consent_privacy) VALUES
('김철수', '삼성전자',   '010-1234-5678', 'kim@samsung.com',  '클라우드 마이그레이션 관련 상담 요청합니다.',       '클라우드 컨설팅', 'NEW',         true),
('이영희', 'LG CNS',     '010-2345-6789', 'lee@lgcns.com',    '데이터 웨어하우스 구축 견적 문의드립니다.',          '데이터 솔루션',   'IN_PROGRESS', true),
('박민수', 'SK하이닉스',  '010-3456-7890', 'park@skhynix.com', 'IT 인프라 통합 관리 솔루션에 대해 알고 싶습니다.',   'IT 인프라',       'COMPLETED',   true);

-- 고객 사례
INSERT INTO union_schema.customer_stories (company, industry, title, content, thumbnail_url, logo_url, published) VALUES
('현대자동차', '제조', '현대자동차 데이터 인프라 혁신 사례',
 '현대자동차는 유니온시스템즈와 함께 레거시 데이터 인프라를 클라우드 기반으로 전환하여 데이터 처리 속도를 3배 향상시켰습니다.',
 '/images/union/story-1.jpg', '/images/union/logo-hyundai.png', true),
('KB금융그룹', '금융', 'KB금융 실시간 데이터 분석 플랫폼 구축',
 'KB금융그룹은 실시간 고객 데이터 분석을 위한 플랫폼을 유니온시스템즈와 함께 구축하여 마케팅 효율을 40% 개선했습니다.',
 '/images/union/story-2.jpg', '/images/union/logo-kb.png', true);

-- 클라이언트 로고
INSERT INTO union_schema.client_logos (name, logo_url, sort_order, is_active) VALUES
('삼성전자',   '/images/union/clients/samsung.png',  1, true),
('현대자동차', '/images/union/clients/hyundai.png',  2, true),
('LG CNS',     '/images/union/clients/lgcns.png',    3, true),
('SK하이닉스', '/images/union/clients/skhynix.png',  4, true),
('KB금융그룹', '/images/union/clients/kb.png',       5, true);

-- 다운로드 신청
INSERT INTO union_schema.downloads (name, company, phone, email, file_type, consent_privacy, consent_marketing) VALUES
('정수진', '카카오',     '010-4567-8901', 'jung@kakao.com',    '회사소개서',   true, true),
('최동현', '네이버',     '010-5678-9012', 'choi@naver.com',    '솔루션 브로슈어', true, false);

-- =============================================
-- DATAWARE_SCHEMA
-- =============================================

-- 배너
INSERT INTO dataware_schema.banners (title, image_url, link_url, position, is_active, sort_order) VALUES
('데이터웨어 메인 배너',          '/images/dw/hero-1.jpg',  '/products',  'HERO',      true, 1),
('DA# 데이터 모델링 도구',        '/images/dw/hero-2.jpg',  '/products/da-sharp', 'HERO', true, 2),
('MetaSharp 메타데이터 관리',      '/images/dw/promo-1.jpg', '/products/meta-sharp', 'PROMOTION', true, 1);

-- 제품
INSERT INTO dataware_schema.products (name, slug, category, subtitle, description, features, icon_url, thumbnail_url, certification, sort_order, published) VALUES
('DA#', 'da-sharp', 'DA_SHARP',
 '데이터 모델링 도구',
 'DA#은 데이터 아키텍처 설계 및 데이터 모델링을 위한 전문 도구입니다. 논리/물리 모델링, 표준 관리, 영향도 분석 등을 지원합니다.',
 '논리/물리 데이터 모델링, 표준 용어 관리, 영향도 분석, 리버스 엔지니어링',
 '/images/dw/icon-da.png', '/images/dw/thumb-da.jpg', 'GS인증 1등급', 1, true),

('Meta#', 'meta-sharp', 'META_SHARP',
 '메타데이터 관리 솔루션',
 'Meta#은 기업 내 산재된 메타데이터를 통합 관리하여 데이터 거버넌스를 실현하는 솔루션입니다.',
 '메타데이터 자동 수집, 데이터 리니지, 데이터 사전 관리, 영향도 분석',
 '/images/dw/icon-meta.png', '/images/dw/thumb-meta.jpg', 'GS인증 1등급', 2, true),

('DQ#', 'dq-sharp', 'DQ_SHARP',
 '데이터 품질 관리 솔루션',
 'DQ#은 데이터 품질 진단, 측정, 개선을 위한 통합 데이터 품질 관리 솔루션입니다.',
 '품질 규칙 정의, 자동 프로파일링, 품질 대시보드, 오류 데이터 추적',
 '/images/dw/icon-dq.png', '/images/dw/thumb-dq.jpg', NULL, 3, true),

('AP#', 'ap-sharp', 'AP_SHARP',
 '데이터 표준 관리 솔루션',
 'AP#은 전사 데이터 표준을 수립하고 관리하는 솔루션으로, 일관된 데이터 관리 체계를 지원합니다.',
 '표준 단어/도메인/용어 관리, 표준 준수율 점검, 변경 이력 관리',
 '/images/dw/icon-ap.png', '/images/dw/thumb-ap.jpg', NULL, 4, true),

('ETT#', 'ett-sharp', 'ETT_SHARP',
 'ETL/데이터 이관 도구',
 'ETT#은 대용량 데이터 추출, 변환, 적재를 위한 고성능 ETL 솔루션입니다.',
 '병렬 처리, 스케줄링, 데이터 변환 룰, 모니터링 대시보드',
 '/images/dw/icon-ett.png', '/images/dw/thumb-ett.jpg', NULL, 5, true),

('DF#', 'df-sharp', 'DF_SHARP',
 '데이터 플로우 관리',
 'DF#은 데이터 흐름을 시각화하고 관리하는 솔루션으로, 복잡한 데이터 파이프라인을 효율적으로 운영합니다.',
 '데이터 흐름 시각화, 파이프라인 모니터링, 장애 알림, 성능 분석',
 '/images/dw/icon-df.png', '/images/dw/thumb-df.jpg', NULL, 6, true),

('DP#', 'dp-sharp', 'DP_SHARP',
 '데이터 포털',
 'DP#은 기업 데이터를 쉽게 검색하고 활용할 수 있는 셀프서비스 데이터 포털입니다.',
 '데이터 카탈로그, 셀프서비스 분석, 데이터 마켓플레이스, 접근 권한 관리',
 '/images/dw/icon-dp.png', '/images/dw/thumb-dp.jpg', NULL, 7, true);

-- 게시글
INSERT INTO dataware_schema.posts (title, content, excerpt, category, thumbnail_url, published, view_count) VALUES
('DA# v5.0 업데이트 안내',
 'DA# v5.0에서는 클라우드 기반 협업 기능이 추가되었습니다. 실시간 동시 편집, 버전 관리, 댓글 기능을 통해 팀 협업이 더욱 편리해졌습니다.',
 'DA# v5.0 주요 업데이트 사항 안내', 'NOTICE', '/images/dw/post-1.jpg', true, 324),

('데이터 거버넌스 세미나 개최 안내',
 '데이터 거버넌스의 최신 트렌드와 실무 적용 사례를 공유하는 세미나를 개최합니다. 현업 전문가의 경험을 직접 들을 수 있는 기회입니다.',
 '데이터 거버넌스 세미나 안내', 'EVENT', '/images/dw/post-2.jpg', true, 178),

('데이터 모델링 베스트 프랙티스 영상',
 '데이터 모델링 시 자주 발생하는 실수와 이를 방지하기 위한 베스트 프랙티스를 영상으로 정리했습니다.',
 '데이터 모델링 베스트 프랙티스', 'VIDEO', '/images/dw/post-3.jpg', true, 456),

('DA# 사용자 매뉴얼 v5.0',
 'DA# v5.0의 전체 기능을 상세히 설명한 사용자 매뉴얼입니다. 신규 기능 가이드와 FAQ를 포함하고 있습니다.',
 'DA# v5.0 사용자 매뉴얼', 'DOCUMENTATION', '/images/dw/post-4.jpg', true, 89);

-- 문의
INSERT INTO dataware_schema.inquiries (name, company, phone, email, message, product, status, consent_privacy, consent_third_party) VALUES
('한지영', '우리은행',   '010-6789-0123', 'han@wooribank.com', 'DA# 도입 관련 데모 요청합니다.',                   'DA#',    'NEW',         true, true),
('오승환', '포스코',     '010-7890-1234', 'oh@posco.com',      'DQ# 데이터 품질 관리 솔루션 견적 문의합니다.',      'DQ#',    'IN_PROGRESS', true, false),
('윤서연', 'CJ대한통운', '010-8901-2345', 'yoon@cj.com',       'Meta# 메타데이터 관리 POC 진행 가능한지 문의합니다.', 'Meta#', 'COMPLETED',   true, true);

-- 고객 사례
INSERT INTO dataware_schema.customer_stories (company, industry, title, content, thumbnail_url, logo_url, published) VALUES
('신한은행', '금융', '신한은행 데이터 거버넌스 체계 구축',
 '신한은행은 DA#과 Meta#을 도입하여 전사 데이터 거버넌스 체계를 구축했으며, 데이터 표준 준수율을 95%까지 향상시켰습니다.',
 '/images/dw/story-1.jpg', '/images/dw/logo-shinhan.png', true),
('포스코', '제조', '포스코 데이터 품질 혁신 프로젝트',
 '포스코는 DQ#을 활용하여 제조 데이터 품질을 체계적으로 관리하고, 데이터 오류율을 80% 감소시켰습니다.',
 '/images/dw/story-2.jpg', '/images/dw/logo-posco.png', true);

-- 클라이언트 로고
INSERT INTO dataware_schema.client_logos (name, logo_url, sort_order, is_active) VALUES
('신한은행',   '/images/dw/clients/shinhan.png',  1, true),
('포스코',     '/images/dw/clients/posco.png',    2, true),
('우리은행',   '/images/dw/clients/woori.png',    3, true),
('CJ대한통운', '/images/dw/clients/cj.png',       4, true),
('한국전력',   '/images/dw/clients/kepco.png',    5, true);

-- 다운로드 신청
INSERT INTO dataware_schema.downloads (name, company, phone, email, file_type, consent_privacy, consent_third_party, consent_marketing) VALUES
('강민호', '롯데정보통신', '010-9012-3456', 'kang@lotte.com',   'DA# 브로슈어',    true, true,  true),
('임수빈', 'KT',           '010-0123-4567', 'lim@kt.com',       '제품 카탈로그',   true, false, false);

-- 교육 신청
INSERT INTO dataware_schema.educations (name, company, phone, email, position, preferred_date, note, consent_privacy, consent_third_party, status) VALUES
('서준혁', 'NH농협',     '010-1111-2222', 'seo@nh.com',     '과장',   '2026-08-15', 'DA# 기초 교육 희망합니다. 5명 참석 예정입니다.',  true, true, 'NEW'),
('장하은', '한화시스템', '010-3333-4444', 'jang@hanwha.com', '대리',   '2026-09-01', 'Meta# 실무 교육 요청합니다.',                    true, true, 'CONFIRMED');

-- 세미나 신청
INSERT INTO dataware_schema.seminars (name, company, phone, email, department, preferred_date, attendees, topic, note, consent_privacy, consent_third_party, status) VALUES
('배성민', '두산에너빌리티', '010-5555-6666', 'bae@doosan.com',  'IT기획팀',    '2026-08-20', 15, '데이터 거버넌스 구축 사례',  '사내 세미나로 진행 희망합니다.', true, true, 'NEW'),
('고은지', 'GS칼텍스',       '010-7777-8888', 'ko@gscaltex.com', '데이터팀',    '2026-09-10', 8,  '데이터 품질 관리 방법론',    NULL,                            true, true, 'CONFIRMED');


-- ===================== V3__add_cms_tables.sql =====================
-- =============================================
-- V3: 백오피스 CMS용 테이블 추가
-- union_schema, dataware_schema 각각 동일 구조
-- 기존 테이블/데이터 변경 없음
-- =============================================

-- =============================================
-- UNION_SCHEMA
-- =============================================

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

-- =============================================
-- DATAWARE_SCHEMA
-- =============================================

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


-- ===================== V4__seed_encore_account.sql =====================
-- 엔코아 전용 VIEWER 계정 (dataware 다운로드 조회만 가능)
-- 비밀번호: encore123!
INSERT INTO common.admins (username, password, role, site)
VALUES ('encore', '$2b$12$eMgIeT4eBjd4O4hhqh8W6OsN0RZbfXR19ypRoURSD836Gyv1SVCpW', 'VIEWER', 'DATAWARE')
ON CONFLICT (username) DO NOTHING;


-- ===================== V5__create_site_config.sql =====================
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


-- ===================== V6__seed_site_config.sql =====================
-- =============================================
-- site_config 초기 설정값 시드
-- 두 사이트 공통 회사 정보 + 사이트별 고유값
-- idempotent: ON CONFLICT DO NOTHING
-- =============================================

-- UNION
INSERT INTO union_schema.site_config (config_key, config_value, description) VALUES
('company_name',    '유니온시스템즈',                              '회사명'),
('company_name_en', 'UNION SYSTEMS',                               '회사 영문명'),
('ceo',             '홍민석',                                      '대표자'),
('tel',             '02-706-8999',                                 '대표전화'),
('fax',             '02-706-8990',                                 '팩스'),
('email',           'ud@unionsystems.co.kr',                       '대표 이메일'),
('email_sales',     'sales@unionsystems.co.kr',                    '영업 이메일'),
('address',         '서울시 성동구 아차산로17길 49, 1209~1210호 (성수동2가, 생각공장데시앙플렉스)', '주소'),
('biz_no',          '120-87-96801',                                '사업자등록번호'),
('copyright',       'Copyright 2015 UNION SYSTEMS. All rights reserved.', '저작권 표시'),
('sns_blog',        'https://blog.naver.com/unionsystems_',        '네이버 블로그'),
('sns_facebook',    'https://www.facebook.com/%EC%9C%A0%EB%8B%88%EC%98%A8%EC%8B%9C%EC%8A%A4%ED%85%9C%EC%A6%88-407065599829009/', '페이스북')
ON CONFLICT (config_key) DO NOTHING;

-- DATAWARE
INSERT INTO dataware_schema.site_config (config_key, config_value, description) VALUES
('company_name',    '주식회사 유니온시스템즈',                      '회사명'),
('company_name_en', 'UNION SYSTEMS',                               '회사 영문명'),
('company_role',    'DA# 총판',                                    '역할'),
('developer',       '㈜엔코아',                                    '개발사'),
('developer_site',  'https://www.en-core.com/',                    '개발사 사이트'),
('ceo',             '홍민석',                                      '대표자'),
('tel',             '02-706-8999',                                 '대표전화'),
('fax',             '02-706-8990',                                 '팩스'),
('email',           'ud@unionsystems.co.kr',                       '대표 이메일'),
('address',         '서울시 성동구 아차산로17길 49, 1209~1210호 (성수동2가, 생각공장데시앙플렉스)', '주소'),
('biz_no',          '120-87-96801',                                '사업자등록번호'),
('copyright',       'Copyright 2021 UNION SYSTEMS. All rights reserved.', '저작권 표시'),
('sns_blog',        'https://blog.naver.com/unionsystems_',        '네이버 블로그'),
('sns_facebook',    'https://www.facebook.com/%EC%9C%A0%EB%8B%88%EC%98%A8%EC%8B%9C%EC%8A%A4%ED%85%9C%EC%A6%88-407065599829009/', '페이스북'),
('youtube_channel', 'https://www.youtube.com/channel/UCeesWbZ2-pAiB__LQkmkJNA', '유튜브 채널')
ON CONFLICT (config_key) DO NOTHING;


-- ===================== V7__seed_menu.sql =====================
-- =============================================
-- 메뉴 트리 초기 시드 — union / dataware
-- is_exposed = true/false 로 백오피스에서 노출 제어
-- idempotent 아님 (최초 1회만 실행) — menu 비어있을 때만
-- =============================================

-- UNION 메뉴
INSERT INTO union_schema.menu (id, parent_id, name, url, menu_type, sort_order, depth, is_exposed) VALUES
-- 1단
(1,  NULL, 'Company',   '/company',         'CONTENT', 1, 0, true),
(2,  NULL, 'Software',  '/software',        'CONTENT', 2, 0, true),
(3,  NULL, 'Solution',  '/solution',        'CONTENT', 3, 0, true),
(4,  NULL, 'Customer',  '/support/notices',  'CONTENT', 4, 0, true),
(5,  NULL, 'Insights',  '/insights',        'CONTENT', 5, 0, true),
(6,  NULL, 'Estimate',  '/estimate',        'CONTENT', 6, 0, true),
(7,  NULL, 'SAM',       '/license-alert',   'CONTENT', 7, 0, true),
(8,  NULL, '도입문의',   '/contact',         'CONTENT', 8, 0, true),
-- Company 하위
(10, 1, '기업소개',    '/company/about',    'CONTENT', 1, 1, true),
(11, 1, '주요연혁',    '/company/history',  'CONTENT', 2, 1, true),
-- Software 하위
(20, 2, 'Microsoft',   '/software/microsoft',  'CONTENT', 1, 1, true),
(21, 2, 'ESTsoft',     '/software/estsoft',    'CONTENT', 2, 1, true),
(22, 2, 'Autodesk',    '/software/autodesk',   'CONTENT', 3, 1, true),
(23, 2, 'Adobe',       '/software/adobe',      'CONTENT', 4, 1, true),
-- Solution 하위
(30, 3, '데이터',      '/solution/data',                    'CONTENT', 1, 1, true),
(31, 3, '자산관리',    '/solution/asset-management',         'CONTENT', 2, 1, true),
(32, 3, '보안',        '/solution/security',                 'CONTENT', 3, 1, true),
-- Solution > 데이터 하위
(33, 30, 'DATAWARE',   'https://dataware.unionsystems.co.kr', 'LINK', 1, 2, true),
-- Solution > 자산관리 하위
(34, 31, 'NetClient',  '/solution/asset-management/netclient', 'CONTENT', 1, 2, true),
-- Solution > 보안 하위
(35, 32, 'AhnLab',       '/solution/security/ahnlab',       'CONTENT', 1, 2, true),
(36, 32, 'ESTsecurity',  '/solution/security/estsecurity',  'CONTENT', 2, 2, true),
(37, 32, 'OfficeKeeper', '/solution/security/officekeeper', 'CONTENT', 3, 2, true),
-- Customer 하위
(40, 4, '공지사항',    '/support/notices',  'BOARD',   1, 1, true),
(41, 4, '1:1 문의',    '/support/inquiry',  'CONTENT', 2, 1, true),
(42, 4, '기술지원',    '/support/tech',     'CONTENT', 3, 1, true),
(43, 4, '이벤트',      '/support/events',   'BOARD',   4, 1, true),
-- SAM 하위
(50, 7, '라이선스 관리 상담', '/license-alert',   'CONTENT', 1, 1, true),
(51, 7, '보안 점검',          '/security-check',  'CONTENT', 2, 1, true),
(52, 7, 'IT·보안 용어사전',   '/glossary',        'CONTENT', 3, 1, true);

SELECT setval('union_schema.menu_id_seq', 100);

-- DATAWARE 메뉴
INSERT INTO dataware_schema.menu (id, parent_id, name, url, menu_type, sort_order, depth, is_exposed) VALUES
-- 1단
(1,  NULL, 'DATAWARE',  '/products',    'CONTENT', 1, 0, true),
(2,  NULL, '교육',       '/education',   'CONTENT', 2, 0, true),
(3,  NULL, '고객지원',   '/resources',   'CONTENT', 3, 0, true),
(4,  NULL, '가격안내',   '/pricing',     'CONTENT', 4, 0, true),
(5,  NULL, '고객사례',   '/customers',   'CONTENT', 5, 0, true),
(6,  NULL, '이벤트',     '/events',      'CONTENT', 6, 0, true),
-- 교육 하위
(10, 2, '무료교육',      '/education',          'CONTENT', 1, 1, true),
(11, 2, '방문 세미나',   '/seminar',            'CONTENT', 2, 1, true),
(12, 2, '동영상 강의',   '/resources/videos',   'CONTENT', 3, 1, true),
-- 고객지원 하위
(20, 3, '공지사항',       '/resources/notices',  'BOARD',   1, 1, true),
(21, 3, '다운로드 신청',  '/download',           'CONTENT', 2, 1, true),
(22, 3, '데이터 진단',    '/diagnosis',          'CONTENT', 3, 1, true),
(23, 3, '파트너 제휴',    '/partner',            'CONTENT', 4, 1, true),
-- 도입문의 (하단 CTA용)
(30, NULL, '도입문의',    '/contact',            'CONTENT', 7, 0, true),
-- 다운로드 (하단 CTA용)
(31, NULL, '다운로드',    '/download',           'CONTENT', 8, 0, false);

SELECT setval('dataware_schema.menu_id_seq', 100);


-- ===================== V8__seed_content.sql =====================
-- =============================================
-- content 초기 시드 — 주요 자유 텍스트 영역
-- region_key: {page}_{section} 패턴
-- menu_id는 NULL (페이지 단위가 아닌 영역 단위 관리)
-- =============================================

-- UNION 콘텐츠
INSERT INTO union_schema.content (menu_id, region_key, title, body_html) VALUES
(NULL, 'company_intro', '기업소개',
 '<h2>유니온시스템즈를 소개합니다</h2><p>유니온시스템즈는 2010년 설립 이래 소프트웨어, 보안, 데이터, 자산관리 분야에서 200여 개 고객사와 함께해온 IT 전문 기업입니다.</p><p>Microsoft, Adobe, Autodesk 등 글로벌 소프트웨어 공식 파트너이자, 엔코아 DA# 공인총판으로서 기업의 디지털 전환을 지원합니다.</p>'),

(NULL, 'company_ceo_greeting', 'CEO 인사말',
 '<h2>대표이사 인사말</h2><p>안녕하세요. 유니온시스템즈 대표이사 홍민석입니다.</p><p>저희는 "고객의 IT 환경을 가장 잘 이해하는 파트너"를 지향합니다. 단순한 제품 공급이 아닌, 도입부터 운영, 유지보수까지 전 과정을 함께하는 진정한 IT 파트너가 되겠습니다.</p>'),

(NULL, 'company_vision', '비전',
 '<h3>비전</h3><p>기업의 IT 자산과 데이터를 안전하고 효율적으로 관리할 수 있도록, 최적의 솔루션과 전문 서비스를 제공하는 대한민국 대표 IT 전문기업이 되겠습니다.</p>'),

(NULL, 'hero_main', '메인 히어로',
 '<h1>IT 인프라의 든든한 파트너</h1><p>소프트웨어 · 보안 · 데이터 · 자산관리<br>기업 IT 환경의 모든 것을 함께합니다.</p>'),

(NULL, 'cta_section', 'CTA 섹션',
 '<h2>지금 바로 도입 상담을 시작하세요</h2><p>전문 컨설턴트가 귀사의 IT 환경에 맞는 최적의 솔루션을 제안합니다.</p>'),

(NULL, 'privacy_policy', '개인정보처리방침',
 '<h2>개인정보처리방침</h2><p>주식회사 유니온시스템즈(이하 "회사")는 개인정보보호법에 따라 이용자의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.</p>');

-- DATAWARE 콘텐츠
INSERT INTO dataware_schema.content (menu_id, region_key, title, body_html) VALUES
(NULL, 'hero_main', '메인 히어로',
 '<h1>데이터 거버넌스의 시작</h1><p>DA#, Meta#, DQ# — 데이터 모델링부터 품질 관리까지<br>엔코아의 데이터 솔루션으로 데이터 자산을 체계적으로 관리하세요.</p>'),

(NULL, 'diagnosis_intro', '데이터 진단 소개',
 '<h2>데이터 거버넌스 성숙도 진단</h2><p>우리 조직의 데이터 관리 수준을 객관적으로 진단하고, 개선 방향을 제시합니다. 5분이면 충분합니다.</p>'),

(NULL, 'pricing_intro', '가격 안내',
 '<h2>합리적인 가격, 확실한 가치</h2><p>DA# 개인용은 무료로 사용할 수 있습니다. 기업 도입은 규모와 요구사항에 맞춰 맞춤 견적을 제공합니다.</p>'),

(NULL, 'download_intro', '다운로드 안내',
 '<h2>DA# 무료 다운로드</h2><p>개인정보를 입력하시면 DA# 개인용 무료 버전과 제품 소개서를 다운로드 받으실 수 있습니다.</p>'),

(NULL, 'contact_intro', '도입문의 안내',
 '<h2>도입문의</h2><p>제품 도입, 기술 상담, 데모 요청 등 궁금한 점을 남겨주시면 담당자가 빠른 시일 내에 연락드리겠습니다.</p>'),

(NULL, 'privacy_policy', '개인정보처리방침',
 '<h2>개인정보처리방침</h2><p>주식회사 유니온시스템즈(이하 "회사")는 개인정보보호법에 따라 이용자의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.</p>');


-- ===================== V9__create_structured_tables.sql =====================
-- =============================================
-- 배치4: 구조화 리스트 전용 테이블
-- union: history, glossary
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


-- ===================== V10__seed_structured_data.sql =====================
-- =============================================
-- 배치4: 구조화 리스트 초기 시드 (하드코딩본 이관)
-- =============================================

-- UNION — 연혁
INSERT INTO union_schema.history (year, title, events, sort_order) VALUES
('2026', '데이터 사업 확장',     '["DATAWARE™ 공식 총판 계약 체결","데이터 검진 프로모션 런칭","Copilot Business 공인 파트너 선정","홈페이지 2차 리뉴얼"]', 1),
('2025', '통합 서비스 강화',     '["유니온 케어팩(통합 유지보수) 서비스 오픈","DA# 조달 캠페인 진행","AutoCAD Toolset 맞춤 제안 서비스 시작"]', 2),
('2024', '포트폴리오 고도화',    '["Microsoft 365 Copilot 도입 컨설팅 시작","AhnLab XDR 통합관제 파트너","DA# Architecture 신규 버전 대응"]', 3),
('2023', '고객사 4,000 돌파',    '["누적 고객사 4,000개 돌파","공공기관 조달 사업 확대","ESTsecurity AI 기반 EDR 파트너"]', 4),
('2022', '데이터 사업 본격화',   '["DA# DQ Edition 총판 계약","데이터 품질관리 컨설팅 서비스 시작","홈페이지 1차 리뉴얼"]', 5),
('2021', 'DA# 총판 계약',       '["엔코아 DA# 총판 계약 체결","데이터 모델링 교육 서비스 시작"]', 6),
('2020', '보안 포트폴리오 확장', '["ESTsecurity 기업용 보안 파트너","OfficeKeeper 내부정보유출방지 공급 시작"]', 7),
('2019', '자산관리 사업 확대',   '["NetClient(DMS/PMS) 공급 본격화","공공기관 자산관리 프로젝트 수주"]', 8),
('2018', 'AhnLab 파트너',       '["AhnLab V3 / MDS 공식 파트너 선정","기업 보안 솔루션 구축 서비스 시작"]', 9),
('2017', 'Microsoft 파트너',    '["Microsoft CSP(Cloud Solution Provider) 공인 파트너","Microsoft 365 공급 시작"]', 10),
('2016', '글로벌 파트너십 확대', '["Adobe 공식 리셀러 계약","Autodesk 공인 리셀러 계약"]', 11),
('2015', '소프트웨어 유통 사업', '["기업용 소프트웨어 유통 사업 시작","한컴오피스 등 국산 SW 공급"]', 12),
('2014', '공공사업 진출',        '["조달청 등록 완료","공공기관 소프트웨어 공급 시작"]', 13),
('2013', '사업 기반 구축',       '["기업 고객 영업 본격화","파트너 네트워크 확장"]', 14),
('2012', '법인 전환',            '["주식회사 유니온시스템즈 법인 설립"]', 15),
('2010', '창업',                 '["유니온시스템즈 창업","소프트웨어 유통 사업 개시"]', 16);

-- UNION — 용어사전 (주요 항목)
INSERT INTO union_schema.glossary (term, full_name, definition, category, sort_order) VALUES
('EPP', 'Endpoint Protection Platform', '안티바이러스·방화벽·행위 기반 탐지를 통합한 엔드포인트 보안 플랫폼.', '보안', 1),
('EDR', 'Endpoint Detection & Response', '엔드포인트에서 발생하는 위협을 실시간 탐지하고 대응하는 보안 기술.', '보안', 2),
('MDS', 'Malware Defense System', '샌드박스 기반 동적 분석으로 APT 공격, 랜섬웨어를 사전 차단하는 솔루션.', '보안', 3),
('DLP', 'Data Loss Prevention', 'USB·네트워크·출력물 등 모든 유출 경로를 차단하여 내부 정보 유출을 방지.', '보안', 4),
('APT', 'Advanced Persistent Threat', '특정 기업·기관을 겨냥해 장기간 잠복하며 정보를 탈취하는 지능형 지속 공격.', '보안', 5),
('DMS', 'Desktop Management System', 'PC 자산의 하드웨어/소프트웨어 정보를 자동 수집하고 관리하는 모듈.', '자산관리', 6),
('PMS', 'Patch Management System', 'Windows 보안 패치와 소프트웨어 업데이트를 중앙에서 관리하는 모듈.', '자산관리', 7),
('SAM', 'Software Asset Management', '소프트웨어 라이선스의 보유·사용 현황을 관리하는 프로세스.', '자산관리', 8),
('CSP', 'Cloud Solution Provider', 'Microsoft 클라우드 서비스를 재판매하는 공인 파트너 프로그램.', '소프트웨어', 9),
('ISV', 'Independent Software Vendor', '자체 소프트웨어를 개발하여 판매하는 독립 소프트웨어 업체.', '소프트웨어', 10);

-- DATAWARE — 가격 플랜
INSERT INTO dataware_schema.pricing_plans (name, license_type, price, original_price, price_display, badge, is_popular, sort_order) VALUES
('DA# Architecture', '1년 라이선스', 2400000, 6000000, '2,400,000원', '60% 할인', false, 1),
('DA# 통합 패키지',  '평생 라이선스', 6000000, 12000000, '6,000,000원', '50% 할인', true, 2),
('DA# Repository',  '평생 라이선스', 15000000, 25000000, '15,000,000원', '40% 할인', false, 3);

-- DATAWARE — 교육 세션
INSERT INTO dataware_schema.education_sessions (title, date, thumbnail, tag, status, description, sort_order) VALUES
('2026 DA# 실전 데이터모델링 (3월)', '2026.03.20(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-1.png', '실전', 'CLOSED', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 1),
('2026 DA# 실전 데이터모델링 (4월)', '2026.04.17(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-2.png', '실전', 'CLOSED', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 2),
('2026 DA# 실전 데이터모델링 (6월)', '2026.06.19(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-3.png', '실전', 'OPEN', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 3),
('2026 홍우석의 실전데이터모델링 (6월)', '2026.06.24(Wed) 13:00~17:00', '/images/uniondata/2606_head.png', '특강', 'OPEN', '현업 데이터 전문가의 실무 모델링 노하우', 4),
('2026 DA# 실전 데이터모델링 (8월)', '2026.08.21(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-1.png', '실전', 'OPEN', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 5),
('2026 DA# 실전 데이터모델링 (10월)', '2026.10.16(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-2.png', '실전', 'OPEN', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 6),
('2026 DA# 실전 데이터모델링 (12월)', '2026.12.18(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-3.png', '실전', 'OPEN', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 7);

-- DATAWARE — 다운로드 자료
INSERT INTO dataware_schema.download_resources (title, description, file_type, thumbnail, sort_order) VALUES
('DA#5 설치파일(기업용)', 'DA# Architecture 기업용 설치 프로그램', 'INSTALLER', '/images/uniondata/da5-biz.png', 1),
('DA#5 설치파일(개인용)', 'DA# Architecture 개인용 무료 버전', 'INSTALLER', '/images/uniondata/da5-personal.png', 2),
('DA# 제품 소개서', 'DA# 제품군 종합 소개 PDF', 'BROCHURE', '/images/uniondata/brochure.png', 3),
('DATAWARE 소개서', 'DATAWARE 통합 패키지 소개 PDF', 'BROCHURE', '/images/uniondata/dataware-brochure.png', 4),
('DA# 사용자 매뉴얼', 'DA# v5.0 사용자 가이드', 'MANUAL', '/images/uniondata/manual.png', 5),
('데이터 거버넌스 백서', '데이터 거버넌스 구축 가이드', 'WHITEPAPER', '/images/uniondata/whitepaper.png', 6);


-- ===================== V11__create_page_layout.sql =====================
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


-- ===================== V12__page_layout_add_status.sql =====================
-- page_layout에 status 컬럼 추가 (DRAFT/PUBLISHED)
ALTER TABLE union_schema.page_layout
    ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'DRAFT';

ALTER TABLE dataware_schema.page_layout
    ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'DRAFT';


-- ===================== V13__add_insights_table.sql =====================
-- V13: Insight 자동 수집 테이블
CREATE TABLE IF NOT EXISTS union_schema.insights (
    id              BIGSERIAL PRIMARY KEY,
    title           VARCHAR(500)    NOT NULL,
    summary         TEXT,
    source_name     VARCHAR(200),
    source_url      VARCHAR(1000)   NOT NULL UNIQUE,
    thumbnail_url   VARCHAR(1000),
    published_at    TIMESTAMP,
    status          VARCHAR(20)     NOT NULL DEFAULT 'PENDING',
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_insights_status ON union_schema.insights (status);
CREATE INDEX idx_insights_published_at ON union_schema.insights (published_at DESC);


-- ===================== V14__insights_add_site_approval_columns.sql =====================
-- V14: insights 테이블에 site_id, approved_at, approved_by 컬럼 추가
ALTER TABLE union_schema.insights
    ADD COLUMN site_id     VARCHAR(20) NOT NULL DEFAULT 'UNION',
    ADD COLUMN approved_at TIMESTAMP,
    ADD COLUMN approved_by VARCHAR(100);


-- ===================== V15__add_slug_to_posts_and_customer_stories.sql =====================
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


-- ===================== V16__add_detail_json_columns.sql =====================
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


-- ===================== V17__seed_dataware_content.sql =====================
-- V17: 프론트엔드 하드코딩 데이터를 DB로 이관 (dataware_schema)
-- 공지사항, 이벤트, 동영상, 고객사례

-- ═══════════════════════════════════════
-- 1. 공지사항 (posts, category=NOTICE)
-- ═══════════════════════════════════════
INSERT INTO dataware_schema.posts (title, slug, content, excerpt, category, thumbnail_url, published, view_count, created_at) VALUES
('DA#_DQ_Edition 조달청 나라장터 등록', 'da-dq-edition-g2b', E'데이터 비즈니스 전문기업 엔코아(대표 이화식)가 자사의 ''데이터웨어 디에이샵 디큐에디션(DATAWARE DA#_DQ Edition)''이 조달청 나라장터에 등록되었다고 밝혔다.\n\nDA#_DQ Edition은 데이터 모델링 툴 DA#과 데이터 품질관리 솔루션 DQ#의 품질진단 기능을 하나의 패키지로 구성한 제품이다.\n\n최근 데이터 표준화와 데이터 품질관리는 데이터 관리 프로세스의 기반이 되는 필수 항목으로, DA#_DQ Edition은 데이터 표준화 기반의 체계적인 품질진단을 지원하며 공공데이터 품질관리 수준평가에 대응하기 위한 최적의 툴을 제공한다.\n\n편리한 모델링 기능과 강력한 품질진단 기능을 하나의 패키지에서 사용할 수 있어 도입 비용 절감과 운영 효율성 향상이 가능하다.', 'DA#-DQ# 패키지로 구성해 데이터 표준화 기반의 체계적인 품질진단 지원. 공공데이터 품질관리 수준평가에 대응하기 위한 최적의 툴 제공.', 'NOTICE', '/images/uniondata/0.png', true, 0, '2021-11-22'),
('[리뷰] 데이터 품질진단 DA# DQ_Edition', 'review-da-dq-edition', E'지속되고 있는 코로나19 팬데믹 사태는 비즈니스 환경을 빠르게 변화시키고 있다. 비대면이 활성화되고 재택근무가 일상이 되면서 정보를 공유할 수 있는 클라우드의 활용은 필수적이 되었고, 공유된 정보와 온라인상에서 정보 보호를 위하여 개인정보보호를 위한 컴퓨팅도 많이 활용되고 있다.\n\n엔코아가 제안하는 디에이샵 디큐 에디션은 데이터 모델링과 품질진단을 한 번에 지원하는 솔루션으로 데이터 모델링 툴 DA#과 데이터 품질관리 솔루션 DQ#의 품질진단 기능을 하나의 패키지로 구성한 제품이다.\n\n출처: IT DAILY', '데이터 모델링과 품질진단 자동화로 관리 효율성 향상. 코로나19 팬데믹 사태로 비대면 활성화와 클라우드 활용이 필수적인 시대.', 'NOTICE', '/images/uniondata/0-1.png', true, 0, '2021-06-02'),
('[리뷰] 데이터모델링 DA#', 'review-da-sharp', E'체계적인 기업의 데이터 품질 관리는 데이터 모델링에서 시작된다. DA#은 차세대 프로젝트에서 단위 업무 모델링까지 폭넓게 활용되며, 개발 생산성과 성능을 높이는 핵심 도구이다.\n\n다중 DBMS 지원, Undo/Redo 편집, 다양한 형태의 산출물 제공 등 편의성을 갖추고 있으며, Repository 기반 팀 모델링과 웹 실시간 VIEW 기능으로 협업 생산성을 극대화한다.\n\n출처: IT DAILY', '차세대 프로젝트에서 단위 업무 모델링까지, 개발 생산성과 성능 제고. 데이터 비즈니스의 기본, 데이터 모델링 툴.', 'NOTICE', '/images/uniondata/0000.png', true, 0, '2021-06-01'),
('DA# DQ_Edition GS인증 1등급', 'da-dq-edition-gs-cert', E'엔코아(대표 이화식)가 데이터 표준화 기반 데이터 품질진단 솔루션 ''디에이샵 디큐 에디션(DA# DQ_Edition)''이 굿소프트웨어(GS)인증 1등급을 획득했다고 밝혔다.\n\nGS인증은 한국정보통신기술협회(TTA)가 소프트웨어의 기능성, 신뢰성, 효율성, 사용성, 유지보수성, 이식성 등 국제표준(ISO/IEC 25023) 기반 품질특성을 시험하여 인증하는 제도로, 1등급은 최고 등급이다.\n\nDA# DQ_Edition은 데이터 모델링과 품질진단을 하나의 패키지로 제공하여 데이터 관리의 효율성을 극대화한 제품이다.', '엔코아가 데이터 표준화 기반 데이터 품질진단 솔루션 DA# DQ Edition이 굿소프트웨어(GS)인증 1등급을 획득했다고 밝혔다.', 'NOTICE', '/images/uniondata/0000-1.png', true, 0, '2021-05-30'),
('유니온시스템즈 DA# 리뉴얼 오픈', 'da-sharp-renewal-open', E'넓어진 화면, 모바일 검색, 디지털 환경 변화에 맞춰 정보를 전달하는데 기존의 홈페이지는 부족함이 있었습니다.\n\n이번 리뉴얼을 통해 DA#과 DA# DQ_Edition 기능, 모델링도구 팁과 활용법, 칼럼, 온&오프라인 참여 가능한 교육 등 다양한 정보를 보다 쉽게 확인하실 수 있습니다.\n\n앞으로도 유니온시스템즈는 고객 여러분께 더 나은 서비스를 제공하기 위해 지속적으로 노력하겠습니다.', '넓어진 화면, 모바일 검색, 디지털 환경 변화에 맞춰 정보를 전달하는데 기존 홈페이지는 부족함이 있었습니다.', 'NOTICE', '/images/uniondata/board__notice.png', true, 0, '2021-05-01'),
('엔코아·유니온시스템즈 DA# 총판 협약', 'encore-unionsystems-dealer-agreement', E'엔코아(대표 이화식)가 데이터 통합관리 솔루션 ''데이터웨어(DATAWARE)'' 주력 제품인 데이터 모델링 툴 ''디에이샵(DA#)'' 시장 확대를 위해 유니온시스템즈와 총판 협약을 체결했다.\n\n이번 총판 협약을 통해 유니온시스템즈는 DA# 및 DATAWARE 제품군의 판매, 기술지원, 교육 등 전반적인 비즈니스를 담당하게 된다.\n\n 엔코아 이화식 대표는 "유니온시스템즈는 데이터 거버넌스 분야에서 풍부한 경험과 전문성을 보유한 파트너로, 이번 협약을 통해 DA# 제품의 시장 확대와 고객 서비스 강화에 큰 시너지가 기대된다"고 전했다.', '엔코아가 데이터 통합관리 솔루션 DATAWARE 주력 제품인 데이터 모델링 툴 DA# 시장 확대를 위해 유니온시스템즈와 총판 협약을 체결했다.', 'NOTICE', '/images/uniondata/board__notice.png', true, 0, '2021-02-24');

-- ═══════════════════════════════════════
-- 2. 이벤트 (posts, category=EVENT)
-- ═══════════════════════════════════════
INSERT INTO dataware_schema.posts (title, slug, content, excerpt, category, thumbnail_url, published, view_count, detail_json, created_at) VALUES
('2025 DA# 조달 캠페인', 'event-2025-jodal', E'2025 연말 맞이 DA# 조달 구매 캠페인입니다.\n\nNO.1 데이터 모델링 툴 DA# 도입과 함께 따뜻한 한 끼를 전하세요!\n솔루션 도입을 넘어 사회적 가치 실현까지!\n\n• 대상: 조달청 나라장터를 통한 DA# 신규 구매 고객\n• 혜택: 구매 고객 전원 기부 참여 + 무료 교육 제공\n• 문의: 02-706-8999', '2025 연말 맞이 DA# 조달 구매 캠페인. NO.1 데이터 모델링 툴 DA# 도입과 함께 따뜻한 한 끼를 전하세요!', 'EVENT', '/images/uniondata/%EC%9C%A0%EB%8B%88%EC%98%A82025DA_%EC%A1%B0%EB%8B%AC%EA%B5%AC%EB%A7%A4%EC%BA%A0%ED%8E%98%EC%9D%B8.png', true, 0, '{"tag":"이벤트","tagColor":"#36c88a","status":"진행중"}', '2025-11-03'),
('DA~드리는 DA# 여름 할인 이벤트', 'event-2025-summer', E'AI 시대 데이터 자산화 전략 START!\n\nDA# 여름 할인 이벤트\n빠른 결정, 더욱 합리적인 혜택!\n\n• 기간: 2025년 7월 1일 ~ 8월 29일\n• 대상: DA# 신규 구매 고객\n• 혜택: 특별 할인가 적용\n• 문의: 02-706-8999', 'AI 시대 데이터 자산화 전략 START! DA# 여름 할인 이벤트. 빠른 결정, 더욱 합리적인 혜택!', 'EVENT', '/images/uniondata/0707_head.png', true, 0, '{"tag":"프로모션","tagColor":"#f59e0b","status":"진행중"}', '2025-07-01'),
('2025 을사년 맞이 BBAM! 프로모션', 'event-2025-bbam', E'2025년 을사년 맞이 BBAM! 프로모션\n\n기간 내 신규 구매 고객께 BBAM!하게 드리는 구매 프로모션입니다.\n\n• 기간: 2025년 2월 3일 ~ 3월 31일\n• 대상: DA# 신규 구매 고객\n• 견적 문의: 02-706-8999', '2025년 을사년 맞이 기간 내 신규 구매 고객께 BBAM!하게 드리는 구매 프로모션.', 'EVENT', '/images/uniondata/0000.png', true, 0, '{"tag":"프로모션","tagColor":"#f59e0b","status":"종료"}', '2025-02-03'),
('DATAWARE DA# 통합 패키지 출시 이벤트', 'event-2024-total-package', E'DATAWARE DA# 통합 패키지 출시 이벤트\n\n4개 제품 스펙을 하나의 라이선스로!\nDA# 통합 패키지 출시 기념 이벤트입니다.\n\n• 혜택: 제품 구매 문의 고객 선착순 30분께 모바일 주유권 제공\n• 포함 제품: DA# Architecture + DQ Edition + Contents Builder + AI Powered Pack\n• 문의: 02-706-8999', '4개 제품 스펙을 하나의 라이선스로! DA# 통합 패키지 출시 기념 이벤트.', 'EVENT', '/images/uniondata/0000-1.png', true, 0, '{"tag":"이벤트","tagColor":"#36c88a","status":"종료"}', '2024-11-29'),
('DA# 보상판매 이벤트', 'event-2024-trade-in', E'국산 모델링 S/W 시장 점유율 및 인지도 1위 기념!\n\n2024 데이터 모델링 툴 DA# 보상판매 이벤트\n최대 55% 할인!\n\n• 기간: 2024년 10월 1일 ~ 12월 31일\n• 조건: 기존 타 브랜드 정품 보유 시 인증 조건으로 할인 구매 가능\n• 할인가: 8,970,000원 → 4,000,000원\n• 문의: 02-706-8999', '국산 모델링 S/W 시장 점유율 및 인지도 1위 기념! 최대 55% 할인!', 'EVENT', '/images/uniondata/2023_thum.jpg', true, 0, '{"tag":"프로모션","tagColor":"#f59e0b","status":"종료"}', '2024-03-31'),
('2024 갑진년 맞이 값진 구매 프로모션', 'event-2024-dragon', E'2024 갑진년 맞이 값진 구매 프로모션\n\n2024 청룡의 해 갑진년 맞이\n유니온시스템즈와 함께 하는 값진 구매 프로모션!\n\n• 혜택: 선착순 24분께만 드리는 특별 혜택\n• 문의: 02-706-8999', '2024 청룡의 해 갑진년 맞이 유니온시스템즈와 함께 하는 값진 구매 프로모션!', 'EVENT', '', true, 0, '{"tag":"프로모션","tagColor":"#f59e0b","status":"종료"}', '2024-01-23'),
('DA# 프로젝트 라이선스 출시 이벤트', 'event-2022-project-license', E'DA# 프로젝트 라이선스 출시 이벤트\n\n• 기간: 2023.01.01 ~ 2023.12.31\n• 문의: 02-706-8999', 'DA# 프로젝트 라이선스 출시 이벤트', 'EVENT', '', true, 0, '{"tag":"이벤트","tagColor":"#36c88a","status":"종료"}', '2022-12-06'),
('공공데이터 품질관리 수준평가 대응 설명회', 'event-2022-public-data', E'공공데이터 품질관리 수준평가 대응 설명회\n\n• 문의: 02-706-8999', '공공데이터 품질관리 수준평가 대응 설명회', 'EVENT', '/images/uniondata/0922-001.png', true, 0, '{"tag":"설명회","tagColor":"#8b5cf6","status":"종료"}', '2022-08-26'),
('ERD 시연, 데이터 관계파악 설명회', 'event-2022-erd', E'ERD 시연, 데이터 관계파악 설명회\n\n• 문의: 02-706-8999', 'ERD 시연, 데이터 관계파악 설명회', 'EVENT', '', true, 0, '{"tag":"설명회","tagColor":"#8b5cf6","status":"종료"}', '2022-03-14'),
('찾아가는 데이터모델링 DA# 설명회', 'event-2022-da-seminar', E'찾아가는 데이터모델링 DA# 설명회\n\n• 문의: 02-706-8999', '찾아가는 데이터모델링 DA# 설명회', 'EVENT', '', true, 0, '{"tag":"설명회","tagColor":"#8b5cf6","status":"종료"}', '2022-02-08');

-- ═══════════════════════════════════════
-- 3. 동영상 (posts, category=VIDEO)
-- ═══════════════════════════════════════
INSERT INTO dataware_schema.posts (title, slug, content, excerpt, category, thumbnail_url, published, view_count, detail_json, created_at) VALUES
('새로운 시대의 데이터모델링 — 이화식 대표', 'video-da5-ep1', '', 'DA#5 런칭 세미나 Episode 1', 'VIDEO', '', true, 0, '{"youtubeId":"33nGO8uZOQ8","speaker":"이화식 대표 (엔코아)","series":"DA#5 런칭 세미나","episode":"Episode 1","tag":"세미나","tagColor":"#36c88a"}', '2021-11-10'),
('개발스토리 — 정철원 디렉터', 'video-da5-ep2', '', 'DA#5 런칭 세미나 Episode 2', 'VIDEO', '', true, 0, '{"youtubeId":"CLsXPIB6EH4","speaker":"정철원 디렉터 (엔코아)","series":"DA#5 런칭 세미나","episode":"Episode 2","tag":"세미나","tagColor":"#36c88a"}', '2021-11-11'),
('기본구조 및 개념 — 최광희 연구원', 'video-da5-ep3', '', 'DA#5 런칭 세미나 Episode 3', 'VIDEO', '', true, 0, '{"youtubeId":"V-8w2lXyiqY","speaker":"최광희 연구원 (엔코아)","series":"DA#5 런칭 세미나","episode":"Episode 3","tag":"세미나","tagColor":"#36c88a"}', '2021-11-11'),
('달라진 모델링 — 정민수 연구원', 'video-da5-ep4', '', 'DA#5 런칭 세미나 Episode 4', 'VIDEO', '', true, 0, '{"youtubeId":"YMyKMXM3m4U","speaker":"정민수 연구원 (엔코아)","series":"DA#5 런칭 세미나","episode":"Episode 4","tag":"세미나","tagColor":"#36c88a"}', '2021-11-11'),
('API 그리고 편의기능 — 김기동 연구원', 'video-da5-ep5', '', 'DA#5 런칭 세미나 Episode 5', 'VIDEO', '', true, 0, '{"youtubeId":"CN93yT8UL44","speaker":"김기동 연구원 (엔코아)","series":"DA#5 런칭 세미나","episode":"Episode 5","tag":"세미나","tagColor":"#36c88a"}', '2021-11-11'),
('초보자도 할 수 있는 현행모델 파헤치기 — 이임형 연구원', 'video-da5-ep6', '', 'DA#5 런칭 세미나 Episode 6', 'VIDEO', '', true, 0, '{"youtubeId":"1qP1zbsChQc","speaker":"이임형 연구원 (엔코아)","series":"DA#5 런칭 세미나","episode":"Episode 6","tag":"세미나","tagColor":"#36c88a"}', '2021-11-11'),
('물리객체생성', 'video-da5-tut1', '', 'DA#5 튜토리얼 Tutorial 1', 'VIDEO', '', true, 0, '{"youtubeId":"HA7kcXJ3IIo","speaker":"엔코아 기술지원팀","series":"DA#5 튜토리얼","episode":"Tutorial 1","tag":"튜토리얼","tagColor":"#60a5fa"}', '2021-11-22'),
('여러물리모델', 'video-da5-tut2', '', 'DA#5 튜토리얼 Tutorial 2', 'VIDEO', '', true, 0, '{"youtubeId":"T1ZCYyOyL3Q","speaker":"엔코아 기술지원팀","series":"DA#5 튜토리얼","episode":"Tutorial 2","tag":"튜토리얼","tagColor":"#60a5fa"}', '2021-11-22'),
('서식적용', 'video-da5-tut3', '', 'DA#5 튜토리얼 Tutorial 3', 'VIDEO', '', true, 0, '{"youtubeId":"RXHDtaAUBKs","speaker":"엔코아 기술지원팀","series":"DA#5 튜토리얼","episode":"Tutorial 3","tag":"튜토리얼","tagColor":"#60a5fa"}', '2021-11-22'),
('DB 리버스', 'video-da5-tut4', '', 'DA#5 튜토리얼 Tutorial 4', 'VIDEO', '', true, 0, '{"youtubeId":"jwNKCliYAEw","speaker":"엔코아 기술지원팀","series":"DA#5 튜토리얼","episode":"Tutorial 4","tag":"튜토리얼","tagColor":"#60a5fa"}', '2021-11-22'),
('리버스 후 모델 자동 배치', 'video-da5-tut5', '', 'DA#5 튜토리얼 Tutorial 5', 'VIDEO', '', true, 0, '{"youtubeId":"OAFBHAElESQ","speaker":"엔코아 기술지원팀","series":"DA#5 튜토리얼","episode":"Tutorial 5","tag":"튜토리얼","tagColor":"#60a5fa"}', '2021-11-22'),
('자동관계생성', 'video-da5-tut6', '', 'DA#5 튜토리얼 Tutorial 6', 'VIDEO', '', true, 0, '{"youtubeId":"t12UZTlIR80","speaker":"엔코아 기술지원팀","series":"DA#5 튜토리얼","episode":"Tutorial 6","tag":"튜토리얼","tagColor":"#60a5fa"}', '2021-11-22');

-- ═══════════════════════════════════════
-- 4. 고객사례 (customer_stories)
-- ═══════════════════════════════════════
INSERT INTO dataware_schema.customer_stories (company, slug, industry, title, content, thumbnail_url, logo_url, published, detail_json, created_at) VALUES
('오늘의집', 'ohouse', '유통', '버킷플레이스, 데이터 품질진단 솔루션 공급', '명확한 데이터 표준 관리와 품질관리로 사용자에게 보다 편리하고 최적의 고객 경험을 제공하기 위해 DA# DQ_Edition을 도입', '/images/uniondata/clients_img_ssg.png', '', true, '{"companyDesc":"올인원 라이프 스타일 플랫폼 오늘의집 운영사 버킷플레이스","pageHeading":"버킷플레이스, 데이터 품질진단 솔루션 공급","background":["컨텐츠/커머스/커뮤니티 유기적으로 결합된 서비스","회원 수와 빠르게 증가하는 데이터 관리"],"features":["DA# DQ_Edition"],"effects":["명확한 데이터 표준 관리, 품질관리","개발 생산성, 편의성 제고, 데이터 의사결정 활용"],"quote":"버킷플레이스 관계자는 \"명확한 데이터 표준 관리와 품질관리로 사용자에게 보다 편리하고 최적의 고객 경험을 제공하기 위해 DA# DQ_Edition을 도입하게 됐다\"며 \"데이터 모델링과 품질진단을 하나의 패키지 도입으로 해결할 수 있어 효율적으로 활용할 수 있을 것으로 기대하고 있다\"고 전했다.","quoteSource":"디지털데일리","meta":{"date":"2021-11-26","industry":"유통","purpose":"그룹웨어, 데이터 효과적 활용 기반 마련"}}', '2021-11-26'),
('SSG닷컴', 'ssg', '유통', 'SSG닷컴이 데이터를 활용하는 법', '데이터를 설계하여 구성원들이 데이터를 비즈니스에 활용하는 것이 데이터모델링의 목적이다.', '/images/uniondata/clients_img_ssg.png', '', true, '{"companyDesc":"신세계 그룹의 온라인 쇼핑 포털 SSG닷컴을 운영하는 이커머스 기업","pageHeading":"SSG닷컴이 데이터를 활용하는 법","background":["방대한 데이터의 수집·저장·통합·활용 등 전 과정을 효과적으로 관리의 필요성","따로 운영되던 유통 서비스를 단일 채널로 통합하기 위한 용어 표준화 필요"],"features":["DA#, DQ#, META# 을 통한 서비스 단일채널 통합","용어 표준화, 전사 데이터 현행화·표준화"],"effects":["기획팀 – 개발팀 소통 원활화","데이터 효과적 활용 기반마련","데이터 품질 향상","계보 관리로 향상된 데이터 프로세스 마련"],"quote":"데이터의 품질을 높이고, 데이터베이스를 설계하여 구성원들이 데이터를 비즈니스에 활용하는 것이 데이터모델링의 목적이다.","quoteSource":"컴퓨터월드","meta":{"date":"2021-11-11","industry":"유통","purpose":"그룹웨어, 데이터 효과적 활용 기반 마련"}}', '2021-11-11'),
('한국수자원공사', 'kwater', '공공기관', '한국수자원공사, 데이터 관리 포털 구축', '데이터 관리 포털 구축 프로젝트는 여타 다른 기업·기관의 프로젝트에 비해 요구사항도 많고 필요한 기능이 많았다.', '/images/uniondata/clients_img_kwater.png', '', true, '{"companyDesc":"국내의 모든 수자원 관리를 담당하는 환경부 산하 공기업","pageHeading":"한국수자원공사, 데이터 관리 포털 구축","background":["현업 담당자들에게 객관적인 데이터 관련 서비스 제공","데이터모델 기반 테이블 변경 관리 체계를 구축하여 데이터 구조 품질확보","비즈니스 분류 관리 및 시스템/DB서버/테이블/컬럼의 메타데이터를 관리하는 데이터 전문 솔루션 도입"],"effects":["개발 생산성, 편의성 제고, 데이터 활용 극대화","데이터모델(ERD) 기반 테이블 변경 프로세스 구축","IT부서 중심의 DB를 다양한 사용자가 활용할 수 있도록 시스템 구축"],"quote":"정보화 사업은 힘들고 어려운 프로젝트다. 수자원공사가 진행한 데이터 관리 포털 구축 프로젝트는 여타 다른 기업·기관의 프로젝트에 비해 요구사항도 많고 필요한 기능이 많았다.","quoteSource":"컴퓨터월드","meta":{"date":"2021-11-11","industry":"공공기관","purpose":"데이터 효과적 활용 기반 마련, 프로세스 구축"}}', '2021-11-11'),
('아모레퍼시픽', 'amore', '유통', '아모레퍼시픽, 메타데이터 관리체계 고도화', '현장의 영업, 마케팅, 생산자가 데이터를 활용하여 의사결정과 업무에 활용할 수 있도록 하는 것이 목표다.', '/images/uniondata/clients_img_amore.png', '', true, '{"companyDesc":"화장품, 생활용품, 건강식품 등을 생산, 판매하는 대한민국 대표적인 화장품 기업","pageHeading":"아모레퍼시픽, 메타데이터 관리체계 고도화","background":["전사 데이터 표준 및 모델관리 프로세스 개선과 시스템 구축","시스템 운영 수준 향상 및 장기적인 고품질 데이터 체계 기반 마련","효율적인 데이터 활용 및 분석을 위한 데이터 기반 비즈니스 의사결정 시스템 구축"],"features":["DATAWARE의 DA#, META# 활용","데이터 아키텍트, 데이터 설계·표준화·모델링 자체 수행"],"effects":["필요한 시점 데이터를 분석해 실시간 의사결정 도출 기반마련","데이터 리터러시 구축으로 마케팅, 영업 경쟁력 강화"],"quote":"데이터를 자체적으로 분석하고 다루는 환경이 안 되면 데이터 기반 영업과 마케팅이 근본적으로 불가능한 시대가 됐다.","quoteSource":"디지털타임스","meta":{"date":"2021-11-11","industry":"유통","purpose":"실시간 의사결정 도출 기반마련, 경쟁력 강화"}}', '2021-11-11'),
('현대해상', 'hyundai-marine', '금융', '현대해상, 메타데이터 관리시스템 재구축', '메타데이터를 통한 애플리케이션, 정보, 시스템 관리와 비즈니스 의사결정에 데이터 활용', '/images/uniondata/clients_img_hyundai-marine.png', '', true, '{"companyDesc":"1955년 3월 5일 설립, 1999년 현대그룹에서 분리된 해상보험 전업회사","pageHeading":"현대해상, 메타데이터 관리시스템 재구축","background":["메타데이터 시스템의 노후화로 인한 유지보수 및 지원 부재","운영인원 감소 및 관리대상 시스템 증가로 인한 효율적인 프로세스 필요"],"effects":["메타데이터를 통한 애플리케이션, 정보, 시스템 관리","축적된 데이터의 효율적 관리의 필요성 비즈니스 의사결정에 데이터 활용"],"quote":"단독으로 데이터 관리만을 위한 목적으로 메타데이터 관리솔루션 도입은 의미가 없다. 비즈니스 플로우를 통해 조직 내부에서 유동성 있게 데이터를 활용할 수 있는 환경 구축이 중요하다.","meta":{"date":"2021-11-10","industry":"금융","purpose":"그룹웨어, 데이터 효과적 활용 기반 마련"}}', '2021-11-10'),
('동양생명', 'dongyang-life', '금융', '동양생명, 데이터 관리체계 자동화 솔루션 도입', '노후화된 메타데이터 솔루션 교체 및 모델링 솔루션 도입으로 데이터 관리체계 자동화 구현', '/images/uniondata/clients_img_tong-yang-life.png', '', true, '{"companyDesc":"1989년 동양베네피트생명으로 설립된 생명보험 전문기업","pageHeading":"동양생명, 데이터 관리체계 자동화 솔루션 도입","background":["노후화된 메타데이터 솔루션 교체 및 모델링 솔루션 도입","모델 변경사항을 CSR 시스템으로 DB에 연동하여 반영","모델 현행화를 위한 표준 갭 분석"],"features":["DA#, META# 기반 데이터 관리 자동화"],"effects":["데이터 품질관리를 통한 고품질 데이터 확보","소통 원활화 및 운영 효율성 개선","데이터 기반 비즈니스 의사결정 지원","전사 IT 자산 관리 환경 제공"],"quote":"메타데이터 관리는 대용량 데이터 중 원하는 정보를 효율적으로 찾아낼 수 있도록 다른 데이터를 설명해 주는 데이터를 관리하는 것이다.","meta":{"date":"2021-11-10","industry":"금융","purpose":"데이터 관리체계 자동화, 고품질 데이터 확보"}}', '2021-11-10');


-- ===================== V18__seed_dataware_client_logos.sql =====================
-- V18: dataware 고객사 로고 시드 (보유 이미지 기준). docker cp + psql -f 로 실행할 것 (파이프 금지)
SET client_encoding TO 'UTF8';
DELETE FROM dataware_schema.client_logos;
INSERT INTO dataware_schema.client_logos (name, logo_url, sort_order, is_active) VALUES
  ('삼성전자', '/images/uniondata/clients-logo-9.jpg', 1, TRUE),
  ('SK하이닉스', '/images/uniondata/clients-logo-10.jpg', 2, TRUE),
  ('현대자동차', '/images/encore/reference-logo1-2.jpg', 3, TRUE),
  ('SK네트웍스', '/images/encore/reference-logo1-1.jpg', 4, TRUE),
  ('현대오일뱅크', '/images/encore/customers-logo2.jpg', 5, TRUE),
  ('우리은행', '/images/encore/reference-logo1-9.jpg', 6, TRUE),
  ('하나은행', '/images/encore/reference-logo1-19.jpg', 7, TRUE),
  ('IBK기업은행', '/images/encore/reference-logo1-3.jpg', 8, TRUE),
  ('KDB산업은행', '/images/encore/reference-logo1-11.jpg', 9, TRUE),
  ('한국은행', '/images/encore/reference-logo1-18.jpg', 10, TRUE),
  ('키움증권', '/images/encore/reference-logo1-6.jpg', 11, TRUE),
  ('유안타증권', '/images/encore/reference-logo1-7.jpg', 12, TRUE),
  ('삼성카드', '/images/uniondata/clients-logo-15.jpg', 13, TRUE),
  ('BC카드', '/images/uniondata/clients-logo-14.jpg', 14, TRUE),
  ('삼성화재', '/images/uniondata/clients-logo-2.jpg', 15, TRUE),
  ('KB손해보험', '/images/encore/reference-logo1-12.jpg', 16, TRUE),
  ('DB손해보험', '/images/encore/reference-logo1-13.jpg', 17, TRUE),
  ('한화생명', '/images/encore/reference-logo1-14.jpg', 18, TRUE),
  ('한국수자원공사', '/images/uniondata/clients-logo-8.jpg', 19, TRUE),
  ('행정안전부', '/images/uniondata/clients-logo-4.jpg', 20, TRUE),
  ('조달청', '/images/uniondata/clients-logo-5.jpg', 21, TRUE),
  ('KOTRA', '/images/uniondata/clients-logo-7.jpg', 22, TRUE),
  ('KINTEX', '/images/encore/reference-logo1-16.jpg', 23, TRUE);


-- ===================== V19__add_yanolja_logo.sql =====================
-- 야놀자 로고 추가 (dataware). docker cp + psql -f 로 실행(파이프 금지).
SET client_encoding TO 'UTF8';
DELETE FROM dataware_schema.client_logos WHERE name = '야놀자';
INSERT INTO dataware_schema.client_logos (name, logo_url, sort_order, is_active)
VALUES ('야놀자', '/images/clients/yanolja.png', 24, TRUE);


-- ===================== V20__upgrade_logo_quality.sql =====================
-- 로고 화질 개선: 저해상도 로고를 로컬 고화질(265x140) 버전으로 교체. docker cp + psql -f.
SET client_encoding TO 'UTF8';
UPDATE dataware_schema.client_logos SET logo_url='/images/encore/customers-logo4.jpg'  WHERE name='우리은행';
UPDATE dataware_schema.client_logos SET logo_url='/images/encore/customers-logo5.jpg'  WHERE name='IBK기업은행';
UPDATE dataware_schema.client_logos SET logo_url='/images/encore/customers-logo6.jpg'  WHERE name='하나은행';
UPDATE dataware_schema.client_logos SET logo_url='/images/encore/customers-logo11.jpg' WHERE name='KB손해보험';


-- ===================== V21__add_more_client_logos.sql =====================
-- 안 쓴 대기업 로고 5개 추가 (dataware). docker cp + psql -f 로 실행(파이프 금지).
SET client_encoding TO 'UTF8';
DELETE FROM dataware_schema.client_logos WHERE name IN ('롯데쇼핑','카카오뱅크','현대카드','KB생명','LG유플러스');
INSERT INTO dataware_schema.client_logos (name, logo_url, sort_order, is_active) VALUES
('롯데쇼핑',   '/images/clients/lotte.png',       25, TRUE),
('카카오뱅크', '/images/clients/kakaobank.png',   26, TRUE),
('현대카드',   '/images/clients/hyundaicard.png', 27, TRUE),
('KB생명',    '/images/clients/kblife.png',      28, TRUE),
('LG유플러스', '/images/clients/lguplus.png',     29, TRUE);


-- ===================== V22__remove_stray_logo.sql =====================
-- 테스트로 들어간 stray 로고 항목 제거 (쁘민/보민 등). docker cp + psql -f.
SET client_encoding TO 'UTF8';
DELETE FROM dataware_schema.client_logos WHERE name IN ('쁘민','보민');
DELETE FROM union_schema.client_logos    WHERE name IN ('쁘민','보민');


-- ===================== V23__seed_union_client_logos.sql =====================
SET client_encoding TO 'UTF8';

-- 기존 placeholder 전부 제거 후 실제 유니온 고객사 15곳으로 교체
DELETE FROM union_schema.client_logos;

INSERT INTO union_schema.client_logos (name, logo_url, sort_order, is_active) VALUES
  ('경신',           '/images/clients/kyungshin.png',       1,  true),
  ('LG CNS',         '/images/clients/lgcns.png',           2,  true),
  ('건국대학교병원',  '/images/clients/konkuk-hospital.png', 3,  true),
  ('KTA',            '/images/clients/kta.png',             4,  true),
  ('LG이노텍',       '/images/clients/lginnotek.png',       5,  true),
  ('SKT',            '/images/clients/skt.png',             6,  true),
  ('영풍문고',       '/images/clients/ypbooks.png',         7,  true),
  ('잡코리아',       '/images/clients/jobkorea.png',        8,  true),
  ('노랑풍선',       '/images/clients/norangpungseon.png',  9,  true),
  ('대웅',           '/images/clients/daewoong.png',        10, true),
  ('종근당',         '/images/clients/jongkeundang.png',    11, true),
  ('KICA',           '/images/clients/kica.png',            12, true),
  ('GC녹십자',       '/images/clients/gc-greencross.png',   13, true),
  ('아워홈',         '/images/clients/ourhome.png',         14, true),
  ('야놀자',         '/images/clients/yanolja.png',         15, true);


-- ===================== V24__add_show_on_home.sql =====================
SET client_encoding TO 'UTF8';

-- 고객사 로고: 홈 노출 여부 컬럼 추가
ALTER TABLE union_schema.client_logos    ADD COLUMN IF NOT EXISTS show_on_home BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE dataware_schema.client_logos ADD COLUMN IF NOT EXISTS show_on_home BOOLEAN NOT NULL DEFAULT false;

-- 기존 홈 노출 로고 이관 (dataware: sort_order <= 24 → show_on_home = true)
UPDATE dataware_schema.client_logos SET show_on_home = true WHERE sort_order <= 24;

-- union: 전체 홈 노출
UPDATE union_schema.client_logos SET show_on_home = true;


-- ===================== V25__transparent_png_logos.sql =====================
SET client_encoding TO 'UTF8';
-- 데이터웨어 고객사 로고: 흰배경 jpg → 투명 png 로 교체 (23개)
UPDATE dataware_schema.client_logos SET logo_url = '/images/uniondata/clients-logo-9.png' WHERE logo_url = '/images/uniondata/clients-logo-9.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/uniondata/clients-logo-10.png' WHERE logo_url = '/images/uniondata/clients-logo-10.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/reference-logo1-2.png' WHERE logo_url = '/images/encore/reference-logo1-2.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/reference-logo1-1.png' WHERE logo_url = '/images/encore/reference-logo1-1.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/customers-logo2.png' WHERE logo_url = '/images/encore/customers-logo2.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/customers-logo4.png' WHERE logo_url = '/images/encore/customers-logo4.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/customers-logo6.png' WHERE logo_url = '/images/encore/customers-logo6.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/customers-logo5.png' WHERE logo_url = '/images/encore/customers-logo5.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/reference-logo1-11.png' WHERE logo_url = '/images/encore/reference-logo1-11.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/reference-logo1-18.png' WHERE logo_url = '/images/encore/reference-logo1-18.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/reference-logo1-6.png' WHERE logo_url = '/images/encore/reference-logo1-6.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/reference-logo1-7.png' WHERE logo_url = '/images/encore/reference-logo1-7.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/uniondata/clients-logo-15.png' WHERE logo_url = '/images/uniondata/clients-logo-15.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/uniondata/clients-logo-14.png' WHERE logo_url = '/images/uniondata/clients-logo-14.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/uniondata/clients-logo-2.png' WHERE logo_url = '/images/uniondata/clients-logo-2.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/customers-logo11.png' WHERE logo_url = '/images/encore/customers-logo11.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/reference-logo1-13.png' WHERE logo_url = '/images/encore/reference-logo1-13.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/reference-logo1-14.png' WHERE logo_url = '/images/encore/reference-logo1-14.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/uniondata/clients-logo-8.png' WHERE logo_url = '/images/uniondata/clients-logo-8.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/uniondata/clients-logo-4.png' WHERE logo_url = '/images/uniondata/clients-logo-4.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/uniondata/clients-logo-5.png' WHERE logo_url = '/images/uniondata/clients-logo-5.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/uniondata/clients-logo-7.png' WHERE logo_url = '/images/uniondata/clients-logo-7.jpg';
UPDATE dataware_schema.client_logos SET logo_url = '/images/encore/reference-logo1-16.png' WHERE logo_url = '/images/encore/reference-logo1-16.jpg';


-- ===================== V26__dataware_logo_balance.sql =====================
SET client_encoding TO 'UTF8';
-- 데이터웨어 고객사 로고: 2단계 구조
--  · 고객사례 페이지(/customers) = 전체 노출(풍성/다양)
--  · 홈 로고월 = 균형 큐레이션(금융 최소)

-- 1) 고객사례 페이지엔 전부 노출
UPDATE dataware_schema.client_logos SET is_active = true;

-- 2) 홈은 일단 전부 내리고
UPDATE dataware_schema.client_logos SET show_on_home = false;

-- 3) 홈 노출 = 분야 균형 세트(비금융 13 + 대표 금융 5 = 18)
UPDATE dataware_schema.client_logos SET show_on_home = true
 WHERE name IN ('삼성전자','SK하이닉스','현대자동차','SK네트웍스','현대오일뱅크',
                '롯데쇼핑','LG유플러스','야놀자',
                '행정안전부','조달청','KOTRA','KINTEX','한국수자원공사',
                '우리은행','하나은행','삼성카드','삼성화재','한화생명');


