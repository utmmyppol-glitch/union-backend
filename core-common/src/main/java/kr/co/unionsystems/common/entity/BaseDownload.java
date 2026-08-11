package kr.co.unionsystems.common.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@MappedSuperclass
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@SuperBuilder
public abstract class BaseDownload {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String company;

    @Column(nullable = false)
    private String phone;

    @Column(nullable = false)
    private String email;

    private String fileType;

    private Boolean consentPrivacy;

    private Boolean consentMarketing;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;
}
