package kr.co.unionsystems.dataware.repository;
import kr.co.unionsystems.dataware.entity.EducationSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
@Repository("datawareEducationSessionRepository")
public interface EducationSessionRepository extends JpaRepository<EducationSession, Long> {
    List<EducationSession> findAllByIsActiveTrueOrderBySortOrderAsc();
}
