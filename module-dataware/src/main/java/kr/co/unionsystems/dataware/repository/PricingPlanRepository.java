package kr.co.unionsystems.dataware.repository;
import kr.co.unionsystems.dataware.entity.PricingPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
@Repository("datawarePricingPlanRepository")
public interface PricingPlanRepository extends JpaRepository<PricingPlan, Long> {
    List<PricingPlan> findAllByIsActiveTrueOrderBySortOrderAsc();
}
