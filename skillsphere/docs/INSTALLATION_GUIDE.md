# SkillSphere — Developer Installation & Environment Setup Guide

**Project:** SkillSphere — Organizational Knowledge Gap Intelligence Platform  
**Internship:** Infosys Springboard Virtual Internship 7.0  
**Target OS:** Windows 10 / 11 Enterprise (x64)  
**Backend:** Java 21 LTS / Spring Boot 3.3.5 / Apache Maven 3.9+  
**Frontend:** Node.js 20+ / npm 10+ / React 18 / Vite 5  
**Database:** Native PostgreSQL 18.4 (Port 5432)  
**Date:** November 18, 2026  

---

## 1. System Prerequisites & Toolchain Verification

Before cloning and setting up the SkillSphere platform, verify that the following core toolchains are installed on your Windows machine:

```powershell
# 1. Verify Java 21 LTS Runtime
java -version
# Expected: openjdk version "21.0.x" or Temurin-21

# 2. Verify Apache Maven
mvn -version
# Expected: Apache Maven 3.9.x

# 3. Verify Node.js and npm
node -v
# Expected: v20.x.x or higher
npm -v
# Expected: 10.x.x or higher

# 4. Verify PostgreSQL CLI Utilities
psql --version
pg_dump --version
# Expected: psql (PostgreSQL) 18.x
```

> [!IMPORTANT]
> Ensure the directory containing `psql.exe`, `pg_dump.exe`, and `pg_restore.exe` (typically `C:\Program Files\PostgreSQL\18\bin` or `D:\PostgreSQL\18\bin`) is added to your Windows system `PATH` environment variable. The native backup and recovery module executes these binaries via `ProcessBuilder`.

---

## 2. Database Setup & Initialization

### 2.1 Native PostgreSQL Service
1. Launch Windows Services (`services.msc`) and verify `postgresql-x64-18` is running.
2. Open PowerShell or Command Prompt and connect to PostgreSQL:
   ```powershell
   psql -U postgres -h 127.0.0.1 -p 5432
   ```
3. Create the dedicated SkillSphere database:
   ```sql
   CREATE DATABASE skillsphere_db;
   \q
   ```

> [!NOTE]
> You do **not** need to manually execute DDL scripts or schema files. When the Spring Boot backend starts, the embedded **Flyway Core engine automatically executes migrations V1 through V11**, creating all 57 tables, 103 foreign keys, and 126 indexes.

---

## 3. Backend Setup & Startup

### 3.1 Environment Configuration (`backend/.env`)
Navigate to the `backend/` directory and create your local environment configuration file from the template:

```powershell
cd c:\Users\gjaya\OneDrive\Desktop\SkillSphere\skillsphere\backend
copy .env.example .env
```

Open `.env` in your text editor and customize the parameters:

```ini
# Database Connection
DB_URL=jdbc:postgresql://localhost:5432/skillsphere_db
DB_USERNAME=postgres
DB_PASSWORD=your_actual_postgres_password

# Server & Client Addressing
SERVER_PORT=8080
FRONTEND_URL=http://localhost:5173
CORS_ALLOWED_ORIGINS=http://localhost:5173

# Security Settings
COOKIE_SECURE=false
LOG_RESET_LINKS=true

# Initial Administrator Seed (Created on startup if users table is empty)
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=ChangeMe!2024
ADMIN_FULL_NAME=SkillSphere Administrator

# External AI Service (Optional - Free API key from https://aistudio.google.com/apikey)
# If left blank, the system automatically uses the database-backed recommendation fallback.
GEMINI_API_KEY=
GEMINI_MODEL=gemini-3.5-flash
```

### 3.2 Running the Backend Application
Execute Maven to download dependencies, apply Flyway migrations, and launch the Spring Boot daemon:

```powershell
mvn spring-boot:run
```

Upon successful startup, the console displays:
```
[INFO] Flyway Community Edition 10.10.0 by Redgate
[INFO] Database: jdbc:postgresql://localhost:5432/skillsphere_db (PostgreSQL 18.4)
[INFO] Successfully applied 11 migrations to schema "public"
[INFO] Hibernate: ddl-auto: validate
[INFO] Started SkillSphereApplication in 7.424 seconds (process running on port 8080)
```

Verify backend health in your browser or curl:
```powershell
curl http://localhost:8080/api/auth/csrf
# Expected: {"parameterName":"_csrf","token":"...","headerName":"X-XSRF-TOKEN"}
```

---

## 4. Frontend Setup & Startup

### 4.1 Install Node Dependencies
Open a separate PowerShell terminal window and navigate to the `frontend/` directory:

```powershell
cd c:\Users\gjaya\OneDrive\Desktop\SkillSphere\skillsphere\frontend
npm install
```

### 4.2 Start Vite Development Server
Launch the client application with Hot Module Replacement (HMR):

```powershell
npm run dev
```

The terminal will report:
```
  VITE v5.4.21  ready in 320 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

Open `http://localhost:5173` in your browser to access the SkillSphere sign-in page.

### 4.3 Production Build Verification
To verify that the frontend bundles cleanly without transpilation errors:

```powershell
npm run build
# Expected: dist/index.html and dist/assets/*.js produced in ~2.5s with 0 errors.
```

---

## 5. Pre-Configured Demonstration Accounts

For testing across all six roles, the database contains seeded demonstration accounts:

| Role Identity | Email Address | Password | Assigned Department / Team |
|:---|:---|:---:|:---|
| **EMPLOYEE** | `test.employee.a.0badfa9e@skillsphere.com` | `Password123!` | Engineering / Frontend |
| **EMPLOYEE 2** | `test.employee.b.40323899@skillsphere.com` | `Password123!` | Engineering / Backend |
| **MANAGER** | `manager@example.com` | `ChangeMe!2024` | Engineering (Team 2 Lead) |
| **MENTOR** | `mentor@example.com` | `ChangeMe!2024` | Engineering (Senior Expert) |
| **HR_SPECIALIST** | `hr@gmail.com` | `Password123!` | Human Resources |
| **DEPARTMENT_HEAD**| `head@gmail.com` | `Password123!` | Engineering Department Head |
| **ADMIN** | `admin@example.com` | `ChangeMe!2024` | Platform Operations |

---

## 6. Common Issues & Troubleshooting

### 6.1 Database Authentication Failed (Password Mismatch)
- **Symptom:** `org.postgresql.util.PSQLException: FATAL: password authentication failed for user "postgres"`.
- **Solution:** Verify the `DB_PASSWORD` value in `backend/.env` matches your local PostgreSQL installation password.

### 6.2 Port 8080 or Port 5432 Already in Use
- **Symptom:** `Web server failed to start. Port 8080 was already in use.`
- **Solution:** Run `Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess | Stop-Process` to terminate stale background processes.

### 6.3 CORS or Cookie Not Sent in Browser
- **Symptom:** Axios calls return `401 Unauthorized` or `403 Forbidden` immediately.
- **Solution:** Always access the frontend via `http://localhost:5173` (not `http://127.0.0.1:5173`), matching the `CORS_ALLOWED_ORIGINS` setting in `backend/.env`.

### 6.4 `pg_dump` Not Recognized on System Path
- **Symptom:** Administrative backup button returns `Error executing pg_dump: Cannot run program "pg_dump"`.
- **Solution:** Add PostgreSQL `bin` directory to your system environment `Path` variable and restart the backend.

---

*SkillSphere Installation Guide verified for Windows development environments.*
