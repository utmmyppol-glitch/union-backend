package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BasePageLayout;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "UnionPageLayout")
@Table(name = "page_layout", schema = "union_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class PageLayout extends BasePageLayout {
}
