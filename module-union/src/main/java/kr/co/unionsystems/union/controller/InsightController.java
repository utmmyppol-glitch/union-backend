package kr.co.unionsystems.union.controller;

import kr.co.unionsystems.union.dto.InsightPublicResponse;
import kr.co.unionsystems.union.service.InsightService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 사용자(프론트)용 인사이트 API.
 * 승인된 인사이트만 공개용 DTO로 반환한다.
 */
@RestController
@RequestMapping("/api/union/insights")
@RequiredArgsConstructor
public class InsightController {

    private final InsightService insightService;

    @GetMapping
    public ResponseEntity<Page<InsightPublicResponse>> getApprovedInsights(
            @PageableDefault(size = 10) Pageable pageable) {
        return ResponseEntity.ok(insightService.getApprovedInsights(pageable));
    }
}
