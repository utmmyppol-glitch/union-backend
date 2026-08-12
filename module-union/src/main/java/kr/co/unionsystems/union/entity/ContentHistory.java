package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseContentHistory;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "UnionContentHistory")
@Table(name = "content_history", schema = "union_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class ContentHistory extends BaseContentHistory {
}
