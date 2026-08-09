-- ============================================================
-- 컬럼 코멘트 일괄 등록 SQL (PostgreSQL)
-- DBeaver에서 그대로 실행하세요
-- ============================================================

-- ============================================================
-- 1. common 스키마
-- ============================================================

-- admins: 관리자 계정
COMMENT ON TABLE common.admins IS '관리자 계정';
COMMENT ON COLUMN common.admins.id IS '관리자 ID (PK)';
COMMENT ON COLUMN common.admins.username IS '로그인 아이디';
COMMENT ON COLUMN common.admins.password IS '비밀번호 (암호화)';
COMMENT ON COLUMN common.admins.role IS '권한 등급 (SUPER/ADMIN/EDITOR/VIEWER)';
COMMENT ON COLUMN common.admins.site IS '담당 사이트 (UNION/DATAWARE)';
COMMENT ON COLUMN common.admins.created_at IS '계정 생성일';

-- ============================================================
-- 2. union_schema
-- ============================================================

-- menu: 사이트 메뉴 (GNB/LNB 트리 구조)
COMMENT ON TABLE union_schema.menu IS '사이트 메뉴 (GNB/LNB 트리 구조)';
COMMENT ON COLUMN union_schema.menu.id IS '메뉴 ID (PK)';
COMMENT ON COLUMN union_schema.menu.parent_id IS '상위 메뉴 ID (자기참조 FK → menu.id, NULL=최상위)';
COMMENT ON COLUMN union_schema.menu.name IS '메뉴명';
COMMENT ON COLUMN union_schema.menu.url IS '연결 URL';
COMMENT ON COLUMN union_schema.menu.menu_type IS '메뉴 유형 (CONTENT/BOARD/LINK)';
COMMENT ON COLUMN union_schema.menu.sort_order IS '정렬 순서';
COMMENT ON COLUMN union_schema.menu.depth IS '메뉴 깊이 (0=최상위)';
COMMENT ON COLUMN union_schema.menu.is_exposed IS '메뉴 노출 여부';
COMMENT ON COLUMN union_schema.menu.created_at IS '생성일';
COMMENT ON COLUMN union_schema.menu.updated_at IS '수정일';

-- content: 메뉴별 페이지 콘텐츠 (HTML)
COMMENT ON TABLE union_schema.content IS '메뉴별 페이지 콘텐츠 (HTML)';
COMMENT ON COLUMN union_schema.content.id IS '콘텐츠 ID (PK)';
COMMENT ON COLUMN union_schema.content.menu_id IS '소속 메뉴 ID (FK → menu.id)';
COMMENT ON COLUMN union_schema.content.region_key IS '페이지 내 영역 키 (header, main 등)';
COMMENT ON COLUMN union_schema.content.title IS '콘텐츠 제목';
COMMENT ON COLUMN union_schema.content.body_html IS 'HTML 본문';
COMMENT ON COLUMN union_schema.content.updated_by IS '마지막 수정자 (FK → admins.id)';
COMMENT ON COLUMN union_schema.content.updated_at IS '수정일';

-- content_history: 콘텐츠 수정 이력
COMMENT ON TABLE union_schema.content_history IS '콘텐츠 수정 이력 (스냅샷)';
COMMENT ON COLUMN union_schema.content_history.id IS '이력 ID (PK)';
COMMENT ON COLUMN union_schema.content_history.content_id IS '원본 콘텐츠 ID (FK → content.id)';
COMMENT ON COLUMN union_schema.content_history.body_html IS '수정 당시 HTML 스냅샷';
COMMENT ON COLUMN union_schema.content_history.edited_by IS '수정자 (FK → admins.id)';
COMMENT ON COLUMN union_schema.content_history.edited_at IS '수정 시각';

-- posts: 게시글 (공지/인사이트/이벤트)
COMMENT ON TABLE union_schema.posts IS '게시글 (공지/인사이트/이벤트)';
COMMENT ON COLUMN union_schema.posts.id IS '게시글 ID (PK)';
COMMENT ON COLUMN union_schema.posts.title IS '게시글 제목';
COMMENT ON COLUMN union_schema.posts.content IS '게시글 본문 (HTML/TEXT)';
COMMENT ON COLUMN union_schema.posts.excerpt IS '요약문 (목록 미리보기용)';
COMMENT ON COLUMN union_schema.posts.category IS '카테고리 (NOTICE/INSIGHT/EVENT)';
COMMENT ON COLUMN union_schema.posts.thumbnail_url IS '썸네일 이미지 URL';
COMMENT ON COLUMN union_schema.posts.published IS '발행 여부 (true=공개)';
COMMENT ON COLUMN union_schema.posts.view_count IS '조회수';
COMMENT ON COLUMN union_schema.posts.created_at IS '작성일';
COMMENT ON COLUMN union_schema.posts.updated_at IS '수정일';

-- banners: 배너 관리
COMMENT ON TABLE union_schema.banners IS '배너 관리';
COMMENT ON COLUMN union_schema.banners.id IS '배너 ID (PK)';
COMMENT ON COLUMN union_schema.banners.title IS '배너명';
COMMENT ON COLUMN union_schema.banners.image_url IS '배너 이미지 URL';
COMMENT ON COLUMN union_schema.banners.link_url IS '클릭 시 이동 URL';
COMMENT ON COLUMN union_schema.banners.position IS '배너 위치 (HERO/POPUP/PROMOTION)';
COMMENT ON COLUMN union_schema.banners.is_active IS '활성 여부';
COMMENT ON COLUMN union_schema.banners.sort_order IS '정렬 순서';
COMMENT ON COLUMN union_schema.banners.created_at IS '생성일';

-- client_logos: 고객사 로고
COMMENT ON TABLE union_schema.client_logos IS '고객사 로고 (레퍼런스 섹션)';
COMMENT ON COLUMN union_schema.client_logos.id IS '로고 ID (PK)';
COMMENT ON COLUMN union_schema.client_logos.name IS '고객사명';
COMMENT ON COLUMN union_schema.client_logos.logo_url IS '로고 이미지 URL';
COMMENT ON COLUMN union_schema.client_logos.sort_order IS '정렬 순서';
COMMENT ON COLUMN union_schema.client_logos.is_active IS '활성 여부';
COMMENT ON COLUMN union_schema.client_logos.created_at IS '생성일';

-- customer_stories: 고객 사례
COMMENT ON TABLE union_schema.customer_stories IS '고객 도입 사례';
COMMENT ON COLUMN union_schema.customer_stories.id IS '사례 ID (PK)';
COMMENT ON COLUMN union_schema.customer_stories.company IS '고객사명';
COMMENT ON COLUMN union_schema.customer_stories.industry IS '업종';
COMMENT ON COLUMN union_schema.customer_stories.title IS '사례 제목';
COMMENT ON COLUMN union_schema.customer_stories.content IS '사례 본문';
COMMENT ON COLUMN union_schema.customer_stories.thumbnail_url IS '썸네일 이미지 URL';
COMMENT ON COLUMN union_schema.customer_stories.logo_url IS '고객사 로고 URL';
COMMENT ON COLUMN union_schema.customer_stories.published IS '발행 여부';
COMMENT ON COLUMN union_schema.customer_stories.created_at IS '작성일';
COMMENT ON COLUMN union_schema.customer_stories.updated_at IS '수정일';

-- downloads: 자료 다운로드 신청
COMMENT ON TABLE union_schema.downloads IS '자료 다운로드 신청';
COMMENT ON COLUMN union_schema.downloads.id IS '신청 ID (PK)';
COMMENT ON COLUMN union_schema.downloads.name IS '신청자명';
COMMENT ON COLUMN union_schema.downloads.company IS '회사명';
COMMENT ON COLUMN union_schema.downloads.phone IS '전화번호';
COMMENT ON COLUMN union_schema.downloads.email IS '이메일';
COMMENT ON COLUMN union_schema.downloads.file_type IS '다운로드 파일 유형';
COMMENT ON COLUMN union_schema.downloads.consent_privacy IS '개인정보 수집 동의';
COMMENT ON COLUMN union_schema.downloads.consent_marketing IS '마케팅 수신 동의';
COMMENT ON COLUMN union_schema.downloads.created_at IS '신청일';

-- inquiries: 문의 접수
COMMENT ON TABLE union_schema.inquiries IS '문의 접수';
COMMENT ON COLUMN union_schema.inquiries.id IS '문의 ID (PK)';
COMMENT ON COLUMN union_schema.inquiries.name IS '문의자명';
COMMENT ON COLUMN union_schema.inquiries.company IS '회사명';
COMMENT ON COLUMN union_schema.inquiries.phone IS '전화번호';
COMMENT ON COLUMN union_schema.inquiries.email IS '이메일';
COMMENT ON COLUMN union_schema.inquiries.message IS '문의 내용';
COMMENT ON COLUMN union_schema.inquiries.product IS '관심 제품';
COMMENT ON COLUMN union_schema.inquiries.status IS '처리 상태 (NEW/IN_PROGRESS/COMPLETED)';
COMMENT ON COLUMN union_schema.inquiries.assignee IS '담당자';
COMMENT ON COLUMN union_schema.inquiries.consent_privacy IS '개인정보 수집 동의';
COMMENT ON COLUMN union_schema.inquiries.created_at IS '접수일';
COMMENT ON COLUMN union_schema.inquiries.updated_at IS '수정일';

-- site_config: 사이트 설정 (key-value)
COMMENT ON TABLE union_schema.site_config IS '사이트 설정 (key-value 저장소)';
COMMENT ON COLUMN union_schema.site_config.id IS '설정 ID (PK)';
COMMENT ON COLUMN union_schema.site_config.config_key IS '설정 키 (UNIQUE)';
COMMENT ON COLUMN union_schema.site_config.config_value IS '설정 값';
COMMENT ON COLUMN union_schema.site_config.description IS '설정 설명';
COMMENT ON COLUMN union_schema.site_config.updated_at IS '수정일';

-- page_layout: 페이지 빌더 레이아웃 (Puck)
COMMENT ON TABLE union_schema.page_layout IS '페이지 빌더 레이아웃 (Puck JSON)';
COMMENT ON COLUMN union_schema.page_layout.id IS '레이아웃 ID (PK)';
COMMENT ON COLUMN union_schema.page_layout.page_key IS '페이지 식별 키 (UNIQUE)';
COMMENT ON COLUMN union_schema.page_layout.title IS '페이지 제목';
COMMENT ON COLUMN union_schema.page_layout.layout_json IS 'Puck 빌더 JSON 데이터';
COMMENT ON COLUMN union_schema.page_layout.status IS '상태 (DRAFT/PUBLISHED)';
COMMENT ON COLUMN union_schema.page_layout.updated_by IS '수정자 (FK → admins.id)';
COMMENT ON COLUMN union_schema.page_layout.updated_at IS '수정일';

-- glossary: 용어 사전
COMMENT ON TABLE union_schema.glossary IS '용어 사전 (데이터 관련 용어)';
COMMENT ON COLUMN union_schema.glossary.id IS '용어 ID (PK)';
COMMENT ON COLUMN union_schema.glossary.term IS '용어 (약어)';
COMMENT ON COLUMN union_schema.glossary.full_name IS '풀네임';
COMMENT ON COLUMN union_schema.glossary.definition IS '정의 (설명)';
COMMENT ON COLUMN union_schema.glossary.category IS '카테고리';
COMMENT ON COLUMN union_schema.glossary.sort_order IS '정렬 순서';
COMMENT ON COLUMN union_schema.glossary.is_active IS '활성 여부';

-- history: 회사 연혁
COMMENT ON TABLE union_schema.history IS '회사 연혁';
COMMENT ON COLUMN union_schema.history.id IS '연혁 ID (PK)';
COMMENT ON COLUMN union_schema.history.year IS '연도';
COMMENT ON COLUMN union_schema.history.title IS '연혁 제목';
COMMENT ON COLUMN union_schema.history.events IS '주요 이벤트 (JSON)';
COMMENT ON COLUMN union_schema.history.sort_order IS '정렬 순서';
COMMENT ON COLUMN union_schema.history.is_active IS '활성 여부';

-- ============================================================
-- 3. dataware_schema
-- ============================================================

-- menu: 사이트 메뉴 (GNB/LNB 트리 구조)
COMMENT ON TABLE dataware_schema.menu IS '사이트 메뉴 (GNB/LNB 트리 구조)';
COMMENT ON COLUMN dataware_schema.menu.id IS '메뉴 ID (PK)';
COMMENT ON COLUMN dataware_schema.menu.parent_id IS '상위 메뉴 ID (자기참조 FK → menu.id, NULL=최상위)';
COMMENT ON COLUMN dataware_schema.menu.name IS '메뉴명';
COMMENT ON COLUMN dataware_schema.menu.url IS '연결 URL';
COMMENT ON COLUMN dataware_schema.menu.menu_type IS '메뉴 유형 (CONTENT/BOARD/LINK)';
COMMENT ON COLUMN dataware_schema.menu.sort_order IS '정렬 순서';
COMMENT ON COLUMN dataware_schema.menu.depth IS '메뉴 깊이 (0=최상위)';
COMMENT ON COLUMN dataware_schema.menu.is_exposed IS '메뉴 노출 여부';
COMMENT ON COLUMN dataware_schema.menu.created_at IS '생성일';
COMMENT ON COLUMN dataware_schema.menu.updated_at IS '수정일';

-- content: 메뉴별 페이지 콘텐츠 (HTML)
COMMENT ON TABLE dataware_schema.content IS '메뉴별 페이지 콘텐츠 (HTML)';
COMMENT ON COLUMN dataware_schema.content.id IS '콘텐츠 ID (PK)';
COMMENT ON COLUMN dataware_schema.content.menu_id IS '소속 메뉴 ID (FK → menu.id)';
COMMENT ON COLUMN dataware_schema.content.region_key IS '페이지 내 영역 키 (header, main 등)';
COMMENT ON COLUMN dataware_schema.content.title IS '콘텐츠 제목';
COMMENT ON COLUMN dataware_schema.content.body_html IS 'HTML 본문';
COMMENT ON COLUMN dataware_schema.content.updated_by IS '마지막 수정자 (FK → admins.id)';
COMMENT ON COLUMN dataware_schema.content.updated_at IS '수정일';

-- content_history: 콘텐츠 수정 이력
COMMENT ON TABLE dataware_schema.content_history IS '콘텐츠 수정 이력 (스냅샷)';
COMMENT ON COLUMN dataware_schema.content_history.id IS '이력 ID (PK)';
COMMENT ON COLUMN dataware_schema.content_history.content_id IS '원본 콘텐츠 ID (FK → content.id)';
COMMENT ON COLUMN dataware_schema.content_history.body_html IS '수정 당시 HTML 스냅샷';
COMMENT ON COLUMN dataware_schema.content_history.edited_by IS '수정자 (FK → admins.id)';
COMMENT ON COLUMN dataware_schema.content_history.edited_at IS '수정 시각';

-- posts: 게시글 (공지/이벤트/영상/문서)
COMMENT ON TABLE dataware_schema.posts IS '게시글 (공지/이벤트/영상/문서)';
COMMENT ON COLUMN dataware_schema.posts.id IS '게시글 ID (PK)';
COMMENT ON COLUMN dataware_schema.posts.title IS '게시글 제목';
COMMENT ON COLUMN dataware_schema.posts.content IS '게시글 본문 (HTML/TEXT)';
COMMENT ON COLUMN dataware_schema.posts.excerpt IS '요약문 (목록 미리보기용)';
COMMENT ON COLUMN dataware_schema.posts.category IS '카테고리 (NOTICE/EVENT/VIDEO/DOCUMENTATION)';
COMMENT ON COLUMN dataware_schema.posts.thumbnail_url IS '썸네일 이미지 URL';
COMMENT ON COLUMN dataware_schema.posts.published IS '발행 여부 (true=공개)';
COMMENT ON COLUMN dataware_schema.posts.view_count IS '조회수';
COMMENT ON COLUMN dataware_schema.posts.created_at IS '작성일';
COMMENT ON COLUMN dataware_schema.posts.updated_at IS '수정일';

-- banners: 배너 관리
COMMENT ON TABLE dataware_schema.banners IS '배너 관리';
COMMENT ON COLUMN dataware_schema.banners.id IS '배너 ID (PK)';
COMMENT ON COLUMN dataware_schema.banners.title IS '배너명';
COMMENT ON COLUMN dataware_schema.banners.image_url IS '배너 이미지 URL';
COMMENT ON COLUMN dataware_schema.banners.link_url IS '클릭 시 이동 URL';
COMMENT ON COLUMN dataware_schema.banners.position IS '배너 위치 (HERO/POPUP/PROMOTION)';
COMMENT ON COLUMN dataware_schema.banners.is_active IS '활성 여부';
COMMENT ON COLUMN dataware_schema.banners.sort_order IS '정렬 순서';
COMMENT ON COLUMN dataware_schema.banners.created_at IS '생성일';

-- client_logos: 고객사 로고
COMMENT ON TABLE dataware_schema.client_logos IS '고객사 로고 (레퍼런스 섹션)';
COMMENT ON COLUMN dataware_schema.client_logos.id IS '로고 ID (PK)';
COMMENT ON COLUMN dataware_schema.client_logos.name IS '고객사명';
COMMENT ON COLUMN dataware_schema.client_logos.logo_url IS '로고 이미지 URL';
COMMENT ON COLUMN dataware_schema.client_logos.sort_order IS '정렬 순서';
COMMENT ON COLUMN dataware_schema.client_logos.is_active IS '활성 여부';
COMMENT ON COLUMN dataware_schema.client_logos.created_at IS '생성일';

-- customer_stories: 고객 도입 사례
COMMENT ON TABLE dataware_schema.customer_stories IS '고객 도입 사례';
COMMENT ON COLUMN dataware_schema.customer_stories.id IS '사례 ID (PK)';
COMMENT ON COLUMN dataware_schema.customer_stories.company IS '고객사명';
COMMENT ON COLUMN dataware_schema.customer_stories.industry IS '업종';
COMMENT ON COLUMN dataware_schema.customer_stories.title IS '사례 제목';
COMMENT ON COLUMN dataware_schema.customer_stories.content IS '사례 본문';
COMMENT ON COLUMN dataware_schema.customer_stories.thumbnail_url IS '썸네일 이미지 URL';
COMMENT ON COLUMN dataware_schema.customer_stories.logo_url IS '고객사 로고 URL';
COMMENT ON COLUMN dataware_schema.customer_stories.published IS '발행 여부';
COMMENT ON COLUMN dataware_schema.customer_stories.created_at IS '작성일';
COMMENT ON COLUMN dataware_schema.customer_stories.updated_at IS '수정일';

-- downloads: 자료 다운로드 신청
COMMENT ON TABLE dataware_schema.downloads IS '자료 다운로드 신청';
COMMENT ON COLUMN dataware_schema.downloads.id IS '신청 ID (PK)';
COMMENT ON COLUMN dataware_schema.downloads.name IS '신청자명';
COMMENT ON COLUMN dataware_schema.downloads.company IS '회사명';
COMMENT ON COLUMN dataware_schema.downloads.phone IS '전화번호';
COMMENT ON COLUMN dataware_schema.downloads.email IS '이메일';
COMMENT ON COLUMN dataware_schema.downloads.file_type IS '다운로드 파일 유형';
COMMENT ON COLUMN dataware_schema.downloads.consent_privacy IS '개인정보 수집 동의';
COMMENT ON COLUMN dataware_schema.downloads.consent_third_party IS '제3자 정보 제공 동의';
COMMENT ON COLUMN dataware_schema.downloads.consent_marketing IS '마케팅 수신 동의';
COMMENT ON COLUMN dataware_schema.downloads.created_at IS '신청일';

-- inquiries: 문의 접수
COMMENT ON TABLE dataware_schema.inquiries IS '문의 접수';
COMMENT ON COLUMN dataware_schema.inquiries.id IS '문의 ID (PK)';
COMMENT ON COLUMN dataware_schema.inquiries.name IS '문의자명';
COMMENT ON COLUMN dataware_schema.inquiries.company IS '회사명';
COMMENT ON COLUMN dataware_schema.inquiries.phone IS '전화번호';
COMMENT ON COLUMN dataware_schema.inquiries.email IS '이메일';
COMMENT ON COLUMN dataware_schema.inquiries.message IS '문의 내용';
COMMENT ON COLUMN dataware_schema.inquiries.product IS '관심 제품';
COMMENT ON COLUMN dataware_schema.inquiries.status IS '처리 상태 (NEW/IN_PROGRESS/COMPLETED)';
COMMENT ON COLUMN dataware_schema.inquiries.assignee IS '담당자';
COMMENT ON COLUMN dataware_schema.inquiries.consent_privacy IS '개인정보 수집 동의';
COMMENT ON COLUMN dataware_schema.inquiries.consent_third_party IS '제3자 정보 제공 동의';
COMMENT ON COLUMN dataware_schema.inquiries.created_at IS '접수일';
COMMENT ON COLUMN dataware_schema.inquiries.updated_at IS '수정일';

-- site_config: 사이트 설정 (key-value)
COMMENT ON TABLE dataware_schema.site_config IS '사이트 설정 (key-value 저장소)';
COMMENT ON COLUMN dataware_schema.site_config.id IS '설정 ID (PK)';
COMMENT ON COLUMN dataware_schema.site_config.config_key IS '설정 키 (UNIQUE)';
COMMENT ON COLUMN dataware_schema.site_config.config_value IS '설정 값';
COMMENT ON COLUMN dataware_schema.site_config.description IS '설정 설명';
COMMENT ON COLUMN dataware_schema.site_config.updated_at IS '수정일';

-- page_layout: 페이지 빌더 레이아웃 (Puck)
COMMENT ON TABLE dataware_schema.page_layout IS '페이지 빌더 레이아웃 (Puck JSON)';
COMMENT ON COLUMN dataware_schema.page_layout.id IS '레이아웃 ID (PK)';
COMMENT ON COLUMN dataware_schema.page_layout.page_key IS '페이지 식별 키 (UNIQUE)';
COMMENT ON COLUMN dataware_schema.page_layout.title IS '페이지 제목';
COMMENT ON COLUMN dataware_schema.page_layout.layout_json IS 'Puck 빌더 JSON 데이터';
COMMENT ON COLUMN dataware_schema.page_layout.status IS '상태 (DRAFT/PUBLISHED)';
COMMENT ON COLUMN dataware_schema.page_layout.updated_by IS '수정자 (FK → admins.id)';
COMMENT ON COLUMN dataware_schema.page_layout.updated_at IS '수정일';

-- products: 제품 정보
COMMENT ON TABLE dataware_schema.products IS '제품 정보';
COMMENT ON COLUMN dataware_schema.products.id IS '제품 ID (PK)';
COMMENT ON COLUMN dataware_schema.products.name IS '제품명';
COMMENT ON COLUMN dataware_schema.products.slug IS 'URL 슬러그 (UNIQUE)';
COMMENT ON COLUMN dataware_schema.products.category IS '제품 카테고리 (DATAWARE/DA_SHARP 등)';
COMMENT ON COLUMN dataware_schema.products.subtitle IS '부제목';
COMMENT ON COLUMN dataware_schema.products.description IS '제품 설명';
COMMENT ON COLUMN dataware_schema.products.features IS '주요 기능 (JSON)';
COMMENT ON COLUMN dataware_schema.products.icon_url IS '아이콘 URL';
COMMENT ON COLUMN dataware_schema.products.thumbnail_url IS '썸네일 이미지 URL';
COMMENT ON COLUMN dataware_schema.products.certification IS '인증 정보';
COMMENT ON COLUMN dataware_schema.products.sort_order IS '정렬 순서';
COMMENT ON COLUMN dataware_schema.products.published IS '발행 여부';
COMMENT ON COLUMN dataware_schema.products.created_at IS '생성일';
COMMENT ON COLUMN dataware_schema.products.updated_at IS '수정일';

-- pricing_plans: 요금제
COMMENT ON TABLE dataware_schema.pricing_plans IS '요금제 정보';
COMMENT ON COLUMN dataware_schema.pricing_plans.id IS '요금제 ID (PK)';
COMMENT ON COLUMN dataware_schema.pricing_plans.name IS '요금제명';
COMMENT ON COLUMN dataware_schema.pricing_plans.license_type IS '라이선스 유형';
COMMENT ON COLUMN dataware_schema.pricing_plans.price IS '가격 (원)';
COMMENT ON COLUMN dataware_schema.pricing_plans.original_price IS '정가 (할인 전)';
COMMENT ON COLUMN dataware_schema.pricing_plans.price_display IS '표시 가격 문자열';
COMMENT ON COLUMN dataware_schema.pricing_plans.features IS '포함 기능 (JSON)';
COMMENT ON COLUMN dataware_schema.pricing_plans.badge IS '뱃지 텍스트 (추천, NEW 등)';
COMMENT ON COLUMN dataware_schema.pricing_plans.is_popular IS '인기 요금제 표시';
COMMENT ON COLUMN dataware_schema.pricing_plans.sort_order IS '정렬 순서';
COMMENT ON COLUMN dataware_schema.pricing_plans.is_active IS '활성 여부';

-- education_sessions: 교육 과정
COMMENT ON TABLE dataware_schema.education_sessions IS '교육 과정 목록';
COMMENT ON COLUMN dataware_schema.education_sessions.id IS '과정 ID (PK)';
COMMENT ON COLUMN dataware_schema.education_sessions.title IS '과정명';
COMMENT ON COLUMN dataware_schema.education_sessions.date IS '일정';
COMMENT ON COLUMN dataware_schema.education_sessions.thumbnail IS '썸네일 이미지';
COMMENT ON COLUMN dataware_schema.education_sessions.tag IS '태그';
COMMENT ON COLUMN dataware_schema.education_sessions.status IS '과정 상태';
COMMENT ON COLUMN dataware_schema.education_sessions.description IS '과정 설명';
COMMENT ON COLUMN dataware_schema.education_sessions.location IS '장소';
COMMENT ON COLUMN dataware_schema.education_sessions.sort_order IS '정렬 순서';
COMMENT ON COLUMN dataware_schema.education_sessions.is_active IS '활성 여부';

-- educations: 교육 신청
COMMENT ON TABLE dataware_schema.educations IS '교육 신청';
COMMENT ON COLUMN dataware_schema.educations.id IS '신청 ID (PK)';
COMMENT ON COLUMN dataware_schema.educations.name IS '신청자명';
COMMENT ON COLUMN dataware_schema.educations.company IS '회사명';
COMMENT ON COLUMN dataware_schema.educations.phone IS '전화번호';
COMMENT ON COLUMN dataware_schema.educations.email IS '이메일';
COMMENT ON COLUMN dataware_schema.educations.position IS '직급/직책';
COMMENT ON COLUMN dataware_schema.educations.preferred_date IS '희망 교육 일자';
COMMENT ON COLUMN dataware_schema.educations.note IS '비고';
COMMENT ON COLUMN dataware_schema.educations.consent_privacy IS '개인정보 수집 동의';
COMMENT ON COLUMN dataware_schema.educations.consent_third_party IS '제3자 정보 제공 동의';
COMMENT ON COLUMN dataware_schema.educations.status IS '처리 상태 (NEW/CONFIRMED/COMPLETED/CANCELLED)';
COMMENT ON COLUMN dataware_schema.educations.created_at IS '신청일';

-- seminars: 세미나 신청
COMMENT ON TABLE dataware_schema.seminars IS '세미나 신청';
COMMENT ON COLUMN dataware_schema.seminars.id IS '신청 ID (PK)';
COMMENT ON COLUMN dataware_schema.seminars.name IS '신청자명';
COMMENT ON COLUMN dataware_schema.seminars.company IS '회사명';
COMMENT ON COLUMN dataware_schema.seminars.phone IS '전화번호';
COMMENT ON COLUMN dataware_schema.seminars.email IS '이메일';
COMMENT ON COLUMN dataware_schema.seminars.department IS '부서';
COMMENT ON COLUMN dataware_schema.seminars.preferred_date IS '희망 일자';
COMMENT ON COLUMN dataware_schema.seminars.attendees IS '참석 인원';
COMMENT ON COLUMN dataware_schema.seminars.topic IS '세미나 주제';
COMMENT ON COLUMN dataware_schema.seminars.note IS '비고';
COMMENT ON COLUMN dataware_schema.seminars.consent_privacy IS '개인정보 수집 동의';
COMMENT ON COLUMN dataware_schema.seminars.consent_third_party IS '제3자 정보 제공 동의';
COMMENT ON COLUMN dataware_schema.seminars.status IS '처리 상태 (NEW/CONFIRMED/COMPLETED/CANCELLED)';
COMMENT ON COLUMN dataware_schema.seminars.created_at IS '신청일';

-- download_resources: 다운로드 자료 목록
COMMENT ON TABLE dataware_schema.download_resources IS '다운로드 자료 목록 (카탈로그)';
COMMENT ON COLUMN dataware_schema.download_resources.id IS '자료 ID (PK)';
COMMENT ON COLUMN dataware_schema.download_resources.title IS '자료명';
COMMENT ON COLUMN dataware_schema.download_resources.description IS '자료 설명';
COMMENT ON COLUMN dataware_schema.download_resources.file_type IS '파일 유형';
COMMENT ON COLUMN dataware_schema.download_resources.thumbnail IS '썸네일 이미지';
COMMENT ON COLUMN dataware_schema.download_resources.download_url IS '다운로드 URL';
COMMENT ON COLUMN dataware_schema.download_resources.sort_order IS '정렬 순서';
COMMENT ON COLUMN dataware_schema.download_resources.is_active IS '활성 여부';
