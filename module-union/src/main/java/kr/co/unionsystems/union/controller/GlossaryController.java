package kr.co.unionsystems.union.controller;

import kr.co.unionsystems.union.entity.GlossaryTerm;
import kr.co.unionsystems.union.service.GlossaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController("unionGlossaryController")
@RequestMapping("/api/union")
@RequiredArgsConstructor
public class GlossaryController {

    private final GlossaryService glossaryService;

    @GetMapping("/glossary")
    public ResponseEntity<List<GlossaryTerm>> getGlossary() {
        return ResponseEntity.ok(glossaryService.getActiveTerms());
    }
}
