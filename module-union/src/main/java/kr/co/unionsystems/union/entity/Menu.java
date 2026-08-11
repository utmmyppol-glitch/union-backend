package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseMenu;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "UnionMenu")
@Table(name = "menu", schema = "union_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class Menu extends BaseMenu {
}
