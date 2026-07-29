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

-- UNION — 파트너
INSERT INTO union_schema.partners (name, role, logo_url, sort_order) VALUES
('Microsoft', 'CSP 공인 파트너', 'https://img.icons8.com/color/96/microsoft.png', 1),
('Adobe',     '공식 리셀러',     'https://img.icons8.com/color/96/adobe.png', 2),
('Autodesk',  '공인 리셀러',     'https://img.icons8.com/color/96/autodesk.png', 3),
('엔코아',    'DA# 공인총판',    '/images/partners/encore.png', 4),
('AhnLab',    '공식 파트너',     '/images/partners/ahnlab.png', 5),
('ESTsecurity','기업보안 파트너', '/images/partners/estsecurity.png', 6);

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
