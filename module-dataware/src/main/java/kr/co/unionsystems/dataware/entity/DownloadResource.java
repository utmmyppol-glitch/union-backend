package kr.co.unionsystems.dataware.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "download_resources", schema = "dataware_schema")
@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class DownloadResource {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    private String title;
    @Column(columnDefinition = "TEXT") private String description;
    @Column(name = "file_type") private String fileType;
    private String thumbnail;
    @Column(name = "download_url") private String downloadUrl;
    private Integer sortOrder;
    private Boolean isActive;
}
