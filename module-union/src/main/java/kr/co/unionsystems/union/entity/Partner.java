package kr.co.unionsystems.union.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "partners", schema = "union_schema")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class Partner {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    private String name;
    private String role;
    @Column(name = "logo_url") private String logoUrl;
    @Column(name = "website_url") private String websiteUrl;
    private Integer sortOrder;
    private Boolean isActive;
}
