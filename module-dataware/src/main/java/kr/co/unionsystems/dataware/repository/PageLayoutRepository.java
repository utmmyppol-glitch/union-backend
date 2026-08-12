package kr.co.unionsystems.dataware.repository;
import kr.co.unionsystems.dataware.entity.PageLayout;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
@Repository("datawarePageLayoutRepository")
public interface PageLayoutRepository extends JpaRepository<PageLayout, Long> {
    Optional<PageLayout> findByPageKey(String pageKey);
}
