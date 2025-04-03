package com.eventmanagement.eventms.controller;

import com.eventmanagement.eventms.dto.UserDTO;
import com.eventmanagement.eventms.dto.auth.JwtResponse;
import com.eventmanagement.eventms.dto.auth.LoginRequest;
import com.eventmanagement.eventms.dto.auth.RegisterRequest;
import com.eventmanagement.eventms.model.Role;
import com.eventmanagement.eventms.model.User;
import com.eventmanagement.eventms.repository.RoleRepository;
import com.eventmanagement.eventms.repository.UserRepository;
import com.eventmanagement.eventms.security.jwt.JwtUtils;
import com.eventmanagement.eventms.security.services.UserDetailsImpl;
import com.eventmanagement.eventms.service.EmailService;
import com.eventmanagement.eventms.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder encoder;
    private final JwtUtils jwtUtils;
    private final UserService userService;
    private final EmailService emailService;

    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());

        return ResponseEntity.ok(new JwtResponse(
                jwt,
                userDetails.getId(),
                userDetails.getName(),
                userDetails.getEmail(),
                userDetails.getProfilePicture(),
                roles));
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@Valid @RequestBody RegisterRequest registerRequest) {
        if (userRepository.existsByEmail(registerRequest.getEmail())) {
            return ResponseEntity.badRequest().body("Error: Email is already in use!");
        }

        // Create new user's account
        UserDTO userDTO = new UserDTO();
        userDTO.setName(registerRequest.getName());
        userDTO.setEmail(registerRequest.getEmail());
        userDTO.setRoles(registerRequest.getRoles());

        UserDTO createdUser = userService.createUser(userDTO, registerRequest.getPassword());

        // Send welcome email
        emailService.sendWelcomeEmail(createdUser.getEmail(), createdUser.getName());

        return ResponseEntity.ok("User registered successfully!");
    }

    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body("User not authenticated");
        }

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        UserDTO userDTO = userService.getUserById(userDetails.getId());

        return ResponseEntity.ok(userDTO);
    }
}