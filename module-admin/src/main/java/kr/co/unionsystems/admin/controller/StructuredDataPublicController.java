package kr.co.unionsystems.admin.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 공개 API: 구조화 리스트 데이터 (is_active=true만 반환)
 * union: history, partners, glossary
 * dataware: pricing-plans, education-sessions, download-resources
 */
@RestController
public class StructuredDataPublicController {

    private final kr.co.unionsystems.union.repository.HistoryRepository unionHistoryRepo;
    private final kr.co.unionsystems.union.repository.PartnerRepository unionPartnerRepo;
    private final kr.co.unionsystems.union.repository.GlossaryRepository unionGlossaryRepo;
    private final kr.co.unionsystems.dataware.repository.PricingPlanRepository datawarePricingRepo;
    private final kr.co.unionsystems.dataware.repository.EducationSessionRepository datawareEduRepo;
    private final kr.co.unionsystems.dataware.repository.DownloadResourceRepository datawareDownloadResRepo;

    public StructuredDataPublicController(
            @Qualifier("unionHistoryRepository") kr.co.unionsystems.union.repository.HistoryRepository unionHistoryRepo,
            @Qualifier("unionPartnerRepository") kr.co.unionsystems.union.repository.PartnerRepository unionPartnerRepo,
            @Qualifier("unionGlossaryRepository") kr.co.unionsystems.union.repository.GlossaryRepository unionGlossaryRepo,
            @Qualifier("datawarePricingPlanRepository") kr.co.unionsystems.dataware.repository.PricingPlanRepository datawarePricingRepo,
            @Qualifier("datawareEducationSessionRepository") kr.co.unionsystems.dataware.repository.EducationSessionRepository datawareEduRepo,
            @Qualifier("datawareDownloadResourceRepository") kr.co.unionsystems.dataware.repository.DownloadResourceRepository datawareDownloadResRepo) {
        this.unionHistoryRepo = unionHistoryRepo;
        this.unionPartnerRepo = unionPartnerRepo;
        this.unionGlossaryRepo = unionGlossaryRepo;
        this.datawarePricingRepo = datawarePricingRepo;
        this.datawareEduRepo = datawareEduRepo;
        this.datawareDownloadResRepo = datawareDownloadResRepo;
    }

    // ── Union ──
    @GetMapping("/api/union/history")
    public ResponseEntity<?> getHistory() {
        return ResponseEntity.ok(unionHistoryRepo.findAllByIsActiveTrueOrderBySortOrderAsc());
    }

    @GetMapping("/api/union/partners")
    public ResponseEntity<?> getPartners() {
        return ResponseEntity.ok(unionPartnerRepo.findAllByIsActiveTrueOrderBySortOrderAsc());
    }

    @GetMapping("/api/union/glossary")
    public ResponseEntity<?> getGlossary() {
        return ResponseEntity.ok(unionGlossaryRepo.findAllByIsActiveTrueOrderBySortOrderAsc());
    }

    // ── Dataware ──
    @GetMapping("/api/dataware/pricing-plans")
    public ResponseEntity<?> getPricingPlans() {
        return ResponseEntity.ok(datawarePricingRepo.findAllByIsActiveTrueOrderBySortOrderAsc());
    }

    @GetMapping("/api/dataware/education-sessions")
    public ResponseEntity<?> getEducationSessions() {
        return ResponseEntity.ok(datawareEduRepo.findAllByIsActiveTrueOrderBySortOrderAsc());
    }

    @GetMapping("/api/dataware/download-resources")
    public ResponseEntity<?> getDownloadResources() {
        return ResponseEntity.ok(datawareDownloadResRepo.findAllByIsActiveTrueOrderBySortOrderAsc());
    }
}
