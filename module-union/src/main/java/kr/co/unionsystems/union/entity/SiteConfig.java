package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity(name = "UnionSiteConfig")
@Table(name = "site_config", schema = "union_schema")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SiteConfig {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "config_key", nullable = false, unique = true, length = 100)
    private String configKey;

    @Column(name = "config_value", columnDefinition = "TEXT", nullable = false)
    private String configValue;

    @Column(length = 255)
    private String description;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
