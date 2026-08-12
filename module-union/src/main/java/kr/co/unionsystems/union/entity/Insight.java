package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * 인사이트(뉴스 기사) 엔티티.
 * <p>
 * 네이버 뉴스 API로 수집된 기사를 저장하며,
 * 관리자 승인(APPROVED) 후에만 사용자에게 노출된다.
 * </p>
 *
 * <b>상태 흐름:</b> PENDING → APPROVED / REJECTED
 */
@Entity(name = "UnionInsight")
@Table(name = "insights", schema = "union_schema")
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class Insight {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 소속 사이트 식별자 (멀티사이트 확장 대비, 기본값 "UNION") */
    @Column(nullable = false, length = 20)
    @Builder.Default
    private String siteId = "UNION";

    @Column(nullable = false, length = 500)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String summary;

    /** 원본 기사 URL — UNIQUE 제약으로 중복 수집 방지 */
    @Column(nullable = false, unique = true, length = 1000)
    private String sourceUrl;

    /** 언론사명 (도메인 매핑 테이블로 자동 해석) */
    @Column(length = 200)
    private String sourceName;

    private LocalDateTime publishedAt;

    /** OG(Open Graph) meta 태그에서 추출한 썸네일 이미지 URL */
    @Column(length = 1000)
    private String thumbnailUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private InsightStatus status = InsightStatus.PENDING;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    /** 승인 처리 일시 — 반려 시 null로 초기화 */
    private LocalDateTime approvedAt;

    /** 승인 처리 관리자 username — 반려 시 null로 초기화 */
    @Column(length = 100)
    private String approvedBy;

    // ── 도메인 메서드 ──────────────────────────────────────

    /**
     * 인사이트를 승인 처리한다.
     *
     * @param adminUsername 승인한 관리자 username
     */
    public void approve(String adminUsername) {
        this.status = InsightStatus.APPROVED;
        this.approvedAt = LocalDateTime.now();
        this.approvedBy = adminUsername;
    }

    /**
     * 인사이트를 반려 처리한다.
     * 승인 이력(approvedAt, approvedBy)을 초기화한다.
     */
    public void reject() {
        this.status = InsightStatus.REJECTED;
        this.approvedAt = null;
        this.approvedBy = null;
    }

    // ── 상태 열거형 ──────────────────────────────────────

    public enum InsightStatus {
        /** 수집 직후 — 관리자 심사 대기 */
        PENDING,
        /** 관리자 승인 완료 — 사용자에게 노출 */
        APPROVED,
        /** 관리자 반려 — 사용자에게 미노출 */
        REJECTED
    }
}
