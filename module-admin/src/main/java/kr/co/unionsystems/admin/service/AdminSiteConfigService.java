package kr.co.unionsystems.admin.service;

import kr.co.unionsystems.admin.dto.SiteConfigRequest;
import kr.co.unionsystems.admin.dto.SiteConfigResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AdminSiteConfigService {

    private final kr.co.unionsystems.union.repository.SiteConfigRepository unionConfigRepo;
    private final kr.co.unionsystems.dataware.repository.SiteConfigRepository datawareConfigRepo;
    private final SiteAccessValidator siteAccessValidator;

    public AdminSiteConfigService(
            @Qualifier("unionSiteConfigRepository") kr.co.unionsystems.union.repository.SiteConfigRepository unionConfigRepo,
            @Qualifier("datawareSiteConfigRepository") kr.co.unionsystems.dataware.repository.SiteConfigRepository datawareConfigRepo,
            SiteAccessValidator siteAccessValidator) {
        this.unionConfigRepo = unionConfigRepo;
        this.datawareConfigRepo = datawareConfigRepo;
        this.siteAccessValidator = siteAccessValidator;
    }

    public List<SiteConfigResponse> getAllConfigs(String site) {
        siteAccessValidator.validateSiteAccess(site);
        String normalized = siteAccessValidator.normalizeSite(site);

        if ("union".equals(normalized)) {
            return unionConfigRepo.findAll().stream().map(this::toResponse).collect(Collectors.toList());
        } else {
            return datawareConfigRepo.findAll().stream().map(this::toResponse).collect(Collectors.toList());
        }
    }

    @Transactional
    public SiteConfigResponse updateConfig(String site, Long id, SiteConfigRequest request) {
        siteAccessValidator.validateWriteAccess(site);
        String normalized = siteAccessValidator.normalizeSite(site);

        if ("union".equals(normalized)) {
            var config = unionConfigRepo.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("설정을 찾을 수 없습니다: " + id));
            config.setConfigValue(request.getConfigValue());
            if (request.getDescription() != null) {
                config.setDescription(request.getDescription());
            }
            return toResponse(unionConfigRepo.save(config));
        } else {
            var config = datawareConfigRepo.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("설정을 찾을 수 없습니다: " + id));
            config.setConfigValue(request.getConfigValue());
            if (request.getDescription() != null) {
                config.setDescription(request.getDescription());
            }
            return toResponse(datawareConfigRepo.save(config));
        }
    }

    /**
     * 공개 API용: key-value Map 반환
     */
    public Map<String, String> getPublicConfigMap(String site) {
        String normalized = siteAccessValidator.normalizeSite(site);

        if ("union".equals(normalized)) {
            return unionConfigRepo.findAll().stream()
                    .collect(Collectors.toMap(
                            kr.co.unionsystems.union.entity.SiteConfig::getConfigKey,
                            kr.co.unionsystems.union.entity.SiteConfig::getConfigValue));
        } else {
            return datawareConfigRepo.findAll().stream()
                    .collect(Collectors.toMap(
                            kr.co.unionsystems.dataware.entity.SiteConfig::getConfigKey,
                            kr.co.unionsystems.dataware.entity.SiteConfig::getConfigValue));
        }
    }

    private SiteConfigResponse toResponse(kr.co.unionsystems.union.entity.SiteConfig c) {
        return SiteConfigResponse.builder()
                .id(c.getId()).configKey(c.getConfigKey())
                .configValue(c.getConfigValue()).description(c.getDescription())
                .updatedAt(c.getUpdatedAt()).build();
    }

    private SiteConfigResponse toResponse(kr.co.unionsystems.dataware.entity.SiteConfig c) {
        return SiteConfigResponse.builder()
                .id(c.getId()).configKey(c.getConfigKey())
                .configValue(c.getConfigValue()).description(c.getDescription())
                .updatedAt(c.getUpdatedAt()).build();
    }
}
