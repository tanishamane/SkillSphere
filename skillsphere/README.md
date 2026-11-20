# SkillSphere — Organizational Knowledge Gap Intelligence Platform

[![Java](https://img.shields.io/badge/Java-21_LTS-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://openjdk.org/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.3.5-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18.4-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![React](https://img.shields.io/badge/React-18-61DAFB?style=for-the-badge&logo=react&logoColor=black)](https://react.dev/)
[![Vite](https://img.shields.io/badge/Vite-5.4-646CFF?style=for-the-badge&logo=vite&logoColor=white)](https://vitejs.dev/)
[![Tests](https://img.shields.io/badge/Tests-404%20Passing-brightgreen?style=for-the-badge&logo=junit5&logoColor=white)]()
[![Status](https://img.shields.io/badge/Status-100%25%20Production%20Ready-success?style=for-the-badge)]()

**SkillSphere** is an enterprise-grade Organizational Knowledge Gap Intelligence Platform developed under the **Infosys Springboard Virtual Internship 7.0**. The platform dynamically identifies workforce competency deficits, computes empirical skill gaps against job-role benchmarks, visualizes multi-tier competency heatmaps, and provides AI-guided learning pathways alongside structured 1-on-1 expert mentorship.

---

## 1. Core Architectural Highlights

- **Dynamic Skill Gap Derivation:** Real-time server-side calculation ($\max(0, \text{Required} - \text{Current})$) backed by PostgreSQL transactional persistence.
- **Six Specialized Role Workspaces:** Dedicated dashboards for `EMPLOYEE`, `MANAGER`, `MENTOR`, `HR_SPECIALIST`, `DEPARTMENT_HEAD`, and `ADMIN`.
- **Enterprise Security:** Stateful session management (`JSESSIONID`, HttpOnly, SameSite=Lax), BCrypt-12 password hashing, double-submit CSRF protection (`X-XSRF-TOKEN`), and strict method-level `@PreAuthorize` authorization (96/96 passing RBAC matrix assertions).
- **Google Gemini Generative AI:** Intelligent course recommendations and assessment authoring, backed by a deterministic database fallback.
- **Relational Integrity:** 57 PostgreSQL tables governed by 11 Flyway migrations under strict Hibernate schema validation (`ddl-auto: validate`).
- **Disaster Recovery:** Native PostgreSQL backup orchestrator (`pg_dump`) paired with non-destructive isolated sandbox restore verification (`pg_restore`).

---

## 2. Platform Technology Stack

| Layer | Framework / Technology | Version & Details |
|:---|:---|:---|
| **Backend Runtime** | Java Development Kit (LTS) | OpenJDK 21.0.6 (64-Bit Server VM) |
| **Backend Framework** | Spring Boot | 3.3.5 (Web, Data JPA, Security, Validation) |
| **Security Engine** | Spring Security | 6.3.4 (Method-level RBAC, CSRF token, Session) |
| **Database Engine** | Native PostgreSQL | 18.4 (Port 5432, 57 tables, 103 FKs, 126 indexes) |
| **Schema Governance**| Flyway Core | 10.10.0 (Sequential migrations V1–V11) |
| **ORM / Dialect** | Hibernate ORM | 6.5.3.Final (`hibernate.ddl-auto: validate`) |
| **Frontend Framework**| React | 18.3.1 (Single Page Application architecture) |
| **Frontend Build Tool**| Vite | 5.4.21 (Production build in 2.52s, 0 errors) |
| **Styling & UI** | Tailwind CSS + Custom CSS3 | Modern enterprise glassmorphic design system |
| **AI Integration** | Google Gemini API | `gemini-3.5-flash` model with rule fallback |
| **Automated Tests** | JUnit 5 / Mockito / AssertJ | **404 / 404 tests passing** (100.0%) |

---

## 3. Repository Structure

```
skillsphere/
├── backend/                             # Java 21 / Spring Boot 3.3.5 service
│   ├── pom.xml                          # Maven build dependencies & test plugins
│   ├── .env.example                     # Backend environment configuration template
│   └── src/
│       ├── main/java/com/skillsphere/   # 23 Controllers, Services, Entities, DTOs
│       ├── main/resources/db/migration/ # Flyway SQL migrations V1 through V11
│       └── test/java/com/skillsphere/   # 404 Automated unit & integration tests
├── frontend/                            # React 18 / Vite 5 SPA
│   ├── package.json                     # Node dependencies & Vite build scripts
│   ├── .env.example                     # Client environment configuration template
│   └── src/
│       ├── components/                  # Shared UI components (Layout, Table, KPI)
│       ├── pages/                       # 6 Role Dashboards & 76 unique subviews
│       ├── services/                    # Axios REST client with CSRF interceptors
│       └── styles/                      # Tailwind & custom glassmorphic stylesheets
├── docs/                                # Authoritative platform documentation
│   ├── README.md                        # Master documentation index
│   ├── PROJECT_REPORT.md                # Complete 21-section technical project report
│   ├── ARCHITECTURE.md                  # System architecture & sequence diagrams
│   ├── DATABASE.md                      # 57 tables, constraints, 126 indexes & ER diagram
│   ├── API_DOCUMENTATION.md             # 291 REST API endpoints & DTO specifications
│   ├── TESTING_REPORT.md                # Consolidated testing report (Phases 1–6)
│   ├── USER_MANUAL.md                   # Operational manual for all six roles
│   ├── INSTALLATION_GUIDE.md            # Windows setup guide (Java, Node, PostgreSQL)
│   ├── DEPLOYMENT_GUIDE.md              # Production deployment & cloud hosting assessment
│   ├── MAINTENANCE_AND_BACKUP_GUIDE.md  # Operations, backup & isolated sandbox restore
│   └── DATA_INVENTORY.md                # Audit of test data vs project baseline data
├── .env.example                         # Root configuration template
└── README.md                            # Main project overview (this file)
```

---

## 4. Quickstart Guide (Local Windows Setup)

### Prerequisites
- **Java 21 LTS** (`java -version`)
- **Apache Maven 3.9+** (`mvn -version`)
- **Node.js 20+ & npm 10+** (`node -v`, `npm -v`)
- **PostgreSQL 18.4** (`psql --version`) running on `localhost:5432`

### 1. Database Creation
```powershell
psql -U postgres -h 127.0.0.1 -p 5432 -c "CREATE DATABASE skillsphere_db;"
```
*(Flyway automatically creates all 57 tables and seeds baseline data on first startup).*

### 2. Backend Startup
```powershell
cd backend
copy .env.example .env
# Edit .env: Set DB_PASSWORD to your PostgreSQL password
mvn spring-boot:run
```
*(Backend launches on `http://localhost:8080`).*

### 3. Frontend Startup
```powershell
cd frontend
npm install
npm run dev
```
*(Client launches on `http://localhost:5173`).*

---

## 5. Demonstration Accounts

The platform includes pre-seeded demonstration accounts for all six organizational roles:

| Role Identity | Email Address | Password | Landing Route |
|:---|:---|:---:|:---|
| **EMPLOYEE** | `test.employee.a.0badfa9e@skillsphere.com` | `Password123!` | `/dashboard/employee` |
| **MANAGER** | `manager@example.com` | `ChangeMe!2024` | `/dashboard/manager` |
| **MENTOR** | `mentor@example.com` | `ChangeMe!2024` | `/dashboard/mentor` |
| **HR_SPECIALIST** | `hr@gmail.com` | `Password123!` | `/dashboard/hr` |
| **DEPARTMENT_HEAD**| `head@gmail.com` | `Password123!` | `/dashboard/department-head` |
| **ADMIN** | `admin@example.com` | `ChangeMe!2024` | `/dashboard/admin` |

---

## 6. Complete Documentation Suite

For detailed technical, architectural, and operational specifications, refer to the documents in the [`docs/`](file:///c:/Users/gjaya/OneDrive/Desktop/SkillSphere/skillsphere/docs) directory:
- 📖 [Project Report](docs/PROJECT_REPORT.md)
- 🏗️ [Architecture Specification](docs/ARCHITECTURE.md)
- 🗄️ [Database Schema & ER Diagram](docs/DATABASE.md)
- 🔌 [REST API Documentation](docs/API_DOCUMENTATION.md)
- 🧪 [Consolidated Testing Report](docs/TESTING_REPORT.md)
- 👥 [Six-Role User Manual](docs/USER_MANUAL.md)
- 💻 [Installation Guide](docs/INSTALLATION_GUIDE.md)
- 🚀 [Production Deployment Guide](docs/DEPLOYMENT_GUIDE.md)
- 🛡️ [Maintenance & Backup Guide](docs/MAINTENANCE_AND_BACKUP_GUIDE.md)
- 📊 [Data Classification & Inventory](docs/DATA_INVENTORY.md)

---

## 7. License & Internship Attributions

Developed by **Jayanth G** as part of the **Infosys Springboard Virtual Internship 7.0**.  
© 2026 SkillSphere Project. All rights reserved.
