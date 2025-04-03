package com.eventmanagement.eventms.repository;

import com.eventmanagement.eventms.model.Event;
import com.eventmanagement.eventms.model.Review;
import com.eventmanagement.eventms.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    Page<Review> findByEvent(Event event, Pageable pageable);
    Page<Review> findByUser(User user, Pageable pageable);
    Optional<Review> findByUserAndEvent(User user, Event event);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.event.id = ?1")
    Double getAverageRatingForEvent(Long eventId);
}