package kr.co.unionsystems.dataware.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseClientLogo;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "DatawareClientLogo")
@Table(name = "client_logos", schema = "dataware_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class ClientLogo extends BaseClientLogo {
}
