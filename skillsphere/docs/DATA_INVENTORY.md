# SkillSphere — Data Classification & Inventory Report

**Project:** SkillSphere — Organizational Knowledge Gap Intelligence Platform  
**Internship:** Infosys Springboard Virtual Internship 7.0  
**Phase:** Phase 7 — Data Audit & Classification  
**Database:** PostgreSQL 18.4 (`skillsphere_db`) on Port 5432  
**Date:** November 18, 2026  

---

## 1. Executive Summary & Audit Mandate

In accordance with Phase 6 and Phase 7 safety requirements, an exhaustive audit of all records residing in `skillsphere_db` was conducted. **Zero records have been deleted, dropped, or modified.**

This document provides a formal inventory classifying every database entity into either:
1. **Intended Project Baseline Data:** Core demonstration and production seed records required for platform evaluation.
2. **Verification Test Data:** Records created or transitioned during Phase 5 and Phase 6 automated end-to-end testing.

---

## 2. Inventory of Test Records Created During Verification

The following records were generated during Phase 6 end-to-end workflow verification and represent valid, evidence-backed proof of system functionality:

### 2.1 Test Courses (Journey 3 Verification)
- **Table:** `courses`
- **Record 1:** ID `225` — Title: `E2E Enterprise Cloud Architecture - 1794969902`, Level: `Advanced`, Duration: `3 hrs`, Created: `2026-11-18 08:15:02`.
- **Record 2:** ID `226` — Title: `E2E Enterprise Cloud Architecture - 1794970106`, Level: `Advanced`, Duration: `3 hrs`, Created: `2026-11-18 08:18:26`.
- **Origin & Purpose:** Created via authenticated `POST /api/hr/courses` calls by HR Specialist `hr@gmail.com` to verify Title Case schema constraint validation (`courses_level_check`) and cross-role visibility in the employee course catalogue.
- **Classification:** **Verification Test Record (Safe to Retain or Archive).**

### 2.2 Test Department Announcements (Journey 6 Verification)
- **Table:** `hr_announcements`
- **Record 1:** ID `89` — Title: `Q4 Strategic Workforce Readiness Plan - 1794969868`, Priority: `HIGH`, Department: `1 (Engineering)`, Created: `2026-11-18 08:14:28`.
- **Record 2:** ID `90` — Title: `Q4 Strategic Workforce Readiness Plan - 1794970106`, Priority: `HIGH`, Department: `1 (Engineering)`, Created: `2026-11-18 08:18:26`.
- **Origin & Purpose:** Created via authenticated `POST /api/department-head/announcements` calls by Department Head `head@gmail.com` to verify department-scoped bulletin board publication.
- **Classification:** **Verification Test Record (Safe to Retain or Archive).**

### 2.3 Employee Course Enrollment Progress (Journey 2 Verification)
- **Table:** `employee_learning`
- **Record:** ID `75` — User ID: `5048`, Course ID: `1`, `progress_pct = 75`, `status = 'IN_PROGRESS'`, Enrolled: `2026-11-18 08:12:29`.
- **Origin & Purpose:** Transitioned via `PUT /api/learning/progress/1` with payload `{"progressPct": 75}` to prove that completion progress updates persist reliably in PostgreSQL.
- **Classification:** **Verification Test Record (Safe to Retain).**

### 2.4 Dynamic Skill Gaps (Journey 1 Verification)
- **Table:** `skill_gaps`
- **Records:** IDs `672` through `678` (7 rows) for User ID `5048`.
  - Skill ID 1 (Java): `current_level=1`, `required_level=4`, `gap_size=3`, Priority: `HIGH`.
  - Skill ID 2 (Spring Boot): `current_level=1`, `required_level=4`, `gap_size=3`, Priority: `HIGH`.
  - Skill ID 3 (React): `current_level=1`, `required_level=3`, `gap_size=2`, Priority: `HIGH`.
  - Skill ID 4 (PostgreSQL): `current_level=1`, `required_level=4`, `gap_size=3`, Priority: `HIGH`.
  - Skill ID 6 (Git): `current_level=1`, `required_level=3`, `gap_size=2`, Priority: `HIGH`.
  - Skill ID 7 (Docker): `current_level=1`, `required_level=4`, `gap_size=3`, Priority: `HIGH`.
  - Skill ID 8 (Kubernetes): `current_level=1`, `required_level=4`, `gap_size=3`, Priority: `HIGH`.
- **Origin & Purpose:** Dynamically calculated by [`AssessmentService.java`](file:///C:/Users/gjaya/OneDrive/Desktop/SkillSphere/skillsphere/backend/src/main/java/com/skillsphere/service/AssessmentService.java#L768-L776) under the repaired `@Transactional` boundary (`SS-BE-001`).
- **Classification:** **Verification Test Record (Safe to Retain).**

### 2.5 Automated Test User Accounts
- **Table:** `users`
- **Accounts:**
  - `test.employee.a.0badfa9e@skillsphere.com` (User ID `5048`)
  - `test.employee.b.40323899@skillsphere.com` (User ID `5049`)
- **Origin & Purpose:** Established to allow continuous automated regression testing without altering baseline demonstration user profiles.
- **Classification:** **Verification Test Record (Safe to Retain).**

---

## 3. Inventory of Core Project Baseline Data

The following data constitutes the authoritative project baseline:

| Table | Live Count | Description of Baseline Content |
|:---|:---:|:---|
| `users` | 48 baseline users | Permanent role demonstration accounts: User 1 (`admin@example.com`), User 2 (`employee@example.com`), User 3 (`manager@example.com`), User 4 (`mentor@example.com`), User 107 (`hr@gmail.com`), User 108 (`head@gmail.com`). |
| `departments` | 17 departments | Organizational units: Engineering, Human Resources, Marketing, Quality Assurance, DevOps, etc. |
| `teams` | 2 teams | Managed engineering teams: Frontend Engineering and Backend Engineering. |
| `skills` | 21 skills | Standard organizational competency catalogue (Java, Spring Boot, React, PostgreSQL, Docker, Kubernetes, etc.). |
| `courses` | 24 baseline courses | Curated external and internal courses (Coursera, Duke University, Meta, etc.). |
| `assessment_questions` | 86 questions | Authoritative question bank covering foundational and advanced competencies. |
| `audit_logs` | 164 events | Permanent tamper-evident platform audit trail. |
| `database_backups` | 15 archives | Permanent metadata catalog of verified native backups. |

---

## 4. Preservation & Safety Certification

- **Zero Data Loss:** All 57 tables remain completely intact.
- **Referential Integrity:** Zero orphaned foreign key relationships exist across any of the verification records.
- **Non-Destructive Posture:** No SQL `DROP`, `TRUNCATE`, or `DELETE` statements were issued during this documentation phase.

---

*SkillSphere Data Classification & Inventory Report certified accurate as of November 18, 2026.*
