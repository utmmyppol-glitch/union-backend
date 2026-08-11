package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseSiteConfig;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "UnionSiteConfig")
@Table(name = "site_config", schema = "union_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class SiteConfig extends BaseSiteConfig {
}
