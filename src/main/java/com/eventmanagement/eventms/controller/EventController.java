package com.eventmanagement.eventms.controller;

import com.eventmanagement.eventms.dto.EventDTO;
import com.eventmanagement.eventms.model.Event;
import com.eventmanagement.eventms.security.services.UserDetailsImpl;
import com.eventmanagement.eventms.service.EventService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;

    @GetMapping("/public/events")
    public ResponseEntity<Page<EventDTO>> getAllPublishedEvents(
            @PageableDefault(size = 10) Pageable pageable) {

        Page<EventDTO> events = eventService.getAllPublishedEvents(pageable);
        return ResponseEntity.ok(events);
    }

    @GetMapping("/public/events/category/{category}")
    public ResponseEntity<Page<EventDTO>> getEventsByCategory(
            @PathVariable Event.EventCategory category,
            @PageableDefault(size = 10) Pageable pageable) {

        Page<EventDTO> events = eventService.getEventsByCategory(category, pageable);
        return ResponseEntity.ok(events);
    }

    @GetMapping("/public/events/upcoming")
    public ResponseEntity<Page<EventDTO>> getUpcomingEvents(
            @PageableDefault(size = 10) Pageable pageable) {

        Page<EventDTO> events = eventService.getUpcomingEvents(pageable);
        return ResponseEntity.ok(events);
    }

    @GetMapping("/public/events/search")
    public ResponseEntity<Page<EventDTO>> searchEvents(
            @RequestParam String keyword,
            @PageableDefault(size = 10) Pageable pageable) {

        Page<EventDTO> events = eventService.searchEvents(keyword, pageable);
        return ResponseEntity.ok(events);
    }

    @GetMapping("/public/events/{id}")
    public ResponseEntity<EventDTO> getEventById(@PathVariable Long id) {
        EventDTO event = eventService.getEventById(id);
        return ResponseEntity.ok(event);
    }

    @GetMapping("/organizer/events")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<Page<EventDTO>> getOrganizerEvents(
            Authentication authentication,
            @PageableDefault(size = 10) Pageable pageable) {

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        Page<EventDTO> events = eventService.getEventsByOrganizer(userDetails.getId(), pageable);
        return ResponseEntity.ok(events);
    }

    @PostMapping("/organizer/events")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<EventDTO> createEvent(
            @Valid @RequestBody EventDTO eventDTO,
            Authentication authentication) {

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        EventDTO createdEvent = eventService.createEvent(eventDTO, userDetails.getId());
        return ResponseEntity.ok(createdEvent);
    }

    @PutMapping("/organizer/events/{id}")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<EventDTO> updateEvent(
            @PathVariable Long id,
            @Valid @RequestBody EventDTO eventDTO,
            Authentication authentication) {

        // Verify organizer is updating their own event
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        EventDTO existingEvent = eventService.getEventById(id);

        if (!existingEvent.getOrganizerId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        EventDTO updatedEvent = eventService.updateEvent(id, eventDTO);
        return ResponseEntity.ok(updatedEvent);
    }

    @DeleteMapping("/organizer/events/{id}")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<?> deleteEvent(
            @PathVariable Long id,
            Authentication authentication) {

        // Verify organizer is deleting their own event
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        EventDTO existingEvent = eventService.getEventById(id);

        if (!existingEvent.getOrganizerId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        eventService.deleteEvent(id);
        return ResponseEntity.ok("Event deleted successfully");
    }

    @PutMapping("/organizer/events/{id}/publish")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<EventDTO> publishEvent(
            @PathVariable Long id,
            Authentication authentication) {

        // Verify organizer is publishing their own event
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        EventDTO existingEvent = eventService.getEventById(id);

        if (!existingEvent.getOrganizerId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        EventDTO publishedEvent = eventService.publishEvent(id);
        return ResponseEntity.ok(publishedEvent);
    }

    @PutMapping("/organizer/events/{id}/unpublish")
    @PreAuthorize("hasRole('ORGANIZER') or hasRole('ADMIN')")
    public ResponseEntity<EventDTO> unpublishEvent(
            @PathVariable Long id,
            Authentication authentication) {

        // Verify organizer is unpublishing their own event
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        EventDTO existingEvent = eventService.getEventById(id);

        if (!existingEvent.getOrganizerId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        EventDTO unpublishedEvent = eventService.unpublishEvent(id);
        return ResponseEntity.ok(unpublishedEvent);
    }
}