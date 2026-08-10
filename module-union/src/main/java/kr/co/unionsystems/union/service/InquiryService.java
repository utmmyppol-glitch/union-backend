package kr.co.unionsystems.union.service;

import kr.co.unionsystems.union.dto.InquiryRequest;
import kr.co.unionsystems.union.dto.InquiryResponse;
import kr.co.unionsystems.union.entity.Inquiry;
import kr.co.unionsystems.union.entity.Inquiry.InquiryStatus;
import kr.co.unionsystems.union.repository.InquiryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("unionInquiryService")
@RequiredArgsConstructor
@Slf4j
public class InquiryService {

    private final InquiryRepository inquiryRepository;

    @Transactional
    public InquiryResponse createInquiry(InquiryRequest request) {
        Inquiry inquiry = Inquiry.builder()
                .name(request.getName())
                .company(request.getCompany())
                .phone(request.getPhone())
                .email(request.getEmail())
                .message(request.getMessage())
                .product(request.getProduct())
                .consentPrivacy(request.getConsentPrivacy())
                .status(InquiryStatus.NEW)
                .build();

        Inquiry saved = inquiryRepository.save(inquiry);
        log.info("New inquiry created: id={}, company={}", saved.getId(), saved.getCompany());

        return InquiryResponse.from(saved);
    }

    @Transactional(readOnly = true)
    public Page<InquiryResponse> getInquiries(Pageable pageable) {
        return inquiryRepository.findAllByOrderByCreatedAtDesc(pageable)
                .map(InquiryResponse::from);
    }

    @Transactional
    public InquiryResponse updateStatus(Long id, String status) {
        if (status == null || status.isBlank())
            throw new IllegalArgumentException("status 값이 필요합니다");
        Inquiry inquiry = inquiryRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("문의를 찾을 수 없습니다: " + id));

        try {
            inquiry.setStatus(InquiryStatus.valueOf(status));
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("유효하지 않은 상태값입니다: " + status);
        }
        Inquiry updated = inquiryRepository.save(inquiry);
        log.info("Inquiry status updated: id={}, status={}", id, status);

        return InquiryResponse.from(updated);
    }
}
