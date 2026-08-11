package kr.co.unionsystems.common.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@MappedSuperclass
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@SuperBuilder
public abstract class BaseContentHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "content_id")
    private Long contentId;

    @Column(name = "body_html", columnDefinition = "TEXT")
    private String bodyHtml;

    @Column(name = "edited_by")
    private Long editedBy;

    @Column(name = "edited_at")
    @Builder.Default
    private LocalDateTime editedAt = LocalDateTime.now();
}
