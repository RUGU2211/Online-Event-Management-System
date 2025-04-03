package com.eventmanagement.eventms.controller;

import com.eventmanagement.eventms.dto.BookingDTO;
import com.eventmanagement.eventms.dto.EventDTO;
import com.eventmanagement.eventms.model.Payment;
import com.eventmanagement.eventms.service.BookingService;
import com.eventmanagement.eventms.service.EventService;
import com.eventmanagement.eventms.service.PaymentService;
import com.eventmanagement.eventms.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
@RequiredArgsConstructor
public class AdminController {

    private final UserService userService;
    private final EventService eventService;
    private final BookingService bookingService;
    private final PaymentService paymentService;

    @GetMapping("/dashboard/stats")
    public ResponseEntity<Map<String, Object>> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        // Implement statistics collection logic
        // This would typically involve aggregation queries to gather system-wide statistics

        return ResponseEntity.ok(stats);
    }

    @GetMapping("/events")
    public ResponseEntity<Page<EventDTO>> getAllEvents(@PageableDefault(size = 10) Pageable pageable) {
        Page<EventDTO> events = eventService.getAllEvents(pageable);
        return ResponseEntity.ok(events);
    }

    @PutMapping("/events/{id}/publish")
    public ResponseEntity<EventDTO> publishEvent(@PathVariable Long id) {
        EventDTO publishedEvent = eventService.publishEvent(id);
        return ResponseEntity.ok(publishedEvent);
    }

    @PutMapping("/events/{id}/unpublish")
    public ResponseEntity<EventDTO> unpublishEvent(@PathVariable Long id) {
        EventDTO unpublishedEvent = eventService.unpublishEvent(id);
        return ResponseEntity.ok(unpublishedEvent);
    }

    @GetMapping("/bookings")
    public ResponseEntity<Page<BookingDTO>> getAllBookings(@PageableDefault(size = 10) Pageable pageable) {
        Page<BookingDTO> bookings = bookingService.getAllBookings(pageable);
        return ResponseEntity.ok(bookings);
    }

    @PutMapping("/payments/{id}/status")
    public ResponseEntity<?> updatePaymentStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> statusData) {

        String status = statusData.get("status");
        if (status == null) {
            return ResponseEntity.badRequest().body("Status is required");
        }

        try {
            Payment.PaymentStatus paymentStatus = Payment.PaymentStatus.valueOf(status.toUpperCase());
            paymentService.updatePaymentStatus(id, paymentStatus);
            return ResponseEntity.ok("Payment status updated successfully");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Invalid payment status");
        }
    }

    @PostMapping("/system/initialize-roles")
    public ResponseEntity<?> initializeRoles() {
        // This would be implemented in a service to create the default roles if they don't exist
        return ResponseEntity.ok("Roles initialized successfully");
    }
}