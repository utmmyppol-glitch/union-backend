package kr.co.unionsystems.admin.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GlossaryAdminRequest {

    @NotBlank(message = "용어는 필수입니다")
    private String term;

    private String fullName;

    private String definition;

    private String category;

    private Integer sortOrder;

    private Boolean isActive;
}
