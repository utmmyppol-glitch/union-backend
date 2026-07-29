package kr.co.unionsystems.union.repository;
import kr.co.unionsystems.union.entity.History;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
@Repository("unionHistoryRepository")
public interface HistoryRepository extends JpaRepository<History, Long> {
    List<History> findAllByIsActiveTrueOrderBySortOrderAsc();
}
