package kr.co.unionsystems.admin.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * /api/admin/{site}/** 요청에 대해 사이트·역할 기반 접근 제어를 수행한다.
 *
 * - SUPER(site=null): 모든 사이트·엔드포인트 접근 가능
 * - VIEWER: 자신의 site에 해당하는 다운로드 이력 조회(GET /api/admin/{site}/downloads)만 허용
 */
@Component
public class AdminAccessFilter extends OncePerRequestFilter {

    private static final Pattern ADMIN_SITE_PATTERN =
            Pattern.compile("^/api/admin/(union|dataware)/(.*)$", Pattern.CASE_INSENSITIVE);

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getServletPath();
        // /api/admin/login 등 {site} 없는 경로는 이 필터 대상 아님
        return !ADMIN_SITE_PATTERN.matcher(path).matches();
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !(auth.getPrincipal() instanceof AdminPrincipal principal)) {
            filterChain.doFilter(request, response);
            return;
        }

        String path = request.getServletPath();
        Matcher matcher = ADMIN_SITE_PATTERN.matcher(path);
        if (!matcher.matches()) {
            filterChain.doFilter(request, response);
            return;
        }

        String requestedSite = matcher.group(1).toUpperCase(); // UNION or DATAWARE
        String role = principal.getRole();
        String adminSite = principal.getSite(); // null이면 SUPER

        // SUPER(site=null) → 전체 접근
        if (adminSite == null) {
            filterChain.doFilter(request, response);
            return;
        }

        // 사이트 불일치 → 차단
        if (!adminSite.equalsIgnoreCase(requestedSite)) {
            sendForbidden(response, "해당 사이트에 대한 접근 권한이 없습니다.");
            return;
        }

        // VIEWER → 다운로드 이력 조회(GET)만 허용
        if ("VIEWER".equals(role)) {
            String subPath = matcher.group(2); // downloads, menus, contents ...
            boolean isDownloadsGet = "GET".equalsIgnoreCase(request.getMethod())
                    && subPath.startsWith("downloads");

            if (!isDownloadsGet) {
                sendForbidden(response, "다운로드 이력 조회만 가능합니다.");
                return;
            }
        }

        filterChain.doFilter(request, response);
    }

    private void sendForbidden(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpStatus.FORBIDDEN.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        objectMapper.writeValue(response.getOutputStream(),
                Map.of("status", 403,
                       "message", message,
                       "timestamp", LocalDateTime.now().toString()));
    }
}
