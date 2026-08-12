package kr.co.unionsystems.dataware.repository;

import kr.co.unionsystems.dataware.entity.Inquiry;
import kr.co.unionsystems.common.entity.BaseInquiry.InquiryStatus;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository("datawareInquiryRepository")
public interface InquiryRepository extends JpaRepository<Inquiry, Long> {

    Page<Inquiry> findAllByOrderByCreatedAtDesc(Pageable pageable);

    @org.springframework.data.jpa.repository.Query("SELECT i FROM DatawareInquiry i WHERE " +
            "(:status IS NULL OR i.status = :status) AND " +
            "(:kw IS NULL OR LOWER(i.name) LIKE LOWER(CONCAT('%', :kw, '%')) " +
            "OR LOWER(i.company) LIKE LOWER(CONCAT('%', :kw, '%')) " +
            "OR LOWER(i.email) LIKE LOWER(CONCAT('%', :kw, '%')) " +
            "OR LOWER(i.phone) LIKE LOWER(CONCAT('%', :kw, '%')) " +
            "OR LOWER(i.product) LIKE LOWER(CONCAT('%', :kw, '%'))) " +
            "ORDER BY i.createdAt DESC")
    Page<Inquiry> searchInquiries(
            @org.springframework.data.repository.query.Param("status") InquiryStatus status,
            @org.springframework.data.repository.query.Param("kw") String kw,
            Pageable pageable);



}
