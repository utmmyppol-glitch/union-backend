package kr.co.unionsystems.union.repository;
import kr.co.unionsystems.union.entity.GlossaryTerm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
@Repository("unionGlossaryRepository")
public interface GlossaryRepository extends JpaRepository<GlossaryTerm, Long> {
    List<GlossaryTerm> findAllByIsActiveTrueOrderBySortOrderAsc();
    List<GlossaryTerm> findByCategoryAndIsActiveTrueOrderBySortOrderAsc(String category);
}
