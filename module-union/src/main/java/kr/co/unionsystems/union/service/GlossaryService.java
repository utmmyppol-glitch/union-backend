package kr.co.unionsystems.union.service;

import kr.co.unionsystems.union.entity.GlossaryTerm;
import kr.co.unionsystems.union.repository.GlossaryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GlossaryService {

    private final GlossaryRepository glossaryRepository;

    @Transactional(readOnly = true)
    public List<GlossaryTerm> getActiveTerms() {
        return glossaryRepository.findAllByIsActiveTrueOrderBySortOrderAsc();
    }

    @Transactional(readOnly = true)
    public List<GlossaryTerm> getActiveTermsByCategory(String category) {
        return glossaryRepository.findByCategoryAndIsActiveTrueOrderBySortOrderAsc(category);
    }
}
