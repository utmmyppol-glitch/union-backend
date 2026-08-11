package kr.co.unionsystems.dataware.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseCustomerStory;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "DatawareCustomerStory")
@Table(name = "customer_stories", schema = "dataware_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class CustomerStory extends BaseCustomerStory {
}
