package kr.co.unionsystems.union.repository;
import kr.co.unionsystems.union.entity.PageLayout;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
@Repository("unionPageLayoutRepository")
public interface PageLayoutRepository extends JpaRepository<PageLayout, Long> {
    Optional<PageLayout> findByPageKey(String pageKey);
}
