-- =============================================
-- 01: 구조 데이터 이관 (배너, 제품, 메뉴, 사이트설정, 파트너 등)
-- 개인정보 미포함 — 안전하게 이관 가능
-- Idempotent: ON CONFLICT DO NOTHING
-- 실행 금지 — 검토 후 수동 실행
-- =============================================

BEGIN;

-- =============================================
-- COMMON — 관리자 계정
-- 주의: 비밀번호 해시는 운영 환경에서 반드시 재설정
-- =============================================
INSERT INTO common.admins (username, password, role, site) VALUES
('admin',        '$2a$10$uTmCLAca6WNYIWS951JeyuzqOmTl3YIm2Ob5EQkNyKwQMOdUNwQoS', 'SUPER',  NULL),
('union_editor', '$2a$10$uTmCLAca6WNYIWS951JeyuzqOmTl3YIm2Ob5EQkNyKwQMOdUNwQoS', 'EDITOR', 'UNION'),
('dw_editor',    '$2a$10$uTmCLAca6WNYIWS951JeyuzqOmTl3YIm2Ob5EQkNyKwQMOdUNwQoS', 'EDITOR', 'DATAWARE'),
('viewer',       '$2a$10$uTmCLAca6WNYIWS951JeyuzqOmTl3YIm2Ob5EQkNyKwQMOdUNwQoS', 'VIEWER', NULL)
ON CONFLICT (username) DO NOTHING;

-- =============================================
-- UNION — 배너
-- =============================================
INSERT INTO union_schema.banners (title, image_url, link_url, position, is_active, sort_order) VALUES
('유니온시스템즈 메인 배너',      '/images/union/hero-1.jpg',  '/about',     'HERO',      true, 1),
('IT 인프라 솔루션 소개',          '/images/union/hero-2.jpg',  '/solutions', 'HERO',      true, 2),
('2026 하반기 프로모션',           '/images/union/promo-1.jpg', '/event',     'PROMOTION', true, 1),
('신규 고객 할인 이벤트',          '/images/union/popup-1.jpg', '/contact',   'POPUP',     true, 1)
ON CONFLICT DO NOTHING;

-- =============================================
-- UNION — 고객사 로고
-- =============================================
INSERT INTO union_schema.client_logos (name, logo_url, sort_order, is_active) VALUES
('삼성전자',   '/images/union/clients/samsung.png',  1, true),
('현대자동차', '/images/union/clients/hyundai.png',  2, true),
('LG CNS',     '/images/union/clients/lgcns.png',    3, true),
('SK하이닉스', '/images/union/clients/skhynix.png',  4, true),
('KB금융그룹', '/images/union/clients/kb.png',       5, true)
ON CONFLICT DO NOTHING;

-- =============================================
-- UNION — 사이트 설정
-- =============================================
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

-- =============================================
-- UNION — 메뉴 트리
-- 주의: ID를 고정 지정하므로 빈 테이블에서만 안전
-- =============================================
INSERT INTO union_schema.menu (id, parent_id, name, url, menu_type, sort_order, depth, is_exposed) VALUES
(1,  NULL, 'Company',   '/company',         'CONTENT', 1, 0, true),
(2,  NULL, 'Software',  '/software',        'CONTENT', 2, 0, true),
(3,  NULL, 'Solution',  '/solution',        'CONTENT', 3, 0, true),
(4,  NULL, 'Customer',  '/support/notices',  'CONTENT', 4, 0, true),
(5,  NULL, 'Insights',  '/insights',        'CONTENT', 5, 0, true),
(6,  NULL, 'Estimate',  '/estimate',        'CONTENT', 6, 0, true),
(7,  NULL, 'SAM',       '/license-alert',   'CONTENT', 7, 0, true),
(8,  NULL, '도입문의',   '/contact',         'CONTENT', 8, 0, true),
(10, 1, '기업소개',    '/company/about',    'CONTENT', 1, 1, true),
(11, 1, '주요연혁',    '/company/history',  'CONTENT', 2, 1, true),
(20, 2, 'Microsoft',   '/software/microsoft',  'CONTENT', 1, 1, true),
(21, 2, 'ESTsoft',     '/software/estsoft',    'CONTENT', 2, 1, true),
(22, 2, 'Autodesk',    '/software/autodesk',   'CONTENT', 3, 1, true),
(23, 2, 'Adobe',       '/software/adobe',      'CONTENT', 4, 1, true),
(30, 3, '데이터',      '/solution/data',                    'CONTENT', 1, 1, true),
(31, 3, '자산관리',    '/solution/asset-management',         'CONTENT', 2, 1, true),
(32, 3, '보안',        '/solution/security',                 'CONTENT', 3, 1, true),
(33, 30, 'DATAWARE',   'https://dataware.unionsystems.co.kr', 'LINK', 1, 2, true),
(34, 31, 'NetClient',  '/solution/asset-management/netclient', 'CONTENT', 1, 2, true),
(35, 32, 'AhnLab',       '/solution/security/ahnlab',       'CONTENT', 1, 2, true),
(36, 32, 'ESTsecurity',  '/solution/security/estsecurity',  'CONTENT', 2, 2, true),
(37, 32, 'OfficeKeeper', '/solution/security/officekeeper', 'CONTENT', 3, 2, true),
(40, 4, '공지사항',    '/support/notices',  'BOARD',   1, 1, true),
(41, 4, '1:1 문의',    '/support/inquiry',  'CONTENT', 2, 1, true),
(42, 4, '기술지원',    '/support/tech',     'CONTENT', 3, 1, true),
(43, 4, '이벤트',      '/support/events',   'BOARD',   4, 1, true),
(50, 7, '라이선스 관리 상담', '/license-alert',   'CONTENT', 1, 1, true),
(51, 7, '보안 점검',          '/security-check',  'CONTENT', 2, 1, true),
(52, 7, 'IT·보안 용어사전',   '/glossary',        'CONTENT', 3, 1, true)
ON CONFLICT (id) DO NOTHING;

SELECT setval('union_schema.menu_id_seq', GREATEST(100, (SELECT COALESCE(MAX(id), 0) + 1 FROM union_schema.menu)));

-- =============================================
-- UNION — 파트너
-- =============================================
INSERT INTO union_schema.partners (name, role, logo_url, sort_order) VALUES
('Microsoft', 'CSP 공인 파트너', 'https://img.icons8.com/color/96/microsoft.png', 1),
('Adobe',     '공식 리셀러',     'https://img.icons8.com/color/96/adobe.png', 2),
('Autodesk',  '공인 리셀러',     'https://img.icons8.com/color/96/autodesk.png', 3),
('엔코아',    'DA# 공인총판',    '/images/partners/encore.png', 4),
('AhnLab',    '공식 파트너',     '/images/partners/ahnlab.png', 5),
('ESTsecurity','기업보안 파트너', '/images/partners/estsecurity.png', 6)
ON CONFLICT DO NOTHING;

-- =============================================
-- UNION — 용어사전
-- =============================================
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
('ISV', 'Independent Software Vendor', '자체 소프트웨어를 개발하여 판매하는 독립 소프트웨어 업체.', '소프트웨어', 10)
ON CONFLICT DO NOTHING;

-- =============================================
-- DATAWARE — 배너
-- =============================================
INSERT INTO dataware_schema.banners (title, image_url, link_url, position, is_active, sort_order) VALUES
('데이터웨어 메인 배너',          '/images/dw/hero-1.jpg',  '/products',  'HERO',      true, 1),
('DA# 데이터 모델링 도구',        '/images/dw/hero-2.jpg',  '/products/da-sharp', 'HERO', true, 2),
('MetaSharp 메타데이터 관리',      '/images/dw/promo-1.jpg', '/products/meta-sharp', 'PROMOTION', true, 1)
ON CONFLICT DO NOTHING;

-- =============================================
-- DATAWARE — 제품
-- =============================================
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
 '/images/dw/icon-dp.png', '/images/dw/thumb-dp.jpg', NULL, 7, true)
ON CONFLICT (slug) DO NOTHING;

-- =============================================
-- DATAWARE — 고객사 로고
-- =============================================
INSERT INTO dataware_schema.client_logos (name, logo_url, sort_order, is_active) VALUES
('신한은행',   '/images/dw/clients/shinhan.png',  1, true),
('포스코',     '/images/dw/clients/posco.png',    2, true),
('우리은행',   '/images/dw/clients/woori.png',    3, true),
('CJ대한통운', '/images/dw/clients/cj.png',       4, true),
('한국전력',   '/images/dw/clients/kepco.png',    5, true)
ON CONFLICT DO NOTHING;

-- =============================================
-- DATAWARE — 사이트 설정
-- =============================================
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

-- =============================================
-- DATAWARE — 메뉴 트리
-- =============================================
INSERT INTO dataware_schema.menu (id, parent_id, name, url, menu_type, sort_order, depth, is_exposed) VALUES
(1,  NULL, 'DATAWARE',  '/products',    'CONTENT', 1, 0, true),
(2,  NULL, '교육',       '/education',   'CONTENT', 2, 0, true),
(3,  NULL, '고객지원',   '/resources',   'CONTENT', 3, 0, true),
(4,  NULL, '가격안내',   '/pricing',     'CONTENT', 4, 0, true),
(5,  NULL, '고객사례',   '/customers',   'CONTENT', 5, 0, true),
(6,  NULL, '이벤트',     '/events',      'CONTENT', 6, 0, true),
(10, 2, '무료교육',      '/education',          'CONTENT', 1, 1, true),
(11, 2, '방문 세미나',   '/seminar',            'CONTENT', 2, 1, true),
(12, 2, '동영상 강의',   '/resources/videos',   'CONTENT', 3, 1, true),
(20, 3, '공지사항',       '/resources/notices',  'BOARD',   1, 1, true),
(21, 3, '다운로드 신청',  '/download',           'CONTENT', 2, 1, true),
(22, 3, '데이터 진단',    '/diagnosis',          'CONTENT', 3, 1, true),
(23, 3, '파트너 제휴',    '/partner',            'CONTENT', 4, 1, true),
(30, NULL, '도입문의',    '/contact',            'CONTENT', 7, 0, true),
(31, NULL, '다운로드',    '/download',           'CONTENT', 8, 0, false)
ON CONFLICT (id) DO NOTHING;

SELECT setval('dataware_schema.menu_id_seq', GREATEST(100, (SELECT COALESCE(MAX(id), 0) + 1 FROM dataware_schema.menu)));

-- =============================================
-- DATAWARE — 가격 플랜
-- =============================================
INSERT INTO dataware_schema.pricing_plans (name, license_type, price, original_price, price_display, badge, is_popular, sort_order) VALUES
('DA# Architecture', '1년 라이선스', 2400000, 6000000, '2,400,000원', '60% 할인', false, 1),
('DA# 통합 패키지',  '평생 라이선스', 6000000, 12000000, '6,000,000원', '50% 할인', true, 2),
('DA# Repository',  '평생 라이선스', 15000000, 25000000, '15,000,000원', '40% 할인', false, 3)
ON CONFLICT DO NOTHING;

-- =============================================
-- DATAWARE — 교육 세션
-- =============================================
INSERT INTO dataware_schema.education_sessions (title, date, thumbnail, tag, status, description, sort_order) VALUES
('2026 DA# 실전 데이터모델링 (3월)', '2026.03.20(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-1.png', '실전', 'CLOSED', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 1),
('2026 DA# 실전 데이터모델링 (4월)', '2026.04.17(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-2.png', '실전', 'CLOSED', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 2),
('2026 DA# 실전 데이터모델링 (6월)', '2026.06.19(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-3.png', '실전', 'OPEN', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 3),
('2026 홍우석의 실전데이터모델링 (6월)', '2026.06.24(Wed) 13:00~17:00', '/images/uniondata/2606_head.png', '특강', 'OPEN', '현업 데이터 전문가의 실무 모델링 노하우', 4),
('2026 DA# 실전 데이터모델링 (8월)', '2026.08.21(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-1.png', '실전', 'OPEN', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 5),
('2026 DA# 실전 데이터모델링 (10월)', '2026.10.16(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-2.png', '실전', 'OPEN', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 6),
('2026 DA# 실전 데이터모델링 (12월)', '2026.12.18(Thu) 09:30~17:00', '/images/uniondata/2026DA_head-3.png', '실전', 'OPEN', '데이터 아키텍처 기본개념부터 고급 활용까지 1DAY', 7)
ON CONFLICT DO NOTHING;

-- =============================================
-- DATAWARE — 다운로드 자료
-- =============================================
INSERT INTO dataware_schema.download_resources (title, description, file_type, thumbnail, sort_order) VALUES
('DA#5 설치파일(기업용)', 'DA# Architecture 기업용 설치 프로그램', 'INSTALLER', '/images/uniondata/da5-biz.png', 1),
('DA#5 설치파일(개인용)', 'DA# Architecture 개인용 무료 버전', 'INSTALLER', '/images/uniondata/da5-personal.png', 2),
('DA# 제품 소개서', 'DA# 제품군 종합 소개 PDF', 'BROCHURE', '/images/uniondata/brochure.png', 3),
('DATAWARE 소개서', 'DATAWARE 통합 패키지 소개 PDF', 'BROCHURE', '/images/uniondata/dataware-brochure.png', 4),
('DA# 사용자 매뉴얼', 'DA# v5.0 사용자 가이드', 'MANUAL', '/images/uniondata/manual.png', 5),
('데이터 거버넌스 백서', '데이터 거버넌스 구축 가이드', 'WHITEPAPER', '/images/uniondata/whitepaper.png', 6)
ON CONFLICT DO NOTHING;

COMMIT;
