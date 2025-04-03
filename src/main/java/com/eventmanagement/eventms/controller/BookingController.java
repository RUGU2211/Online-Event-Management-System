package com.eventmanagement.eventms.controller;

import com.eventmanagement.eventms.dto.BookingDTO;
import com.eventmanagement.eventms.dto.EventDTO;
import com.eventmanagement.eventms.dto.PaymentDTO;
import com.eventmanagement.eventms.security.services.UserDetailsImpl;
import com.eventmanagement.eventms.service.BookingService;
import com.eventmanagement.eventms.service.EventService;
import com.eventmanagement.eventms.service.PaymentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;
    private final EventService eventService;
    private final PaymentService paymentService;

    @GetMapping("/bookings")
    @PreAuthorize("hasRole('ATTENDEE') or hasRole('ADMIN')")
    public ResponseEntity<Page<BookingDTO>> getUserBookings(
            Authentication authentication,
            @PageableDefault(size = 10) Pageable pageable) {

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        Page<BookingDTO> bookings = bookingService.getBookingsByUser(userDetails.getId(), pageable);
        return ResponseEntity.ok(bookings);
    }

    @PostMapping("/bookings")
    @PreAuthorize("hasRole('ATTENDEE') or hasRole('ADMIN')")
    public ResponseEntity<BookingDTO> createBooking(
            @Valid @RequestBody BookingDTO bookingDTO,
            Authentication authentication) {

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        BookingDTO createdBooking = bookingService.createBooking(bookingDTO, userDetails.getId());
        return ResponseEntity.ok(createdBooking);
    }

    @GetMapping("/bookings/{id}")
    @PreAuthorize("hasAnyRole('ATTENDEE', 'ORGANIZER', 'ADMIN')")
    public ResponseEntity<BookingDTO> getBookingById(
            @PathVariable Long id,
            Authentication authentication) {

        BookingDTO booking = bookingService.getBookingById(id);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        // Check if user is the booking owner, event organizer, or admin
        if (!booking.getUserId().equals(userDetails.getId())) {
            EventDTO event = eventService.getEventById(booking.getEventId());
            if (!event.getOrganizerId().equals(userDetails.getId()) &&
                    !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
                return ResponseEntity.status(403).build();
            }
        }

        return ResponseEntity.ok(booking);
    }

    @GetMapping("/bookings/number/{bookingNumber}")
    @PreAuthorize("hasAnyRole('ATTENDEE', 'ORGANIZER', 'ADMIN')")
    public ResponseEntity<BookingDTO> getBookingByNumber(
            @PathVariable String bookingNumber,
            Authentication authentication) {

        BookingDTO booking = bookingService.getBookingByNumber(bookingNumber);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        // Check if user is the booking owner, event organizer, or admin
        if (!booking.getUserId().equals(userDetails.getId())) {
            EventDTO event = eventService.getEventById(booking.getEventId());
            if (!event.getOrganizerId().equals(userDetails.getId()) &&
                    !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
                return ResponseEntity.status(403).build();
            }
        }

        return ResponseEntity.ok(booking);
    }

    @PutMapping("/bookings/{id}/cancel")
    @PreAuthorize("hasRole('ATTENDEE') or hasRole('ADMIN')")
    public ResponseEntity<BookingDTO> cancelBooking(
            @PathVariable Long id,
            Authentication authentication) {

        BookingDTO booking = bookingService.getBookingById(id);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        // Check if user is the booking owner or admin
        if (!booking.getUserId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        BookingDTO cancelledBooking = bookingService.cancelBooking(id);
        return ResponseEntity.ok(cancelledBooking);
    }

    @GetMapping("/organizer/bookings/event/{eventId}")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<Page<BookingDTO>> getBookingsByEvent(
            @PathVariable Long eventId,
            @PageableDefault(size = 10) Pageable pageable,
            Authentication authentication) {

        // Check if user is the event organizer or admin
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        EventDTO event = eventService.getEventById(eventId);

        if (!event.getOrganizerId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        Page<BookingDTO> bookings = bookingService.getBookingsByEvent(eventId, pageable);
        return ResponseEntity.ok(bookings);
    }

    @GetMapping("/organizer/bookings")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<Page<BookingDTO>> getOrganizerBookings(
            Authentication authentication,
            @PageableDefault(size = 10) Pageable pageable) {

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        Page<BookingDTO> bookings = bookingService.getBookingsByOrganizer(userDetails.getId(), pageable);
        return ResponseEntity.ok(bookings);
    }

    @PostMapping("/bookings/{id}/create-payment-order")
    @PreAuthorize("hasRole('ATTENDEE') or hasRole('ADMIN')")
    public ResponseEntity<?> createPaymentOrder(
            @PathVariable Long id,
            Authentication authentication) {

        BookingDTO booking = bookingService.getBookingById(id);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        // Check if user is the booking owner or admin
        if (!booking.getUserId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        String orderId = paymentService.createRazorpayOrder(id);
        return ResponseEntity.ok(Map.of("orderId", orderId));
    }

    @PostMapping("/bookings/{id}/process-payment")
    @PreAuthorize("hasRole('ATTENDEE') or hasRole('ADMIN')")
    public ResponseEntity<PaymentDTO> processPayment(
            @PathVariable Long id,
            @RequestBody Map<String, String> paymentInfo,
            Authentication authentication) {

        BookingDTO booking = bookingService.getBookingById(id);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        // Check if user is the booking owner or admin
        if (!booking.getUserId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        PaymentDTO payment = paymentService.processPayment(
                paymentInfo.get("paymentId"),
                paymentInfo.get("orderId"),
                paymentInfo.get("signature"),
                id);

        return ResponseEntity.ok(payment);
    }

    @PutMapping("/organizer/bookings/{id}/complete")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<BookingDTO> completeBooking(
            @PathVariable Long id,
            Authentication authentication) {

        BookingDTO booking = bookingService.getBookingById(id);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        // Check if user is the event organizer or admin
        EventDTO event = eventService.getEventById(booking.getEventId());
        if (!event.getOrganizerId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        BookingDTO completedBooking = bookingService.completeBooking(id);
        return ResponseEntity.ok(completedBooking);
    }
}