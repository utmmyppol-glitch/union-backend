package kr.co.unionsystems.dataware.service;

import kr.co.unionsystems.dataware.entity.PricingPlan;
import kr.co.unionsystems.dataware.repository.PricingPlanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PricingPlanService {

    private final PricingPlanRepository pricingPlanRepository;

    @Transactional(readOnly = true)
    public List<PricingPlan> getActivePlans() {
        return pricingPlanRepository.findAllByIsActiveTrueOrderBySortOrderAsc();
    }
}
