# SkillSphere — System & Software Architecture Specification

**Project:** SkillSphere — Organizational Knowledge Gap Intelligence Platform  
**Internship:** Infosys Springboard Virtual Internship 7.0  
**Version:** 2.0 (Post-Phase 6 Production Acceptance)  
**Status:** Approved & Implemented  
**Date:** November 18, 2026  

---

## 1. High-Level System Architecture

SkillSphere is architected as an enterprise single-page application (SPA) backed by a robust, secure, stateful RESTful service and a native relational database. The platform integrates external generative artificial intelligence (Google Gemini API) for dynamic assessment authoring and intelligent course recommendations, coupled with a native PostgreSQL database backup and sandbox recovery engine.

```mermaid
graph TB
    subgraph Client Tier ["Client Tier (Browser)"]
        SPA["React 18 SPA (Vite 5.4.21)<br/>Tailwind CSS + Custom CSS3 Design System<br/>React Router v6 Client Routing<br/>Stateful Axios HTTP Client (withCredentials: true)"]
    end

    subgraph Security Tier ["Security & Gateway Tier"]
        SecurityFilterChain["Spring Security 6 Filter Chain<br/>CookieCsrfTokenRepository (Double-Submit CSRF)<br/>HttpSessionSecurityContextRepository (JSESSIONID)<br/>BCryptPasswordEncoder (Cost: 12)<br/>MethodSecurityInterceptor (@PreAuthorize)"]
    end

    subgraph Application Tier ["Application Tier (Spring Boot 3.3.5 / Java 21 LTS)"]
        Controllers["23 @RestController Controllers (291 Endpoints)<br/>Auth, Dashboards, Employee, Manager, Mentor,<br/>HR, Department Head, Admin, Backups, Reports"]
        Services["Domain Service Layer<br/>AssessmentService, LearningService, ManagerService,<br/>HrDashboardService, DepartmentHeadService, BackupService"]
        AI_Integration["GeminiRecommendationService<br/>Google Gemini 3.5 Flash API<br/>Deterministic Database Catalogue Fallback"]
        ORM["Spring Data JPA / Hibernate 6.5.3.Final<br/>ddl-auto: validate<br/>HikariCP Connection Pool (Max: 10, Min: 5)"]
    end

    subgraph Data Tier ["Data Tier (PostgreSQL 18.4)"]
        FlywayEngine["Flyway Migration Engine (V1–V11)"]
        PostgresDB[("PostgreSQL 18.4 Database: skillsphere_db<br/>57 Relational Tables<br/>103 Foreign Key Constraints<br/>126 Performance Indexes")]
        BackupEngine["Native ProcessBuilder Orchestrator<br/>pg_dump.exe & pg_restore.exe<br/>15 Immutable Backup Archives"]
    end

    SPA <-->|"HTTP/1.1 REST + JSON (Port 8080)<br/>Session Cookie + X-XSRF-TOKEN"| SecurityFilterChain
    SecurityFilterChain <--> Controllers
    Controllers <--> Services
    Services <--> AI_Integration
    Services <--> ORM
    ORM <-->|"JDBC (HikariCP / Port 5432)"| PostgresDB
    FlywayEngine -.->|"Schema Validation on Startup"| PostgresDB
    Services -.->|"Subprocess Execution"| BackupEngine
    BackupEngine <--> PostgresDB
```

---

## 2. Frontend Component Architecture

The frontend is built with React 18 and Vite 5, structured into modular page workspaces corresponding to the six organizational roles, unified by a shared enterprise layout and responsive design primitives.

```mermaid
graph TD
    subgraph Core App Shell
        Main["main.jsx / App.jsx"] --> Router["React Router v6 Browser Router"]
        Router --> AuthProvider["AuthContext / ProtectedRoute"]
    end

    subgraph Shared Layout Components
        AuthProvider --> DashboardLayout["DashboardLayout.jsx<br/>Glassmorphic Sidebar (Desktop)<br/>Collapsible Header + Touch Drawer (Mobile)<br/>Active Role Pill & Session Indicator"]
        DashboardLayout --> KpiCard["KpiCard.jsx (Metric, Trend, Icon)"]
        DashboardLayout --> DataTable["DataTable.jsx (Sort, Filter, Pagination)"]
        DashboardLayout --> EmptyState["EmptyState.jsx (Illustration, Action)"]
    end

    subgraph Six Role Workspaces
        DashboardLayout --> EmployeeDash["EmployeeDashboard.jsx (21 Subviews)"]
        DashboardLayout --> ManagerDash["ManagerDashboard.jsx (13 Subviews)"]
        DashboardLayout --> MentorDash["MentorDashboard.jsx (10 Subviews)"]
        DashboardLayout --> HrDash["HrDashboard.jsx (15 Subviews)"]
        DashboardLayout --> DeptHeadDash["DepartmentHeadDashboard.jsx (11 Subviews)"]
        DashboardLayout --> AdminDash["AdminDashboard.jsx (12 Subviews)"]
    end

    subgraph Service Layer (Axios)
        EmployeeDash -.-> ApiServices["services/api.js<br/>authService, employeeProfileService, managerService,<br/>mentorService, hrService, deptHeadService, adminService"]
        ManagerDash -.-> ApiServices
        MentorDash -.-> ApiServices
        HrDash -.-> ApiServices
        DeptHeadDash -.-> ApiServices
        AdminDash -.-> ApiServices
    end
```

### Component Breakdown
- **`DashboardLayout.jsx`**: Enterprise wrapper supporting dynamic role-swapping, mobile navigation drawers, responsive collapse states ($\ge 1024\text{px}$ desktop sidebar, $< 1024\text{px}$ off-canvas hamburger drawer), user notification badges, and session logout controls.
- **`KpiCard.jsx`**: High-contrast, WCAG AA compliant metric container rendering numerical KPIs, percentage trend badges, and contextual Feather icons.
- **`DataTable.jsx`**: Standardized tabular display with column sorting, live search filtering, pagination controls, and mobile-friendly responsive wrappers.
- **`EmptyState.jsx`**: Friendly graphical placeholder rendered when queries return zero records (e.g., unassigned mentors, empty reassessment queues).

---

## 3. Backend Layered Architecture

The backend follows clean layered architecture principles, ensuring strict separation of concerns, dependency injection, and centralized exception handling.

```mermaid
graph TD
    subgraph Request Processing
        HTTP_Req["Incoming HTTP Request"] --> SecurityFilter["Spring Security Filter Chain"]
        SecurityFilter --> GlobalEx["GlobalExceptionHandler<br/>Catches MethodArgumentNotValidException,<br/>MethodArgumentTypeMismatchException (SS-BE-002),<br/>BadCredentialsException, AccessDeniedException"]
    end

    subgraph Controller Layer ["Web / Controller Layer (com.skillsphere.controller)"]
        GlobalEx --> Controllers["23 @RestController Classes<br/>Validation via @Valid & Bean Validation DTOs<br/>Security via @PreAuthorize('hasRole(...)')"]
    end

    subgraph Service Layer ["Business Service Layer (com.skillsphere.service)"]
        Controllers --> Services["Transactional Business Services<br/>AssessmentService (@Transactional read-write boundary SS-BE-001)<br/>LearningService, ManagerService, HrDashboardService,<br/>DepartmentHeadService, UserService, DatabaseBackupService"]
        Services --> GeminiClient["GeminiRecommendationService<br/>Restclient / WebClient to Google Gemini API<br/>Resilient Fallback Algorithm"]
    end

    subgraph Data Access Layer ["Persistence Layer (com.skillsphere.repository)"]
        Services --> Repositories["Spring Data JPA Repositories<br/>UserRepository, SkillRepository, SkillGapRepository,<br/>CourseRepository, DepartmentRepository, TeamRepository,<br/>AuditLogRepository, BackupMetadataRepository"]
    end

    subgraph Domain Model ["Domain Entity Model (com.skillsphere.model)"]
        Repositories --> Entities["57 JPA Entities<br/>User, Role, Skill, SkillGap, Course, EmployeeLearning,<br/>Department, Team, MentorshipSession, AuditLog"]
    end

    subgraph Database ["Physical Database (PostgreSQL 18.4)"]
        Entities --> DB[("skillsphere_db on localhost:5432")]
    end
```

---

## 4. Authentication, Authorization & Session Flow

SkillSphere adopts a stateful session architecture with enterprise CSRF double-submit protection:

```mermaid
sequenceDiagram
    autonumber
    actor User as User Browser / Client
    participant CSRF as /api/auth/csrf
    participant Auth as /api/auth/login
    participant Sec as Spring Security Filter Chain
    participant DB as PostgreSQL (users, roles)
    participant Res as Protected Controller (/api/manager/*)

    User->>CSRF: GET /api/auth/csrf
    CSRF-->>User: 200 OK + Set-Cookie: XSRF-TOKEN (readable by SPA)
    
    User->>Auth: POST /api/auth/login {"email", "password"}<br/>Header: X-XSRF-TOKEN
    Auth->>Sec: DaoAuthenticationProvider.authenticate()
    Sec->>DB: SELECT * FROM users WHERE email = ?
    DB-->>Sec: User entity + BCrypt hash + Roles
    Sec->>Sec: BCrypt.checkpw(rawPassword, hash)
    Sec-->>User: 200 OK + Set-Cookie: JSESSIONID (HttpOnly, SameSite=Lax)
    
    Note over User,Res: Authenticated Session Established
    
    User->>Res: GET /api/manager/teams<br/>Cookie: JSESSIONID
    Res->>Sec: Evaluate @PreAuthorize("hasAnyRole('MANAGER', 'ADMIN')")
    alt Authorized (User has ROLE_MANAGER)
        Sec->>Res: Delegate to ManagerController.getManagedTeams()
        Res-->>User: 200 OK [JSON Team List]
    else Unauthorized (User has ROLE_EMPLOYEE)
        Sec-->>User: 403 Forbidden {"error": "Access Denied"}
    else Unauthenticated (Missing/Expired JSESSIONID)
        Sec-->>User: 401 Unauthorized {"error": "Please sign in"}
    end
```

---

## 5. Core Business Workflow Diagrams

### 5.1 Dynamic Skill Gap Derivation & Persistence Engine
When an employee views their skill gaps, the system computes differences between their current assessed skills and the required competencies for their job role:

```mermaid
flowchart TD
    Start(["Employee calls GET /api/assessments/my-gaps"]) --> CheckAuth["Authenticate User from SecurityContext"]
    CheckAuth --> LoadReqs["Load RoleSkillRequirement for User's Job Role"]
    LoadReqs --> LoadSkills["Load EmployeeSkill Inventory for User"]
    LoadSkills --> Derivation{"Are there missing or deficient skills?"}
    
    Derivation -- Yes --> Compute["Compute gap_size = max(0, required_level - current_level)<br/>Assign Priority: HIGH / MEDIUM / LOW"]
    Derivation -- No --> NoGaps["Return Empty Gap List (0 gaps)"]
    
    Compute --> TxCheck["Open @Transactional Read-Write Boundary (SS-BE-001 Fixed)"]
    TxCheck --> PurgeOld["Delete stale cached gaps from skill_gaps table"]
    PurgeOld --> Persist["Persist new SkillGap entities to PostgreSQL"]
    Persist --> MapDTO["Map to SkillGapDto list"]
    MapDTO --> Client["Return HTTP 200 OK + JSON Gap Array"]
    NoGaps --> Client
```

### 5.2 Gemini AI Recommendation Engine with Graceful Fallback
Course recommendations leverage Google Gemini generative intelligence with an automatic database fallback:

```mermaid
flowchart TD
    Req(["POST /api/ai/recommendations"]) --> CheckApiKey{"Is GEMINI_API_KEY configured & valid?"}
    
    CheckApiKey -- No --> Fallback["Activate Rule-Based Recommendation Fallback"]
    CheckApiKey -- Yes --> CallGemini["Assemble Gap Dossier & Call Gemini 3.5 Flash API"]
    
    CallGemini --> GeminiResp{"Did Gemini return valid JSON within timeout?"}
    GeminiResp -- Yes (HTTP 200) --> ValidateIDs["Filter recommended course IDs against active catalogue"]
    GeminiResp -- Rate-Limited / 429 / 5xx --> Fallback
    
    Fallback --> SQLQuery["Query courses table matching skill_gaps for employee"]
    SQLQuery --> Rank["Rank courses by skill priority and difficulty level"]
    
    ValidateIDs --> Return["Return Recommendations (Source: 'GEMINI_AI')"]
    Rank --> ReturnFallback["Return Recommendations (Source: 'DATABASE_FALLBACK')"]
```

### 5.3 PostgreSQL Backup & Isolated Sandbox Restore Workflow
Platform integrity and disaster recovery are maintained via native PostgreSQL CLI utilities:

```mermaid
sequenceDiagram
    autonumber
    actor Admin as System Administrator
    participant BackupCtrl as DatabaseBackupController
    participant BackupSvc as DatabaseBackupService
    participant Shell as Windows Subprocess (ProcessBuilder)
    participant PG as PostgreSQL 18.4 Engine
    participant Disk as Local Backup Storage (.sql / .dump)

    Admin->>BackupCtrl: POST /api/admin/backups/create
    BackupCtrl->>BackupSvc: createBackup()
    BackupSvc->>Shell: Execute: pg_dump -U postgres -d skillsphere_db -F c -f backup_YYYYMMDD.dump
    Shell->>PG: Stream database catalog and schema
    PG-->>Shell: Complete binary dump stream
    Shell-->>Disk: Write compressed archive file
    BackupSvc->>PG: INSERT INTO database_backups (filename, size_bytes, created_at)
    BackupSvc-->>BackupCtrl: BackupMetadataDto
    BackupCtrl-->>Admin: HTTP 201 Created

    Admin->>BackupCtrl: POST /api/admin/backups/{id}/test-restore
    BackupCtrl->>BackupSvc: testRestoreInSandbox(id)
    BackupSvc->>PG: CREATE DATABASE skillsphere_sandbox_temp;
    BackupSvc->>Shell: Execute: pg_restore -d skillsphere_sandbox_temp backup_YYYYMMDD.dump
    Shell->>PG: Restore schema and records into sandbox
    BackupSvc->>PG: Query table counts & verify schema integrity in sandbox
    BackupSvc->>PG: DROP DATABASE skillsphere_sandbox_temp;
    BackupSvc->>PG: INSERT INTO audit_logs (action='ISOLATED_RESTORE_SUCCESS')
    BackupSvc-->>BackupCtrl: RestoreVerificationReportDto (Success: true)
    BackupCtrl-->>Admin: HTTP 200 OK
```

---

*SkillSphere Architecture Specification approved for production baseline.*
