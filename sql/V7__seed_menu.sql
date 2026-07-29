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
