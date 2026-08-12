package kr.co.unionsystems.admin.controller;

import jakarta.validation.Valid;
import kr.co.unionsystems.admin.dto.HistoryAdminRequest;
import kr.co.unionsystems.admin.dto.HistoryAdminResponse;
import kr.co.unionsystems.admin.service.AdminHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/{site}/history")
@RequiredArgsConstructor
public class HistoryAdminController {

    private final AdminHistoryService adminHistoryService;

    @GetMapping
    public ResponseEntity<List<HistoryAdminResponse>> getAll(
            @PathVariable String site,
            @RequestParam(required = false) String keyword) {
        return ResponseEntity.ok(adminHistoryService.getAll(site, keyword));
    }

    @GetMapping("/{id}")
    public ResponseEntity<HistoryAdminResponse> getOne(
            @PathVariable String site, @PathVariable Long id) {
        return ResponseEntity.ok(adminHistoryService.getOne(site, id));
    }

    @PostMapping
    public ResponseEntity<HistoryAdminResponse> create(
            @PathVariable String site, @Valid @RequestBody HistoryAdminRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(adminHistoryService.create(site, request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<HistoryAdminResponse> update(
            @PathVariable String site, @PathVariable Long id,
            @Valid @RequestBody HistoryAdminRequest request) {
        return ResponseEntity.ok(adminHistoryService.update(site, id, request));
    }

    @PatchMapping("/{id}/isActive")
    public ResponseEntity<HistoryAdminResponse> toggleActive(
            @PathVariable String site, @PathVariable Long id,
            @RequestBody java.util.Map<String, Boolean> body) {
        Boolean isActive = body.get("isActive");
        if (isActive == null) {
            throw new IllegalArgumentException("isActive 값은 필수입니다");
        }
        return ResponseEntity.ok(adminHistoryService.toggleActive(site, id, isActive));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(
            @PathVariable String site, @PathVariable Long id) {
        adminHistoryService.delete(site, id);
        return ResponseEntity.noContent().build();
    }
}
