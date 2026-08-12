package kr.co.unionsystems.union.service;

import kr.co.unionsystems.union.dto.InsightPublicResponse;
import kr.co.unionsystems.union.dto.InsightResponse;
import kr.co.unionsystems.union.entity.Insight;
import kr.co.unionsystems.union.entity.Insight.InsightStatus;
import kr.co.unionsystems.union.repository.InsightRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("unionInsightService")
@RequiredArgsConstructor
@Slf4j
public class InsightService {

    private final InsightRepository insightRepository;

    /**
     * 승인된 인사이트를 공개용 DTO로 반환 (사용자 API).
     * 관리자 전용 필드(status, approvedAt, approvedBy)는 노출하지 않는다.
     */
    @Transactional(readOnly = true)
    public Page<InsightPublicResponse> getApprovedInsights(Pageable pageable) {
        return insightRepository.findByStatusOrderByPublishedAtDesc(InsightStatus.APPROVED, pageable)
                .map(InsightPublicResponse::from);
    }

    /**
     * 상태별 인사이트를 관리자용 DTO로 반환 (관리자 API).
     */
    @Transactional(readOnly = true)
    public Page<InsightResponse> getInsightsByStatus(String status, Pageable pageable) {
        InsightStatus insightStatus = InsightStatus.valueOf(status.toUpperCase());
        return insightRepository.findByStatusOrderByPublishedAtDesc(insightStatus, pageable)
                .map(InsightResponse::from);
    }

    /**
     * 인사이트 승인 처리.
     * Entity 도메인 메서드를 통해 상태를 변경하고 승인자를 기록한다.
     */
    @Transactional
    public InsightResponse approve(Long id, String adminUsername) {
        Insight insight = insightRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("인사이트를 찾을 수 없습니다: " + id));

        insight.approve(adminUsername);

        log.info("Insight approved: id={}, by={}", id, adminUsername);
        return InsightResponse.from(insight);
    }

    /**
     * 인사이트 반려 처리.
     * 승인 이력을 초기화하고 상태를 REJECTED로 변경한다.
     */
    @Transactional
    public InsightResponse reject(Long id) {
        Insight insight = insightRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("인사이트를 찾을 수 없습니다: " + id));

        insight.reject();

        log.info("Insight rejected: id={}", id);
        return InsightResponse.from(insight);
    }
}
