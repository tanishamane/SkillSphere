package com.skillsphere.repository;

import com.skillsphere.entity.MentorshipGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MentorshipGoalRepository extends JpaRepository<MentorshipGoal, Long> {

    @Query("select g from MentorshipGoal g join fetch g.assignment a " +
           "where a.id = :assignmentId order by g.createdAt desc")
    List<MentorshipGoal> findByAssignmentIdOrderByCreatedAtDesc(@Param("assignmentId") Long assignmentId);
}
