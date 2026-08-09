package kr.co.unionsystems.admin.service;

import kr.co.unionsystems.admin.dto.GlossaryAdminRequest;
import kr.co.unionsystems.admin.dto.GlossaryAdminResponse;
import kr.co.unionsystems.union.entity.GlossaryTerm;
import kr.co.unionsystems.union.repository.GlossaryRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class AdminGlossaryService {

    private final GlossaryRepository glossaryRepo;
    private final SiteAccessValidator siteAccessValidator;

    public AdminGlossaryService(
            @Qualifier("unionGlossaryRepository") GlossaryRepository glossaryRepo,
            SiteAccessValidator siteAccessValidator) {
        this.glossaryRepo = glossaryRepo;
        this.siteAccessValidator = siteAccessValidator;
    }

    @Transactional(readOnly = true)
    public List<GlossaryAdminResponse> getAll(String site, String keyword) {
        siteAccessValidator.validateSiteAccess(site);
        String s = siteAccessValidator.normalizeSite(site);
        if (!"union".equals(s)) {
            throw new IllegalArgumentException("용어 관리는 union 사이트에서만 가능합니다");
        }
        List<GlossaryTerm> all = glossaryRepo.findAll(Sort.by("sortOrder"));
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.trim().toLowerCase();
            all = all.stream()
                    .filter(g -> (g.getTerm() != null && g.getTerm().toLowerCase().contains(kw))
                            || (g.getFullName() != null && g.getFullName().toLowerCase().contains(kw))
                            || (g.getCategory() != null && g.getCategory().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
        }
        return all.stream().map(this::from).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public GlossaryAdminResponse getOne(String site, Long id) {
        siteAccessValidator.validateSiteAccess(site);
        siteAccessValidator.normalizeSite(site);
        return glossaryRepo.findById(id).map(this::from)
                .orElseThrow(() -> new IllegalArgumentException("용어를 찾을 수 없습니다: " + id));
    }

    @Transactional
    public GlossaryAdminResponse create(String site, GlossaryAdminRequest req) {
        siteAccessValidator.validateWriteAccess(site);
        String s = siteAccessValidator.normalizeSite(site);
        if (!"union".equals(s)) {
            throw new IllegalArgumentException("용어 관리는 union 사이트에서만 가능합니다");
        }
        GlossaryTerm term = GlossaryTerm.builder()
                .term(req.getTerm())
                .fullName(req.getFullName())
                .definition(req.getDefinition())
                .category(req.getCategory())
                .sortOrder(req.getSortOrder())
                .isActive(req.getIsActive() != null ? req.getIsActive() : true)
                .build();
        return from(glossaryRepo.save(term));
    }

    @Transactional
    public GlossaryAdminResponse update(String site, Long id, GlossaryAdminRequest req) {
        siteAccessValidator.validateWriteAccess(site);
        GlossaryTerm term = glossaryRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("용어를 찾을 수 없습니다: " + id));
        term.setTerm(req.getTerm());
        term.setFullName(req.getFullName());
        term.setDefinition(req.getDefinition());
        term.setCategory(req.getCategory());
        if (req.getSortOrder() != null) term.setSortOrder(req.getSortOrder());
        if (req.getIsActive() != null) term.setIsActive(req.getIsActive());
        return from(glossaryRepo.save(term));
    }

    @Transactional
    public GlossaryAdminResponse toggleActive(String site, Long id, boolean isActive) {
        siteAccessValidator.validateWriteAccess(site);
        GlossaryTerm term = glossaryRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("용어를 찾을 수 없습니다: " + id));
        term.setIsActive(isActive);
        return from(glossaryRepo.save(term));
    }

    @Transactional
    public void delete(String site, Long id) {
        siteAccessValidator.validateWriteAccess(site);
        glossaryRepo.deleteById(id);
    }

    private GlossaryAdminResponse from(GlossaryTerm g) {
        return GlossaryAdminResponse.builder()
                .id(g.getId())
                .term(g.getTerm())
                .fullName(g.getFullName())
                .definition(g.getDefinition())
                .category(g.getCategory())
                .sortOrder(g.getSortOrder())
                .isActive(g.getIsActive())
                .build();
    }
}
