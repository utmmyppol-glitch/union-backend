package kr.co.unionsystems.admin.controller;

import kr.co.unionsystems.admin.service.AdminContentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 공개 API: 홈페이지 프론트엔드가 콘텐츠 영역을 읽어갈 때 사용.
 * region_key 목록으로 조회. 인증 불필요.
 */
@RestController
@RequiredArgsConstructor
public class ContentPublicController {

    private final AdminContentService contentService;

    /**
     * GET /api/{site}/content?keys=company_intro,company_vision,...
     * 반환: { "company_intro": "<p>...</p>", "company_vision": "<h2>...</h2>" }
     */
    @GetMapping("/api/{site}/content")
    public ResponseEntity<Map<String, String>> getContent(
            @PathVariable String site,
            @RequestParam(required = false) List<String> keys) {
        Map<String, String> result = contentService.getPublicContent(site, keys);
        return ResponseEntity.ok(result);
    }
}
