package kr.co.unionsystems.admin.controller;

import jakarta.validation.Valid;
import kr.co.unionsystems.admin.dto.GlossaryAdminRequest;
import kr.co.unionsystems.admin.dto.GlossaryAdminResponse;
import kr.co.unionsystems.admin.service.AdminGlossaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/{site}/glossary")
@RequiredArgsConstructor
public class GlossaryAdminController {

    private final AdminGlossaryService adminGlossaryService;

    @GetMapping
    public ResponseEntity<List<GlossaryAdminResponse>> getAll(
            @PathVariable String site,
            @RequestParam(required = false) String keyword) {
        return ResponseEntity.ok(adminGlossaryService.getAll(site, keyword));
    }

    @GetMapping("/{id}")
    public ResponseEntity<GlossaryAdminResponse> getOne(
            @PathVariable String site, @PathVariable Long id) {
        return ResponseEntity.ok(adminGlossaryService.getOne(site, id));
    }

    @PostMapping
    public ResponseEntity<GlossaryAdminResponse> create(
            @PathVariable String site, @Valid @RequestBody GlossaryAdminRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(adminGlossaryService.create(site, request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<GlossaryAdminResponse> update(
            @PathVariable String site, @PathVariable Long id,
            @Valid @RequestBody GlossaryAdminRequest request) {
        return ResponseEntity.ok(adminGlossaryService.update(site, id, request));
    }

    @PatchMapping("/{id}/isActive")
    public ResponseEntity<GlossaryAdminResponse> toggleActive(
            @PathVariable String site, @PathVariable Long id,
            @RequestBody java.util.Map<String, Boolean> body) {
        Boolean isActive = body.get("isActive");
        if (isActive == null) {
            throw new IllegalArgumentException("isActive 값은 필수입니다");
        }
        return ResponseEntity.ok(adminGlossaryService.toggleActive(site, id, isActive));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable String site, @PathVariable Long id) {
        adminGlossaryService.delete(site, id);
        return ResponseEntity.noContent().build();
    }
}
