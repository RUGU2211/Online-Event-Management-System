package com.eventmanagement.eventms.security.oauth2;

import com.eventmanagement.eventms.exception.OAuth2AuthenticationProcessingException;
import com.eventmanagement.eventms.model.Role;
import com.eventmanagement.eventms.model.User;
import com.eventmanagement.eventms.repository.RoleRepository;
import com.eventmanagement.eventms.repository.UserRepository;
import com.eventmanagement.eventms.security.oauth2.user.OAuth2UserInfo;
import com.eventmanagement.eventms.security.oauth2.user.OAuth2UserInfoFactory;
import com.eventmanagement.eventms.service.EmailService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final EmailService emailService;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest oAuth2UserRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(oAuth2UserRequest);

        try {
            return processOAuth2User(oAuth2UserRequest, oAuth2User);
        } catch (AuthenticationException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new InternalAuthenticationServiceException(ex.getMessage(), ex.getCause());
        }
    }

    private OAuth2User processOAuth2User(OAuth2UserRequest oAuth2UserRequest, OAuth2User oAuth2User) {
        String registrationId = oAuth2UserRequest.getClientRegistration().getRegistrationId();
        OAuth2UserInfo oAuth2UserInfo = OAuth2UserInfoFactory.getOAuth2UserInfo(registrationId, oAuth2User.getAttributes());

        if (!StringUtils.hasText(oAuth2UserInfo.getEmail())) {
            throw new OAuth2AuthenticationProcessingException("Email not found from OAuth2 provider");
        }

        Optional<User> userOptional = userRepository.findByEmail(oAuth2UserInfo.getEmail());
        User user;

        if (userOptional.isPresent()) {
            user = userOptional.get();

            // Update user with info from OAuth2
            user.setName(oAuth2UserInfo.getName());
            user.setProfilePicture(oAuth2UserInfo.getImageUrl());

            // If user was registered locally, update the provider info
            if (user.getProvider() == null || user.getProvider().isEmpty()) {
                user.setProvider(registrationId);
                user.setProviderId(oAuth2UserInfo.getId());
            }

            userRepository.save(user);
        } else {
            // Register new user
            user = registerNewUser(oAuth2UserRequest, oAuth2UserInfo);

            // Send welcome email
            emailService.sendWelcomeEmail(user.getEmail(), user.getName());
        }

        return new CustomOAuth2User(oAuth2User, registrationId);
    }

    private User registerNewUser(OAuth2UserRequest oAuth2UserRequest, OAuth2UserInfo oAuth2UserInfo) {
        User user = new User();

        user.setProvider(oAuth2UserRequest.getClientRegistration().getRegistrationId());
        user.setProviderId(oAuth2UserInfo.getId());
        user.setName(oAuth2UserInfo.getName());
        user.setEmail(oAuth2UserInfo.getEmail());
        user.setProfilePicture(oAuth2UserInfo.getImageUrl());
        user.setEnabled(true);

        // Set default role as ATTENDEE
        Set<Role> roles = new HashSet<>();
        Role attendeeRole = roleRepository.findByName(Role.ERole.ROLE_ATTENDEE)
                .orElseThrow(() -> new RuntimeException("Error: Attendee role not found."));
        roles.add(attendeeRole);
        user.setRoles(roles);

        return userRepository.save(user);
    }
}