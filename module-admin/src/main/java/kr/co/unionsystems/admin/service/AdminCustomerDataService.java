package kr.co.unionsystems.admin.service;

import kr.co.unionsystems.admin.dto.DownloadAdminResponse;
import kr.co.unionsystems.admin.dto.EducationAdminResponse;
import kr.co.unionsystems.admin.dto.SeminarAdminResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.co.unionsystems.dataware.entity.Education;
import kr.co.unionsystems.dataware.entity.Seminar;

@Service
@Slf4j
public class AdminCustomerDataService {

    private final kr.co.unionsystems.dataware.repository.DownloadRepository datawareDownloadRepo;
    private final kr.co.unionsystems.dataware.repository.EducationRepository datawareEducationRepo;
    private final kr.co.unionsystems.dataware.repository.SeminarRepository datawareSeminarRepo;
    private final SiteAccessValidator siteAccessValidator;

    public AdminCustomerDataService(
            @Qualifier("datawareDownloadRepository") kr.co.unionsystems.dataware.repository.DownloadRepository datawareDownloadRepo,
            kr.co.unionsystems.dataware.repository.EducationRepository datawareEducationRepo,
            kr.co.unionsystems.dataware.repository.SeminarRepository datawareSeminarRepo,
            SiteAccessValidator siteAccessValidator) {
        this.datawareDownloadRepo = datawareDownloadRepo;
        this.datawareEducationRepo = datawareEducationRepo;
        this.datawareSeminarRepo = datawareSeminarRepo;
        this.siteAccessValidator = siteAccessValidator;
    }

    @Transactional(readOnly = true)
    public Page<DownloadAdminResponse> getDownloads(String site, Pageable pageable) {
        siteAccessValidator.validateSiteAccess(site);
        String normalized = siteAccessValidator.normalizeSite(site);

        if (!"dataware".equals(normalized)) {
            throw new IllegalArgumentException("다운로드 조회는 dataware 사이트에서만 가능합니다");
        }
        return datawareDownloadRepo.findAllByOrderByCreatedAtDesc(pageable)
                .map(this::toDatawareDownloadResponse);
    }

    @Transactional(readOnly = true)
    public Page<EducationAdminResponse> getEducations(String site, Pageable pageable) {
        siteAccessValidator.validateSiteAccess(site);
        String normalized = siteAccessValidator.normalizeSite(site);
        if (!"dataware".equals(normalized)) {
            throw new IllegalArgumentException("교육 신청은 dataware 사이트에서만 조회할 수 있습니다");
        }
        return datawareEducationRepo.findAllByOrderByCreatedAtDesc(pageable)
                .map(this::toEducationResponse);
    }

    @Transactional(readOnly = true)
    public Page<SeminarAdminResponse> getSeminars(String site, Pageable pageable) {
        siteAccessValidator.validateSiteAccess(site);
        String normalized = siteAccessValidator.normalizeSite(site);
        if (!"dataware".equals(normalized)) {
            throw new IllegalArgumentException("세미나 신청은 dataware 사이트에서만 조회할 수 있습니다");
        }
        return datawareSeminarRepo.findAllByOrderByCreatedAtDesc(pageable)
                .map(this::toSeminarResponse);
    }

    @Transactional
    public EducationAdminResponse updateEducationStatus(String site, Long id, String status) {
        siteAccessValidator.validateSiteAccess(site);
        if (!"dataware".equals(siteAccessValidator.normalizeSite(site)))
            throw new IllegalArgumentException("교육 신청은 dataware 사이트에서만 관리할 수 있습니다");
        if (status == null || status.isBlank())
            throw new IllegalArgumentException("status 값이 필요합니다");
        Education e = datawareEducationRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("교육 신청을 찾을 수 없습니다: " + id));
        try {
            e.setStatus(Education.EducationStatus.valueOf(status));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("유효하지 않은 상태값입니다: " + status);
        }
        return toEducationResponse(datawareEducationRepo.save(e));
    }

    @Transactional
    public void deleteEducation(String site, Long id) {
        siteAccessValidator.validateSiteAccess(site);
        if (!"dataware".equals(siteAccessValidator.normalizeSite(site)))
            throw new IllegalArgumentException("교육 신청은 dataware 사이트에서만 관리할 수 있습니다");
        datawareEducationRepo.deleteById(id);
    }

    @Transactional
    public SeminarAdminResponse updateSeminarStatus(String site, Long id, String status) {
        siteAccessValidator.validateSiteAccess(site);
        if (!"dataware".equals(siteAccessValidator.normalizeSite(site)))
            throw new IllegalArgumentException("세미나 신청은 dataware 사이트에서만 관리할 수 있습니다");
        if (status == null || status.isBlank())
            throw new IllegalArgumentException("status 값이 필요합니다");
        Seminar sm = datawareSeminarRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("세미나 신청을 찾을 수 없습니다: " + id));
        try {
            sm.setStatus(Seminar.SeminarStatus.valueOf(status));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("유효하지 않은 상태값입니다: " + status);
        }
        return toSeminarResponse(datawareSeminarRepo.save(sm));
    }

    @Transactional
    public void deleteSeminar(String site, Long id) {
        siteAccessValidator.validateSiteAccess(site);
        if (!"dataware".equals(siteAccessValidator.normalizeSite(site)))
            throw new IllegalArgumentException("세미나 신청은 dataware 사이트에서만 관리할 수 있습니다");
        datawareSeminarRepo.deleteById(id);
    }

    @Transactional
    public void deleteDownload(String site, Long id) {
        siteAccessValidator.validateSiteAccess(site);
        if (!"dataware".equals(siteAccessValidator.normalizeSite(site))) {
            throw new IllegalArgumentException("다운로드 삭제는 dataware 사이트에서만 가능합니다");
        }
        datawareDownloadRepo.deleteById(id);
    }

    private DownloadAdminResponse toDatawareDownloadResponse(kr.co.unionsystems.dataware.entity.Download d) {
        return DownloadAdminResponse.builder()
                .id(d.getId()).name(d.getName()).company(d.getCompany())
                .phone(d.getPhone()).email(d.getEmail()).fileType(d.getFileType())
                .createdAt(d.getCreatedAt())
                .build();
    }

    private EducationAdminResponse toEducationResponse(kr.co.unionsystems.dataware.entity.Education e) {
        return EducationAdminResponse.builder()
                .id(e.getId()).name(e.getName()).company(e.getCompany())
                .phone(e.getPhone()).email(e.getEmail()).position(e.getPosition())
                .preferredDate(e.getPreferredDate()).note(e.getNote())
                .status(e.getStatus().name()).createdAt(e.getCreatedAt())
                .build();
    }

    private SeminarAdminResponse toSeminarResponse(kr.co.unionsystems.dataware.entity.Seminar s) {
        return SeminarAdminResponse.builder()
                .id(s.getId()).name(s.getName()).company(s.getCompany())
                .phone(s.getPhone()).email(s.getEmail()).department(s.getDepartment())
                .preferredDate(s.getPreferredDate()).attendees(s.getAttendees())
                .topic(s.getTopic()).note(s.getNote())
                .status(s.getStatus().name()).createdAt(s.getCreatedAt())
                .build();
    }
}
