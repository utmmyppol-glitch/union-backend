package kr.co.unionsystems.admin.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HistoryAdminRequest {

    @NotBlank(message = "연도는 필수입니다")
    private String year;

    @NotBlank(message = "제목은 필수입니다")
    private String title;

    private String events;

    private Integer sortOrder;

    private Boolean isActive;
}
