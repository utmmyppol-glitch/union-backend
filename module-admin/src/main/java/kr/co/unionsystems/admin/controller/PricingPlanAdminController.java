package kr.co.unionsystems.admin.controller;

import jakarta.validation.Valid;
import kr.co.unionsystems.admin.dto.PricingPlanAdminRequest;
import kr.co.unionsystems.admin.dto.PricingPlanAdminResponse;
import kr.co.unionsystems.admin.service.AdminPricingPlanService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/{site}/pricing")
@RequiredArgsConstructor
public class PricingPlanAdminController {

    private final AdminPricingPlanService adminPricingPlanService;

    @GetMapping
    public ResponseEntity<List<PricingPlanAdminResponse>> getAll(
            @PathVariable String site,
            @RequestParam(required = false) String keyword) {
        return ResponseEntity.ok(adminPricingPlanService.getAll(site, keyword));
    }

    @GetMapping("/{id}")
    public ResponseEntity<PricingPlanAdminResponse> getOne(
            @PathVariable String site, @PathVariable Long id) {
        return ResponseEntity.ok(adminPricingPlanService.getOne(site, id));
    }

    @PostMapping
    public ResponseEntity<PricingPlanAdminResponse> create(
            @PathVariable String site, @Valid @RequestBody PricingPlanAdminRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(adminPricingPlanService.create(site, request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PricingPlanAdminResponse> update(
            @PathVariable String site, @PathVariable Long id,
            @Valid @RequestBody PricingPlanAdminRequest request) {
        return ResponseEntity.ok(adminPricingPlanService.update(site, id, request));
    }

    @PatchMapping("/{id}/isActive")
    public ResponseEntity<PricingPlanAdminResponse> toggleActive(
            @PathVariable String site, @PathVariable Long id,
            @RequestBody java.util.Map<String, Boolean> body) {
        Boolean isActive = body.get("isActive");
        if (isActive == null) {
            throw new IllegalArgumentException("isActive 값은 필수입니다");
        }
        return ResponseEntity.ok(adminPricingPlanService.toggleActive(site, id, isActive));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable String site, @PathVariable Long id) {
        adminPricingPlanService.delete(site, id);
        return ResponseEntity.noContent().build();
    }
}
