package com.skillsphere.dto;

public record EmployeeProfileDto(
        Long userId,
        String fullName,
        String email,
        String employeeId,
        String jobRole,
        String department,
        String experienceLevel,
        String bio,
        String skills
) {}
