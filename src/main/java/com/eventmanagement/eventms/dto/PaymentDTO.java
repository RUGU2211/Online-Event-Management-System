package com.eventmanagement.eventms.dto;

import com.eventmanagement.eventms.model.Payment;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentDTO {

    private Long id;

    private Long bookingId;

    private String bookingNumber;

    private String paymentId;

    private BigDecimal amount;

    private String currency;

    private LocalDateTime paymentDate;

    private Payment.PaymentStatus status;

    private String paymentMethod;

    private String transactionDetails;
}