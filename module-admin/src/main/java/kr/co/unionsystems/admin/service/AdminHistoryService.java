package kr.co.unionsystems.admin.service;

import kr.co.unionsystems.admin.dto.HistoryAdminRequest;
import kr.co.unionsystems.admin.dto.HistoryAdminResponse;
import kr.co.unionsystems.union.entity.History;
import kr.co.unionsystems.union.repository.HistoryRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class AdminHistoryService {

    private final HistoryRepository historyRepo;
    private final SiteAccessValidator siteAccessValidator;

    public AdminHistoryService(
            @Qualifier("unionHistoryRepository") HistoryRepository historyRepo,
            SiteAccessValidator siteAccessValidator) {
        this.historyRepo = historyRepo;
        this.siteAccessValidator = siteAccessValidator;
    }

    @Transactional(readOnly = true)
    public List<HistoryAdminResponse> getAll(String site, String keyword) {
        siteAccessValidator.validateSiteAccess(site);
        String s = siteAccessValidator.normalizeSite(site);
        if (!"union".equals(s)) {
            throw new IllegalArgumentException("연혁 관리는 union 사이트에서만 가능합니다");
        }
        List<History> all = historyRepo.findAll(Sort.by("sortOrder"));
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            all = all.stream()
                    .filter(h -> (h.getTitle() != null && h.getTitle().toLowerCase().contains(kw))
                            || (h.getYear() != null && h.getYear().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
        }
        return all.stream().map(this::from).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public HistoryAdminResponse getOne(String site, Long id) {
        siteAccessValidator.validateSiteAccess(site);
        siteAccessValidator.normalizeSite(site);
        return historyRepo.findById(id).map(this::from)
                .orElseThrow(() -> new IllegalArgumentException("연혁을 찾을 수 없습니다: " + id));
    }

    @Transactional
    public HistoryAdminResponse create(String site, HistoryAdminRequest req) {
        siteAccessValidator.validateWriteAccess(site);
        String s = siteAccessValidator.normalizeSite(site);
        if (!"union".equals(s)) {
            throw new IllegalArgumentException("연혁 관리는 union 사이트에서만 가능합니다");
        }
        History history = History.builder()
                .year(req.getYear())
                .title(req.getTitle())
                .events(req.getEvents())
                .sortOrder(req.getSortOrder())
                .isActive(req.getIsActive() != null ? req.getIsActive() : true)
                .build();
        return from(historyRepo.save(history));
    }

    @Transactional
    public HistoryAdminResponse update(String site, Long id, HistoryAdminRequest req) {
        siteAccessValidator.validateWriteAccess(site);
        History history = historyRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("연혁을 찾을 수 없습니다: " + id));
        history.setYear(req.getYear());
        history.setTitle(req.getTitle());
        history.setEvents(req.getEvents());
        if (req.getSortOrder() != null) history.setSortOrder(req.getSortOrder());
        if (req.getIsActive() != null) history.setIsActive(req.getIsActive());
        return from(historyRepo.save(history));
    }

    @Transactional
    public HistoryAdminResponse toggleActive(String site, Long id, boolean isActive) {
        siteAccessValidator.validateWriteAccess(site);
        History history = historyRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("연혁을 찾을 수 없습니다: " + id));
        history.setIsActive(isActive);
        return from(historyRepo.save(history));
    }

    @Transactional
    public void delete(String site, Long id) {
        siteAccessValidator.validateWriteAccess(site);
        historyRepo.deleteById(id);
    }

    private HistoryAdminResponse from(History h) {
        return HistoryAdminResponse.builder()
                .id(h.getId())
                .year(h.getYear())
                .title(h.getTitle())
                .events(h.getEvents())
                .sortOrder(h.getSortOrder())
                .isActive(h.getIsActive())
                .build();
    }
}
