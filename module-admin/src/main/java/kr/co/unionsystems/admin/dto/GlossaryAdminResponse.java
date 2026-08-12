package kr.co.unionsystems.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GlossaryAdminResponse {
    private Long id;
    private String term;
    private String fullName;
    private String definition;
    private String category;
    private Integer sortOrder;
    private Boolean isActive;
}
