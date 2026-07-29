package kr.co.unionsystems.dataware.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "pricing_plans", schema = "dataware_schema")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class PricingPlan {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    private String name;
    @Column(name = "license_type") private String licenseType;
    private Integer price;
    @Column(name = "original_price") private Integer originalPrice;
    @Column(name = "price_display") private String priceDisplay;
    @Column(columnDefinition = "TEXT") private String features;
    private String badge;
    @Column(name = "is_popular") private Boolean isPopular;
    private Integer sortOrder;
    private Boolean isActive;
}
