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
