package kr.co.unionsystems.admin.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SiteConfigRequest {
    @NotBlank
    private String configKey;

    @NotBlank
    private String configValue;

    private String description;
}
