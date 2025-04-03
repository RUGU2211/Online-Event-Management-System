package com.eventmanagement.eventms.service;

import com.eventmanagement.eventms.dto.EventDTO;
import com.eventmanagement.eventms.exception.ResourceNotFoundException;
import com.eventmanagement.eventms.model.Event;
import com.eventmanagement.eventms.model.User;
import com.eventmanagement.eventms.repository.EventRepository;
import com.eventmanagement.eventms.repository.ReviewRepository;
import com.eventmanagement.eventms.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventRepository eventRepository;
    private final UserRepository userRepository;
    private final ReviewRepository reviewRepository;

    public Page<EventDTO> getAllEvents(Pageable pageable) {
        return eventRepository.findAll(pageable).map(this::convertToDTO);
    }

    public Page<EventDTO> getAllPublishedEvents(Pageable pageable) {
        return eventRepository.findByPublishedTrue(pageable).map(this::convertToDTO);
    }

    public Page<EventDTO> getEventsByCategory(Event.EventCategory category, Pageable pageable) {
        return eventRepository.findByCategory(category, pageable).map(this::convertToDTO);
    }

    public Page<EventDTO> getUpcomingEvents(Pageable pageable) {
        return eventRepository.findUpcomingEvents(LocalDateTime.now(), pageable).map(this::convertToDTO);
    }

    public Page<EventDTO> searchEvents(String keyword, Pageable pageable) {
        return eventRepository.searchEvents(keyword, pageable).map(this::convertToDTO);
    }

    public Page<EventDTO> getEventsByOrganizer(Long organizerId, Pageable pageable) {
        User organizer = userRepository.findById(organizerId)
                .orElseThrow(() -> new ResourceNotFoundException("Organizer not found with id: " + organizerId));

        return eventRepository.findByOrganizer(organizer, pageable).map(this::convertToDTO);
    }

    public EventDTO getEventById(Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));

        return convertToDTO(event);
    }

    @Transactional
    public EventDTO createEvent(EventDTO eventDTO, Long organizerId) {
        User organizer = userRepository.findById(organizerId)
                .orElseThrow(() -> new ResourceNotFoundException("Organizer not found with id: " + organizerId));

        Event event = convertToEntity(eventDTO);
        event.setOrganizer(organizer);
        event.setAvailableSeats(event.getTotalSeats());

        Event savedEvent = eventRepository.save(event);
        return convertToDTO(savedEvent);
    }

    @Transactional
    public EventDTO updateEvent(Long id, EventDTO eventDTO) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));

        // Update event properties
        event.setTitle(eventDTO.getTitle());
        event.setDescription(eventDTO.getDescription());
        event.setStartDateTime(eventDTO.getStartDateTime());
        event.setEndDateTime(eventDTO.getEndDateTime());
        event.setVenue(eventDTO.getVenue());
        event.setVenueAddress(eventDTO.getVenueAddress());
        event.setCategory(eventDTO.getCategory());
        event.setTicketPrice(eventDTO.getTicketPrice());

        // Only update banner image if provided
        if (eventDTO.getBannerImage() != null && !eventDTO.getBannerImage().isEmpty()) {
            event.setBannerImage(eventDTO.getBannerImage());
        }

        // Handle total seats update (only if no tickets have been sold)
        if (!event.getTotalSeats().equals(eventDTO.getTotalSeats())) {
            int bookedSeats = event.getTotalSeats() - event.getAvailableSeats();

            if (eventDTO.getTotalSeats() < bookedSeats) {
                throw new IllegalArgumentException("Cannot reduce total seats below the number of booked seats");
            }

            event.setTotalSeats(eventDTO.getTotalSeats());
            event.setAvailableSeats(eventDTO.getTotalSeats() - bookedSeats);
        }

        // Update published status
        event.setPublished(eventDTO.isPublished());

        Event updatedEvent = eventRepository.save(event);
        return convertToDTO(updatedEvent);
    }

    @Transactional
    public void deleteEvent(Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));

        // Check if event has any bookings
        if (!event.getBookings().isEmpty()) {
            throw new IllegalStateException("Cannot delete event with existing bookings");
        }

        eventRepository.delete(event);
    }

    @Transactional
    public EventDTO publishEvent(Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));

        event.setPublished(true);
        Event updatedEvent = eventRepository.save(event);

        return convertToDTO(updatedEvent);
    }

    @Transactional
    public EventDTO unpublishEvent(Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));

        event.setPublished(false);
        Event updatedEvent = eventRepository.save(event);

        return convertToDTO(updatedEvent);
    }

    @Transactional
    public void updateAvailableSeats(Long eventId, int bookedSeats) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));

        if (event.getAvailableSeats() < bookedSeats) {
            throw new IllegalStateException("Not enough seats available");
        }

        event.setAvailableSeats(event.getAvailableSeats() - bookedSeats);
        eventRepository.save(event);
    }

    // Helper method to convert Event entity to EventDTO
    public EventDTO convertToDTO(Event event) {
        EventDTO eventDTO = new EventDTO();
        eventDTO.setId(event.getId());
        eventDTO.setTitle(event.getTitle());
        eventDTO.setDescription(event.getDescription());
        eventDTO.setStartDateTime(event.getStartDateTime());
        eventDTO.setEndDateTime(event.getEndDateTime());
        eventDTO.setVenue(event.getVenue());
        eventDTO.setVenueAddress(event.getVenueAddress());
        eventDTO.setBannerImage(event.getBannerImage());
        eventDTO.setCategory(event.getCategory());
        eventDTO.setTotalSeats(event.getTotalSeats());
        eventDTO.setTicketPrice(event.getTicketPrice());
        eventDTO.setPublished(event.isPublished());

        // Set organizer info
        eventDTO.setOrganizerId(event.getOrganizer().getId());
        eventDTO.setOrganizerName(event.getOrganizer().getName());

        // Get average rating
        Double avgRating = reviewRepository.getAverageRatingForEvent(event.getId());
        eventDTO.setAverageRating(avgRating != null ? avgRating : 0.0);

        return eventDTO;
    }

    // Helper method to convert EventDTO to Event entity
    public Event convertToEntity(EventDTO eventDTO) {
        Event event = new Event();
        event.setId(eventDTO.getId());
        event.setTitle(eventDTO.getTitle());
        event.setDescription(eventDTO.getDescription());
        event.setStartDateTime(eventDTO.getStartDateTime());
        event.setEndDateTime(eventDTO.getEndDateTime());
        event.setVenue(eventDTO.getVenue());
        event.setVenueAddress(eventDTO.getVenueAddress());
        event.setBannerImage(eventDTO.getBannerImage());
        event.setCategory(eventDTO.getCategory());
        event.setTotalSeats(eventDTO.getTotalSeats());
        event.setAvailableSeats(eventDTO.getTotalSeats()); // Initially all seats are available
        event.setTicketPrice(eventDTO.getTicketPrice());
        event.setPublished(eventDTO.isPublished());

        return event;
    }
}