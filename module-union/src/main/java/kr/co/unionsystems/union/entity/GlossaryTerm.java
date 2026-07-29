package kr.co.unionsystems.union.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "glossary", schema = "union_schema")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class GlossaryTerm {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    private String term;
    @Column(name = "full_name") private String fullName;
    @Column(columnDefinition = "TEXT") private String definition;
    private String category;
    private Integer sortOrder;
    private Boolean isActive;
}
