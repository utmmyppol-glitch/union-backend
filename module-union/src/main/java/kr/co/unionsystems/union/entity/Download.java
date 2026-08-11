package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseDownload;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "UnionDownload")
@Table(name = "downloads", schema = "union_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class Download extends BaseDownload {
}
