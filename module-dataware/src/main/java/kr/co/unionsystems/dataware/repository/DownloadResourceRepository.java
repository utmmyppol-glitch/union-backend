package kr.co.unionsystems.dataware.repository;
import kr.co.unionsystems.dataware.entity.DownloadResource;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
@Repository("datawareDownloadResourceRepository")
public interface DownloadResourceRepository extends JpaRepository<DownloadResource, Long> {
    List<DownloadResource> findAllByIsActiveTrueOrderBySortOrderAsc();
}
