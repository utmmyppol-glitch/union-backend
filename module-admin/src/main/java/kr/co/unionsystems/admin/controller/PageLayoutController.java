package kr.co.unionsystems.admin.controller;

import kr.co.unionsystems.admin.config.AdminPrincipal;
import kr.co.unionsystems.admin.service.SiteAccessValidator;
import lombok.Data;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
public class PageLayoutController {

    private final kr.co.unionsystems.union.repository.PageLayoutRepository unionRepo;
    private final kr.co.unionsystems.dataware.repository.PageLayoutRepository datawareRepo;
    private final SiteAccessValidator siteAccessValidator;

    public PageLayoutController(
            @Qualifier("unionPageLayoutRepository") kr.co.unionsystems.union.repository.PageLayoutRepository unionRepo,
            @Qualifier("datawarePageLayoutRepository") kr.co.unionsystems.dataware.repository.PageLayoutRepository datawareRepo,
            SiteAccessValidator siteAccessValidator) {
        this.unionRepo = unionRepo;
        this.datawareRepo = datawareRepo;
        this.siteAccessValidator = siteAccessValidator;
    }

    // ── 공개 API (PUBLISHED만, 홈페이지 SSR용) ──
    @GetMapping("/api/{site}/page-layout/{pageKey}")
    public ResponseEntity<Map<String, Object>> getPublicLayout(
            @PathVariable String site, @PathVariable String pageKey) {
        String normalized = siteAccessValidator.normalizeSite(site);
        String json = null;
        if ("union".equals(normalized)) {
            var opt = unionRepo.findByPageKey(pageKey);
            if (opt.isPresent() && "PUBLISHED".equals(opt.get().getStatus())) {
                json = opt.get().getLayoutJson();
            }
        } else {
            var opt = datawareRepo.findByPageKey(pageKey);
            if (opt.isPresent() && "PUBLISHED".equals(opt.get().getStatus())) {
                json = opt.get().getLayoutJson();
            }
        }
        if (json == null) return ResponseEntity.notFound().build();
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("pageKey", pageKey);
        result.put("layoutJson", json);
        return ResponseEntity.ok(result);
    }

    // ── 관리자 API: 불러오기 ──
    @GetMapping("/api/admin/{site}/page-layout/{pageKey}")
    public ResponseEntity<Map<String, Object>> getLayout(
            @PathVariable String site, @PathVariable String pageKey) {
        siteAccessValidator.validateSiteAccess(site);
        String normalized = siteAccessValidator.normalizeSite(site);
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("pageKey", pageKey);

        if ("union".equals(normalized)) {
            var layout = unionRepo.findByPageKey(pageKey).orElse(null);
            result.put("layoutJson", layout != null ? layout.getLayoutJson() : "{}");
            result.put("status", layout != null ? layout.getStatus() : "DRAFT");
        } else {
            var layout = datawareRepo.findByPageKey(pageKey).orElse(null);
            result.put("layoutJson", layout != null ? layout.getLayoutJson() : "{}");
            result.put("status", layout != null ? layout.getStatus() : "DRAFT");
        }
        return ResponseEntity.ok(result);
    }

    // ── 관리자 API: 저장 ──
    @PutMapping("/api/admin/{site}/page-layout/{pageKey}")
    public ResponseEntity<Map<String, String>> saveLayout(
            @PathVariable String site, @PathVariable String pageKey,
            @RequestBody LayoutRequest request) {
        siteAccessValidator.validateWriteAccess(site);
        String normalized = siteAccessValidator.normalizeSite(site);
        AdminPrincipal admin = (AdminPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String status = request.getStatus() != null ? request.getStatus() : "DRAFT";

        if ("union".equals(normalized)) {
            var layout = unionRepo.findByPageKey(pageKey).orElse(
                    kr.co.unionsystems.union.entity.PageLayout.builder().pageKey(pageKey).layoutJson("{}").build());
            layout.setTitle(request.getTitle());
            layout.setLayoutJson(request.getLayoutJson());
            layout.setStatus(status);
            layout.setUpdatedBy(admin.getId());
            unionRepo.save(layout);
        } else {
            var layout = datawareRepo.findByPageKey(pageKey).orElse(
                    kr.co.unionsystems.dataware.entity.PageLayout.builder().pageKey(pageKey).layoutJson("{}").build());
            layout.setTitle(request.getTitle());
            layout.setLayoutJson(request.getLayoutJson());
            layout.setStatus(status);
            layout.setUpdatedBy(admin.getId());
            datawareRepo.save(layout);
        }
        return ResponseEntity.ok(Map.of("status", "saved", "pageKey", pageKey));
    }

    @Data
    static class LayoutRequest {
        private String title;
        private String layoutJson;
        private String status;
    }
}
