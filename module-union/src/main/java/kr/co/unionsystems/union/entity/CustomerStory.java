package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseCustomerStory;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "UnionCustomerStory")
@Table(name = "customer_stories", schema = "union_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class CustomerStory extends BaseCustomerStory {
}
