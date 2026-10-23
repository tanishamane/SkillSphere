package com.skillsphere.controller;

import com.skillsphere.service.UserService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * Placeholder role-protected endpoints. Each dashboard is enforced on the server;
 * the React route guards only improve the experience.
 */
@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    private final UserService userService;

    public DashboardController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/employee")
    @PreAuthorize("hasAnyRole('EMPLOYEE','ADMIN')")
    public Map<String, String> employee(Authentication auth) {
        return payload(auth, "Employee workspace", "Your skills profile and recommended learning will appear here.");
    }

    @GetMapping("/hr")
    @PreAuthorize("hasAnyRole('HR','ADMIN')")
    public Map<String, String> hr(Authentication auth) {
        return payload(auth, "HR workspace", "Organization-wide skill coverage and training programmes will appear here.");
    }

    @GetMapping("/manager")
    @PreAuthorize("hasAnyRole('MANAGER','ADMIN')")
    public Map<String, String> manager(Authentication auth) {
        return payload(auth, "Manager workspace", "Your team's skill gaps and development plans will appear here.");
    }

    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public Map<String, String> admin(Authentication auth) {
        return payload(auth, "Admin console", "Manage people, roles, and access across SkillSphere.");
    }

    private Map<String, String> payload(Authentication auth, String title, String message) {
        var user = userService.getByEmail(auth.getName());
        return Map.of("title", title, "message", message,
                "fullName", user.getFullName(), "role", user.getRole().name());
    }
}
