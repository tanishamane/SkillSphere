package com.skillsphere.repository;

import com.skillsphere.entity.MentorshipFeedback;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface MentorshipFeedbackRepository extends JpaRepository<MentorshipFeedback, Long> {

    @Query("select f from MentorshipFeedback f join fetch f.session s join fetch f.author where s.id = :sessionId")
    Optional<MentorshipFeedback> findBySessionId(@Param("sessionId") Long sessionId);

    boolean existsBySessionId(Long sessionId);
}
