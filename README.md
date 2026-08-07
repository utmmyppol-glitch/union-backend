# Union Backend

유니온시스템즈 통합 백엔드 API 서버.

유니온시스템즈 홈페이지(`union-frontend`), 유니온데이터웨어 홈페이지(`dataware-frontend`), 백오피스 관리자(`backoffice`)에 API를 제공한다.

## 기술 스택

- **Java 17** / Spring Boot 3.2.5
- **PostgreSQL 17** (스키마 분리: `common`, `union_schema`, `dataware_schema`)
- **Gradle** (Kotlin DSL, 멀티 모듈)
- **Spring Security** + JWT 인증
- **Docker** / Docker Compose
- **GitLab CI/CD**

## 프로젝트 구조

```
union-backend/
├── core-common/          # 공통 설정 (Security, CORS, WebConfig)
├── module-union/         # 유니온시스템즈 홈페이지 API
├── module-dataware/      # 유니온데이터웨어 홈페이지 API
├── module-admin/         # 백오피스 관리자 API + 메인 부트 엔트리포인트
├── sql/                  # DB 스키마 및 시드 데이터
├── Dockerfile            # 멀티스테이지 빌드 (JDK 17 → JRE 17)
├── docker-compose.yml    # DB + App 컨테이너
└── .gitlab-ci.yml        # CI/CD 파이프라인
```

### 모듈 의존 관계

```
module-admin (부트 모듈)
├── module-union
│   └── core-common
└── module-dataware
    └── core-common
```

`module-admin`이 부트 엔트리포인트다. 빌드하면 union, dataware, core-common이 모두 포함된 하나의 JAR가 나온다.

## 데이터베이스 구조

PostgreSQL 하나의 DB(`union_integrated`)에 3개 스키마로 분리했다. 유니온과 데이터웨어가 동일한 구조의 테이블(게시글, 배너 등)을 각각 가지되, 사이트별 독립 데이터를 유지하기 위해 스키마를 나눴다. 관리자 인증은 사이트 공통이므로 `common` 스키마에 둔다.

### common 스키마

| 테이블 | 설명 | 주요 컬럼 |
|--------|------|-----------|
| `admins` | 관리자 계정 | username(UNIQUE), password, role(SUPER/ADMIN/EDITOR/VIEWER), site(UNION/DATAWARE) |

### union_schema

| 테이블 | 설명 | 비고 |
|--------|------|------|
| `posts` | 게시글 (뉴스, 인사이트, 이벤트) | slug UNIQUE, category: NOTICE/INSIGHT/EVENT |
| `customer_stories` | 고객 도입 사례 | slug UNIQUE |
| `banners` | 배너 | position: HERO/POPUP/PROMOTION |
| `client_logos` | 고객사 로고 | showOnHome으로 메인 노출 여부 제어 |
| `inquiries` | 문의 접수 | status: NEW/IN_PROGRESS/COMPLETED |
| `downloads` | 자료 다운로드 신청 | |
| `insights` | 뉴스 인사이트 (네이버 API 수집) | sourceUrl UNIQUE, status: PENDING/APPROVED/REJECTED |
| `menu` | 메뉴 구조 | parent_id 자기참조, depth로 계층 표현 |
| `content` | 페이지 콘텐츠 | (menu_id, region_key) UNIQUE |
| `content_history` | 콘텐츠 수정 이력 | content_id FK |
| `site_config` | 사이트 설정 (key-value) | config_key UNIQUE |
| `page_layout` | 페이지 레이아웃 (JSON) | page_key UNIQUE |
| `history` | 회사 연혁 | events: JSON 배열 |
| `glossary` | IT 용어집 | |

### dataware_schema

union_schema와 공통 테이블(posts, customer_stories, banners, client_logos, inquiries, downloads, menu, content, content_history, site_config, page_layout) 구조가 동일하고, 아래 테이블이 추가로 있다:

| 테이블 | 설명 | 비고 |
|--------|------|------|
| `products` | 제품 정보 (DA#, META# 등) | slug UNIQUE, category: DATAWARE/DA_SHARP/META_SHARP/... |
| `educations` | 교육 신청 | status: NEW/CONFIRMED/COMPLETED/CANCELLED |
| `seminars` | 세미나 신청 | attendees, topic 등 |
| `education_sessions` | 교육 일정 (공개용) | |
| `pricing_plans` | 요금제 정보 | features: JSON 배열 |
| `download_resources` | 다운로드 가능 자료 목록 | |

dataware의 inquiries, downloads 테이블에는 `consent_third_party` 컬럼이 추가되어 있다 (제3자 제공 동의).

## 로컬 개발 환경

### 1. 환경변수 설정

```bash
cp .env.example .env
# .env 파일을 열고 값을 수정
```

### 2. 실행

```bash
docker compose up --build -d
```

DB 헬스체크 통과 후 앱이 자동 기동된다.

- DB: `localhost:5433` / `union_integrated` / `postgres:postgres`
- 앱: `http://localhost:8080`

### 3. 빌드 (JAR만)

```bash
./gradlew :module-admin:bootJar
# 결과: module-admin/build/libs/*.jar
```

## 환경변수

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `SPRING_PROFILES_ACTIVE` | 프로파일 (`dev` / `prod`) | `prod` |
| `DB_URL` | PostgreSQL JDBC URL | `jdbc:postgresql://localhost:5433/union_integrated` |
| `DB_USERNAME` | DB 사용자 | `postgres` |
| `DB_PASSWORD` | DB 비밀번호 | `postgres` |
| `SERVER_PORT` | 서버 포트 | `8080` |
| `JWT_SECRET` | JWT 서명 키 (prod에서 반드시 변경) | 개발용 기본값 있음 |
| `JWT_EXPIRATION_MS` | JWT 만료 시간 (ms) | `7200000` (2시간) |
| `CORS_ALLOWED_ORIGINS` | CORS 허용 도메인 (쉼표 구분) | `http://localhost:3000,3001,3002` |
| `NAVER_APIGW_KEY_ID` | 네이버 API Gateway 키 ID (인사이트 수집) | - |
| `NAVER_APIGW_KEY` | 네이버 API Gateway 키 | - |
| `UPLOAD_DIR` | 파일 업로드 경로 | dev: `./uploads`, prod: `/var/data/union-uploads` |

## 프로파일 차이

| 항목 | dev | prod |
|------|-----|------|
| SQL 로그 | 출력 | 미출력 |
| 로그 레벨 | DEBUG | INFO (Spring: WARN) |
| 업로드 경로 | `./uploads` | `/var/data/union-uploads` |
| DB 커넥션 풀 | 기본값 | max 20, min idle 5 |
| CORS | localhost:3000~3002 고정 | 환경변수로 지정 |

## 인증/권한

JWT 기반 인증. 관리자 역할(role)에 따라 접근 범위가 다르다:

| 역할 | 범위 |
|------|------|
| `SUPER` | 양쪽 사이트 전체 접근 |
| `ADMIN` | 자기 사이트 전체 접근 |
| `EDITOR` | 자기 사이트 전체 접근 |
| `VIEWER` | dataware 다운로드 이력 조회만 가능 |

공개 API(문의 접수, 게시글 조회 등)는 인증 없이 접근 가능.

## API 개요

### 공개 엔드포인트 (인증 불필요)

**유니온 (GET)**
- `/api/union/posts`, `/api/union/posts/{id}`, `/api/union/posts/slug/{slug}`
- `/api/union/customer-stories`, `/api/union/customer-stories/{id}`, `/api/union/customer-stories/slug/{slug}`
- `/api/union/banners`, `/api/union/client-logos`, `/api/union/insights`
- `/api/union/history`, `/api/union/glossary`

**데이터웨어 (GET)**
- `/api/dataware/posts`, `/api/dataware/posts/{id}`, `/api/dataware/posts/slug/{slug}`
- `/api/dataware/customer-stories`, `/api/dataware/customer-stories/{id}`, `/api/dataware/customer-stories/slug/{slug}`
- `/api/dataware/banners`, `/api/dataware/client-logos`, `/api/dataware/products`, `/api/dataware/products/{slug}`
- `/api/dataware/pricing-plans`, `/api/dataware/education-sessions`, `/api/dataware/download-resources`

**공통 (GET)**
- `/api/{site}/config` — 사이트 설정
- `/api/{site}/menu` — 메뉴 구조
- `/api/{site}/content` — 페이지 콘텐츠
- `/api/{site}/page-layout/{pageKey}` — 페이지 레이아웃

**폼 접수 (POST)**
- `/api/union/inquiries` — 유니온 문의
- `/api/union/downloads` — 유니온 다운로드 신청
- `/api/dataware/inquiries` — 데이터웨어 문의
- `/api/dataware/downloads` — 데이터웨어 다운로드 신청
- `/api/dataware/educations` — 교육 신청
- `/api/dataware/seminars` — 세미나 신청

### 관리자 엔드포인트 (JWT 필요)

- `POST /api/admin/login` — 로그인 (이것만 공개)
- `/api/admin/{site}/posts/**` — 게시글 CRUD
- `/api/admin/{site}/banners/**` — 배너 CRUD
- `/api/admin/{site}/customer-stories/**` — 고객사례 CRUD
- `/api/admin/{site}/client-logos/**` — 로고 CRUD
- `/api/admin/{site}/products/**` — 제품 CRUD (dataware)
- `/api/admin/{site}/inquiries/**` — 문의 조회/답변
- `/api/admin/{site}/contents/**` — 콘텐츠 편집 + 이력
- `/api/admin/{site}/menus/**` — 메뉴 CRUD
- `/api/admin/{site}/site-config/**` — 사이트 설정
- `/api/admin/{site}/page-layout/{pageKey}` — 레이아웃 편집
- `/api/admin/{site}/upload` — 파일 업로드
- `/api/admin/{site}/downloads` — 다운로드 이력 조회
- `/api/admin/{site}/educations` — 교육 신청 이력 (dataware)
- `/api/admin/{site}/seminars` — 세미나 신청 이력 (dataware)
- `/api/admin/union/insights/**` — 인사이트 관리 (조회/승인/거부/수집)

> `{site}`는 `union` 또는 `dataware`

## CI/CD

GitLab CI 파이프라인 (`.gitlab-ci.yml`):

| 스테이지 | 트리거 | 내용 |
|----------|--------|------|
| build | 모든 브랜치 | `./gradlew :module-admin:bootJar` |
| test | 모든 브랜치 | `./gradlew test` (JUnit 결과 리포트) |
| docker | main, tags | Docker 이미지 빌드 → GitLab Registry 푸시 |
| deploy | main (수동) | 배포 트리거 |

## 연관 프로젝트

| 프로젝트 | 포트 | 저장소 |
|----------|------|--------|
| union-frontend | 3000 | `unionsystems/union-frontend` |
| dataware-frontend | 3001 | `unionsystems/dataware-frontend` |
| backoffice | 3002 | `unionsystems/backoffice` |
