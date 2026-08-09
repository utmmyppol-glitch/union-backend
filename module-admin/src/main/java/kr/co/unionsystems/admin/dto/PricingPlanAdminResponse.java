package kr.co.unionsystems.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PricingPlanAdminResponse {
    private Long id;
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
