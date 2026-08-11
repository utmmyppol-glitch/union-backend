package kr.co.unionsystems.common.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@MappedSuperclass
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@SuperBuilder
public abstract class BaseMenu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 255)
    private String url;

    @Enumerated(EnumType.STRING)
    @Column(name = "menu_type", nullable = false, length = 20)
    @Builder.Default
    private MenuType menuType = MenuType.CONTENT;

    @Column(name = "sort_order")
    @Builder.Default
    private Integer sortOrder = 0;

    @Builder.Default
    private Integer depth = 0;

    @Column(name = "is_exposed")
    @Builder.Default
    private Boolean isExposed = true;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public enum MenuType {
        CONTENT, BOARD, LINK
    }
}
