package com.eventmanagement.eventms.repository;

import com.eventmanagement.eventms.model.Booking;
import com.eventmanagement.eventms.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    Optional<Payment> findByPaymentId(String paymentId);
    Optional<Payment> findByBooking(Booking booking);
}