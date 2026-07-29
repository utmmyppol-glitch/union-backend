package kr.co.unionsystems.union.repository;
import kr.co.unionsystems.union.entity.Partner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
@Repository("unionPartnerRepository")
public interface PartnerRepository extends JpaRepository<Partner, Long> {
    List<Partner> findAllByIsActiveTrueOrderBySortOrderAsc();
}
