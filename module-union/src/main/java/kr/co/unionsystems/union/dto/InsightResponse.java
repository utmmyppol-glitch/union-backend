package kr.co.unionsystems.union.dto;

import kr.co.unionsystems.union.entity.Insight;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 관리자(백오피스)용 인사이트 응답 DTO.
 * <p>
 * 승인 상태·승인자 등 관리 필드를 포함하여
 * 관리자가 인사이트를 심사·관리할 수 있도록 한다.
 * </p>
 *
 * @see InsightPublicResponse 사용자 공개용 DTO (관리 필드 제외)
 */
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InsightResponse {

    /** 인사이트 고유 식별자 */
    private Long id;

    /** 뉴스 기사 제목 */
    private String title;

    /** 뉴스 기사 요약 */
    private String summary;

    /** 언론사명 (예: "ZDNet Korea", "전자신문") */
    private String sourceName;

    /** 원본 기사 URL */
    private String sourceUrl;

    /** OG(Open Graph) 이미지 URL — 기사 썸네일 */
    private String thumbnailUrl;

    /** 기사 발행 일시 */
    private LocalDateTime publishedAt;

    /** 승인 상태 (PENDING / APPROVED / REJECTED) */
    private String status;

    /** 수집 일시 (최초 저장 시각) */
    private LocalDateTime createdAt;

    /** 승인 처리 일시 — 미승인 시 null */
    private LocalDateTime approvedAt;

    /** 승인 처리 관리자 username — 미승인 시 null */
    private String approvedBy;

    /**
     * Entity → 관리자용 DTO 변환 팩토리 메서드.
     * 승인/반려 상태 포함 전체 필드를 매핑한다.
     */
    public static InsightResponse from(Insight insight) {
        return InsightResponse.builder()
                .id(insight.getId())
                .title(insight.getTitle())
                .summary(insight.getSummary())
                .sourceName(insight.getSourceName())
                .sourceUrl(insight.getSourceUrl())
                .thumbnailUrl(insight.getThumbnailUrl())
                .publishedAt(insight.getPublishedAt())
                .status(insight.getStatus().name())
                .createdAt(insight.getCreatedAt())
                .approvedAt(insight.getApprovedAt())
                .approvedBy(insight.getApprovedBy())
                .build();
    }
}
