package com.eventmanagement.eventms.repository;

import com.eventmanagement.eventms.model.Booking;
import com.eventmanagement.eventms.model.Event;
import com.eventmanagement.eventms.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findByUser(User user);
    Page<Booking> findByUser(User user, Pageable pageable);
    Page<Booking> findByEvent(Event event, Pageable pageable);
    Optional<Booking> findByBookingNumber(String bookingNumber);

    @Query("SELECT COUNT(b) FROM Booking b WHERE b.event.id = ?1 AND b.status = 'CONFIRMED'")
    Long countConfirmedBookingsByEvent(Long eventId);

    @Query("SELECT b FROM Booking b WHERE b.event.organizer.id = ?1")
    Page<Booking> findBookingsByOrganizer(Long organizerId, Pageable pageable);
}