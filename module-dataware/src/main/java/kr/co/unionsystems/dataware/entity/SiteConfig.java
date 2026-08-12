package kr.co.unionsystems.dataware.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseSiteConfig;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "DatawareSiteConfig")
@Table(name = "site_config", schema = "dataware_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class SiteConfig extends BaseSiteConfig {
}
