-- =============================================
-- 04: 시퀀스 동기화
-- INSERT 후 auto-increment 시퀀스를 max(id)+1 로 재설정
-- 이관 스크립트 01~03 실행 후에 반드시 실행
-- 실행 금지 — 검토 후 수동 실행
-- =============================================

BEGIN;

-- COMMON
SELECT setval('common.admins_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM common.admins)));

-- UNION_SCHEMA
SELECT setval('union_schema.banners_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.banners)));

SELECT setval('union_schema.posts_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.posts)));

SELECT setval('union_schema.inquiries_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.inquiries)));

SELECT setval('union_schema.customer_stories_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.customer_stories)));

SELECT setval('union_schema.client_logos_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.client_logos)));

SELECT setval('union_schema.downloads_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.downloads)));

SELECT setval('union_schema.menu_id_seq',
  GREATEST(100, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.menu)));

SELECT setval('union_schema.content_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.content)));

SELECT setval('union_schema.site_config_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.site_config)));

SELECT setval('union_schema.history_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.history)));

SELECT setval('union_schema.glossary_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.glossary)));

-- DATAWARE_SCHEMA
SELECT setval('dataware_schema.banners_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.banners)));

SELECT setval('dataware_schema.products_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.products)));

SELECT setval('dataware_schema.posts_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.posts)));

SELECT setval('dataware_schema.inquiries_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.inquiries)));

SELECT setval('dataware_schema.customer_stories_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.customer_stories)));

SELECT setval('dataware_schema.client_logos_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.client_logos)));

SELECT setval('dataware_schema.downloads_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.downloads)));

SELECT setval('dataware_schema.educations_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.educations)));

SELECT setval('dataware_schema.seminars_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.seminars)));

SELECT setval('dataware_schema.menu_id_seq',
  GREATEST(100, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.menu)));

SELECT setval('dataware_schema.content_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.content)));

SELECT setval('dataware_schema.site_config_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.site_config)));

SELECT setval('dataware_schema.pricing_plans_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.pricing_plans)));

SELECT setval('dataware_schema.education_sessions_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.education_sessions)));

SELECT setval('dataware_schema.download_resources_id_seq',
  GREATEST(1, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.download_resources)));

COMMIT;
