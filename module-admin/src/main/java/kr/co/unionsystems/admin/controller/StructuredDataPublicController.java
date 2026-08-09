package kr.co.unionsystems.admin.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 공개 API: 구조화 리스트 데이터 (is_active=true만 반환)
 * dataware: education-sessions, download-resources
 * (history, glossary는 module-union 컨트롤러에서 처리)
 * (pricing-plans는 module-dataware 컨트롤러에서 처리)
 */
@RestController
public class StructuredDataPublicController {

    private final kr.co.unionsystems.dataware.repository.EducationSessionRepository datawareEduRepo;
    private final kr.co.unionsystems.dataware.repository.DownloadResourceRepository datawareDownloadResRepo;

    public StructuredDataPublicController(
            @Qualifier("datawareEducationSessionRepository") kr.co.unionsystems.dataware.repository.EducationSessionRepository datawareEduRepo,
            @Qualifier("datawareDownloadResourceRepository") kr.co.unionsystems.dataware.repository.DownloadResourceRepository datawareDownloadResRepo) {
        this.datawareEduRepo = datawareEduRepo;
        this.datawareDownloadResRepo = datawareDownloadResRepo;
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
