package kr.co.unionsystems.union.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseInquiry;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "UnionInquiry")
@Table(name = "inquiries", schema = "union_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class Inquiry extends BaseInquiry {
}
