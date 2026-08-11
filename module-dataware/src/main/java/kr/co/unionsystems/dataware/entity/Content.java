package kr.co.unionsystems.dataware.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseContent;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "DatawareContent")
@Table(name = "content", schema = "dataware_schema",
       uniqueConstraints = @UniqueConstraint(columnNames = {"menu_id", "region_key"}))
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class Content extends BaseContent {
}
