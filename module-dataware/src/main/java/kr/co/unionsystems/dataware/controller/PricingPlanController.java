package kr.co.unionsystems.dataware.controller;

import kr.co.unionsystems.dataware.entity.PricingPlan;
import kr.co.unionsystems.dataware.service.PricingPlanService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController("datawarePricingPlanController")
@RequestMapping("/api/dataware/pricing-plans")
@RequiredArgsConstructor
public class PricingPlanController {

    private final PricingPlanService pricingPlanService;

    @GetMapping
    public ResponseEntity<List<PricingPlan>> getPricingPlans() {
        return ResponseEntity.ok(pricingPlanService.getActivePlans());
    }
}
