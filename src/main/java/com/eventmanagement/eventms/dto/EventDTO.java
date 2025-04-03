package com.eventmanagement.eventms.dto;

import com.eventmanagement.eventms.model.Event;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EventDTO {

    private Long id;

    @NotBlank(message = "Title is required")
    private String title;

    private String description;

    @NotNull(message = "Start date and time is required")
    @Future(message = "Start date must be in the future")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime startDateTime;

    @NotNull(message = "End date and time is required")
    @Future(message = "End date must be in the future")
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime endDateTime;

    @NotBlank(message = "Venue is required")
    private String venue;

    private String venueAddress;

    private String bannerImage;

    @NotNull(message = "Category is required")
    private Event.EventCategory category;

    @NotNull(message = "Total seats is required")
    @Min(value = 1, message = "Total seats must be at least 1")
    private Integer totalSeats;

    @NotNull(message = "Ticket price is required")
    @Min(value = 0, message = "Ticket price cannot be negative")
    private BigDecimal ticketPrice;

    private boolean published;

    private Long organizerId;

    private String organizerName;

    private Double averageRating;
}