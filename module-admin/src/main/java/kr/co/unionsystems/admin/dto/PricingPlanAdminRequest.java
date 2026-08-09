package kr.co.unionsystems.admin.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PricingPlanAdminRequest {

    @NotBlank(message = "플랜명은 필수입니다")
    private String name;

    private String licenseType;

    private Integer price;

    private Integer originalPrice;

    private String priceDisplay;

    private String features;

    private String badge;

    private Boolean isPopular;

    private Integer sortOrder;

    private Boolean isActive;
}
