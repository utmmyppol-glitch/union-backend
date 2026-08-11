package kr.co.unionsystems.dataware.controller;

import jakarta.validation.Valid;
import kr.co.unionsystems.dataware.dto.InquiryRequest;
import kr.co.unionsystems.dataware.dto.InquiryResponse;
import kr.co.unionsystems.dataware.service.InquiryService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.UUID;

@RestController("datawareInquiryController")
@RequestMapping("/api/dataware/inquiries")
@RequiredArgsConstructor
public class InquiryController {

    private final InquiryService inquiryService;

    @Value("${upload.dir:uploads}")
    private String uploadDir;

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<InquiryResponse> createInquiry(@Valid @RequestBody InquiryRequest request) {
        InquiryResponse response = inquiryService.createInquiry(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<InquiryResponse> createInquiryWithFile(
            @RequestParam String name,
            @RequestParam String company,
            @RequestParam String phone,
            @RequestParam String email,
            @RequestParam(required = false) String message,
            @RequestParam(required = false) String product,
            @RequestParam Boolean consentPrivacy,
            @RequestParam(required = false) Boolean consentThirdParty,
            @RequestParam(required = false) Boolean consentMarketing,
            @RequestPart(required = false) MultipartFile file) throws IOException {

        InquiryRequest request = InquiryRequest.builder()
                .name(name).company(company).phone(phone).email(email)
                .message(message).product(product)
                .consentPrivacy(consentPrivacy)
                .consentThirdParty(consentThirdParty)
                .build();

        String fileUrl = null;
        if (file != null && !file.isEmpty()) {
            fileUrl = saveFile(file);
        }

        InquiryResponse response = inquiryService.createInquiry(request, fileUrl);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping
    public ResponseEntity<Page<InquiryResponse>> getInquiries(
            @PageableDefault(size = 20) Pageable pageable) {
        return ResponseEntity.ok(inquiryService.getInquiries(pageable));
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<InquiryResponse> updateStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String status = body.get("status");
        return ResponseEntity.ok(inquiryService.updateStatus(id, status));
    }

    private String saveFile(MultipartFile file) throws IOException {
        Path uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
        Files.createDirectories(uploadPath);
        String ext = "";
        String original = file.getOriginalFilename();
        if (original != null && original.contains(".")) {
            ext = original.substring(original.lastIndexOf('.'));
        }
        String newName = UUID.randomUUID() + ext;
        Path target = uploadPath.resolve(newName).normalize();
        if (!target.startsWith(uploadPath)) {
            throw new IOException("잘못된 파일 경로");
        }
        file.transferTo(target.toFile());
        return "/uploads/" + newName;
    }
}
