package kr.co.unionsystems.union.repository;

import kr.co.unionsystems.union.entity.Insight;
import kr.co.unionsystems.union.entity.Insight.InsightStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository("unionInsightRepository")
public interface InsightRepository extends JpaRepository<Insight, Long> {

    Page<Insight> findByStatusOrderByPublishedAtDesc(InsightStatus status, Pageable pageable);

    boolean existsBySourceUrl(String sourceUrl);
}
