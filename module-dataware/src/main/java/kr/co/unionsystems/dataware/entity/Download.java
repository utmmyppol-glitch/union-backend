package kr.co.unionsystems.dataware.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseDownload;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "DatawareDownload")
@Table(name = "downloads", schema = "dataware_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class Download extends BaseDownload {

    private Boolean consentThirdParty;
}
