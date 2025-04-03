package com.eventmanagement.eventms.service;

import com.eventmanagement.eventms.dto.BookingDTO;
import com.eventmanagement.eventms.exception.ResourceNotFoundException;
import com.eventmanagement.eventms.model.Booking;
import com.eventmanagement.eventms.model.Event;
import com.eventmanagement.eventms.model.User;
import com.eventmanagement.eventms.repository.BookingRepository;
import com.eventmanagement.eventms.repository.EventRepository;
import com.eventmanagement.eventms.repository.UserRepository;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;
    private final EventService eventService;
    private final EmailService emailService;

    public Page<BookingDTO> getAllBookings(Pageable pageable) {
        return bookingRepository.findAll(pageable).map(this::convertToDTO);
    }

    public Page<BookingDTO> getBookingsByUser(Long userId, Pageable pageable) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        return bookingRepository.findByUser(user, pageable).map(this::convertToDTO);
    }

    public Page<BookingDTO> getBookingsByEvent(Long eventId, Pageable pageable) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));

        return bookingRepository.findByEvent(event, pageable).map(this::convertToDTO);
    }

    public Page<BookingDTO> getBookingsByOrganizer(Long organizerId, Pageable pageable) {
        if (!userRepository.existsById(organizerId)) {
            throw new ResourceNotFoundException("Organizer not found with id: " + organizerId);
        }

        return bookingRepository.findBookingsByOrganizer(organizerId, pageable).map(this::convertToDTO);
    }

    public BookingDTO getBookingById(Long id) {
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + id));

        return convertToDTO(booking);
    }

    public BookingDTO getBookingByNumber(String bookingNumber) {
        Booking booking = bookingRepository.findByBookingNumber(bookingNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with number: " + bookingNumber));

        return convertToDTO(booking);
    }

    @Transactional
    public BookingDTO createBooking(BookingDTO bookingDTO, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        Event event = eventRepository.findById(bookingDTO.getEventId())
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + bookingDTO.getEventId()));

        // Check if enough seats are available
        if (event.getAvailableSeats() < bookingDTO.getNumberOfTickets()) {
            throw new IllegalStateException("Not enough seats available");
        }

        // Create new booking
        Booking booking = new Booking();
        booking.setBookingNumber(generateBookingNumber());
        booking.setUser(user);
        booking.setEvent(event);
        booking.setNumberOfTickets(bookingDTO.getNumberOfTickets());
        booking.setTotalAmount(event.getTicketPrice().multiply(BigDecimal.valueOf(bookingDTO.getNumberOfTickets())));
        booking.setBookingDate(LocalDateTime.now());
        booking.setStatus(Booking.BookingStatus.PENDING);

        // Save booking
        Booking savedBooking = bookingRepository.save(booking);

        // Generate QR code
        String qrCodePath = generateQRCode(savedBooking);
        savedBooking.setQrCodePath(qrCodePath);
        savedBooking = bookingRepository.save(savedBooking);

        return convertToDTO(savedBooking);
    }

    @Transactional
    public BookingDTO confirmBooking(Long id, String paymentId) {
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + id));

        // Update booking status
        booking.setStatus(Booking.BookingStatus.CONFIRMED);
        booking.setPaymentId(paymentId);

        // Update available seats in event
        eventService.updateAvailableSeats(booking.getEvent().getId(), booking.getNumberOfTickets());

        // Save updated booking
        Booking confirmedBooking = bookingRepository.save(booking);

        // Send confirmation email
        sendBookingConfirmationEmail(confirmedBooking);

        return convertToDTO(confirmedBooking);
    }

    @Transactional
    public BookingDTO cancelBooking(Long id) {
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + id));

        // Can only cancel if status is PENDING or CONFIRMED
        if (booking.getStatus() == Booking.BookingStatus.COMPLETED) {
            throw new IllegalStateException("Cannot cancel a completed booking");
        }

        // If the booking was confirmed, return seats to available pool
        if (booking.getStatus() == Booking.BookingStatus.CONFIRMED) {
            Event event = booking.getEvent();
            event.setAvailableSeats(event.getAvailableSeats() + booking.getNumberOfTickets());
            eventRepository.save(event);
        }

        // Update booking status
        booking.setStatus(Booking.BookingStatus.CANCELLED);
        Booking cancelledBooking = bookingRepository.save(booking);

        // Send cancellation email
        emailService.sendBookingCancellationEmail(
                booking.getUser().getEmail(),
                booking.getUser().getName(),
                booking.getEvent().getTitle(),
                booking.getBookingNumber()
        );

        return convertToDTO(cancelledBooking);
    }

    @Transactional
    public BookingDTO completeBooking(Long id) {
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + id));

        // Can only complete if status is CONFIRMED
        if (booking.getStatus() != Booking.BookingStatus.CONFIRMED) {
            throw new IllegalStateException("Cannot complete a booking that is not confirmed");
        }

        // Update booking status
        booking.setStatus(Booking.BookingStatus.COMPLETED);
        Booking completedBooking = bookingRepository.save(booking);

        return convertToDTO(completedBooking);
    }

    // Helper method to generate unique booking number
    private String generateBookingNumber() {
        return "BK" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    // Helper method to generate QR code for booking
    private String generateQRCode(Booking booking) {
        try {
            // Create directory if it doesn't exist
            Path qrDir = Paths.get("uploads/qrcodes");
            if (!Files.exists(qrDir)) {
                Files.createDirectories(qrDir);
            }

            // Generate QR code content
            String qrContent = String.format("Booking: %s\nEvent: %s\nDate: %s\nTickets: %d\nCustomer: %s",
                    booking.getBookingNumber(),
                    booking.getEvent().getTitle(),
                    booking.getEvent().getStartDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")),
                    booking.getNumberOfTickets(),
                    booking.getUser().getName());

            // Generate QR code
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(qrContent, BarcodeFormat.QR_CODE, 200, 200);

            // Save QR code image
            String fileName = booking.getBookingNumber() + ".png";
            Path path = qrDir.resolve(fileName);
            MatrixToImageWriter.writeToPath(bitMatrix, "PNG", path);

            return "uploads/qrcodes/" + fileName;
        } catch (WriterException | IOException e) {
            throw new RuntimeException("Failed to generate QR code", e);
        }
    }

    // Helper method to send booking confirmation email
    private void sendBookingConfirmationEmail(Booking booking) {
        String eventDate = booking.getEvent().getStartDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

        emailService.sendBookingConfirmationEmail(
                booking.getUser().getEmail(),
                booking.getUser().getName(),
                booking.getEvent().getTitle(),
                eventDate,
                booking.getEvent().getVenue(),
                booking.getBookingNumber(),
                booking.getNumberOfTickets(),
                booking.getTotalAmount().toString(),
                booking.getQrCodePath()
        );
    }

    // Helper method to convert Booking entity to BookingDTO
    public BookingDTO convertToDTO(Booking booking) {
        BookingDTO bookingDTO = new BookingDTO();
        bookingDTO.setId(booking.getId());
        bookingDTO.setBookingNumber(booking.getBookingNumber());
        bookingDTO.setUserId(booking.getUser().getId());
        bookingDTO.setUserName(booking.getUser().getName());
        bookingDTO.setUserEmail(booking.getUser().getEmail());
        bookingDTO.setEventId(booking.getEvent().getId());
        bookingDTO.setEventTitle(booking.getEvent().getTitle());
        bookingDTO.setEventDateTime(booking.getEvent().getStartDateTime());
        bookingDTO.setEventVenue(booking.getEvent().getVenue());
        bookingDTO.setNumberOfTickets(booking.getNumberOfTickets());
        bookingDTO.setTotalAmount(booking.getTotalAmount());
        bookingDTO.setBookingDate(booking.getBookingDate());
        bookingDTO.setStatus(booking.getStatus());
        bookingDTO.setQrCodePath(booking.getQrCodePath());
        bookingDTO.setPaymentId(booking.getPaymentId());

        return bookingDTO;
    }
}