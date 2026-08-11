package kr.co.unionsystems.dataware.entity;

import jakarta.persistence.*;
import kr.co.unionsystems.common.entity.BaseInquiry;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity(name = "DatawareInquiry")
@Table(name = "inquiries", schema = "dataware_schema")
@Getter @Setter @NoArgsConstructor
@SuperBuilder
public class Inquiry extends BaseInquiry {

    private Boolean consentThirdParty;
}
