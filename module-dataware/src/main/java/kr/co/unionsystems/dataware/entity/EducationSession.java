package kr.co.unionsystems.dataware.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "education_sessions", schema = "dataware_schema")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class EducationSession {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    private String title;
    private String date;
    private String thumbnail;
    private String tag;
    private String status;
    @Column(columnDefinition = "TEXT") private String description;
    private String location;
    private Integer sortOrder;
    private Boolean isActive;
}
