package kr.co.unionsystems.union.dto;

import kr.co.unionsystems.union.entity.Insight;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 사용자(프론트) 공개용 인사이트 응답 DTO.
 * <p>
 * 관리자 전용 필드(status, approvedAt, approvedBy)를 제외하여
 * 승인된 뉴스 인사이트만 클라이언트에 안전하게 노출한다.
 * </p>
 */
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InsightPublicResponse {

    /** 인사이트 고유 식별자 */
    private Long id;

    /** 뉴스 기사 제목 (HTML 태그 제거된 텍스트) */
    private String title;

    /** 뉴스 기사 요약 (HTML 태그 제거된 텍스트) */
    private String summary;

    /** 언론사명 (예: "ZDNet Korea", "전자신문") */
    private String sourceName;

    /** 원본 기사 URL */
    private String sourceUrl;

    /** OG(Open Graph) 이미지 URL — 기사 썸네일 */
    private String thumbnailUrl;

    /** 기사 발행 일시 */
    private LocalDateTime publishedAt;

    /**
     * Entity → 공개 DTO 변환 팩토리 메서드.
     * 관리자 전용 필드는 의도적으로 매핑하지 않는다.
     */
    public static InsightPublicResponse from(Insight insight) {
        return InsightPublicResponse.builder()
                .id(insight.getId())
                .title(insight.getTitle())
                .summary(insight.getSummary())
                .sourceName(insight.getSourceName())
                .sourceUrl(insight.getSourceUrl())
                .thumbnailUrl(insight.getThumbnailUrl())
                .publishedAt(insight.getPublishedAt())
                .build();
    }
}
