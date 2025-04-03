package com.eventmanagement.eventms.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender emailSender;
    private final TemplateEngine templateEngine;

    public void sendBookingConfirmationEmail(String to, String userName, String eventTitle, String eventDate,
                                             String venue, String bookingNumber, int ticketCount, String totalAmount,
                                             String qrCodePath) {
        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(to);
            helper.setSubject("Booking Confirmation: " + eventTitle);

            // Prepare the Thymeleaf context
            Context context = new Context();
            Map<String, Object> variables = new HashMap<>();
            variables.put("userName", userName);
            variables.put("eventTitle", eventTitle);
            variables.put("eventDate", eventDate);
            variables.put("venue", venue);
            variables.put("bookingNumber", bookingNumber);
            variables.put("ticketCount", ticketCount);
            variables.put("totalAmount", totalAmount);
            context.setVariables(variables);

            // Process the template
            String htmlContent = templateEngine.process("booking-confirmation", context);
            helper.setText(htmlContent, true);

            // Attach QR code
            if (qrCodePath != null && !qrCodePath.isEmpty()) {
                FileSystemResource qr = new FileSystemResource(new File(qrCodePath));
                helper.addInline("qrCode", qr);
                helper.addAttachment("e-ticket.png", qr);
            }

            // Send email
            emailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send booking confirmation email", e);
        }
    }

    public void sendBookingCancellationEmail(String to, String userName, String eventTitle, String bookingNumber) {
        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(to);
            helper.setSubject("Booking Cancellation: " + eventTitle);

            // Prepare the Thymeleaf context
            Context context = new Context();
            Map<String, Object> variables = new HashMap<>();
            variables.put("userName", userName);
            variables.put("eventTitle", eventTitle);
            variables.put("bookingNumber", bookingNumber);
            context.setVariables(variables);

            // Process the template
            String htmlContent = templateEngine.process("booking-cancellation", context);
            helper.setText(htmlContent, true);

            // Send email
            emailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send booking cancellation email", e);
        }
    }

    public void sendEventReminderEmail(String to, String userName, String eventTitle, String eventDate, String venue) {
        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(to);
            helper.setSubject("Reminder: " + eventTitle + " is coming up!");

            // Prepare the Thymeleaf context
            Context context = new Context();
            Map<String, Object> variables = new HashMap<>();
            variables.put("userName", userName);
            variables.put("eventTitle", eventTitle);
            variables.put("eventDate", eventDate);
            variables.put("venue", venue);
            context.setVariables(variables);

            // Process the template
            String htmlContent = templateEngine.process("event-reminder", context);
            helper.setText(htmlContent, true);

            // Send email
            emailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send event reminder email", e);
        }
    }

    public void sendPasswordResetEmail(String to, String userName, String resetToken) {
        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(to);
            helper.setSubject("Password Reset Request");

            // Prepare the Thymeleaf context
            Context context = new Context();
            Map<String, Object> variables = new HashMap<>();
            variables.put("userName", userName);
            variables.put("resetToken", resetToken);
            variables.put("resetUrl", "http://localhost:8080/eventms/reset-password?token=" + resetToken);
            context.setVariables(variables);

            // Process the template
            String htmlContent = templateEngine.process("password-reset", context);
            helper.setText(htmlContent, true);

            // Send email
            emailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send password reset email", e);
        }
    }

    public void sendWelcomeEmail(String to, String userName) {
        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(to);
            helper.setSubject("Welcome to Event Management System");

            // Prepare the Thymeleaf context
            Context context = new Context();
            Map<String, Object> variables = new HashMap<>();
            variables.put("userName", userName);
            context.setVariables(variables);

            // Process the template
            String htmlContent = templateEngine.process("welcome-email", context);
            helper.setText(htmlContent, true);

            // Send email
            emailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send welcome email", e);
        }
    }
}