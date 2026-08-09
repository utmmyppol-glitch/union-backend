-- =============================================
-- 05: 이관 후 검증 쿼리
-- 이관 스크립트 01~04 실행 후 검증용
-- 모든 쿼리는 SELECT — 데이터 변경 없음
-- =============================================

-- =============================================
-- A. 행수 검증 — 이관 전 기록과 비교
-- =============================================
SELECT 'common.admins' AS tbl, count(*) AS cnt FROM common.admins
UNION ALL SELECT 'union.banners', count(*) FROM union_schema.banners
UNION ALL SELECT 'union.posts', count(*) FROM union_schema.posts
UNION ALL SELECT 'union.inquiries', count(*) FROM union_schema.inquiries
UNION ALL SELECT 'union.customer_stories', count(*) FROM union_schema.customer_stories
UNION ALL SELECT 'union.client_logos', count(*) FROM union_schema.client_logos
UNION ALL SELECT 'union.downloads', count(*) FROM union_schema.downloads
UNION ALL SELECT 'union.menu', count(*) FROM union_schema.menu
UNION ALL SELECT 'union.content', count(*) FROM union_schema.content
UNION ALL SELECT 'union.site_config', count(*) FROM union_schema.site_config
UNION ALL SELECT 'union.history', count(*) FROM union_schema.history
UNION ALL SELECT 'union.glossary', count(*) FROM union_schema.glossary
UNION ALL SELECT 'dw.banners', count(*) FROM dataware_schema.banners
UNION ALL SELECT 'dw.products', count(*) FROM dataware_schema.products
UNION ALL SELECT 'dw.posts', count(*) FROM dataware_schema.posts
UNION ALL SELECT 'dw.inquiries', count(*) FROM dataware_schema.inquiries
UNION ALL SELECT 'dw.customer_stories', count(*) FROM dataware_schema.customer_stories
UNION ALL SELECT 'dw.client_logos', count(*) FROM dataware_schema.client_logos
UNION ALL SELECT 'dw.downloads', count(*) FROM dataware_schema.downloads
UNION ALL SELECT 'dw.educations', count(*) FROM dataware_schema.educations
UNION ALL SELECT 'dw.seminars', count(*) FROM dataware_schema.seminars
UNION ALL SELECT 'dw.pricing_plans', count(*) FROM dataware_schema.pricing_plans
UNION ALL SELECT 'dw.education_sessions', count(*) FROM dataware_schema.education_sessions
UNION ALL SELECT 'dw.download_resources', count(*) FROM dataware_schema.download_resources
ORDER BY tbl;

-- 기대 행수 (시드 데이터 기준):
-- common.admins: 5 (4 + encore viewer)
-- union.banners: 4
-- union.posts: 4
-- union.inquiries: 3
-- union.customer_stories: 2
-- union.client_logos: 5
-- union.downloads: 2
-- union.menu: 28
-- union.content: 6
-- union.site_config: 12
-- union.history: 16
-- union.glossary: 10
-- dw.banners: 3
-- dw.products: 7
-- dw.posts: 4
-- dw.inquiries: 3
-- dw.customer_stories: 2
-- dw.client_logos: 5
-- dw.downloads: 2
-- dw.educations: 2
-- dw.seminars: 2
-- dw.pricing_plans: 3
-- dw.education_sessions: 7
-- dw.download_resources: 6

-- =============================================
-- B. 유니크 제약 검증
-- =============================================

-- admin username 중복
SELECT username, count(*) FROM common.admins GROUP BY username HAVING count(*) > 1;

-- product slug 중복
SELECT slug, count(*) FROM dataware_schema.products GROUP BY slug HAVING count(*) > 1;

-- site_config key 중복
SELECT config_key, count(*) FROM union_schema.site_config GROUP BY config_key HAVING count(*) > 1;
SELECT config_key, count(*) FROM dataware_schema.site_config GROUP BY config_key HAVING count(*) > 1;

-- content region_key 중복 (menu_id, region_key 복합)
SELECT menu_id, region_key, count(*) FROM union_schema.content GROUP BY menu_id, region_key HAVING count(*) > 1;
SELECT menu_id, region_key, count(*) FROM dataware_schema.content GROUP BY menu_id, region_key HAVING count(*) > 1;

-- =============================================
-- C. 메뉴 트리 무결성
-- =============================================

-- parent_id가 없는 메뉴 참조 (깨진 트리)
SELECT m.id, m.name, m.parent_id
FROM union_schema.menu m
LEFT JOIN union_schema.menu p ON m.parent_id = p.id
WHERE m.parent_id IS NOT NULL AND p.id IS NULL;

SELECT m.id, m.name, m.parent_id
FROM dataware_schema.menu m
LEFT JOIN dataware_schema.menu p ON m.parent_id = p.id
WHERE m.parent_id IS NOT NULL AND p.id IS NULL;

-- 시퀀스 현재값 확인 (max(id) 이상이어야 함)
SELECT 'union.menu' AS seq, currval('union_schema.menu_id_seq') AS seq_val, max(id) AS max_id FROM union_schema.menu;
SELECT 'dw.menu' AS seq, currval('dataware_schema.menu_id_seq') AS seq_val, max(id) AS max_id FROM dataware_schema.menu;

-- =============================================
-- D. 데이터 스팟체크
-- =============================================

-- 제품 목록 확인
SELECT id, name, slug, category, published FROM dataware_schema.products ORDER BY sort_order;

-- 고객사례 published 상태
SELECT company, published FROM union_schema.customer_stories;
SELECT company, published FROM dataware_schema.customer_stories;

-- 문의 상태 분포
SELECT status, count(*) FROM union_schema.inquiries GROUP BY status;
SELECT status, count(*) FROM dataware_schema.inquiries GROUP BY status;

-- 배너 위치별 개수
SELECT position, count(*) FROM union_schema.banners GROUP BY position;
SELECT position, count(*) FROM dataware_schema.banners GROUP BY position;

-- =============================================
-- E. 이미지 참조 무결성
-- =============================================

-- NULL 이미지 URL 확인
SELECT 'union.banners' AS src, id, title FROM union_schema.banners WHERE image_url IS NULL OR image_url = ''
UNION ALL SELECT 'dw.banners', id, title FROM dataware_schema.banners WHERE image_url IS NULL OR image_url = ''
UNION ALL SELECT 'dw.products', id, name FROM dataware_schema.products WHERE icon_url IS NULL
UNION ALL SELECT 'union.posts', id, title FROM union_schema.posts WHERE thumbnail_url IS NULL
UNION ALL SELECT 'dw.posts', id, title FROM dataware_schema.posts WHERE thumbnail_url IS NULL;

-- =============================================
-- F. 개인정보 동의 검증
-- =============================================

-- 동의 없이 저장된 개인정보 건수 (0이어야 함)
SELECT 'union.inquiries' AS src, count(*) FROM union_schema.inquiries WHERE consent_privacy IS NOT TRUE
UNION ALL SELECT 'union.downloads', count(*) FROM union_schema.downloads WHERE consent_privacy IS NOT TRUE
UNION ALL SELECT 'dw.inquiries', count(*) FROM dataware_schema.inquiries WHERE consent_privacy IS NOT TRUE
UNION ALL SELECT 'dw.downloads', count(*) FROM dataware_schema.downloads WHERE consent_privacy IS NOT TRUE
UNION ALL SELECT 'dw.educations', count(*) FROM dataware_schema.educations WHERE consent_privacy IS NOT TRUE
UNION ALL SELECT 'dw.seminars', count(*) FROM dataware_schema.seminars WHERE consent_privacy IS NOT TRUE;
