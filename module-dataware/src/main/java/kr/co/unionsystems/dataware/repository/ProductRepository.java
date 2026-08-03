package kr.co.unionsystems.dataware.repository;

import kr.co.unionsystems.dataware.entity.Product;
import kr.co.unionsystems.dataware.entity.Product.ProductCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository("datawareProductRepository")
public interface ProductRepository extends JpaRepository<Product, Long> {

    List<Product> findByPublishedTrueOrderBySortOrderAsc();

    List<Product> findByCategoryAndPublishedTrueOrderBySortOrderAsc(ProductCategory category);

    Optional<Product> findBySlug(String slug);

    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) ORDER BY p.sortOrder ASC")
    List<Product> searchByKeyword(@Param("keyword") String keyword);
}
