package com.eventmanagement.eventms.service;

import com.eventmanagement.eventms.dto.ReviewDTO;
import com.eventmanagement.eventms.exception.ResourceNotFoundException;
import com.eventmanagement.eventms.model.Booking;
import com.eventmanagement.eventms.model.Event;
import com.eventmanagement.eventms.model.Review;
import com.eventmanagement.eventms.model.User;
import com.eventmanagement.eventms.repository.BookingRepository;
import com.eventmanagement.eventms.repository.EventRepository;
import com.eventmanagement.eventms.repository.ReviewRepository;
import com.eventmanagement.eventms.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;
    private final BookingRepository bookingRepository;

    public Page<ReviewDTO> getAllReviews(Pageable pageable) {
        return reviewRepository.findAll(pageable).map(this::convertToDTO);
    }

    public Page<ReviewDTO> getReviewsByEvent(Long eventId, Pageable pageable) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));

        return reviewRepository.findByEvent(event, pageable).map(this::convertToDTO);
    }

    public Page<ReviewDTO> getReviewsByUser(Long userId, Pageable pageable) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        return reviewRepository.findByUser(user, pageable).map(this::convertToDTO);
    }

    public ReviewDTO getReviewById(Long id) {
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Review not found with id: " + id));

        return convertToDTO(review);
    }

    public ReviewDTO getUserReviewForEvent(Long userId, Long eventId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));

        Review review = reviewRepository.findByUserAndEvent(user, event)
                .orElse(null);

        return review != null ? convertToDTO(review) : null;
    }

    @Transactional
    public ReviewDTO createReview(ReviewDTO reviewDTO, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        Event event = eventRepository.findById(reviewDTO.getEventId())
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + reviewDTO.getEventId()));

        // Check if user has attended the event
        List<Booking> userBookings = bookingRepository.findByUser(user);
        boolean hasAttended = userBookings.stream()
                .anyMatch(booking -> booking.getEvent().getId().equals(event.getId()) &&
                        (booking.getStatus() == Booking.BookingStatus.CONFIRMED ||
                                booking.getStatus() == Booking.BookingStatus.COMPLETED));

        if (!hasAttended) {
            throw new IllegalStateException("User must attend the event before leaving a review");
        }

        // Check if user has already reviewed this event
        if (reviewRepository.findByUserAndEvent(user, event).isPresent()) {
            throw new IllegalStateException("User has already reviewed this event");
        }

        // Create new review
        Review review = new Review();
        review.setUser(user);
        review.setEvent(event);
        review.setRating(reviewDTO.getRating());
        review.setComment(reviewDTO.getComment());
        review.setReviewDate(LocalDateTime.now());

        Review savedReview = reviewRepository.save(review);

        return convertToDTO(savedReview);
    }

    @Transactional
    public ReviewDTO updateReview(Long id, ReviewDTO reviewDTO) {
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Review not found with id: " + id));

        // Update review properties
        review.setRating(reviewDTO.getRating());
        review.setComment(reviewDTO.getComment());

        Review updatedReview = reviewRepository.save(review);

        return convertToDTO(updatedReview);
    }

    @Transactional
    public void deleteReview(Long id) {
        if (!reviewRepository.existsById(id)) {
            throw new ResourceNotFoundException("Review not found with id: " + id);
        }

        reviewRepository.deleteById(id);
    }

    public Double getAverageRatingForEvent(Long eventId) {
        if (!eventRepository.existsById(eventId)) {
            throw new ResourceNotFoundException("Event not found with id: " + eventId);
        }

        Double avgRating = reviewRepository.getAverageRatingForEvent(eventId);
        return avgRating != null ? avgRating : 0.0;
    }

    // Helper method to convert Review entity to ReviewDTO
    public ReviewDTO convertToDTO(Review review) {
        ReviewDTO reviewDTO = new ReviewDTO();
        reviewDTO.setId(review.getId());
        reviewDTO.setUserId(review.getUser().getId());
        reviewDTO.setUserName(review.getUser().getName());
        reviewDTO.setUserProfilePicture(review.getUser().getProfilePicture());
        reviewDTO.setEventId(review.getEvent().getId());
        reviewDTO.setEventTitle(review.getEvent().getTitle());
        reviewDTO.setRating(review.getRating());
        reviewDTO.setComment(review.getComment());
        reviewDTO.setReviewDate(review.getReviewDate());

        return reviewDTO;
    }
}