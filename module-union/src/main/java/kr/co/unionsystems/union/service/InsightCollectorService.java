package kr.co.unionsystems.union.service;

import kr.co.unionsystems.union.entity.Insight;
import kr.co.unionsystems.union.repository.InsightRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class InsightCollectorService {

    private final NaverNewsService naverNewsService;
    private final InsightRepository insightRepository;

    // ── 1층: 검색 키워드 (네이버 API 질의어) ──
    private static final List<String> SEARCH_KEYWORDS = List.of(
            "유니온시스템즈", "엔코아", "ENCORA",
            "데이터 거버넌스", "데이터 품질", "마스터데이터", "MDM",
            "데이터 표준화", "데이터 아키텍처", "데이터 모델링", "메타데이터 관리",
            "소프트웨어 자산관리", "SAM 라이선스", "IT 자산관리", "라이선스 관리"
    );

    // ── 2층: 화이트리스트 (제목·요약에 최소 1개 포함해야 통과) ──
    private static final List<String> WHITELIST_KEYWORDS = List.of(
            "유니온시스템즈", "엔코아", "ENCORA",
            "데이터 거버넌스", "데이터 품질", "마스터데이터", "MDM", "데이터 표준",
            "데이터 모델", "메타데이터", "데이터 통합", "데이터 관리",
            "자산관리", "라이선스", "SAM", "거버넌스"
    );

    // ── 2층: 블랙리스트 (포함 시 제외) ──
    private static final List<String> BLACKLIST_KEYWORDS = List.of(
            "채용", "부고", "주가", "코스닥", "분양", "할인",
            "인사", "부동산", "연예", "스포츠"
    );

    private static final DateTimeFormatter PUB_DATE_FORMAT =
            DateTimeFormatter.ofPattern("EEE, dd MMM yyyy HH:mm:ss Z", Locale.ENGLISH);

    // ── 도메인 → 언론사명 매핑 ──
    private static final Map<String, String> SOURCE_NAME_MAP = Map.ofEntries(
            Map.entry("zdnet.co.kr", "ZDNet Korea"),
            Map.entry("etnews.com", "전자신문"),
            Map.entry("chosun.com", "조선일보"),
            Map.entry("joongang.co.kr", "중앙일보"),
            Map.entry("donga.com", "동아일보"),
            Map.entry("hankyung.com", "한국경제"),
            Map.entry("mk.co.kr", "매일경제"),
            Map.entry("sedaily.com", "서울경제"),
            Map.entry("edaily.co.kr", "이데일리"),
            Map.entry("mt.co.kr", "머니투데이"),
            Map.entry("dt.co.kr", "디지털타임스"),
            Map.entry("bloter.net", "블로터"),
            Map.entry("itworld.co.kr", "ITWorld Korea"),
            Map.entry("ddaily.co.kr", "디지털데일리"),
            Map.entry("newsis.com", "뉴시스"),
            Map.entry("yonhapnews.co.kr", "연합뉴스"),
            Map.entry("hani.co.kr", "한겨레"),
            Map.entry("kmib.co.kr", "국민일보"),
            Map.entry("biz.chosun.com", "조선비즈"),
            Map.entry("news.mt.co.kr", "머니투데이"),
            Map.entry("yna.co.kr", "연합뉴스"),
            Map.entry("inews24.com", "아이뉴스24"),
            Map.entry("businesspost.co.kr", "비즈니스포스트")
    );

    private static final String COLLECT_CRON = "0 0 7,19 * * *"; // 매일 07:00, 19:00

    @Scheduled(cron = COLLECT_CRON)
    public void collectInsights() {
        log.info("=== Insight collection started ===");
        int totalFetched = 0;
        int totalSaved = 0;
        int filteredByWhitelist = 0;
        int filteredByBlacklist = 0;
        int filteredByDuplicate = 0;

        for (String keyword : SEARCH_KEYWORDS) {
            List<NaverNewsService.NewsItem> items = naverNewsService.searchNews(keyword, 100);
            totalFetched += items.size();

            for (NaverNewsService.NewsItem item : items) {
                String text = (item.title() + " " + item.description()).toLowerCase();

                // 2층-화이트리스트: title+description에 최소 1개 포함
                if (!matchesWhitelist(text)) {
                    filteredByWhitelist++;
                    continue;
                }

                // 2층-블랙리스트: 포함 시 제외
                if (matchesBlacklist(text)) {
                    filteredByBlacklist++;
                    continue;
                }

                // 중복 제거: link 기준
                String url = item.originalLink().isBlank() ? item.link() : item.originalLink();
                if (url.isBlank() || insightRepository.existsBySourceUrl(url)) {
                    filteredByDuplicate++;
                    continue;
                }

                try {
                    LocalDateTime publishedAt = parsePubDate(item.pubDate());
                    if (publishedAt == null) {
                        publishedAt = LocalDateTime.now();
                    }

                    Insight insight = Insight.builder()
                            .siteId("UNION")
                            .title(item.title())
                            .summary(item.description())
                            .sourceUrl(url)
                            .sourceName(resolveSourceName(url))
                            .thumbnailUrl(fetchOgImage(url))
                            .publishedAt(publishedAt)
                            .status(Insight.InsightStatus.PENDING)
                            .build();

                    insightRepository.save(insight);
                    totalSaved++;
                    log.info("Saved insight: {}", insight.getTitle());
                } catch (Exception e) {
                    log.warn("Failed to save insight '{}': {}", item.title(), e.getMessage());
                }
            }
        }

        log.info("=== Insight collection finished: fetched={}, saved={}, " +
                        "filteredByWhitelist={}, filteredByBlacklist={}, filteredByDuplicate={} ===",
                totalFetched, totalSaved, filteredByWhitelist, filteredByBlacklist, filteredByDuplicate);
    }

    private boolean matchesWhitelist(String text) {
        for (String kw : WHITELIST_KEYWORDS) {
            if (text.contains(kw.toLowerCase())) return true;
        }
        return false;
    }

    private boolean matchesBlacklist(String text) {
        for (String kw : BLACKLIST_KEYWORDS) {
            if (text.contains(kw)) return true;
        }
        return false;
    }

    private String resolveSourceName(String url) {
        try {
            String host = java.net.URI.create(url).getHost();
            if (host == null) return url;
            // 정확히 매핑 테이블에 있으면 반환
            if (SOURCE_NAME_MAP.containsKey(host)) return SOURCE_NAME_MAP.get(host);
            // www. 제거 후 재시도
            String bare = host.startsWith("www.") ? host.substring(4) : host;
            if (SOURCE_NAME_MAP.containsKey(bare)) return SOURCE_NAME_MAP.get(bare);
            // 서브도메인 포함 전체 매칭 (news.mt.co.kr 등)
            for (Map.Entry<String, String> entry : SOURCE_NAME_MAP.entrySet()) {
                if (host.endsWith("." + entry.getKey()) || host.equals(entry.getKey())) {
                    return entry.getValue();
                }
            }
            // 매핑 없으면 도메인 그대로
            return bare;
        } catch (Exception e) {
            return url;
        }
    }

    private String fetchOgImage(String url) {
        try {
            Document doc = Jsoup.connect(url)
                    .userAgent("Mozilla/5.0")
                    .timeout(4000)
                    .ignoreContentType(true)
                    .get();
            String ogImage = doc.select("meta[property=og:image]").attr("content");
            return ogImage.isBlank() ? null : ogImage;
        } catch (Exception e) {
            log.debug("Failed to fetch og:image from '{}': {}", url, e.getMessage());
            return null;
        }
    }

    private LocalDateTime parsePubDate(String pubDate) {
        if (pubDate == null || pubDate.isBlank()) return null;
        try {
            return ZonedDateTime.parse(pubDate, PUB_DATE_FORMAT).toLocalDateTime();
        } catch (Exception e) {
            log.debug("Failed to parse pubDate '{}': {}", pubDate, e.getMessage());
            return null;
        }
    }
}
