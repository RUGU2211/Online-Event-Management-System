package com.eventmanagement.eventms.service;

import com.eventmanagement.eventms.dto.UserDTO;
import com.eventmanagement.eventms.exception.ResourceNotFoundException;
import com.eventmanagement.eventms.model.Role;
import com.eventmanagement.eventms.model.User;
import com.eventmanagement.eventms.repository.RoleRepository;
import com.eventmanagement.eventms.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public Page<UserDTO> getAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable).map(this::convertToDTO);
    }

    public UserDTO getUserById(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
        return convertToDTO(user);
    }

    public UserDTO getUserByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with email: " + email));
        return convertToDTO(user);
    }

    @Transactional
    public UserDTO createUser(UserDTO userDTO, String password) {
        if (userRepository.existsByEmail(userDTO.getEmail())) {
            throw new IllegalArgumentException("Email is already taken");
        }

        User user = new User();
        user.setName(userDTO.getName());
        user.setEmail(userDTO.getEmail());
        user.setPassword(passwordEncoder.encode(password));
        user.setProfilePicture(userDTO.getProfilePicture());
        user.setProvider("local");

        Set<Role> roles = new HashSet<>();

        if (userDTO.getRoles() == null || userDTO.getRoles().isEmpty()) {
            Role attendeeRole = roleRepository.findByName(Role.ERole.ROLE_ATTENDEE)
                    .orElseThrow(() -> new RuntimeException("Error: Attendee role not found."));
            roles.add(attendeeRole);
        } else {
            userDTO.getRoles().forEach(role -> {
                switch (role) {
                    case "admin":
                        Role adminRole = roleRepository.findByName(Role.ERole.ROLE_ADMIN)
                                .orElseThrow(() -> new RuntimeException("Error: Admin role not found."));
                        roles.add(adminRole);
                        break;
                    case "organizer":
                        Role organizerRole = roleRepository.findByName(Role.ERole.ROLE_ORGANIZER)
                                .orElseThrow(() -> new RuntimeException("Error: Organizer role not found."));
                        roles.add(organizerRole);
                        break;
                    default:
                        Role attendeeRole = roleRepository.findByName(Role.ERole.ROLE_ATTENDEE)
                                .orElseThrow(() -> new RuntimeException("Error: Attendee role not found."));
                        roles.add(attendeeRole);
                }
            });
        }

        user.setRoles(roles);
        User savedUser = userRepository.save(user);

        return convertToDTO(savedUser);
    }

    @Transactional
    public UserDTO updateUser(Long id, UserDTO userDTO) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));

        user.setName(userDTO.getName());

        // Only update email if it's changed and not already taken by another user
        if (!user.getEmail().equals(userDTO.getEmail())) {
            if (userRepository.existsByEmail(userDTO.getEmail())) {
                throw new IllegalArgumentException("Email is already taken");
            }
            user.setEmail(userDTO.getEmail());
        }

        // Update profile picture if provided
        if (userDTO.getProfilePicture() != null && !userDTO.getProfilePicture().isEmpty()) {
            user.setProfilePicture(userDTO.getProfilePicture());
        }

        // Update roles if provided (admin only)
        if (userDTO.getRoles() != null && !userDTO.getRoles().isEmpty()) {
            Set<Role> roles = new HashSet<>();
            userDTO.getRoles().forEach(role -> {
                switch (role) {
                    case "admin":
                        Role adminRole = roleRepository.findByName(Role.ERole.ROLE_ADMIN)
                                .orElseThrow(() -> new RuntimeException("Error: Admin role not found."));
                        roles.add(adminRole);
                        break;
                    case "organizer":
                        Role organizerRole = roleRepository.findByName(Role.ERole.ROLE_ORGANIZER)
                                .orElseThrow(() -> new RuntimeException("Error: Organizer role not found."));
                        roles.add(organizerRole);
                        break;
                    default:
                        Role attendeeRole = roleRepository.findByName(Role.ERole.ROLE_ATTENDEE)
                                .orElseThrow(() -> new RuntimeException("Error: Attendee role not found."));
                        roles.add(attendeeRole);
                }
            });
            user.setRoles(roles);
        }

        User updatedUser = userRepository.save(user);
        return convertToDTO(updatedUser);
    }

    @Transactional
    public void deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("User not found with id: " + id);
        }
        userRepository.deleteById(id);
    }

    @Transactional
    public void changePassword(Long id, String oldPassword, String newPassword) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new IllegalArgumentException("Incorrect old password");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    // Helper method to convert User entity to UserDTO
    public UserDTO convertToDTO(User user) {
        UserDTO userDTO = new UserDTO();
        userDTO.setId(user.getId());
        userDTO.setName(user.getName());
        userDTO.setEmail(user.getEmail());
        userDTO.setProfilePicture(user.getProfilePicture());
        userDTO.setProvider(user.getProvider());

        Set<String> roles = user.getRoles().stream()
                .map(role -> role.getName().name().substring(5).toLowerCase())
                .collect(Collectors.toSet());
        userDTO.setRoles(roles);

        return userDTO;
    }

    // Helper method to convert UserDTO to User entity
    public User convertToEntity(UserDTO userDTO) {
        User user = new User();
        user.setId(userDTO.getId());
        user.setName(userDTO.getName());
        user.setEmail(userDTO.getEmail());
        user.setProfilePicture(userDTO.getProfilePicture());
        user.setProvider(userDTO.getProvider());

        return user;
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public Optional<User> findByProviderId(String providerId) {
        return userRepository.findByProviderId(providerId);
    }
}