-- V27: 유니온 회사소개(조직도) 기본 콘텐츠 seed
--  - content 테이블에 해당 region_key 가 없을 때만 INSERT
--  - 이미 편집·저장돼 있으면 건드리지 않음(덮어쓰기 X), 재실행 안전(idempotent)
--  - 적용: (로컬) docker cp + psql -f  /  (운영) DBeaver 에서 실행
SET client_encoding TO 'UTF8';
SET standard_conforming_strings TO on;

-- CEO / 기술자문 / 섹션 제목·설명
INSERT INTO union_schema.content (menu_id, region_key, title, body_html)
SELECT NULL, 'company_org', 'company_org',
  '{"img":"/images/crawl/unionsystems/about_organization_chart_30.jpg","title":"소수정예 전문가 조직","text":"각 분야의 전문가들이 고객의 IT 환경을 책임집니다.","ceo":"CEO","advisor":"기술자문"}'
WHERE NOT EXISTS (
  SELECT 1 FROM union_schema.content WHERE region_key = 'company_org' AND menu_id IS NULL
);

-- 부서(가로) + 팀목록(members, 줄바꿈=\n) + 카드 설명(desc)
INSERT INTO union_schema.content (menu_id, region_key, title, body_html)
SELECT NULL, 'company_depts', 'company_depts',
  '[{"name":"경영관리부","desc":"경영지원과 운영으로 조직을 뒷받침합니다.","members":"경리 팀\n회계 팀"},{"name":"솔루션사업부","desc":"DATA·SW·SI 사업을 수행합니다.","members":"DATA 사업 팀\nSW 사업 팀\nSI 사업 팀"},{"name":"영업부","desc":"공공·기업·교육 시장을 아우르는 영업을 수행합니다.","members":"공공영업 팀\n기업영업 팀\n교육영업 팀"},{"name":"서비스사업부","desc":"설치부터 유지보수까지 안정 운영을 책임집니다.","members":"기술지원 팀"},{"name":"사업지원부","desc":"리뉴얼·마케팅·영업지원을 담당합니다.","members":"리뉴얼 팀\n마케팅 팀\n영업지원 팀"}]'
WHERE NOT EXISTS (
  SELECT 1 FROM union_schema.content WHERE region_key = 'company_depts' AND menu_id IS NULL
);

-- 확인용
-- SELECT region_key, body_html FROM union_schema.content WHERE region_key IN ('company_org','company_depts');
