-- Run once as a PostgreSQL superuser to create the database:
--   psql -U postgres -c "CREATE DATABASE skillsphere_db;"
-- The tables are created automatically by Flyway when the backend starts
-- (see backend/src/main/resources/db/migration). The statements below are the
-- same schema, provided for reference or manual setup.

\connect skillsphere_db

CREATE TABLE IF NOT EXISTS users (
    id              BIGSERIAL PRIMARY KEY,
    full_name       VARCHAR(120)  NOT NULL,
    email           VARCHAR(254)  NOT NULL,
    employee_id     VARCHAR(30),
    password_hash   VARCHAR(100)  NOT NULL,
    role            VARCHAR(20)   NOT NULL DEFAULT 'EMPLOYEE',
    requested_role  VARCHAR(20),
    account_status  VARCHAR(20)   NOT NULL DEFAULT 'ACTIVE',
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    CONSTRAINT uq_users_email       UNIQUE (email),
    CONSTRAINT uq_users_employee_id UNIQUE (employee_id),
    CONSTRAINT chk_users_email_lc   CHECK (email = lower(email)),
    CONSTRAINT chk_users_role       CHECK (role IN ('EMPLOYEE', 'HR', 'MANAGER', 'ADMIN')),
    CONSTRAINT chk_users_req_role   CHECK (requested_role IS NULL OR requested_role IN ('EMPLOYEE', 'HR', 'MANAGER', 'ADMIN')),
    CONSTRAINT chk_users_status     CHECK (account_status IN ('ACTIVE', 'PENDING', 'SUSPENDED'))
);
CREATE INDEX IF NOT EXISTS idx_users_role ON users (role);

CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT       NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    token_hash  VARCHAR(64)  NOT NULL,
    expires_at  TIMESTAMPTZ  NOT NULL,
    used_at     TIMESTAMPTZ,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT uq_prt_token_hash UNIQUE (token_hash)
);
CREATE INDEX IF NOT EXISTS idx_prt_user ON password_reset_tokens (user_id);


-- V3: Knowledge Sharing, Peer Mentorship and Employee Profiles
CREATE TABLE IF NOT EXISTS employee_profiles (
    id                  BIGSERIAL PRIMARY KEY,
    user_id             BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    job_role            VARCHAR(80) NOT NULL DEFAULT 'Software Developer',
    department          VARCHAR(80),
    experience_level    VARCHAR(40) NOT NULL DEFAULT 'Entry level',
    bio                 TEXT,
    skills              TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT chk_profile_job_role CHECK (job_role IN ('Software Developer', 'Data Analyst', 'QA Engineer', 'Support Engineer')),
    CONSTRAINT chk_profile_experience CHECK (experience_level IN ('Entry level', 'Intermediate', 'Experienced'))
);
CREATE INDEX IF NOT EXISTS idx_employee_profiles_user ON employee_profiles (user_id);
CREATE INDEX IF NOT EXISTS idx_employee_profiles_job_role ON employee_profiles (job_role);

CREATE TABLE IF NOT EXISTS mentor_profiles (
    id                  BIGSERIAL PRIMARY KEY,
    user_id             BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    headline            VARCHAR(140) NOT NULL,
    expertise_areas     TEXT NOT NULL,
    max_mentees         INT NOT NULL DEFAULT 3 CHECK (max_mentees > 0),
    is_active           BOOLEAN NOT NULL DEFAULT true,
    approved_by_id      BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_mentor_profiles_active ON mentor_profiles (is_active);
CREATE INDEX IF NOT EXISTS idx_mentor_profiles_user ON mentor_profiles (user_id);

CREATE TABLE IF NOT EXISTS mentor_assignments (
    id                  BIGSERIAL PRIMARY KEY,
    mentor_id           BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    employee_id         BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assigned_by_id      BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    status              VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' 
                        CHECK (status IN ('ACTIVE', 'COMPLETED', 'TERMINATED')),
    notes               TEXT,
    assigned_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    ended_at            TIMESTAMPTZ,
    CONSTRAINT chk_no_self_mentoring CHECK (mentor_id <> employee_id)
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_active_employee_mentor ON mentor_assignments (employee_id) WHERE status = 'ACTIVE';
CREATE INDEX IF NOT EXISTS idx_mentor_assignments_mentor ON mentor_assignments (mentor_id);
CREATE INDEX IF NOT EXISTS idx_mentor_assignments_employee ON mentor_assignments (employee_id);

CREATE TABLE IF NOT EXISTS mentorship_sessions (
    id                  BIGSERIAL PRIMARY KEY,
    assignment_id       BIGINT NOT NULL REFERENCES mentor_assignments(id) ON DELETE CASCADE,
    title               VARCHAR(140) NOT NULL,
    description         TEXT,
    scheduled_at        TIMESTAMPTZ NOT NULL,
    duration_minutes    INT NOT NULL DEFAULT 45 CHECK (duration_minutes > 0),
    meeting_link        VARCHAR(500),
    status              VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED' 
                        CHECK (status IN ('SCHEDULED', 'COMPLETED', 'CANCELLED')),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_sessions_assignment ON mentorship_sessions (assignment_id);
CREATE INDEX IF NOT EXISTS idx_sessions_scheduled ON mentorship_sessions (scheduled_at);

CREATE TABLE IF NOT EXISTS mentorship_goals (
    id                  BIGSERIAL PRIMARY KEY,
    assignment_id       BIGINT NOT NULL REFERENCES mentor_assignments(id) ON DELETE CASCADE,
    title               VARCHAR(140) NOT NULL,
    description         TEXT,
    target_date         DATE,
    status              VARCHAR(20) NOT NULL DEFAULT 'IN_PROGRESS' 
                        CHECK (status IN ('IN_PROGRESS', 'ACHIEVED', 'ABANDONED')),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_goals_assignment ON mentorship_goals (assignment_id);

CREATE TABLE IF NOT EXISTS mentorship_feedback (
    id                  BIGSERIAL PRIMARY KEY,
    session_id          BIGINT NOT NULL UNIQUE REFERENCES mentorship_sessions(id) ON DELETE CASCADE,
    author_id           BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating              INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comments            TEXT NOT NULL,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_feedback_author ON mentorship_feedback (author_id);
