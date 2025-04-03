package com.eventmanagement.eventms.dto;

import com.eventmanagement.eventms.model.Booking;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingDTO {

    private Long id;

    private String bookingNumber;

    private Long userId;

    private String userName;

    private String userEmail;

    @NotNull(message = "Event is required")
    private Long eventId;

    private String eventTitle;

    private LocalDateTime eventDateTime;

    private String eventVenue;

    @NotNull(message = "Number of tickets is required")
    @Min(value = 1, message = "At least one ticket must be booked")
    private Integer numberOfTickets;

    private BigDecimal totalAmount;

    private LocalDateTime bookingDate;

    private Booking.BookingStatus status;

    private String qrCodePath;

    private String paymentId;
}