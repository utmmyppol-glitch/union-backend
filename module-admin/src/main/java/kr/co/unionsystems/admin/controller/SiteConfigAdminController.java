package kr.co.unionsystems.admin.controller;

import jakarta.validation.Valid;
import kr.co.unionsystems.admin.dto.SiteConfigRequest;
import kr.co.unionsystems.admin.dto.SiteConfigResponse;
import kr.co.unionsystems.admin.service.AdminSiteConfigService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/{site}/site-config")
@RequiredArgsConstructor
public class SiteConfigAdminController {

    private final AdminSiteConfigService siteConfigService;

    @GetMapping
    public ResponseEntity<List<SiteConfigResponse>> getAll(@PathVariable String site) {
        return ResponseEntity.ok(siteConfigService.getAllConfigs(site));
    }

    @PutMapping("/{id}")
    public ResponseEntity<SiteConfigResponse> update(
            @PathVariable String site,
            @PathVariable Long id,
            @Valid @RequestBody SiteConfigRequest request) {
        return ResponseEntity.ok(siteConfigService.updateConfig(site, id, request));
    }
}
