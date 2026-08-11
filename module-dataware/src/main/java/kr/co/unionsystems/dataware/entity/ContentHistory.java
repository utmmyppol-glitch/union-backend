package kr.co.unionsystems.dataware.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseContentHistory;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "DatawareContentHistory")
@Table(name = "content_history", schema = "dataware_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class ContentHistory extends BaseContentHistory {
}
