package kr.co.unionsystems.dataware.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseMenu;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "DatawareMenu")
@Table(name = "menu", schema = "dataware_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class Menu extends BaseMenu {
}
