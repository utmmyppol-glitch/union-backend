package kr.co.unionsystems.union.repository;

import kr.co.unionsystems.union.entity.CustomerStory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository("unionCustomerStoryRepository")
public interface CustomerStoryRepository extends JpaRepository<CustomerStory, Long> {

    Optional<CustomerStory> findBySlug(String slug);

    Page<CustomerStory> findByPublishedTrueOrderByCreatedAtDesc(Pageable pageable);

    Page<CustomerStory> findByIndustryAndPublishedTrueOrderByCreatedAtDesc(String industry, Pageable pageable);

    Page<CustomerStory> findAllByOrderByCreatedAtDesc(Pageable pageable);
}
