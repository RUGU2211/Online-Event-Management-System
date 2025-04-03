package com.eventmanagement.eventms.dto.auth;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class JwtResponse {

    private String token;
    private String type = "Bearer";
    private Long id;
    private String name;
    private String email;
    private String profilePicture;
    private List<String> roles;

    public JwtResponse(String token, Long id, String name, String email, String profilePicture, List<String> roles) {
        this.token = token;
        this.id = id;
        this.name = name;
        this.email = email;
        this.profilePicture = profilePicture;
        this.roles = roles;
    }
}