# 데이터 이관 분석·매핑·스크립트 초안·검증 계획

> **작성일**: 2026-08-03  
> **상태**: 분석·설계 완료 — 실행 전 사람 검토 필요  
> **실행 금지**: 이 문서의 스크립트는 검토·승인 후 별도 진행

---

## 1. 소스 파악 — 이관 대상 데이터 총 목록

### 1.1 소스 위치 요약

| # | 소스 파일 | 내용 | 비고 |
|---|----------|------|------|
| 1 | `sql/V2__seed_data.sql` | 관리자, 배너, 게시글, 문의, 고객사례, 고객로고, 다운로드, 교육, 세미나 | 목업 데이터 (14KB) |
| 2 | `sql/V4__seed_encore_account.sql` | dataware viewer 계정 1건 | 파트너 계정 |
| 3 | `sql/V6__seed_site_config.sql` | 사이트 설정 (회사정보, 연락처, SNS) | idempotent (ON CONFLICT) |
| 4 | `sql/V7__seed_menu.sql` | 메뉴 트리 (union 28개 + dataware 16개) | ID 고정, setval 사용 |
| 5 | `sql/V8__seed_content.sql` | CMS 콘텐츠 (union 6페이지 + dataware 6페이지) | body_html |
| 6 | `sql/V10__seed_structured_data.sql` | 연혁, 파트너, 용어사전, 가격플랜, 교육세션, 다운로드자료 | 구조화 리스트 |
| 7 | `uploads/` (루트) | UUID 이미지 3개 (533KB) | 업로드 콘텐츠 |
| 8 | `module-admin/uploads/` | UUID 이미지 4개 (608KB) | 관리자 업로드 |
| 9 | `scripts/column_comments.sql` | DB 컬럼 코멘트 200+건 | 메타데이터 |

### 1.2 조사 결과: 존재하지 않는 소스

- 구 DB 덤프 (.dump, .backup): **없음**
- crawl/스크래핑 폴더 (/images/crawl): **없음**
- mol-extract/handoff: **없음**
- CSV/JSON 데이터 파일: **없음**
- 외부 시스템 연동: **없음**

> **결론**: 모든 이관 대상 데이터는 Flyway 시드 SQL + 업로드 이미지에 집중.
> 실운영 데이터가 축적된 별도 DB가 있다면 별도 조사 필요.

### 1.3 사이트별 이관 대상 상세

#### UNION (union_schema)

| 데이터 유형 | 건수 | 소스 파일 | 개인정보 포함 |
|------------|------|----------|-------------|
| 관리자 계정 | 4건 (공통 common.admins) | V2 | O (bcrypt 비밀번호) |
| 배너 | 4건 | V2 | X |
| 게시글 (NOTICE/INSIGHT/EVENT) | 4건 | V2 | X |
| 문의 | 3건 | V2 | **O** (이름, 전화, 이메일) |
| 고객 사례 | 2건 | V2 | X |
| 고객사 로고 | 5건 | V2 | X |
| 다운로드 신청 | 2건 | V2 | **O** (이름, 전화, 이메일) |
| 사이트 설정 | 12건 | V6 | X |
| 메뉴 트리 | 28건 | V7 | X |
| CMS 콘텐츠 | 6건 | V8 | X |
| 연혁 | 16건 | V10 | X |
| 파트너 | 6건 | V10 | X |
| 용어사전 | 10건 | V10 | X |

#### DATAWARE (dataware_schema)

| 데이터 유형 | 건수 | 소스 파일 | 개인정보 포함 |
|------------|------|----------|-------------|
| 배너 | 3건 | V2 | X |
| 제품 | 7건 | V2 | X |
| 게시글 (NOTICE/EVENT/VIDEO/DOCUMENTATION) | 4건 | V2 | X |
| 문의 | 3건 | V2 | **O** (이름, 전화, 이메일) |
| 고객 사례 | 2건 | V2 | X |
| 고객사 로고 | 5건 | V2 | X |
| 다운로드 신청 | 2건 | V2 | **O** (이름, 전화, 이메일) |
| 교육 신청 | 2건 | V2 | **O** (이름, 전화, 이메일) |
| 세미나 신청 | 2건 | V2 | **O** (이름, 전화, 이메일) |
| 사이트 설정 | 15건 | V6 | X |
| 메뉴 트리 | 16건 | V7 | X |
| CMS 콘텐츠 | 6건 | V8 | X |
| 가격 플랜 | 3건 | V10 | X |
| 교육 세션 | 7건 | V10 | X |
| 다운로드 자료 | 6건 | V10 | X |

---

## 2. 타깃 스키마 — 현재 DB 구조

### 2.1 스키마 개요

```
union_integrated (PostgreSQL)
├── common
│   └── admins
├── union_schema
│   ├── banners
│   ├── posts
│   ├── inquiries
│   ├── customer_stories
│   ├── client_logos
│   ├── downloads
│   ├── menu
│   ├── content
│   ├── content_history
│   ├── site_config
│   ├── history
│   ├── partners
│   ├── glossary
│   └── page_layout
└── dataware_schema
    ├── banners
    ├── products
    ├── posts
    ├── inquiries
    ├── customer_stories
    ├── client_logos
    ├── downloads
    ├── educations
    ├── seminars
    ├── menu
    ├── content
    ├── content_history
    ├── site_config
    ├── pricing_plans
    ├── education_sessions
    ├── download_resources
    └── page_layout
```

### 2.2 테이블별 컬럼 정의

> Flyway 마이그레이션 V1, V3, V5, V9, V11, V12 기준.
> 아래는 이관에 필요한 핵심 테이블만 기술. 전체 DDL은 `sql/V1__init_schema.sql` ~ `V12` 참조.

#### common.admins

| 컬럼 | 타입 | 제약 | 비고 |
|------|------|------|------|
| id | BIGSERIAL | PK | |
| username | VARCHAR(255) | NOT NULL, UNIQUE | |
| password | VARCHAR(255) | NOT NULL | bcrypt |
| role | VARCHAR(255) | NOT NULL, DEFAULT 'VIEWER' | SUPER/EDITOR/VIEWER |
| site | VARCHAR(255) | nullable | NULL=전체, UNION, DATAWARE |
| created_at | TIMESTAMP | DEFAULT NOW() | |

#### union_schema.posts / dataware_schema.posts

| 컬럼 | 타입 | 제약 | 비고 |
|------|------|------|------|
| id | BIGSERIAL | PK | |
| title | VARCHAR(255) | NOT NULL | |
| content | TEXT | nullable | |
| excerpt | VARCHAR(255) | nullable | |
| category | VARCHAR(255) | NOT NULL | union: NOTICE/INSIGHT/EVENT, dataware: NOTICE/EVENT/VIDEO/DOCUMENTATION |
| thumbnail_url | VARCHAR(255) | nullable | |
| published | BOOLEAN | DEFAULT FALSE | |
| view_count | INTEGER | DEFAULT 0 | |
| created_at | TIMESTAMP | DEFAULT NOW() | |
| updated_at | TIMESTAMP | DEFAULT NOW() | |

#### dataware_schema.products

| 컬럼 | 타입 | 제약 | 비고 |
|------|------|------|------|
| id | BIGSERIAL | PK | |
| name | VARCHAR(255) | NOT NULL | |
| slug | VARCHAR(255) | NOT NULL, UNIQUE | URL 슬러그 |
| category | VARCHAR(255) | NOT NULL | DATAWARE/DA_SHARP/META_SHARP/DQ_SHARP/AP_SHARP/DF_SHARP/ETT_SHARP/DP_SHARP |
| subtitle | TEXT | nullable | |
| description | TEXT | nullable | |
| features | TEXT | nullable | |
| icon_url | VARCHAR(255) | nullable | |
| thumbnail_url | VARCHAR(255) | nullable | |
| certification | VARCHAR(255) | nullable | |
| sort_order | INTEGER | nullable | |
| published | BOOLEAN | DEFAULT TRUE | |
| created_at | TIMESTAMP | DEFAULT NOW() | |
| updated_at | TIMESTAMP | DEFAULT NOW() | |

#### *_schema.inquiries

| 컬럼 | 타입 | 제약 | 비고 |
|------|------|------|------|
| id | BIGSERIAL | PK | |
| name | VARCHAR(255) | NOT NULL | **개인정보** |
| company | VARCHAR(255) | NOT NULL | |
| phone | VARCHAR(255) | NOT NULL | **개인정보** |
| email | VARCHAR(255) | NOT NULL | **개인정보** |
| message | TEXT | nullable | |
| product | VARCHAR(255) | nullable | |
| status | VARCHAR(255) | NOT NULL, DEFAULT 'NEW' | NEW/IN_PROGRESS/COMPLETED |
| assignee | VARCHAR(255) | nullable | |
| consent_privacy | BOOLEAN | nullable | |
| consent_third_party | BOOLEAN | nullable | dataware만 |
| created_at | TIMESTAMP | DEFAULT NOW() | |
| updated_at | TIMESTAMP | DEFAULT NOW() | |

> 나머지 테이블(banners, customer_stories, client_logos, downloads, menu, content,
> site_config, history, partners, glossary, pricing_plans, education_sessions,
> download_resources, educations, seminars, page_layout)의 상세 DDL은
> `sql/V1__init_schema.sql`, `V3`, `V5`, `V9`, `V11`, `V12` 참조.

---

## 3. 소스 → 타깃 매핑표

### 3.1 시드 SQL → 테이블 1:1 매핑

현재 시드 데이터는 이미 타깃 스키마에 직접 INSERT하는 형태로 작성되어 있어
**소스 필드 = 타깃 컬럼** (1:1 매핑, 변환 불필요).

| 소스 (시드 SQL) | 타깃 테이블 | 매핑 방식 | 변환 필요 |
|----------------|-----------|----------|---------|
| V2: common.admins INSERT | common.admins | 직접 | X — 단, 비밀번호 해시 재생성 권장 |
| V2: union_schema.banners INSERT | union_schema.banners | 직접 | X |
| V2: union_schema.posts INSERT | union_schema.posts | 직접 | X |
| V2: union_schema.inquiries INSERT | union_schema.inquiries | 직접 | **주의**: 개인정보 |
| V2: union_schema.customer_stories | union_schema.customer_stories | 직접 | X |
| V2: union_schema.client_logos | union_schema.client_logos | 직접 | X |
| V2: union_schema.downloads | union_schema.downloads | 직접 | **주의**: 개인정보 |
| V2: dataware_schema.banners | dataware_schema.banners | 직접 | X |
| V2: dataware_schema.products | dataware_schema.products | 직접 | X |
| V2: dataware_schema.posts | dataware_schema.posts | 직접 | X |
| V2: dataware_schema.inquiries | dataware_schema.inquiries | 직접 | **주의**: 개인정보 |
| V2: dataware_schema.customer_stories | dataware_schema.customer_stories | 직접 | X |
| V2: dataware_schema.client_logos | dataware_schema.client_logos | 직접 | X |
| V2: dataware_schema.downloads | dataware_schema.downloads | 직접 | **주의**: 개인정보 |
| V2: dataware_schema.educations | dataware_schema.educations | 직접 | **주의**: 개인정보 |
| V2: dataware_schema.seminars | dataware_schema.seminars | 직접 | **주의**: 개인정보 |
| V6: site_config (양쪽) | *_schema.site_config | 직접 | X |
| V7: menu (양쪽) | *_schema.menu | 직접 | X — ID 고정, setval 필요 |
| V8: content (양쪽) | *_schema.content | 직접 | X |
| V10: history | union_schema.history | 직접 | X |
| V10: partners | union_schema.partners | 직접 | X |
| V10: glossary | union_schema.glossary | 직접 | X |
| V10: pricing_plans | dataware_schema.pricing_plans | 직접 | X |
| V10: education_sessions | dataware_schema.education_sessions | 직접 | X |
| V10: download_resources | dataware_schema.download_resources | 직접 | X |

### 3.2 이미지 파일 매핑

| 소스 | 타깃 | 비고 |
|------|------|------|
| `uploads/*.png` (3개) | 운영 서버 `uploads/` | UUID 파일명 유지 |
| `module-admin/uploads/*.png` (4개) | 운영 서버 `uploads/` | 경로 통일 필요 여부 확인 |
| 시드 SQL 내 `/images/union/*`, `/images/dw/*` 참조 | 프론트 정적 파일 | 프론트 배포 시 포함 |

### 3.3 실운영 데이터 (향후 추가 확인 필요)

현재 파악된 소스는 모두 **개발/테스트용 시드 데이터**.
실제 운영 DB에 축적된 데이터가 있다면:

- 운영 DB 접속 → `SELECT count(*) FROM <table>` 로 실 데이터량 확인
- 운영 데이터가 시드와 다르면 별도 `pg_dump` → 변환 스크립트 필요
- **이 문서의 스크립트는 시드 데이터 기준이므로, 운영 데이터 이관 시 반드시 재검토**

---

## 4. 이관 스크립트 초안

> **경고: 아래 스크립트는 파일로만 보관, 절대 실행하지 말 것.**
> **검토·승인 후 별도 수동 실행.**

### 4.1 스크립트 설계 원칙

1. **Idempotent**: `INSERT ... ON CONFLICT DO NOTHING` 사용, 재실행 안전
2. **트랜잭션**: 전체를 하나의 트랜잭션으로 감싸 실패 시 자동 롤백
3. **시퀀스 동기화**: INSERT 후 `setval` 로 시퀀스를 max(id) 이상으로 재설정
4. **개인정보 분리**: 문의/다운로드/교육/세미나 데이터는 별도 단계로 분리
5. **백업 선행**: 이관 전 반드시 `pg_dump` 실행

### 4.2 스크립트 파일 위치

```
docs/
├── data-migration-plan.md        (이 문서)
└── migration-scripts/
    ├── 00_backup.sh              (백업 스크립트)
    ├── 01_migrate_structure.sql  (구조 데이터: 배너, 제품, 메뉴, 콘텐츠 등)
    ├── 02_migrate_content.sql    (게시글, 고객사례, 연혁, 용어사전 등)
    ├── 03_migrate_pii.sql        (개인정보: 문의, 다운로드, 교육, 세미나)
    ├── 04_sync_sequences.sql     (시퀀스 동기화)
    └── 05_verify.sql             (검증 쿼리)
```

---

## 5. 백업·검증·롤백 절차

### 5.1 백업 절차 (이관 실행 전 필수)

```bash
# 1. 전체 DB 덤프 (plain SQL)
pg_dump -h localhost -p 5433 -U postgres -d union_integrated \
  --format=plain --file=backup_pre_migration_$(date +%Y%m%d_%H%M%S).sql

# 2. 스키마별 덤프 (데이터 포함)
pg_dump -h localhost -p 5433 -U postgres -d union_integrated \
  --schema=union_schema --format=custom \
  --file=backup_union_schema_$(date +%Y%m%d_%H%M%S).dump

pg_dump -h localhost -p 5433 -U postgres -d union_integrated \
  --schema=dataware_schema --format=custom \
  --file=backup_dataware_schema_$(date +%Y%m%d_%H%M%S).dump

pg_dump -h localhost -p 5433 -U postgres -d union_integrated \
  --schema=common --format=custom \
  --file=backup_common_$(date +%Y%m%d_%H%M%S).dump

# 3. 이미지 파일 백업
cp -r uploads/ backup_uploads_$(date +%Y%m%d_%H%M%S)/
cp -r module-admin/uploads/ backup_admin_uploads_$(date +%Y%m%d_%H%M%S)/
```

### 5.2 검증 계획

#### A. 행수 검증 (이관 전후 비교)

```sql
-- 이관 전에 실행하여 기준값 기록
SELECT 'common.admins' AS tbl, count(*) FROM common.admins
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
UNION ALL SELECT 'union.partners', count(*) FROM union_schema.partners
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
```

#### B. 스팟체크 (샘플 데이터 검증)

```sql
-- 제품 slug 유니크 확인
SELECT slug, count(*) FROM dataware_schema.products GROUP BY slug HAVING count(*) > 1;

-- 메뉴 트리 무결성: parent_id가 존재하는 id를 가리키는지
SELECT m.id, m.name, m.parent_id
FROM union_schema.menu m
LEFT JOIN union_schema.menu p ON m.parent_id = p.id
WHERE m.parent_id IS NOT NULL AND p.id IS NULL;

-- 고객사례 published 상태 확인
SELECT company, published FROM union_schema.customer_stories;
SELECT company, published FROM dataware_schema.customer_stories;

-- 문의 상태 분포
SELECT status, count(*) FROM union_schema.inquiries GROUP BY status;
SELECT status, count(*) FROM dataware_schema.inquiries GROUP BY status;
```

#### C. 이미지 참조 무결성

```sql
-- 배너 이미지 URL이 비어있지 않은지
SELECT id, title, image_url FROM union_schema.banners WHERE image_url IS NULL OR image_url = '';
SELECT id, title, image_url FROM dataware_schema.banners WHERE image_url IS NULL OR image_url = '';

-- 제품 아이콘/썸네일 참조
SELECT id, name, icon_url, thumbnail_url FROM dataware_schema.products
WHERE icon_url IS NULL OR thumbnail_url IS NULL;
```

### 5.3 롤백 절차

```bash
# 방법 1: 전체 DB 복원 (가장 안전)
dropdb -h localhost -p 5433 -U postgres union_integrated
createdb -h localhost -p 5433 -U postgres union_integrated
psql -h localhost -p 5433 -U postgres -d union_integrated \
  < backup_pre_migration_YYYYMMDD_HHMMSS.sql

# 방법 2: 스키마 단위 복원 (부분 롤백)
# 해당 스키마의 모든 테이블 TRUNCATE 후 복원
psql -h localhost -p 5433 -U postgres -d union_integrated \
  -c "DROP SCHEMA union_schema CASCADE;"
pg_restore -h localhost -p 5433 -U postgres -d union_integrated \
  backup_union_schema_YYYYMMDD_HHMMSS.dump

# 방법 3: 트랜잭션 미커밋
# 스크립트가 BEGIN/COMMIT으로 감싸져 있으므로,
# 에러 발생 시 자동 ROLLBACK됨 (수동 개입 불필요)
```

---

## 6. 개인정보 이관 주의사항

### 6.1 개인정보 포함 테이블

| 테이블 | 개인정보 필드 | 건수 | 법적 근거 |
|--------|-------------|------|----------|
| union_schema.inquiries | name, phone, email | 3건 | 개인정보보호법 제15조 (동의) |
| union_schema.downloads | name, phone, email | 2건 | 동의 기반 |
| dataware_schema.inquiries | name, phone, email | 3건 | 동의 기반 |
| dataware_schema.downloads | name, phone, email | 2건 | 동의 기반 |
| dataware_schema.educations | name, phone, email | 2건 | 동의 기반 |
| dataware_schema.seminars | name, phone, email | 2건 | 동의 기반 |

### 6.2 이관 시 준수 사항

1. **동의 범위 확인**: 기존 consent_privacy, consent_third_party 값이 true인 건만 이관
2. **최소 수집**: 이관 목적에 불필요한 개인정보 필드는 마스킹 고려
3. **접근 통제**: 이관 스크립트 실행은 DB 관리자만 가능하게 제한
4. **로그 기록**: 이관 수행 일시, 수행자, 건수를 기록
5. **보관 기한**: 문의 데이터의 보관 기한 정책 확인 후 기한 초과 건은 이관 제외 또는 비식별화
6. **개발 환경 분리**: 개발/테스트 DB에는 실 개인정보 대신 마스킹 데이터 사용

### 6.3 마스킹 예시 (개발 환경용)

```sql
-- 이관 후 개발 환경에서 실행
UPDATE union_schema.inquiries SET
  name = '테스트' || id,
  phone = '010-0000-' || LPAD(id::text, 4, '0'),
  email = 'test' || id || '@example.com';
```

---

## 7. 현황 요약 및 다음 단계

### 7.1 현황

| 항목 | 상태 |
|------|------|
| 소스 데이터 파악 | 완료 — Flyway 시드 SQL 6개 + 이미지 7개 |
| 타깃 스키마 파악 | 완료 — 3 스키마, 22 테이블 |
| 소스→타깃 매핑 | 완료 — 1:1 직접 매핑 (변환 불필요) |
| 스크립트 초안 | 별도 파일로 작성 예정 (아래 참조) |
| 검증 쿼리 | 완료 — 행수/스팟체크/이미지 참조 |
| 백업·롤백 절차 | 완료 |
| 개인정보 주의사항 | 완료 |

### 7.2 다음 단계 (사람이 수행)

1. **운영 DB 현황 확인**: 실제 운영 DB에 시드 외 축적 데이터가 있는지 확인
2. **개인정보 보관 기한 정책 확인**: 법무/준법팀과 협의
3. **이관 스크립트 검토**: 이 문서의 스크립트 초안을 검토·승인
4. **테스트 환경 실행**: 개발 DB에서 먼저 이관 스크립트 실행·검증
5. **운영 이관**: 유지보수 시간에 백업 → 이관 → 검증 → 서비스 재개
