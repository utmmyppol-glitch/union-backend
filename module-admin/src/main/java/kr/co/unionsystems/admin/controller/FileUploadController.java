package kr.co.unionsystems.admin.controller;

import kr.co.unionsystems.admin.service.SiteAccessValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import static java.util.Map.entry;

@RestController
public class FileUploadController {

    private static final Logger log = LoggerFactory.getLogger(FileUploadController.class);
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final Set<String> ALLOWED_TYPES = Set.of(
            "image/jpeg", "image/png", "image/webp"
    );
    private static final Map<String, String> TYPE_TO_EXT = Map.ofEntries(
            entry("image/jpeg", ".jpg"),
            entry("image/png", ".png"),
            entry("image/webp", ".webp")
    );

    private final SiteAccessValidator siteAccessValidator;
    private final Path uploadPath;

    public FileUploadController(
            SiteAccessValidator siteAccessValidator,
            @Value("${upload.dir:uploads}") String uploadDir) {
        this.siteAccessValidator = siteAccessValidator;
        this.uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
        log.info("Upload path resolved to: {}", this.uploadPath);
    }

    /** 이미지 업로드 (관리자 전용) */
    @PostMapping("/api/admin/{site}/upload")
    public ResponseEntity<?> uploadFile(
            @PathVariable String site,
            @RequestParam("file") MultipartFile file) {

        siteAccessValidator.validateWriteAccess(site);

        if (file.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "파일이 비어 있습니다"));
        }
        if (file.getSize() > MAX_FILE_SIZE) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "파일 크기는 5MB 이하여야 합니다"));
        }
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_TYPES.contains(contentType)) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", "이미지 파일만 업로드할 수 있습니다 (jpg, png, webp)"));
        }

        String originalName = file.getOriginalFilename();
        String ext = TYPE_TO_EXT.getOrDefault(contentType, "");
        String newFileName = UUID.randomUUID() + ext;

        try {
            Files.createDirectories(uploadPath);
            Path targetPath = uploadPath.resolve(newFileName).normalize();
            if (!targetPath.startsWith(uploadPath)) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "잘못된 파일 경로입니다"));
            }
            file.transferTo(targetPath.toFile());
            log.info("File uploaded: {} -> {}", originalName, targetPath);

            String url = "/uploads/" + newFileName;
            return ResponseEntity.ok(Map.of(
                    "url", url,
                    "fileName", newFileName
            ));
        } catch (IOException e) {
            log.error("File upload failed", e);
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "파일 저장에 실패했습니다"));
        }
    }

    /** 이미지 서빙 (공개) */
    @GetMapping("/uploads/{fileName:.+}")
    public ResponseEntity<Resource> serveFile(@PathVariable String fileName) {
        try {
            Path filePath = uploadPath.resolve(fileName).normalize();
            if (!filePath.startsWith(uploadPath)) {
                return ResponseEntity.notFound().build();
            }
            Resource resource = new UrlResource(filePath.toUri());
            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.notFound().build();
            }

            String contentType = Files.probeContentType(filePath);
            if (contentType == null) contentType = "application/octet-stream";

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CACHE_CONTROL, "public, max-age=86400")
                    .body(resource);
        } catch (MalformedURLException e) {
            return ResponseEntity.notFound().build();
        } catch (IOException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
