package kr.co.unionsystems.common.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@MappedSuperclass
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@SuperBuilder
public abstract class BaseClientLogo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String logoUrl;

    private Integer sortOrder;

    @Builder.Default
    private Boolean isActive = true;

    @Builder.Default
    private Boolean showOnHome = false;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;
}
