package kr.co.unionsystems.admin.controller;

import kr.co.unionsystems.admin.service.AdminSiteConfigService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 공개 API: 홈페이지 프론트엔드가 설정값을 읽어갈 때 사용.
 * 인증 불필요 (SecurityConfig에서 permitAll).
 */
@RestController
@RequiredArgsConstructor
public class SiteConfigPublicController {

    private final AdminSiteConfigService siteConfigService;

    @GetMapping("/api/{site}/config")
    public ResponseEntity<Map<String, String>> getConfig(@PathVariable String site) {
        return ResponseEntity.ok(siteConfigService.getPublicConfigMap(site));
    }
}
