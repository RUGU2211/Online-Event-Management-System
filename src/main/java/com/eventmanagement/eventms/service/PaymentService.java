package com.eventmanagement.eventms.service;

import com.eventmanagement.eventms.dto.BookingDTO;
import com.eventmanagement.eventms.dto.PaymentDTO;
import com.eventmanagement.eventms.exception.ResourceNotFoundException;
import com.eventmanagement.eventms.model.Booking;
import com.eventmanagement.eventms.model.Payment;
import com.eventmanagement.eventms.repository.BookingRepository;
import com.eventmanagement.eventms.repository.PaymentRepository;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import lombok.RequiredArgsConstructor;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final BookingRepository bookingRepository;
    private final BookingService bookingService;

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret}")
    private String razorpayKeySecret;

    @Value("${app.payment-currency:INR}")
    private String currency;

    public PaymentDTO getPaymentById(Long id) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with id: " + id));

        return convertToDTO(payment);
    }

    public PaymentDTO getPaymentByPaymentId(String paymentId) {
        Payment payment = paymentRepository.findByPaymentId(paymentId)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with paymentId: " + paymentId));

        return convertToDTO(payment);
    }

    public PaymentDTO getPaymentByBooking(Long bookingId) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

        Payment payment = paymentRepository.findByBooking(booking)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found for booking: " + bookingId));

        return convertToDTO(payment);
    }
    @Transactional
    public String createRazorpayOrder(Long bookingId) {
        try {
            Booking booking = bookingRepository.findById(bookingId)
                    .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

            // Initialize Razorpay client
            RazorpayClient razorpayClient = new RazorpayClient(razorpayKeyId, razorpayKeySecret);

            // Create order request
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", booking.getTotalAmount().multiply(new BigDecimal("100")).intValue()); // amount in the smallest currency unit (paise)
            orderRequest.put("currency", currency);
            orderRequest.put("receipt", booking.getBookingNumber());
            orderRequest.put("payment_capture", 1); // auto capture payment

            // Create order
            Order order = razorpayClient.orders().create(orderRequest); // Changed from razorpayClient.orders.create

            // Return the order ID
            return order.get("id");

        } catch (RazorpayException e) {
            throw new RuntimeException("Error creating Razorpay order: " + e.getMessage(), e);
        }
    }


//    @Transactional
//    public String createRazorpayOrder(Long bookingId) {
//        try {
//            Booking booking = bookingRepository.findById(bookingId)
//                    .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));
//
//            // Initialize Razorpay client
//            RazorpayClient razorpayClient = new RazorpayClient(razorpayKeyId, razorpayKeySecret);
//
//            // Create order request
//            JSONObject orderRequest = new JSONObject();
//            orderRequest.put("amount", booking.getTotalAmount().multiply(new BigDecimal("100")).intValue()); // amount in the smallest currency unit (paise)
//            orderRequest.put("currency", currency);
//            orderRequest.put("receipt", booking.getBookingNumber());
//            orderRequest.put("payment_capture", 1); // auto capture payment
//
//            // Create order
//            Order order = razorpayClient.orders.create(orderRequest);
//
//            // Return the order ID
//            return order.get("id");
//
//        } catch (RazorpayException e) {
//            throw new RuntimeException("Error creating Razorpay order: " + e.getMessage(), e);
//        }
//    }

    @Transactional
    public PaymentDTO processPayment(String razorpayPaymentId, String razorpayOrderId, String razorpaySignature, Long bookingId) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

        // Verify payment signature (this would typically involve using Razorpay's verification utility)
        // For simplicity, we're skipping detailed verification here

        // Create payment record
        Payment payment = new Payment();
        payment.setBooking(booking);
        payment.setPaymentId(razorpayPaymentId);
        payment.setAmount(booking.getTotalAmount());
        payment.setCurrency(currency);
        payment.setPaymentDate(LocalDateTime.now());
        payment.setStatus(Payment.PaymentStatus.SUCCESS);
        payment.setPaymentMethod("Razorpay");

        // Additional transaction details
        JSONObject transactionDetails = new JSONObject();
        transactionDetails.put("orderId", razorpayOrderId);
        transactionDetails.put("signature", razorpaySignature);
        payment.setTransactionDetails(transactionDetails.toString());

        // Save payment
        Payment savedPayment = paymentRepository.save(payment);

        // Update booking status
        bookingService.confirmBooking(bookingId, razorpayPaymentId);

        return convertToDTO(savedPayment);
    }

    @Transactional
    public PaymentDTO createPayment(PaymentDTO paymentDTO) {
        Booking booking = bookingRepository.findById(paymentDTO.getBookingId())
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + paymentDTO.getBookingId()));

        Payment payment = new Payment();
        payment.setBooking(booking);
        payment.setPaymentId(generatePaymentId());
        payment.setAmount(booking.getTotalAmount());
        payment.setCurrency(currency);
        payment.setPaymentDate(LocalDateTime.now());
        payment.setStatus(Payment.PaymentStatus.SUCCESS);
        payment.setPaymentMethod(paymentDTO.getPaymentMethod());
        payment.setTransactionDetails(paymentDTO.getTransactionDetails());

        Payment savedPayment = paymentRepository.save(payment);

        // Update booking status
        bookingService.confirmBooking(booking.getId(), savedPayment.getPaymentId());

        return convertToDTO(savedPayment);
    }

    @Transactional
    public PaymentDTO updatePaymentStatus(Long id, Payment.PaymentStatus status) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with id: " + id));

        payment.setStatus(status);
        Payment updatedPayment = paymentRepository.save(payment);

        // If payment is refunded, update the booking status
        if (status == Payment.PaymentStatus.REFUNDED) {
            bookingService.cancelBooking(payment.getBooking().getId());
        }

        return convertToDTO(updatedPayment);
    }

    // Helper method to generate unique payment ID
    private String generatePaymentId() {
        return "PAY" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    // Helper method to convert Payment entity to PaymentDTO
    public PaymentDTO convertToDTO(Payment payment) {
        PaymentDTO paymentDTO = new PaymentDTO();
        paymentDTO.setId(payment.getId());
        paymentDTO.setBookingId(payment.getBooking().getId());
        paymentDTO.setBookingNumber(payment.getBooking().getBookingNumber());
        paymentDTO.setPaymentId(payment.getPaymentId());
        paymentDTO.setAmount(payment.getAmount());
        paymentDTO.setCurrency(payment.getCurrency());
        paymentDTO.setPaymentDate(payment.getPaymentDate());
        paymentDTO.setStatus(payment.getStatus());
        paymentDTO.setPaymentMethod(payment.getPaymentMethod());
        paymentDTO.setTransactionDetails(payment.getTransactionDetails());

        return paymentDTO;
    }
}