package kr.co.unionsystems.dataware.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BasePageLayout;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "DatawarePageLayout")
@Table(name = "page_layout", schema = "dataware_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class PageLayout extends BasePageLayout {
}
