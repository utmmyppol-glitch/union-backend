package kr.co.unionsystems.admin.dto;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

/**
 * 관리자(백오피스)용 문의 응답 DTO.
 * <p>
 * 고객이 홈페이지 문의 폼으로 접수한 내용과
 * 관리자 처리 상태(담당자·상태)를 함께 반환한다.
 * </p>
 */
@Getter
@Builder
public class InquiryAdminResponse {

    /** 문의 고유 식별자 */
    private Long id;

    /** 고객 이름 */
    private String name;

    /** 고객 회사명 */
    private String company;

    /** 고객 연락처 */
    private String phone;

    /** 고객 이메일 */
    private String email;

    /** 문의 내용 */
    private String message;

    /** 관심 제품 */
    private String product;

    /** 처리 상태 (NEW / IN_PROGRESS / COMPLETED) */
    private String status;

    /** 담당자 username */
    private String assignee;

    /** 개인정보 수집·이용 동의 여부 */
    private Boolean consentPrivacy;

    /** 접수 일시 */
    private LocalDateTime createdAt;

    /** 최종 수정 일시 */
    private LocalDateTime updatedAt;
}
