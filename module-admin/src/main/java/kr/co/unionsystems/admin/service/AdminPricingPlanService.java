package kr.co.unionsystems.admin.service;

import kr.co.unionsystems.admin.dto.PricingPlanAdminRequest;
import kr.co.unionsystems.admin.dto.PricingPlanAdminResponse;
import kr.co.unionsystems.dataware.entity.PricingPlan;
import kr.co.unionsystems.dataware.repository.PricingPlanRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class AdminPricingPlanService {

    private final PricingPlanRepository pricingPlanRepo;
    private final SiteAccessValidator siteAccessValidator;

    public AdminPricingPlanService(
            @Qualifier("datawarePricingPlanRepository") PricingPlanRepository pricingPlanRepo,
            SiteAccessValidator siteAccessValidator) {
        this.pricingPlanRepo = pricingPlanRepo;
        this.siteAccessValidator = siteAccessValidator;
    }

    @Transactional(readOnly = true)
    public List<PricingPlanAdminResponse> getAll(String site, String keyword) {
        siteAccessValidator.validateSiteAccess(site);
        String s = siteAccessValidator.normalizeSite(site);
        if (!"dataware".equals(s)) {
            throw new IllegalArgumentException("가격 플랜 관리는 dataware 사이트에서만 가능합니다");
        }
        List<PricingPlan> all = pricingPlanRepo.findAll(Sort.by("sortOrder"));
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            all = all.stream()
                    .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(kw))
                            || (p.getLicenseType() != null && p.getLicenseType().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
        }
        return all.stream().map(this::from).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public PricingPlanAdminResponse getOne(String site, Long id) {
        siteAccessValidator.validateSiteAccess(site);
        siteAccessValidator.normalizeSite(site);
        return pricingPlanRepo.findById(id).map(this::from)
                .orElseThrow(() -> new IllegalArgumentException("가격 플랜을 찾을 수 없습니다: " + id));
    }

    @Transactional
    public PricingPlanAdminResponse create(String site, PricingPlanAdminRequest req) {
        siteAccessValidator.validateWriteAccess(site);
        String s = siteAccessValidator.normalizeSite(site);
        if (!"dataware".equals(s)) {
            throw new IllegalArgumentException("가격 플랜 관리는 dataware 사이트에서만 가능합니다");
        }
        PricingPlan plan = PricingPlan.builder()
                .name(req.getName())
                .licenseType(req.getLicenseType())
                .price(req.getPrice())
                .originalPrice(req.getOriginalPrice())
                .priceDisplay(req.getPriceDisplay())
                .features(req.getFeatures())
                .badge(req.getBadge())
                .isPopular(req.getIsPopular() != null ? req.getIsPopular() : false)
                .sortOrder(req.getSortOrder())
                .isActive(req.getIsActive() != null ? req.getIsActive() : true)
                .build();
        return from(pricingPlanRepo.save(plan));
    }

    @Transactional
    public PricingPlanAdminResponse update(String site, Long id, PricingPlanAdminRequest req) {
        siteAccessValidator.validateWriteAccess(site);
        PricingPlan plan = pricingPlanRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("가격 플랜을 찾을 수 없습니다: " + id));
        plan.setName(req.getName());
        plan.setLicenseType(req.getLicenseType());
        plan.setPrice(req.getPrice());
        plan.setOriginalPrice(req.getOriginalPrice());
        plan.setPriceDisplay(req.getPriceDisplay());
        plan.setFeatures(req.getFeatures());
        plan.setBadge(req.getBadge());
        if (req.getIsPopular() != null) plan.setIsPopular(req.getIsPopular());
        if (req.getSortOrder() != null) plan.setSortOrder(req.getSortOrder());
        if (req.getIsActive() != null) plan.setIsActive(req.getIsActive());
        return from(pricingPlanRepo.save(plan));
    }

    @Transactional
    public PricingPlanAdminResponse toggleActive(String site, Long id, boolean isActive) {
        siteAccessValidator.validateWriteAccess(site);
        PricingPlan plan = pricingPlanRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("가격 플랜을 찾을 수 없습니다: " + id));
        plan.setIsActive(isActive);
        return from(pricingPlanRepo.save(plan));
    }

    @Transactional
    public void delete(String site, Long id) {
        siteAccessValidator.validateWriteAccess(site);
        pricingPlanRepo.deleteById(id);
    }

    private PricingPlanAdminResponse from(PricingPlan p) {
        return PricingPlanAdminResponse.builder()
                .id(p.getId())
                .name(p.getName())
                .licenseType(p.getLicenseType())
                .price(p.getPrice())
                .originalPrice(p.getOriginalPrice())
                .priceDisplay(p.getPriceDisplay())
                .features(p.getFeatures())
                .badge(p.getBadge())
                .isPopular(p.getIsPopular())
                .sortOrder(p.getSortOrder())
                .isActive(p.getIsActive())
                .build();
    }
}
