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
public class CustomerStoryAdminResponse {
    private Long id;
    private String company;
    private String slug;
    private String industry;
    private String title;
    private String content;
    private String thumbnailUrl;
    private String logoUrl;
    private String detailJson;
    private Boolean published;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
