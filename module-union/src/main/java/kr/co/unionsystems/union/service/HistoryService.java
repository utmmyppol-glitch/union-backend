package kr.co.unionsystems.union.service;

import kr.co.unionsystems.union.entity.History;
import kr.co.unionsystems.union.repository.HistoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HistoryService {

    private final HistoryRepository historyRepository;

    @Transactional(readOnly = true)
    public List<History> getActiveHistories() {
        return historyRepository.findAllByIsActiveTrueOrderBySortOrderAsc();
    }
}
