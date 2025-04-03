package com.eventmanagement.eventms.repository;

import com.eventmanagement.eventms.model.Event;
import com.eventmanagement.eventms.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {
    Page<Event> findByPublishedTrue(Pageable pageable);
    Page<Event> findByOrganizer(User organizer, Pageable pageable);
    Page<Event> findByCategory(Event.EventCategory category, Pageable pageable);

    @Query("SELECT e FROM Event e WHERE e.published = true AND e.startDateTime > ?1 ORDER BY e.startDateTime ASC")
    Page<Event> findUpcomingEvents(LocalDateTime now, Pageable pageable);

    @Query("SELECT e FROM Event e WHERE e.published = true AND e.title LIKE %?1% OR e.description LIKE %?1%")
    Page<Event> searchEvents(String keyword, Pageable pageable);
}