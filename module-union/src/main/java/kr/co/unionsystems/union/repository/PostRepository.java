package kr.co.unionsystems.union.repository;

import kr.co.unionsystems.union.entity.Post;
import kr.co.unionsystems.union.entity.Post.PostCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository("unionPostRepository")
public interface PostRepository extends JpaRepository<Post, Long> {

    Optional<Post> findBySlug(String slug);

    Page<Post> findByPublishedTrueOrderByCreatedAtDesc(Pageable pageable);

    Page<Post> findByCategoryAndPublishedTrueOrderByCreatedAtDesc(PostCategory category, Pageable pageable);

    Page<Post> findAllByOrderByCreatedAtDesc(Pageable pageable);

    Page<Post> findByCategoryOrderByCreatedAtDesc(PostCategory category, Pageable pageable);

    @Query("SELECT p FROM UnionPost p WHERE LOWER(p.title) LIKE LOWER(CONCAT('%', :keyword, '%')) ORDER BY p.createdAt DESC")
    Page<Post> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);
}
