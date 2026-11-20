# SkillSphere — Six-Role Enterprise User Manual

**Project:** SkillSphere — Organizational Knowledge Gap Intelligence Platform  
**Internship:** Infosys Springboard Virtual Internship 7.0  
**Target Audience:** Employees, People Managers, Mentors, HR Specialists, Department Heads, System Administrators  
**Platform URL:** `http://localhost:5173` (Development) / `https://skillsphere.example.com` (Production)  
**Version:** 2.0  
**Date:** November 18, 2026  

---

## 1. General Access & Security Conventions

### 1.1 Authentication & Login
1. Navigate to `/login` using any modern web browser (Google Chrome, Mozilla Firefox, Microsoft Edge, Safari).
2. Enter your corporate **Email Address** and **Password**.
3. Click the **"Sign In"** button.
4. Upon successful credential verification, the platform automatically redirects you to your role-specific dashboard based on your assigned organizational role.

```
+----------------------------------------------------------------------------------------------------+
|                                    ROLE REDIRECTION DIRECTORY                                       |
+---------------------+-----------------------------+------------------------------------------------+
| User Role           | Default Landing Route       | Primary Operational Objective                  |
+---------------------+-----------------------------+------------------------------------------------+
| EMPLOYEE            | `/dashboard/employee`       | Assess skills, track gaps, complete courses    |
| MANAGER             | `/dashboard/manager`        | Monitor team gaps, review assessments, heatmaps|
| MENTOR              | `/dashboard/mentor`         | Conduct 1-on-1 sessions, track mentee goals    |
| HR_SPECIALIST       | `/dashboard/hr`             | Manage competency frameworks, courses, audits  |
| DEPARTMENT_HEAD     | `/dashboard/department-head`| Department capability matrices, risk alerts    |
| ADMIN               | `/dashboard/admin`          | User account lifecycle, system config, backups |
+---------------------+-----------------------------+------------------------------------------------+
```

### 1.2 Layout & Navigation Primitives
- **Desktop Sidebar ($\ge 1024\text{ px}$):** Persistent left-hand dark glassmorphic navigation panel displaying your active role badge, primary navigation items, and user profile summary.
- **Mobile Drawer ($< 1024\text{ px}$):** Click the hamburger menu icon ($\equiv$) in the top-left header to reveal the full navigation drawer. Click anywhere outside or select an item to close.
- **Session Logout:** Click the **"Sign Out"** button in the lower section of the sidebar to immediately invalidate your session and return to the login screen.

---

## 2. Employee Workspace (`EMPLOYEE`)

### 2.1 Workspace Overview
The Employee Workspace empowers individual contributors to self-evaluate competencies, identify skill deficits, discover targeted learning courses, and engage with expert mentors.

### 2.2 Key Navigation Modules & Workflows
1. **Overview (`/dashboard/employee`):**
   - Displays real-time summary cards: *Assessed Skills*, *Active Skill Gaps*, *Enrolled Courses*, and *Overall Readiness Score*.
   - Quick action shortcuts to start a new assessment or browse recommended courses.
2. **Skills Inventory:**
   - View your self-assessed and endorsed proficiencies on a 5-point scale: `Unaware (1)`, `Beginner (2)`, `Intermediate (3)`, `Advanced (4)`, `Expert (5)`.
   - Add newly acquired skills with optional proof-of-work URLs.
3. **Skill Assessments & Gap Derivation:**
   - Select an available assessment from the catalogue.
   - Complete the multiple-choice question pool.
   - Upon submission, the engine dynamically recalculates your skill gaps against your job role requirements. View your categorized deficits (*High*, *Medium*, *Low Priority*).
4. **Learning & Courses:**
   - Discover internal and external courses aligned with your detected gaps.
   - Click **"Enroll"** to start a course.
   - Update your progress slider (0% to 100%). Upon reaching 100%, the platform marks the course as `COMPLETED` and awards a digital certificate.
5. **AI Course Recommendations:**
   - Powered by Gemini generative intelligence. Click **"Refresh Recommendations"** to receive AI-tailored course pathways based on your latest assessment gaps.
6. **Mentorship:**
   - Browse the directory of certified mentors.
   - Submit a mentorship pairing request specifying target growth areas.
   - Once paired, access shared developmental goals and meeting agendas.

---

## 3. Manager Workspace (`MANAGER`)

### 3.1 Workspace Overview
Designed for engineering managers, team leads, and project directors to oversee direct reports, analyze team-level competency heatmaps, and approve reassessments.

### 3.2 Key Navigation Modules & Workflows
1. **Team Overview:**
   - Filter by assigned team (e.g., *Frontend Engineering*, *Backend Services*).
   - High-level KPIs: *Team Headcount*, *Average Gap Severity*, *Course Completion Velocity*.
2. **Team Member Roster:**
   - Search and filter direct reports.
   - Click any member to inspect their individual dossier, current skills, and active gaps.
3. **Team Skill Heatmap:**
   - Interactive matrix displaying team members along rows and skills along columns.
   - Color-coded cells indicate proficiency levels (Red = Critical Gap, Yellow = Moderate, Green = Proficient).
4. **Reassessment Approval Queue:**
   - Review pending employee requests to re-take skill assessments.
   - Click **"Approve"** to unlock the assessment or **"Reject"** with feedback notes.
5. **Assign Recommended Courses:**
   - Recommend high-priority courses to team members to address recurring operational gaps.

---

## 4. Mentor Workspace (`MENTOR`)

### 4.1 Workspace Overview
Empowers subject-matter experts and senior staff to guide junior employees through structured 1-on-1 coaching, goal setting, and skill endorsements.

### 4.2 Key Navigation Modules & Workflows
1. **Mentor Overview:**
   - Active mentee count against your configured capacity limit.
   - Quick calendar summary of upcoming scheduled coaching sessions.
2. **Mentorship Applications:**
   - Review incoming requests from employees seeking guidance.
   - Inspect their verified skill gaps and proposed focus topics.
   - Click **"Accept"** to establish the mentorship pairing.
3. **Active Mentees & Action Plans:**
   - Co-create SMART developmental goals with each mentee.
   - Break goals down into granular checklist action items with target completion dates.
4. **Session Logging:**
   - Log completed 1-on-1 coaching sessions.
   - Record meeting notes, key takeaways, and next steps.

---

## 5. HR Specialist Workspace (`HR_SPECIALIST`)

### 5.1 Workspace Overview
The command center for Human Resources and People Operations to define enterprise competency standards, design role requirements, manage course catalogues, and monitor organization-wide readiness.

### 5.2 Key Navigation Modules & Workflows
1. **Enterprise Workforce Overview:**
   - Organization-level talent metrics, department capability distributions, and headcount health.
2. **Competency Framework Management:**
   - Define new organizational skills under categories (Technical, Domain, Quality, Leadership).
   - Maintain the standard 5-point competency definitions.
3. **Role-Based Skill Requirements:**
   - Establish required baseline proficiencies for every job role (e.g., *Senior Software Engineer requires Java Level 4, Spring Boot Level 4*).
   - These baselines directly power the dynamic gap calculation engine across all employee accounts.
4. **Course Catalogue & Training Cohorts:**
   - Create and edit internal and external courses.
   - Ensure the difficulty level matches Title Case conventions: `Beginner`, `Intermediate`, or `Advanced`.
   - Organize formal corporate training programmes and monitor enrollment cohorts.
5. **Organization Gap Heatmap:**
   - Cross-department macro view identifying widespread skill deficits to guide talent acquisition and training budgets.
6. **Broadcast Announcements:**
   - Publish organization-wide bulletins to inform employees of training schedules and platform updates.

---

## 6. Department Head Workspace (`DEPARTMENT_HEAD`)

### 6.1 Workspace Overview
Tailored for Vice Presidents and Department Directors to audit strategic workforce capabilities, assess operational risks, and align engineering talent with business milestones.

### 6.2 Key Navigation Modules & Workflows
1. **Department Executive Dashboard:**
   - Automatically scoped to your assigned department (e.g., *Engineering*).
   - Strategic metrics: *Overall Capability Readiness Score*, *Critical Risk Count*, *Total Department Headcount*.
2. **Department Teams & Matrix:**
   - Deep-dive into department teams and team-by-team capability distributions.
   - Evaluate whether critical competencies are concentrated in single points of failure.
3. **Capability Risk Priority Alerts:**
   - Identifies high-severity skill deficits that threaten project delivery timelines.
   - Color-coded risk priority badges (*High*, *Medium*, *Low*).
4. **Publish Strategic Bulletins:**
   - Issue high-priority announcements targeted directly to your department workforce.
5. **Executive CSV Report Export:**
   - Click **"Export CSV"** to download comprehensive departmental capability and gap audit spreadsheets for executive review.

---

## 7. System Administrator Workspace (`ADMIN`)

### 7.1 Workspace Overview
Provides complete platform governance, security auditing, account lifecycle administration, and automated database disaster recovery.

### 7.2 Key Navigation Modules & Workflows
1. **Executive Platform Health:**
   - Real-time active user accounts, role distribution breakdowns, and database health indicators.
2. **User Accounts Management (`/dashboard/admin`):**
   - Search, filter, and inspect detailed user accounts across all six roles.
   - Change user roles (e.g., promote `EMPLOYEE` to `MANAGER`).
   - Toggle account status between `ACTIVE` and `SUSPENDED`.
3. **Immutable Security Audit Log:**
   - Inspect the tamper-evident security audit trail (164+ logged events).
   - Filters for authentication events, role modifications, configuration changes, and backup restorations.
4. **Native PostgreSQL Backup Management:**
   - View the catalog of available compressed backup archives.
   - Click **"Create Backup Now"** to trigger a native `pg_dump` binary snapshot of `skillsphere_db`.
   - Click **"Test Sandbox Restore"** to execute an isolated, non-destructive recovery verification in a temporary database sandbox to guarantee archive validity.
5. **System Configuration:**
   - Manage global application parameters (session timeouts, notification policies, email gateway settings).

---

*SkillSphere Six-Role User Manual certified for organizational rollout.*
