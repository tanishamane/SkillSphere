package com.skillsphere.service;

import com.skillsphere.dto.EmployeeProfileDto;
import com.skillsphere.dto.UpdateProfileRequest;
import com.skillsphere.entity.EmployeeProfile;
import com.skillsphere.entity.User;
import com.skillsphere.exception.ApiException;
import com.skillsphere.repository.EmployeeProfileRepository;
import com.skillsphere.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class EmployeeProfileService {

    private final EmployeeProfileRepository profileRepository;
    private final UserRepository userRepository;

    public EmployeeProfileService(EmployeeProfileRepository profileRepository, UserRepository userRepository) {
        this.profileRepository = profileRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public EmployeeProfile getOrCreateProfile(User user) {
        return profileRepository.findByUserId(user.getId())
                .orElseGet(() -> {
                    EmployeeProfile p = new EmployeeProfile(user);
                    return profileRepository.save(p);
                });
    }

    @Transactional(readOnly = true)
    public EmployeeProfileDto getProfileByEmail(String email) {
        User user = userRepository.findByEmail(email.trim().toLowerCase())
                .orElseThrow(() -> new ApiException(HttpStatus.NOT_FOUND, "User not found."));
        EmployeeProfile p = profileRepository.findByUserId(user.getId())
                .orElseGet(() -> new EmployeeProfile(user));
        return toDto(user, p);
    }

    @Transactional
    public EmployeeProfileDto updateProfile(String email, UpdateProfileRequest req) {
        User user = userRepository.findByEmail(email.trim().toLowerCase())
                .orElseThrow(() -> new ApiException(HttpStatus.NOT_FOUND, "User not found."));

        EmployeeProfile profile = profileRepository.findByUserId(user.getId())
                .orElseGet(() -> new EmployeeProfile(user));

        profile.setJobRole(req.jobRole().trim());
        profile.setDepartment(req.department() == null || req.department().isBlank() ? null : req.department().trim());
        profile.setExperienceLevel(req.experienceLevel().trim());
        profile.setBio(req.bio() == null || req.bio().isBlank() ? null : req.bio().trim());
        profile.setSkills(req.skills() == null || req.skills().isBlank() ? null : req.skills().trim());

        EmployeeProfile saved = profileRepository.save(profile);
        return toDto(user, saved);
    }

    private EmployeeProfileDto toDto(User u, EmployeeProfile p) {
        return new EmployeeProfileDto(
                u.getId(),
                u.getFullName(),
                u.getEmail(),
                u.getEmployeeId(),
                p.getJobRole() != null ? p.getJobRole() : "Software Developer",
                p.getDepartment(),
                p.getExperienceLevel() != null ? p.getExperienceLevel() : "Entry level",
                p.getBio(),
                p.getSkills()
        );
    }
}
