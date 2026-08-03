#!/usr/bin/env bash
# =============================================
# 이관 전 백업 스크립트
# 실행: bash 00_backup.sh
# 주의: 이관 실행 전에 반드시 이 스크립트를 먼저 실행
# =============================================

set -euo pipefail

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups/${TIMESTAMP}"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5433}"
DB_USER="${DB_USER:-postgres}"
DB_NAME="${DB_NAME:-union_integrated}"

echo "=== 이관 전 백업 시작: ${TIMESTAMP} ==="
mkdir -p "${BACKUP_DIR}"

# 1. 전체 DB 덤프 (plain SQL)
echo "[1/5] 전체 DB 덤프..."
pg_dump -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" \
  --format=plain --file="${BACKUP_DIR}/full_dump.sql"

# 2. 스키마별 custom 덤프 (빠른 복원용)
echo "[2/5] common 스키마 덤프..."
pg_dump -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" \
  --schema=common --format=custom \
  --file="${BACKUP_DIR}/common.dump"

echo "[3/5] union_schema 덤프..."
pg_dump -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" \
  --schema=union_schema --format=custom \
  --file="${BACKUP_DIR}/union_schema.dump"

echo "[4/5] dataware_schema 덤프..."
pg_dump -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" \
  --schema=dataware_schema --format=custom \
  --file="${BACKUP_DIR}/dataware_schema.dump"

# 3. 이미지 파일 백업
echo "[5/5] 업로드 이미지 백업..."
if [ -d "../../uploads" ]; then
  cp -r "../../uploads" "${BACKUP_DIR}/uploads"
fi
if [ -d "../../module-admin/uploads" ]; then
  cp -r "../../module-admin/uploads" "${BACKUP_DIR}/admin_uploads"
fi

# 4. 이관 전 행수 기록
echo "=== 이관 전 행수 기록 ==="
psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" \
  -t -A -F'|' -c "
SELECT 'common.admins', count(*) FROM common.admins
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
ORDER BY 1;
" | tee "${BACKUP_DIR}/row_counts_before.txt"

echo ""
echo "=== 백업 완료: ${BACKUP_DIR} ==="
echo "백업 파일 목록:"
ls -lh "${BACKUP_DIR}/"
