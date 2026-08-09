package kr.co.unionsystems.union.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 네이버 클라우드 플랫폼(NCP) 뉴스 검색 API 클라이언트.
 * <p>
 * API 키가 미설정 시 빈 목록을 반환하여 애플리케이션 기동에 영향을 주지 않는다.
 * 응답의 HTML 엔티티/태그는 {@link #stripHtml(String)}로 제거한다.
 * </p>
 */
@Service
@Slf4j
public class NaverNewsService {

    private static final String SEARCH_URL = "https://naverapihub.apigw.ntruss.com/search/v1/news";

    private final String apiKeyId;
    private final String apiKey;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public NaverNewsService(
            @Value("${naver.api.key-id:}") String apiKeyId,
            @Value("${naver.api.key:}") String apiKey) {
        this.apiKeyId = apiKeyId;
        this.apiKey = apiKey;
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    public List<NewsItem> searchNews(String query, int display) {
        if (apiKeyId.isBlank() || apiKey.isBlank()) {
            log.warn("NAVER API keys not configured - skipping search for '{}'", query);
            return Collections.emptyList();
        }

        try {
            URI uri = UriComponentsBuilder.fromHttpUrl(SEARCH_URL)
                    .queryParam("query", query)
                    .queryParam("display", display)
                    .queryParam("sort", "date")
                    .encode()
                    .build()
                    .toUri();

            HttpHeaders headers = new HttpHeaders();
            headers.set("X-NCP-APIGW-API-KEY-ID", apiKeyId);
            headers.set("X-NCP-APIGW-API-KEY", apiKey);

            RequestEntity<Void> request = RequestEntity.get(uri).headers(headers).build();
            ResponseEntity<String> response = restTemplate.exchange(request, String.class);

            return parseItems(response.getBody());
        } catch (Exception e) {
            log.error("NAVER news search failed for query '{}': {}", query, e.getMessage());
            return Collections.emptyList();
        }
    }

    private List<NewsItem> parseItems(String json) {
        List<NewsItem> items = new ArrayList<>();
        try {
            JsonNode root = objectMapper.readTree(json);
            JsonNode itemsNode = root.get("items");
            if (itemsNode == null || !itemsNode.isArray()) return items;

            for (JsonNode node : itemsNode) {
                items.add(new NewsItem(
                        stripHtml(node.path("title").asText("")),
                        stripHtml(node.path("description").asText("")),
                        node.path("originallink").asText(""),
                        node.path("link").asText(""),
                        node.path("pubDate").asText("")
                ));
            }
        } catch (Exception e) {
            log.error("Failed to parse NAVER news response: {}", e.getMessage());
        }
        return items;
    }

    private String stripHtml(String html) {
        return html.replaceAll("<[^>]*>", "").replaceAll("&[a-z]+;", " ").trim();
    }

    /** 네이버 뉴스 검색 결과 단건 DTO */
    public record NewsItem(
            String title,
            String description,
            String originalLink,
            String link,
            String pubDate
    ) {}
}
