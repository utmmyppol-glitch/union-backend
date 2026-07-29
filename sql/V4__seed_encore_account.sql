-- 엔코아 전용 VIEWER 계정 (dataware 다운로드 조회만 가능)
INSERT INTO common.admins (username, password, role, site)
VALUES ('encore', '$2a$10$nmAPN/JSijYZPTx3LtlKaeqIN.dqJOwWuTx0c1E73bHf15nKTnvd.', 'VIEWER', 'DATAWARE')
ON CONFLICT (username) DO NOTHING;
