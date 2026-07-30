package kr.co.unionsystems.admin.controller;

import kr.co.unionsystems.admin.service.SiteAccessValidator;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@RestController
public class FileUploadController {

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final Set<String> ALLOWED_TYPES = Set.of(
            "image/jpeg", "image/png", "image/webp"
    );

    private final SiteAccessValidator siteAccessValidator;
    private final String uploadDir;

    public FileUploadController(
            SiteAccessValidator siteAccessValidator,
            @Value("${upload.dir:uploads}") String uploadDir) {
        this.siteAccessValidator = siteAccessValidator;
        this.uploadDir = uploadDir;
    }

    @PostMapping("/api/admin/{site}/upload")
    public ResponseEntity<?> uploadFile(
            @PathVariable String site,
            @RequestParam("file") MultipartFile file) {

        siteAccessValidator.validateWriteAccess(site);

        // 빈 파일
        if (file.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "파일이 비어 있습니다"));
        }

        // 크기 제한
        if (file.getSize() > MAX_FILE_SIZE) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "파일 크기는 5MB 이하여야 합니다"));
        }

        // 타입 검증
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_TYPES.contains(contentType)) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "이미지 파일만 업로드할 수 있습니다 (jpg, png, webp)"));
        }

        // 확장자 추출
        String originalName = file.getOriginalFilename();
        String ext = "";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf('.'));
        }

        // 새 파일명 생성
        String newFileName = UUID.randomUUID().toString() + ext;

        try {
            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            Files.createDirectories(uploadPath);
            Path targetPath = uploadPath.resolve(newFileName).normalize();

            // path traversal 방지
            if (!targetPath.startsWith(uploadPath)) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "잘못된 파일 경로입니다"));
            }

            file.transferTo(targetPath.toFile());

            String url = "/uploads/" + newFileName;
            return ResponseEntity.ok(Map.of(
                    "url", url,
                    "fileName", newFileName
            ));
        } catch (IOException e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "파일 저장에 실패했습니다"));
        }
    }
}
