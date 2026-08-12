package kr.co.unionsystems.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PostAdminResponse {
    private Long id;
    private String title;
    private String slug;
    private String content;
    private String excerpt;
    private String category;
    private String thumbnailUrl;
    private String detailJson;
    private Boolean published;
    private Integer viewCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
