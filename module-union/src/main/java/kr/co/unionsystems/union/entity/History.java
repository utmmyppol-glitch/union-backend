package kr.co.unionsystems.union.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "history", schema = "union_schema")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class History {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    private String year;
    private String title;
    @Column(columnDefinition = "TEXT") private String events;
    private Integer sortOrder;
    private Boolean isActive;
}
