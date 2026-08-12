package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseClientLogo;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "UnionClientLogo")
@Table(name = "client_logos", schema = "union_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class ClientLogo extends BaseClientLogo {
}
