package kr.co.unionsystems.union.entity;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UpdateTimestamp;
import java.time.LocalDateTime;
@Entity(name = "UnionPageLayout")
@Table(name = "page_layout", schema = "union_schema")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class PageLayout {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "page_key", nullable = false, unique = true, length = 100) private String pageKey;
    @Column(length = 255) private String title;
    @Column(name = "layout_json", columnDefinition = "TEXT", nullable = false) private String layoutJson;
    @Column(length = 20, nullable = false) @Builder.Default private String status = "DRAFT";
    @Column(name = "updated_by") private Long updatedBy;
    @UpdateTimestamp private LocalDateTime updatedAt;
}
