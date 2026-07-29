package kr.co.unionsystems.admin.controller;

import kr.co.unionsystems.admin.dto.MenuResponse;
import kr.co.unionsystems.admin.service.AdminMenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 공개 API: 홈페이지 프론트엔드가 메뉴 트리를 읽어갈 때 사용.
 * is_exposed=true인 항목만 반환. 인증 불필요.
 */
@RestController
@RequiredArgsConstructor
public class MenuPublicController {

    private final AdminMenuService menuService;

    @GetMapping("/api/{site}/menu")
    public ResponseEntity<List<MenuResponse>> getMenu(@PathVariable String site) {
        return ResponseEntity.ok(menuService.getPublicMenuTree(site));
    }
}
