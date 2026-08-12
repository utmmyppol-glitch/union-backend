package kr.co.unionsystems.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HistoryAdminResponse {
    private Long id;
    private String year;
    private String title;
    private String events;
    private Integer sortOrder;
    private Boolean isActive;
}
