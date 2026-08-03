-- =============================================
-- 03: 개인정보 포함 데이터 이관 (문의, 다운로드, 교육, 세미나)
-- *** 주의: 개인정보(이름, 전화번호, 이메일) 포함 ***
-- 이관 전 확인사항:
--   1. consent_privacy = true 인 건만 이관 (법적 근거)
--   2. 보관 기한 초과 건은 제외 또는 비식별화
--   3. 이관 수행 일시·수행자·건수를 별도 기록
--   4. 개발 환경에서는 이관 후 반드시 마스킹 적용
-- Idempotent: ON CONFLICT DO NOTHING
-- 실행 금지 — 검토 후 수동 실행
-- =============================================

BEGIN;

-- =============================================
-- UNION — 문의
-- =============================================
INSERT INTO union_schema.inquiries (name, company, phone, email, message, product, status, consent_privacy) VALUES
('김철수', '삼성전자',   '010-1234-5678', 'kim@samsung.com',  '클라우드 마이그레이션 관련 상담 요청합니다.',       '클라우드 컨설팅', 'NEW',         true),
('이영희', 'LG CNS',     '010-2345-6789', 'lee@lgcns.com',    '데이터 웨어하우스 구축 견적 문의드립니다.',          '데이터 솔루션',   'IN_PROGRESS', true),
('박민수', 'SK하이닉스',  '010-3456-7890', 'park@skhynix.com', 'IT 인프라 통합 관리 솔루션에 대해 알고 싶습니다.',   'IT 인프라',       'COMPLETED',   true)
ON CONFLICT DO NOTHING;

-- =============================================
-- UNION — 다운로드 신청
-- =============================================
INSERT INTO union_schema.downloads (name, company, phone, email, file_type, consent_privacy, consent_marketing) VALUES
('정수진', '카카오',     '010-4567-8901', 'jung@kakao.com',    '회사소개서',   true, true),
('최동현', '네이버',     '010-5678-9012', 'choi@naver.com',    '솔루션 브로슈어', true, false)
ON CONFLICT DO NOTHING;

-- =============================================
-- DATAWARE — 문의
-- =============================================
INSERT INTO dataware_schema.inquiries (name, company, phone, email, message, product, status, consent_privacy, consent_third_party) VALUES
('한지영', '우리은행',   '010-6789-0123', 'han@wooribank.com', 'DA# 도입 관련 데모 요청합니다.',                   'DA#',    'NEW',         true, true),
('오승환', '포스코',     '010-7890-1234', 'oh@posco.com',      'DQ# 데이터 품질 관리 솔루션 견적 문의합니다.',      'DQ#',    'IN_PROGRESS', true, false),
('윤서연', 'CJ대한통운', '010-8901-2345', 'yoon@cj.com',       'Meta# 메타데이터 관리 POC 진행 가능한지 문의합니다.', 'Meta#', 'COMPLETED',   true, true)
ON CONFLICT DO NOTHING;

-- =============================================
-- DATAWARE — 다운로드 신청
-- =============================================
INSERT INTO dataware_schema.downloads (name, company, phone, email, file_type, consent_privacy, consent_third_party, consent_marketing) VALUES
('강민호', '롯데정보통신', '010-9012-3456', 'kang@lotte.com',   'DA# 브로슈어',    true, true,  true),
('임수빈', 'KT',           '010-0123-4567', 'lim@kt.com',       '제품 카탈로그',   true, false, false)
ON CONFLICT DO NOTHING;

-- =============================================
-- DATAWARE — 교육 신청
-- =============================================
INSERT INTO dataware_schema.educations (name, company, phone, email, position, preferred_date, note, consent_privacy, consent_third_party, status) VALUES
('서준혁', 'NH농협',     '010-1111-2222', 'seo@nh.com',     '과장',   '2026-08-15', 'DA# 기초 교육 희망합니다. 5명 참석 예정입니다.',  true, true, 'NEW'),
('장하은', '한화시스템', '010-3333-4444', 'jang@hanwha.com', '대리',   '2026-09-01', 'Meta# 실무 교육 요청합니다.',                    true, true, 'CONFIRMED')
ON CONFLICT DO NOTHING;

-- =============================================
-- DATAWARE — 세미나 신청
-- =============================================
INSERT INTO dataware_schema.seminars (name, company, phone, email, department, preferred_date, attendees, topic, note, consent_privacy, consent_third_party, status) VALUES
('배성민', '두산에너빌리티', '010-5555-6666', 'bae@doosan.com',  'IT기획팀',    '2026-08-20', 15, '데이터 거버넌스 구축 사례',  '사내 세미나로 진행 희망합니다.', true, true, 'NEW'),
('고은지', 'GS칼텍스',       '010-7777-8888', 'ko@gscaltex.com', '데이터팀',    '2026-09-10', 8,  '데이터 품질 관리 방법론',    NULL,                            true, true, 'CONFIRMED')
ON CONFLICT DO NOTHING;

COMMIT;

-- =============================================
-- 개발 환경 마스킹 (운영에서는 실행하지 않음)
-- 아래는 개발 DB에서만 실행
-- =============================================
-- BEGIN;
--
-- UPDATE union_schema.inquiries SET
--   name = '테스트' || id,
--   phone = '010-0000-' || LPAD(id::text, 4, '0'),
--   email = 'test' || id || '@example.com';
--
-- UPDATE union_schema.downloads SET
--   name = '다운로드테스트' || id,
--   phone = '010-0000-' || LPAD(id::text, 4, '0'),
--   email = 'dl' || id || '@example.com';
--
-- UPDATE dataware_schema.inquiries SET
--   name = '테스트' || id,
--   phone = '010-0000-' || LPAD(id::text, 4, '0'),
--   email = 'test' || id || '@example.com';
--
-- UPDATE dataware_schema.downloads SET
--   name = '다운로드테스트' || id,
--   phone = '010-0000-' || LPAD(id::text, 4, '0'),
--   email = 'dl' || id || '@example.com';
--
-- UPDATE dataware_schema.educations SET
--   name = '교육테스트' || id,
--   phone = '010-0000-' || LPAD(id::text, 4, '0'),
--   email = 'edu' || id || '@example.com';
--
-- UPDATE dataware_schema.seminars SET
--   name = '세미나테스트' || id,
--   phone = '010-0000-' || LPAD(id::text, 4, '0'),
--   email = 'sem' || id || '@example.com';
--
-- COMMIT;
