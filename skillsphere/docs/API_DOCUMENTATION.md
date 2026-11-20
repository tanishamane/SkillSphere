# SkillSphere — Comprehensive REST API Specification

**Project:** SkillSphere — Organizational Knowledge Gap Intelligence Platform  
**Internship:** Infosys Springboard Virtual Internship 7.0  
**Version:** 2.0 (Post-Phase 6 Production Acceptance)  
**Base URL:** `http://localhost:8080` (Development) / `https://api.skillsphere.example.com` (Production)  
**Authentication:** Cookie Session (`JSESSIONID`, HttpOnly) + Double-Submit CSRF Header (`X-XSRF-TOKEN`)  
**Total Mapped Endpoints:** 291 across 23 `@RestController` Classes  
**Date:** November 18, 2026  

---

## 1. Authentication, Session & Security Conventions

All secured endpoints enforce Spring Security 6 session-based authentication.
- **CSRF Handshake:** Clients must issue `GET /api/auth/csrf` to acquire the `XSRF-TOKEN` cookie, and forward its value as the `X-XSRF-TOKEN` header on all mutating HTTP requests (`POST`, `PUT`, `PATCH`, `DELETE`).
- **Standard Error Contract (`ApiError`):**
  ```json
  {
    "status": 400,
    "error": "Bad Request",
    "message": "Validation failed: durationHours must be at least 1",
    "timestamp": "2026-11-18T08:18:26Z",
    "path": "/api/hr/courses"
  }
  ```
- **HTTP Status Code Mapping:**
  - `200 OK`: Request succeeded; entity or list returned.
  - `201 Created`: Entity created successfully (`POST`).
  - `204 No Content`: Successful execution with empty body (e.g., unassigned mentor).
  - `400 Bad Request`: Payload validation failure or path variable type mismatch (`SS-BE-002`).
  - `401 Unauthorized`: Unauthenticated user; valid session missing.
  - `403 Forbidden`: Authenticated user lacks required role boundary (RBAC).
  - `404 Not Found`: Requested resource ID does not exist.
  - `409 Conflict`: Unique constraint violation or duplicate state.

---

## 2. Authentication & Public Gateway (`AuthController`)

Base Path: `/api/auth` (Public access; zero authentication required)

| Method | Endpoint | Role Requirement | Description | Expected Status |
|:---:|:---|:---:|:---|:---:|
| `GET` | `/api/auth/csrf` | `permitAll` | Returns current CSRF token and sets `XSRF-TOKEN` cookie | 200 OK |
| `POST` | `/api/auth/login` | `permitAll` | Authenticates email & password; sets `JSESSIONID` cookie | 200 OK, 401 |
| `POST` | `/api/auth/register` | `permitAll` | Self-service employee account registration | 201 Created, 400, 409 |
| `POST` | `/api/auth/logout` | `permitAll` | Revokes server session and clears session cookies | 200 OK |
| `POST` | `/api/auth/forgot-password` | `permitAll` | Triggers single-use password reset token creation | 200 OK |
| `POST` | `/api/auth/reset-password` | `permitAll` | Validates token and resets account password | 200 OK, 400 |
| `GET` | `/api/auth/me` | Authenticated | Returns currently authenticated user session details | 200 OK, 401 |

### Representative Login Example
- **Request (`POST /api/auth/login`):**
  ```json
  {
    "email": "employee@example.com",
    "password": "Password123!"
  }
  ```
- **Response (`200 OK`):**
  ```json
  {
    "id": 2,
    "email": "employee@example.com",
    "fullName": "Jane Doe",
    "role": "EMPLOYEE",
    "departmentName": "Engineering",
    "status": "ACTIVE"
  }
  ```

---

## 3. Employee Workspace Endpoints

### 3.1 Employee Profile & Dossier (`EmployeeProfileController`)
Base Path: `/api/employee/profile` (Allowed: `EMPLOYEE`, `ADMIN`)

| Method | Endpoint | Description | Request Body | Response DTO |
|:---:|:---|:---|:---:|:---:|
| `GET` | `/api/employee/profile` | Personal profile dossier | None | `EmployeeProfileDto` |
| `PUT` | `/api/employee/profile` | Update bio, phone, title | `UpdateProfileRequest` | `EmployeeProfileDto` |
| `GET` | `/api/employee/profile/resume` | Retrieve resume metadata | None | `ResumeMetadataDto` |
| `POST` | `/api/employee/profile/resume` | Upload PDF/Docx resume | Multipart Form | `ResumeMetadataDto` |

### 3.2 Skills & Dynamic Gap Analysis (`SkillController`, `AssessmentController`)
Base Paths: `/api/skills`, `/api/assessments` (Allowed: Authenticated Users)

| Method | Endpoint | Role | Description | Response DTO |
|:---:|:---|:---:|:---|:---:|
| `GET` | `/api/skills` | Any | Full organizational skill catalogue | `List<SkillDto>` |
| `GET` | `/api/skills/categories` | Any | Skill categories taxonomy | `List<CategoryDto>` |
| `GET` | `/api/skills/employee` | `EMPLOYEE` | User's evaluated skill proficiencies | `List<EmployeeSkillDto>` |
| `GET` | `/api/assessments/my-gaps` | `EMPLOYEE` | Dynamic skill gaps derivation & cache (`SS-BE-001`) | `List<SkillGapDto>` |
| `GET` | `/api/assessments` | `EMPLOYEE` | Catalogue of available assessments | `List<AssessmentDto>` |
| `POST` | `/api/assessments/{id}/start` | `EMPLOYEE` | Begin assessment & generate question pool | `AssessmentSessionDto` |
| `POST` | `/api/assessments/submit` | `EMPLOYEE` | Submit answers and trigger gap recalculation | `SubmissionResultDto` |

- **Skill Gap Response Example (`GET /api/assessments/my-gaps`):**
  ```json
  [
    {
      "id": 672,
      "skillId": 1,
      "skillName": "Java",
      "categoryName": "Technical",
      "currentProficiency": 1,
      "requiredProficiency": 4,
      "gapSize": 3,
      "priority": "HIGH",
      "calculatedAt": "2026-11-18T08:18:25Z"
    }
  ]
  ```

### 3.3 Learning & Course Tracking (`LearningController`, `RecommendationController`)
Base Paths: `/api/learning`, `/api/ai`

| Method | Endpoint | Role | Description | Response DTO |
|:---:|:---|:---:|:---|:---:|
| `GET` | `/api/learning/courses` | Any | Active course catalogue | `List<CourseDto>` |
| `GET` | `/api/learning/my` | `EMPLOYEE` | Courses enrolled by current user | `List<EnrolledCourseDto>` |
| `POST` | `/api/learning/enroll/{courseId}` | `EMPLOYEE` | Enroll in course | `EnrolledCourseDto` (201) |
| `PUT` | `/api/learning/progress/{courseId}` | `EMPLOYEE` | Update completion percentage | `EnrolledCourseDto` (200) |
| `POST` | `/api/ai/recommendations` | `EMPLOYEE` | Gemini AI course recommendations | `List<CourseRecommendationDto>` |

---

## 4. Manager Workspace Endpoints (`ManagerController`)

Base Path: `/api/manager` (Allowed: `MANAGER`, `ADMIN`)

| Method | Endpoint | Parameters | Description | Response DTO |
|:---:|:---|:---:|:---|:---:|
| `GET` | `/api/manager/overview` | `teamId` (opt) | Team size, avg gaps, completion rate | `ManagerOverviewDto` |
| `GET` | `/api/manager/teams` | None | Managed teams assigned to manager | `List<TeamDto>` |
| `GET` | `/api/manager/team-members`| `teamId`, `search` | Direct reports roster with gap counts | `List<TeamMemberDto>` |
| `GET` | `/api/manager/gap-analysis`| `teamId` | Team skill gaps and heat distribution | `TeamGapAnalysisDto` |
| `GET` | `/api/manager/heatmap` | `teamId` | Competency matrix across team members | `HeatmapMatrixDto` |
| `GET` | `/api/manager/reassessments`| None | Pending employee reassessment requests | `List<ReassessmentDto>` |
| `POST` | `/api/manager/reassessments/{id}/approve` | None | Approve reassessment request | `Void` (200 OK) |
| `GET` | `/api/manager/recommendations` | `teamId` | AI team skill development suggestions | `List<TeamRecommendationDto>` |
| `POST` | `/api/manager/course-recommendations` | JSON body | Assign recommended course to employee | `ManagerRecommendationDto` |

---

## 5. Mentor Workspace Endpoints (`MentorDashboardController`, `MentorshipController`)

Base Paths: `/api/mentor`, `/api/mentorship` (Allowed: `MENTOR`, `ADMIN`)

| Method | Endpoint | Role | Description | Response DTO |
|:---:|:---|:---:|:---|:---:|
| `GET` | `/api/mentor/overview` | `MENTOR` | Active mentees count, upcoming sessions | `MentorOverviewDto` |
| `GET` | `/api/mentor/mentees` | `MENTOR` | Roster of assigned mentees | `List<MenteeDetailDto>` |
| `GET` | `/api/mentor/requests` | `MENTOR` | Pending mentorship applications | `List<MentorshipRequestDto>` |
| `POST` | `/api/mentor/requests/{id}/accept` | `MENTOR` | Accept mentorship pairing request | `MentorshipPairingDto` |
| `GET` | `/api/mentor/sessions` | `MENTOR` | Logged 1-on-1 mentorship sessions | `List<SessionLogDto>` |
| `POST` | `/api/mentor/sessions` | `MENTOR` | Record meeting notes & action items | `SessionLogDto` (201) |
| `GET` | `/api/mentor/action-plans` | `MENTOR` | Developmental goals and milestones | `List<ActionPlanDto>` |

---

## 6. HR Specialist Workspace Endpoints (`HrDashboardController`)

Base Path: `/api/hr` (Allowed: `HR_SPECIALIST`, `ADMIN`)

| Method | Endpoint | Role | Description | Expected Status |
|:---:|:---|:---:|:---|:---:|
| `GET` | `/api/hr/overview` | `HR_SPEC` | Organization workforce KPIs | 200 OK |
| `GET` | `/api/hr/employees` | `HR_SPEC` | Complete employee directory & filters | 200 OK |
| `GET` | `/api/hr/employees/{id}/dossier` | `HR_SPEC` | Deep competency dossier for user | 200 OK |
| `GET` | `/api/hr/competencies` | `HR_SPEC` | Enterprise competency framework | 200 OK |
| `POST` | `/api/hr/competencies` | `HR_SPEC` | Create/update competency domain | 201 Created |
| `GET` | `/api/hr/role-requirements` | `HR_SPEC` | Role-to-skill baseline matrices | 200 OK |
| `POST` | `/api/hr/role-requirements` | `HR_SPEC` | Define required skill proficiency | 200 OK |
| `GET` | `/api/hr/skill-gaps/summary` | `HR_SPEC` | Organization-wide gap metrics | 200 OK |
| `GET` | `/api/hr/skill-gaps/heatmap` | `HR_SPEC` | Cross-department skill deficit heatmap | 200 OK |
| `GET` | `/api/hr/courses` | `HR_SPEC` | Course catalogue management | 200 OK |
| `POST` | `/api/hr/courses` | `HR_SPEC` | Create course (Level: Beginner/Intermediate/Advanced) | 201 Created |
| `GET` | `/api/hr/training-programmes` | `HR_SPEC` | Corporate training programmes | 200 OK |
| `POST` | `/api/hr/training-programmes` | `HR_SPEC` | Launch new corporate training cohort | 201 Created |
| `GET` | `/api/hr/mentors` | `HR_SPEC` | Mentorship governance & capacity | 200 OK |
| `POST` | `/api/hr/announcements` | `HR_SPEC` | Organization-wide broadcast bulletin | 201 Created |

---

## 7. Department Head Workspace Endpoints (`DepartmentHeadController`)

Base Path: `/api/department-head` (Allowed: `DEPARTMENT_HEAD`, `ADMIN`)

| Method | Endpoint | Parameters | Description | Response DTO |
|:---:|:---|:---:|:---|:---:|
| `GET` | `/api/department-head/overview` | `departmentId` | Executive department health score | `DeptOverviewDto` |
| `GET` | `/api/department-head/department`| `departmentId` | Department profile & team list | `DeptProfileDto` |
| `GET` | `/api/department-head/teams` | `departmentId` | Breakdown of department teams | `List<DeptTeamDto>` |
| `GET` | `/api/department-head/skill-matrix` | `departmentId` | Department-wide skill capability matrix | `DeptSkillMatrixDto`|
| `GET` | `/api/department-head/heatmap` | `departmentId` | Department gap severity heatmap | `DeptHeatmapDto` |
| `GET` | `/api/department-head/capability`| `departmentId` | Strategic readiness & benchmark score | `DeptCapabilityDto` |
| `GET` | `/api/department-head/risks` | `departmentId` | Critical skill gap priority alerts | `List<RiskAlertDto>` |
| `POST` | `/api/department-head/announcements` | None | Publish high-priority strategic bulletin | `AnnouncementDto` (201)|
| `GET` | `/api/department-head/reports/csv` | `reportType` | Export departmental analytics CSV | `byte[]` (text/csv) |

---

## 8. System Administrator & Governance Endpoints

### 8.1 User Management (`AdminController`)
Base Path: `/api/admin/users` (Allowed: `ADMIN`)

| Method | Endpoint | Description | Request / Action | Expected Status |
|:---:|:---|:---|:---:|:---:|
| `GET` | `/api/admin/users` | List all system accounts | None | 200 OK |
| `PATCH` | `/api/admin/users/{id}/role` | Update user role | `{"role": "MANAGER"}` | 200 OK |
| `PATCH` | `/api/admin/users/{id}/status`| Update status (ACTIVE/SUSPENDED) | `{"status": "SUSPENDED"}` | 200 OK |

### 8.2 System Health, Audit & Backups (`AdminDashboardController`, `DatabaseBackupController`)
Base Path: `/api/admin` (Allowed: `ADMIN`)

| Method | Endpoint | Description | Response DTO |
|:---:|:---|:---|:---:|
| `GET` | `/api/admin/overview` | Platform health, active sessions, role distribution | `AdminOverviewDto` |
| `GET` | `/api/admin/audit-logs` | Immutable security audit trail (164+ events) | `List<AuditLogDto>` |
| `GET` | `/api/admin/backups` | Native PostgreSQL backup archive catalog | `List<BackupMetadataDto>` |
| `POST` | `/api/admin/backups/create` | Trigger native `pg_dump` backup | `BackupMetadataDto` (201) |
| `POST` | `/api/admin/backups/{id}/test-restore` | Execute isolated sandbox recovery verification | `RestoreReportDto` (200) |

---

*SkillSphere REST API Specification verified across all 291 controller endpoints.*
