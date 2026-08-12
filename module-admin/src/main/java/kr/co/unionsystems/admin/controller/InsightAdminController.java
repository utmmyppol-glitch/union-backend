package kr.co.unionsystems.admin.controller;

import kr.co.unionsystems.admin.config.AdminPrincipal;
import kr.co.unionsystems.union.dto.InsightResponse;
import kr.co.unionsystems.union.service.InsightCollectorService;
import kr.co.unionsystems.union.service.InsightService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 관리자(백오피스)용 인사이트 관리 API.
 * 인사이트 목록 조회, 승인/반려, 수동 수집 트리거를 제공한다.
 */
@RestController
@RequestMapping("/api/admin/union/insights")
@RequiredArgsConstructor
public class InsightAdminController {

    private final InsightService insightService;
    private final InsightCollectorService insightCollectorService;

    @GetMapping
    public ResponseEntity<Page<InsightResponse>> getInsights(
            @RequestParam(defaultValue = "PENDING") String status,
            @PageableDefault(size = 20) Pageable pageable) {
        return ResponseEntity.ok(insightService.getInsightsByStatus(status, pageable));
    }

    @PatchMapping("/{id}/approve")
    public ResponseEntity<InsightResponse> approve(
            @PathVariable Long id,
            @AuthenticationPrincipal AdminPrincipal principal) {
        return ResponseEntity.ok(insightService.approve(id, principal.getUsername()));
    }

    @PatchMapping("/{id}/reject")
    public ResponseEntity<InsightResponse> reject(@PathVariable Long id) {
        return ResponseEntity.ok(insightService.reject(id));
    }

    @PostMapping("/collect")
    public ResponseEntity<Map<String, String>> triggerCollection() {
        insightCollectorService.collectInsights();
        return ResponseEntity.ok(Map.of("message", "수집 완료"));
    }
}
