package kr.co.unionsystems.union.controller;

import kr.co.unionsystems.union.entity.History;
import kr.co.unionsystems.union.service.HistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController("unionHistoryController")
@RequestMapping("/api/union")
@RequiredArgsConstructor
public class HistoryController {

    private final HistoryService historyService;

    @GetMapping("/history")
    public ResponseEntity<List<History>> getHistories() {
        return ResponseEntity.ok(historyService.getActiveHistories());
    }
}
