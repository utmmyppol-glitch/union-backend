package kr.co.unionsystems.union.controller;

import jakarta.validation.Valid;
import kr.co.unionsystems.union.dto.DownloadRequest;
import kr.co.unionsystems.union.service.DownloadService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;

@RestController("unionDownloadController")
@RequestMapping("/api/union/downloads")
@RequiredArgsConstructor
@Slf4j
public class DownloadController {

    private final DownloadService downloadService;

    @Value("${upload.dir:uploads}")
    private String uploadDir;

    @PostMapping
    public ResponseEntity<Map<String, Object>> submitDownloadRequest(
            @Valid @RequestBody DownloadRequest request) {
        var saved = downloadService.submitDownload(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(Map.of("message", "다운로드 신청이 완료되었습니다", "id", saved.getId()));
    }

    /**
     * 브로셔 파일 다운로드.
     * uploads 디렉터리에서 brochure.pdf (또는 brochure.*) 파일을 탐색하여 서빙.
     */
    @GetMapping("/brochure")
    public ResponseEntity<Resource> downloadBrochure() {
        try {
            Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
            Path brochurePath = findBrochureFile(uploadPath);
            if (brochurePath == null) {
                log.warn("Brochure file not found in {}", uploadPath);
                return ResponseEntity.notFound().build();
            }

            Resource resource = new UrlResource(brochurePath.toUri());
            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.notFound().build();
            }

            String contentType = Files.probeContentType(brochurePath);
            if (contentType == null) contentType = "application/octet-stream";

            String fileName = brochurePath.getFileName().toString();
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                    .body(resource);

        } catch (MalformedURLException e) {
            return ResponseEntity.notFound().build();
        } catch (IOException e) {
            log.error("Brochure download error", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    private Path findBrochureFile(Path dir) {
        // brochure.pdf 우선, 그 외 brochure.* 탐색
        String[] candidates = {"brochure.pdf", "brochure.PDF", "brochure.zip"};
        for (String name : candidates) {
            Path p = dir.resolve(name);
            if (Files.exists(p) && Files.isReadable(p)) return p;
        }
        // brochure 로 시작하는 파일 탐색
        try (var stream = Files.list(dir)) {
            return stream
                    .filter(p -> p.getFileName().toString().toLowerCase().startsWith("brochure"))
                    .filter(Files::isReadable)
                    .findFirst().orElse(null);
        } catch (IOException e) {
            return null;
        }
    }
}
