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
