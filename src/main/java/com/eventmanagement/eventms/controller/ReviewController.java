package com.eventmanagement.eventms.controller;

import com.eventmanagement.eventms.dto.ReviewDTO;
import com.eventmanagement.eventms.security.services.UserDetailsImpl;
import com.eventmanagement.eventms.service.ReviewService;
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
public class ReviewController {

    private final ReviewService reviewService;

    @GetMapping("/public/reviews/event/{eventId}")
    public ResponseEntity<Page<ReviewDTO>> getReviewsByEvent(
            @PathVariable Long eventId,
            @PageableDefault(size = 10) Pageable pageable) {

        Page<ReviewDTO> reviews = reviewService.getReviewsByEvent(eventId, pageable);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/reviews/user")
    @PreAuthorize("hasAnyRole('ATTENDEE', 'ADMIN')")
    public ResponseEntity<Page<ReviewDTO>> getUserReviews(
            Authentication authentication,
            @PageableDefault(size = 10) Pageable pageable) {

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        Page<ReviewDTO> reviews = reviewService.getReviewsByUser(userDetails.getId(), pageable);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/reviews/event/{eventId}/user")
    @PreAuthorize("hasAnyRole('ATTENDEE', 'ADMIN')")
    public ResponseEntity<ReviewDTO> getUserReviewForEvent(
            @PathVariable Long eventId,
            Authentication authentication) {

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        ReviewDTO review = reviewService.getUserReviewForEvent(userDetails.getId(), eventId);

        if (review == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(review);
    }

    @PostMapping("/reviews")
    @PreAuthorize("hasAnyRole('ATTENDEE', 'ADMIN')")
    public ResponseEntity<ReviewDTO> createReview(
            @Valid @RequestBody ReviewDTO reviewDTO,
            Authentication authentication) {

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        ReviewDTO createdReview = reviewService.createReview(reviewDTO, userDetails.getId());
        return ResponseEntity.ok(createdReview);
    }

    @PutMapping("/reviews/{id}")
    @PreAuthorize("hasAnyRole('ATTENDEE', 'ADMIN')")
    public ResponseEntity<ReviewDTO> updateReview(
            @PathVariable Long id,
            @Valid @RequestBody ReviewDTO reviewDTO,
            Authentication authentication) {

        ReviewDTO existingReview = reviewService.getReviewById(id);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        // Check if user is the review owner or admin
        if (!existingReview.getUserId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        ReviewDTO updatedReview = reviewService.updateReview(id, reviewDTO);
        return ResponseEntity.ok(updatedReview);
    }

    @DeleteMapping("/reviews/{id}")
    @PreAuthorize("hasAnyRole('ATTENDEE', 'ADMIN')")
    public ResponseEntity<?> deleteReview(
            @PathVariable Long id,
            Authentication authentication) {

        ReviewDTO existingReview = reviewService.getReviewById(id);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        // Check if user is the review owner or admin
        if (!existingReview.getUserId().equals(userDetails.getId()) &&
                !authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
            return ResponseEntity.status(403).build();
        }

        reviewService.deleteReview(id);
        return ResponseEntity.ok("Review deleted successfully");
    }

    @GetMapping("/public/reviews/event/{eventId}/average")
    public ResponseEntity<Double> getAverageRatingForEvent(@PathVariable Long eventId) {
        Double averageRating = reviewService.getAverageRatingForEvent(eventId);
        return ResponseEntity.ok(averageRating);
    }
}