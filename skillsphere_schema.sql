--
-- PostgreSQL database dump
--

\restrict 6By1Rf2lbbAkZ1iXOpeXR0FvFZ78eVYMGo3wgKcdp7ztZaskDbmZ85w2ER8TqRt

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: assessment_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_assignments (
    id bigint NOT NULL,
    assessment_id bigint NOT NULL,
    user_id bigint NOT NULL,
    assigned_by_id bigint NOT NULL,
    due_date date,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT assessment_assignments_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'COMPLETED'::character varying, 'OVERDUE'::character varying])::text[])))
);


--
-- Name: assessment_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessment_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessment_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessment_assignments_id_seq OWNED BY public.assessment_assignments.id;


--
-- Name: assessment_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_attempts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    assessment_id bigint,
    assignment_id bigint,
    target_level character varying(30) DEFAULT 'Intermediate'::character varying NOT NULL,
    current_level character varying(30) DEFAULT 'Unaware'::character varying,
    status character varying(20) DEFAULT 'IN_PROGRESS'::character varying NOT NULL,
    generation_source character varying(30) DEFAULT 'FALLBACK'::character varying NOT NULL,
    generation_status character varying(30) DEFAULT 'SUCCESS'::character varying NOT NULL,
    generation_error text,
    score integer,
    passed boolean,
    correct_answers integer,
    total_questions integer DEFAULT 0 NOT NULL,
    answers_json text,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    CONSTRAINT assessment_attempts_generation_source_check CHECK (((generation_source)::text = ANY ((ARRAY['AI_GENERATED'::character varying, 'FALLBACK'::character varying])::text[]))),
    CONSTRAINT assessment_attempts_generation_status_check CHECK (((generation_status)::text = ANY ((ARRAY['SUCCESS'::character varying, 'FALLBACK_TRIGGERED'::character varying, 'FAILED'::character varying])::text[]))),
    CONSTRAINT assessment_attempts_status_check CHECK (((status)::text = ANY ((ARRAY['IN_PROGRESS'::character varying, 'COMPLETED'::character varying, 'ABANDONED'::character varying, 'EXPIRED'::character varying])::text[])))
);


--
-- Name: assessment_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessment_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessment_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessment_attempts_id_seq OWNED BY public.assessment_attempts.id;


--
-- Name: assessment_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_questions (
    id bigint NOT NULL,
    assessment_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    question_text text NOT NULL,
    options_json text NOT NULL,
    correct_answer_index integer NOT NULL,
    points integer DEFAULT 1 NOT NULL,
    attempt_id bigint,
    difficulty character varying(20) DEFAULT 'MEDIUM'::character varying NOT NULL,
    subtopic character varying(100),
    explanation text,
    question_order integer DEFAULT 0 NOT NULL
);


--
-- Name: assessment_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessment_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessment_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessment_questions_id_seq OWNED BY public.assessment_questions.id;


--
-- Name: assessment_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_responses (
    id bigint NOT NULL,
    submission_id bigint NOT NULL,
    question_id bigint NOT NULL,
    selected_option_index integer NOT NULL,
    is_correct boolean NOT NULL
);


--
-- Name: assessment_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessment_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessment_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessment_responses_id_seq OWNED BY public.assessment_responses.id;


--
-- Name: assessment_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_submissions (
    id bigint NOT NULL,
    assessment_id bigint NOT NULL,
    user_id bigint NOT NULL,
    assignment_id bigint,
    score integer NOT NULL,
    passed boolean DEFAULT false NOT NULL,
    completed_at timestamp with time zone DEFAULT now() NOT NULL,
    attempt_id bigint,
    generation_source character varying(30) DEFAULT 'FALLBACK'::character varying NOT NULL,
    target_level character varying(30),
    skill_id bigint
);


--
-- Name: assessment_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessment_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessment_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessment_submissions_id_seq OWNED BY public.assessment_submissions.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    user_id bigint,
    action character varying(100) NOT NULL,
    entity_name character varying(100) NOT NULL,
    entity_id character varying(100),
    details text,
    ip_address character varying(45),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: calendar_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calendar_events (
    id bigint NOT NULL,
    creator_id bigint NOT NULL,
    title character varying(140) NOT NULL,
    description text,
    event_type character varying(20) NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    location_or_link character varying(500),
    reference_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT calendar_events_event_type_check CHECK (((event_type)::text = ANY ((ARRAY['ASSESSMENT'::character varying, 'MENTORSHIP'::character varying, 'LEARNING'::character varying, 'TRAINING'::character varying, 'TEAM'::character varying])::text[])))
);


--
-- Name: calendar_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calendar_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calendar_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.calendar_events_id_seq OWNED BY public.calendar_events.id;


--
-- Name: certificates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificates (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    course_id bigint NOT NULL,
    certificate_code character varying(80) NOT NULL,
    title character varying(140) NOT NULL,
    issue_date date DEFAULT CURRENT_DATE NOT NULL,
    expiry_date date,
    credential_url character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: certificates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificates_id_seq OWNED BY public.certificates.id;


--
-- Name: conversation_participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversation_participants (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    user_id bigint NOT NULL,
    joined_at timestamp with time zone DEFAULT now() NOT NULL,
    last_read_at timestamp with time zone,
    is_muted boolean DEFAULT false NOT NULL,
    is_archived boolean DEFAULT false NOT NULL
);


--
-- Name: conversation_participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conversation_participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversation_participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conversation_participants_id_seq OWNED BY public.conversation_participants.id;


--
-- Name: conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversations (
    id bigint NOT NULL,
    type character varying(20) DEFAULT 'DIRECT'::character varying NOT NULL,
    title character varying(140),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    team_id bigint,
    CONSTRAINT conversations_type_check CHECK (((type)::text = ANY ((ARRAY['DIRECT'::character varying, 'TEAM'::character varying])::text[])))
);


--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    id bigint NOT NULL,
    title character varying(140) NOT NULL,
    description text,
    skill_id bigint,
    level character varying(20) NOT NULL,
    duration_hours integer DEFAULT 10 NOT NULL,
    provider character varying(80) DEFAULT 'SkillSphere Academy'::character varying NOT NULL,
    course_url character varying(500),
    thumbnail_url character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT courses_level_check CHECK (((level)::text = ANY ((ARRAY['Beginner'::character varying, 'Intermediate'::character varying, 'Advanced'::character varying])::text[])))
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    head_user_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: discussion_replies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discussion_replies (
    id bigint NOT NULL,
    thread_id bigint NOT NULL,
    author_id bigint NOT NULL,
    content text NOT NULL,
    is_accepted_answer boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: discussion_replies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.discussion_replies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discussion_replies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.discussion_replies_id_seq OWNED BY public.discussion_replies.id;


--
-- Name: discussion_threads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discussion_threads (
    id bigint NOT NULL,
    author_id bigint NOT NULL,
    title character varying(140) NOT NULL,
    content text NOT NULL,
    category character varying(80),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    reply_count integer DEFAULT 0 NOT NULL
);


--
-- Name: discussion_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.discussion_threads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discussion_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.discussion_threads_id_seq OWNED BY public.discussion_threads.id;


--
-- Name: employee_learning; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_learning (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    course_id bigint NOT NULL,
    status character varying(30) DEFAULT 'NOT_STARTED'::character varying NOT NULL,
    progress_pct integer DEFAULT 0 NOT NULL,
    enrolled_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    expires_at timestamp with time zone,
    CONSTRAINT employee_learning_status_check CHECK (((status)::text = ANY ((ARRAY['NOT_STARTED'::character varying, 'IN_PROGRESS'::character varying, 'COMPLETED'::character varying, 'CERTIFIED'::character varying, 'EXPIRED'::character varying])::text[])))
);


--
-- Name: employee_learning_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_learning_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_learning_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_learning_id_seq OWNED BY public.employee_learning.id;


--
-- Name: employee_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_profiles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    job_role character varying(80) DEFAULT 'Software Developer'::character varying NOT NULL,
    department character varying(80),
    experience_level character varying(40) DEFAULT 'Entry level'::character varying NOT NULL,
    bio text,
    skills text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_profile_experience CHECK (((experience_level)::text = ANY ((ARRAY['Entry level'::character varying, 'Intermediate'::character varying, 'Experienced'::character varying])::text[]))),
    CONSTRAINT chk_profile_job_role CHECK (((job_role)::text = ANY ((ARRAY['Software Developer'::character varying, 'Data Analyst'::character varying, 'QA Engineer'::character varying, 'Support Engineer'::character varying])::text[])))
);


--
-- Name: employee_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_profiles_id_seq OWNED BY public.employee_profiles.id;


--
-- Name: employee_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_skills (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    proficiency_level character varying(20) NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    verified_by_id bigint,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT employee_skills_proficiency_level_check CHECK (((proficiency_level)::text = ANY ((ARRAY['Unaware'::character varying, 'Beginner'::character varying, 'Intermediate'::character varying, 'Advanced'::character varying, 'Expert'::character varying])::text[])))
);


--
-- Name: employee_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_skills_id_seq OWNED BY public.employee_skills.id;


--
-- Name: event_participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_participants (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    user_id bigint NOT NULL,
    status character varying(20) DEFAULT 'INVITED'::character varying NOT NULL,
    CONSTRAINT event_participants_status_check CHECK (((status)::text = ANY ((ARRAY['INVITED'::character varying, 'ACCEPTED'::character varying, 'DECLINED'::character varying])::text[])))
);


--
-- Name: event_participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_participants_id_seq OWNED BY public.event_participants.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: goal_action_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goal_action_items (
    id bigint NOT NULL,
    goal_id bigint NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    is_completed boolean DEFAULT false NOT NULL,
    due_date date,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: goal_action_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goal_action_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goal_action_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goal_action_items_id_seq OWNED BY public.goal_action_items.id;


--
-- Name: hr_announcement_reads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_announcement_reads (
    id bigint NOT NULL,
    announcement_id bigint NOT NULL,
    user_id bigint NOT NULL,
    read_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: hr_announcement_reads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hr_announcement_reads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hr_announcement_reads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hr_announcement_reads_id_seq OWNED BY public.hr_announcement_reads.id;


--
-- Name: hr_announcements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hr_announcements (
    id bigint NOT NULL,
    author_id bigint NOT NULL,
    target_type character varying(30) DEFAULT 'ORGANIZATION'::character varying NOT NULL,
    department_id bigint,
    target_role character varying(80),
    title character varying(200) NOT NULL,
    content text NOT NULL,
    priority character varying(20) DEFAULT 'NORMAL'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT hr_announcements_priority_check CHECK (((priority)::text = ANY ((ARRAY['NORMAL'::character varying, 'HIGH'::character varying, 'URGENT'::character varying])::text[]))),
    CONSTRAINT hr_announcements_target_type_check CHECK (((target_type)::text = ANY ((ARRAY['ORGANIZATION'::character varying, 'DEPARTMENT'::character varying, 'ROLE'::character varying])::text[])))
);


--
-- Name: hr_announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hr_announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hr_announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hr_announcements_id_seq OWNED BY public.hr_announcements.id;


--
-- Name: knowledge_articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.knowledge_articles (
    id bigint NOT NULL,
    category_id bigint,
    author_id bigint NOT NULL,
    title character varying(140) NOT NULL,
    content text NOT NULL,
    tags character varying(200),
    status character varying(20) DEFAULT 'PUBLISHED'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT knowledge_articles_status_check CHECK (((status)::text = ANY ((ARRAY['DRAFT'::character varying, 'PUBLISHED'::character varying, 'ARCHIVED'::character varying])::text[])))
);


--
-- Name: knowledge_articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.knowledge_articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: knowledge_articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.knowledge_articles_id_seq OWNED BY public.knowledge_articles.id;


--
-- Name: knowledge_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.knowledge_categories (
    id bigint NOT NULL,
    name character varying(80) NOT NULL,
    description text
);


--
-- Name: knowledge_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.knowledge_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: knowledge_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.knowledge_categories_id_seq OWNED BY public.knowledge_categories.id;


--
-- Name: leadership_report_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leadership_report_shares (
    id bigint NOT NULL,
    report_type character varying(60) NOT NULL,
    title character varying(200) NOT NULL,
    shared_by_id bigint NOT NULL,
    shared_with_role character varying(30) NOT NULL,
    department_id bigint,
    summary_notes text,
    report_data_json text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT leadership_report_shares_shared_with_role_check CHECK (((shared_with_role)::text = ANY ((ARRAY['MANAGER'::character varying, 'DEPARTMENT_HEAD'::character varying, 'ALL_LEADERSHIP'::character varying])::text[])))
);


--
-- Name: leadership_report_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leadership_report_shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leadership_report_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leadership_report_shares_id_seq OWNED BY public.leadership_report_shares.id;


--
-- Name: learning_path_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.learning_path_items (
    id bigint NOT NULL,
    learning_path_id bigint NOT NULL,
    course_id bigint NOT NULL,
    step_order integer NOT NULL
);


--
-- Name: learning_path_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.learning_path_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: learning_path_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.learning_path_items_id_seq OWNED BY public.learning_path_items.id;


--
-- Name: learning_paths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.learning_paths (
    id bigint NOT NULL,
    title character varying(140) NOT NULL,
    description text,
    target_role character varying(80),
    created_by_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    skill_id bigint,
    difficulty_level character varying(30) DEFAULT 'Beginner'::character varying
);


--
-- Name: learning_paths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.learning_paths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: learning_paths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.learning_paths_id_seq OWNED BY public.learning_paths.id;


--
-- Name: manager_course_recommendations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manager_course_recommendations (
    id bigint NOT NULL,
    manager_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    course_id bigint NOT NULL,
    skill_id bigint,
    reason text NOT NULL,
    status character varying(20) DEFAULT 'RECOMMENDED'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_mgr_rec_status CHECK (((status)::text = ANY ((ARRAY['RECOMMENDED'::character varying, 'ENROLLED'::character varying, 'DISMISSED'::character varying])::text[])))
);


--
-- Name: manager_course_recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.manager_course_recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manager_course_recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.manager_course_recommendations_id_seq OWNED BY public.manager_course_recommendations.id;


--
-- Name: mentee_skill_consents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentee_skill_consents (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    mentor_id bigint NOT NULL,
    can_view_skills boolean DEFAULT true NOT NULL,
    can_view_gaps boolean DEFAULT true NOT NULL,
    can_view_assessments boolean DEFAULT true NOT NULL,
    consent_status character varying(20) DEFAULT 'GRANTED'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mentee_skill_consents_consent_status_check CHECK (((consent_status)::text = ANY ((ARRAY['GRANTED'::character varying, 'REVOKED'::character varying])::text[])))
);


--
-- Name: mentee_skill_consents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentee_skill_consents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentee_skill_consents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentee_skill_consents_id_seq OWNED BY public.mentee_skill_consents.id;


--
-- Name: mentor_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentor_assignments (
    id bigint NOT NULL,
    mentor_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    assigned_by_id bigint NOT NULL,
    status character varying(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
    notes text,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    ended_at timestamp with time zone,
    CONSTRAINT chk_no_self_mentoring CHECK ((mentor_id <> employee_id)),
    CONSTRAINT mentor_assignments_status_check CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'COMPLETED'::character varying, 'TERMINATED'::character varying])::text[])))
);


--
-- Name: mentor_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentor_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentor_assignments_id_seq OWNED BY public.mentor_assignments.id;


--
-- Name: mentor_availability; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentor_availability (
    id bigint NOT NULL,
    mentor_id bigint NOT NULL,
    day_of_week character varying(20) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    session_format character varying(30) DEFAULT 'VIRTUAL'::character varying NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_time_window CHECK ((end_time > start_time)),
    CONSTRAINT mentor_availability_day_of_week_check CHECK (((day_of_week)::text = ANY ((ARRAY['MONDAY'::character varying, 'TUESDAY'::character varying, 'WEDNESDAY'::character varying, 'THURSDAY'::character varying, 'FRIDAY'::character varying, 'SATURDAY'::character varying, 'SUNDAY'::character varying])::text[]))),
    CONSTRAINT mentor_availability_session_format_check CHECK (((session_format)::text = ANY ((ARRAY['VIRTUAL'::character varying, 'IN_PERSON'::character varying, 'HYBRID'::character varying])::text[])))
);


--
-- Name: mentor_availability_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_availability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentor_availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentor_availability_id_seq OWNED BY public.mentor_availability.id;


--
-- Name: mentor_evaluations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentor_evaluations (
    id bigint NOT NULL,
    mentor_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    session_id bigint,
    rating integer NOT NULL,
    strengths text,
    areas_for_growth text,
    comments text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mentor_evaluations_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: mentor_evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_evaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentor_evaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentor_evaluations_id_seq OWNED BY public.mentor_evaluations.id;


--
-- Name: mentor_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentor_profiles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    headline character varying(140) NOT NULL,
    expertise_areas text NOT NULL,
    max_mentees integer DEFAULT 3 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    approved_by_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    preferred_format character varying(30) DEFAULT 'VIRTUAL'::character varying,
    bio text,
    CONSTRAINT mentor_profiles_max_mentees_check CHECK ((max_mentees > 0))
);


--
-- Name: mentor_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentor_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentor_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentor_profiles_id_seq OWNED BY public.mentor_profiles.id;


--
-- Name: mentorship_feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentorship_feedback (
    id bigint NOT NULL,
    session_id bigint NOT NULL,
    author_id bigint NOT NULL,
    rating integer NOT NULL,
    comments text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mentorship_feedback_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: mentorship_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentorship_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentorship_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentorship_feedback_id_seq OWNED BY public.mentorship_feedback.id;


--
-- Name: mentorship_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentorship_goals (
    id bigint NOT NULL,
    assignment_id bigint NOT NULL,
    title character varying(140) NOT NULL,
    description text,
    target_date date,
    status character varying(20) DEFAULT 'IN_PROGRESS'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    priority character varying(20) DEFAULT 'MEDIUM'::character varying,
    skill_id bigint,
    CONSTRAINT mentorship_goals_status_check CHECK (((status)::text = ANY ((ARRAY['PROPOSED'::character varying, 'AGREED'::character varying, 'IN_PROGRESS'::character varying, 'ACHIEVED'::character varying, 'COMPLETED'::character varying, 'ON_HOLD'::character varying, 'ABANDONED'::character varying, 'CANCELLED'::character varying])::text[])))
);


--
-- Name: mentorship_goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentorship_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentorship_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentorship_goals_id_seq OWNED BY public.mentorship_goals.id;


--
-- Name: mentorship_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentorship_requests (
    id bigint NOT NULL,
    mentor_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    message text,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    responded_at timestamp with time zone,
    response_note text,
    CONSTRAINT mentorship_requests_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'ACCEPTED'::character varying, 'DECLINED'::character varying, 'CANCELLED'::character varying])::text[])))
);


--
-- Name: mentorship_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentorship_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentorship_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentorship_requests_id_seq OWNED BY public.mentorship_requests.id;


--
-- Name: mentorship_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mentorship_sessions (
    id bigint NOT NULL,
    assignment_id bigint NOT NULL,
    title character varying(140) NOT NULL,
    description text,
    scheduled_at timestamp with time zone NOT NULL,
    duration_minutes integer DEFAULT 45 NOT NULL,
    meeting_link character varying(500),
    status character varying(20) DEFAULT 'SCHEDULED'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shared_notes text,
    mentor_prep_notes text,
    CONSTRAINT mentorship_sessions_duration_minutes_check CHECK ((duration_minutes > 0)),
    CONSTRAINT mentorship_sessions_status_check CHECK (((status)::text = ANY ((ARRAY['SCHEDULED'::character varying, 'COMPLETED'::character varying, 'CANCELLED'::character varying])::text[])))
);


--
-- Name: mentorship_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mentorship_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentorship_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mentorship_sessions_id_seq OWNED BY public.mentorship_sessions.id;


--
-- Name: message_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_reports (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    reporter_id bigint NOT NULL,
    reason character varying(255) NOT NULL,
    details text,
    status character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: message_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.message_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: message_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.message_reports_id_seq OWNED BY public.message_reports.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    sender_id bigint NOT NULL,
    content text NOT NULL,
    attachment_url character varying(500),
    attachment_name character varying(140),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    type character varying(30) NOT NULL,
    title character varying(140) NOT NULL,
    message text NOT NULL,
    link character varying(250),
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token_hash character varying(64) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.password_reset_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: password_reset_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.password_reset_tokens_id_seq OWNED BY public.password_reset_tokens.id;


--
-- Name: platform_feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_feedback (
    id bigint NOT NULL,
    user_id bigint,
    category character varying(80) NOT NULL,
    rating integer NOT NULL,
    comments text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT platform_feedback_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: platform_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.platform_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: platform_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.platform_feedback_id_seq OWNED BY public.platform_feedback.id;


--
-- Name: reassessment_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reassessment_requests (
    id bigint NOT NULL,
    manager_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    reason text NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_reassessment_status CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'COMPLETED'::character varying, 'CANCELLED'::character varying])::text[])))
);


--
-- Name: reassessment_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reassessment_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reassessment_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reassessment_requests_id_seq OWNED BY public.reassessment_requests.id;


--
-- Name: role_skill_requirements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_skill_requirements (
    id bigint NOT NULL,
    job_role character varying(80) NOT NULL,
    skill_id bigint NOT NULL,
    required_proficiency character varying(20) NOT NULL,
    priority character varying(20) DEFAULT 'HIGH'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT role_skill_requirements_priority_check CHECK (((priority)::text = ANY ((ARRAY['HIGH'::character varying, 'MEDIUM'::character varying, 'LOW'::character varying])::text[]))),
    CONSTRAINT role_skill_requirements_required_proficiency_check CHECK (((required_proficiency)::text = ANY ((ARRAY['Unaware'::character varying, 'Beginner'::character varying, 'Intermediate'::character varying, 'Advanced'::character varying, 'Expert'::character varying])::text[])))
);


--
-- Name: role_skill_requirements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.role_skill_requirements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_skill_requirements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.role_skill_requirements_id_seq OWNED BY public.role_skill_requirements.id;


--
-- Name: shared_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shared_resources (
    id bigint NOT NULL,
    assignment_id bigint NOT NULL,
    title character varying(140) NOT NULL,
    url_or_content text NOT NULL,
    shared_by_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    resource_type character varying(30) DEFAULT 'ARTICLE'::character varying,
    description text,
    skill_id bigint
);


--
-- Name: shared_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shared_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shared_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shared_resources_id_seq OWNED BY public.shared_resources.id;


--
-- Name: skill_assessments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skill_assessments (
    id bigint NOT NULL,
    title character varying(140) NOT NULL,
    description text,
    category_id bigint,
    target_role character varying(80),
    pass_score integer DEFAULT 70 NOT NULL,
    time_limit_minutes integer DEFAULT 30 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    skill_id bigint
);


--
-- Name: skill_assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skill_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skill_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skill_assessments_id_seq OWNED BY public.skill_assessments.id;


--
-- Name: skill_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skill_categories (
    id bigint NOT NULL,
    name character varying(80) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: skill_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skill_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skill_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skill_categories_id_seq OWNED BY public.skill_categories.id;


--
-- Name: skill_evidence; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skill_evidence (
    id bigint NOT NULL,
    employee_skill_id bigint NOT NULL,
    title character varying(140) NOT NULL,
    description text,
    evidence_url character varying(500),
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    reviewed_by_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT skill_evidence_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'APPROVED'::character varying, 'REJECTED'::character varying])::text[])))
);


--
-- Name: skill_evidence_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skill_evidence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skill_evidence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skill_evidence_id_seq OWNED BY public.skill_evidence.id;


--
-- Name: skill_gaps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skill_gaps (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    current_level integer NOT NULL,
    required_level integer NOT NULL,
    gap_size integer NOT NULL,
    priority character varying(20) NOT NULL,
    calculated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT skill_gaps_priority_check CHECK (((priority)::text = ANY ((ARRAY['HIGH'::character varying, 'MEDIUM'::character varying, 'LOW'::character varying, 'ON_TRACK'::character varying])::text[])))
);


--
-- Name: skill_gaps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skill_gaps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skill_gaps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skill_gaps_id_seq OWNED BY public.skill_gaps.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skills (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.support_tickets (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    subject character varying(140) NOT NULL,
    description text NOT NULL,
    priority character varying(20) DEFAULT 'MEDIUM'::character varying NOT NULL,
    status character varying(20) DEFAULT 'OPEN'::character varying NOT NULL,
    admin_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT support_tickets_priority_check CHECK (((priority)::text = ANY ((ARRAY['LOW'::character varying, 'MEDIUM'::character varying, 'HIGH'::character varying])::text[]))),
    CONSTRAINT support_tickets_status_check CHECK (((status)::text = ANY ((ARRAY['OPEN'::character varying, 'IN_PROGRESS'::character varying, 'RESOLVED'::character varying, 'CLOSED'::character varying])::text[])))
);


--
-- Name: support_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.support_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.support_tickets_id_seq OWNED BY public.support_tickets.id;


--
-- Name: system_configuration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_configuration (
    config_key character varying(100) NOT NULL,
    config_value text NOT NULL,
    description text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: team_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_memberships (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    user_id bigint NOT NULL,
    joined_at timestamp with time zone DEFAULT now() NOT NULL,
    role_in_team character varying(50) DEFAULT 'MEMBER'::character varying NOT NULL
);


--
-- Name: team_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_memberships_id_seq OWNED BY public.team_memberships.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    department_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    manager_user_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: training_enrollments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.training_enrollments (
    id bigint NOT NULL,
    programme_id bigint NOT NULL,
    user_id bigint NOT NULL,
    status character varying(20) DEFAULT 'ENROLLED'::character varying NOT NULL,
    enrolled_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT training_enrollments_status_check CHECK (((status)::text = ANY ((ARRAY['ENROLLED'::character varying, 'ATTENDED'::character varying, 'CANCELLED'::character varying])::text[])))
);


--
-- Name: training_enrollments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.training_enrollments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_enrollments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.training_enrollments_id_seq OWNED BY public.training_enrollments.id;


--
-- Name: training_programmes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.training_programmes (
    id bigint NOT NULL,
    title character varying(140) NOT NULL,
    description text,
    department_id bigint,
    start_date date NOT NULL,
    end_date date NOT NULL,
    capacity integer DEFAULT 30 NOT NULL,
    trainer_name character varying(100),
    status character varying(20) DEFAULT 'UPCOMING'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    enrolled_count integer DEFAULT 0 NOT NULL,
    skill_id bigint,
    course_id bigint,
    CONSTRAINT training_programmes_status_check CHECK (((status)::text = ANY ((ARRAY['UPCOMING'::character varying, 'ACTIVE'::character varying, 'COMPLETED'::character varying, 'CANCELLED'::character varying])::text[])))
);


--
-- Name: training_programmes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.training_programmes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_programmes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.training_programmes_id_seq OWNED BY public.training_programmes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    full_name character varying(120) NOT NULL,
    email character varying(254) NOT NULL,
    employee_id character varying(30),
    password_hash character varying(100) NOT NULL,
    role character varying(20) DEFAULT 'EMPLOYEE'::character varying NOT NULL,
    requested_role character varying(20),
    account_status character varying(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_users_email_lc CHECK (((email)::text = lower((email)::text))),
    CONSTRAINT chk_users_req_role CHECK (((requested_role IS NULL) OR ((requested_role)::text = ANY ((ARRAY['EMPLOYEE'::character varying, 'MANAGER'::character varying, 'MENTOR'::character varying, 'HR_SPECIALIST'::character varying, 'DEPARTMENT_HEAD'::character varying, 'ADMIN'::character varying])::text[])))),
    CONSTRAINT chk_users_role CHECK (((role)::text = ANY ((ARRAY['EMPLOYEE'::character varying, 'MANAGER'::character varying, 'MENTOR'::character varying, 'HR_SPECIALIST'::character varying, 'DEPARTMENT_HEAD'::character varying, 'ADMIN'::character varying])::text[]))),
    CONSTRAINT chk_users_status CHECK (((account_status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'PENDING'::character varying, 'SUSPENDED'::character varying])::text[])))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: assessment_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_assignments ALTER COLUMN id SET DEFAULT nextval('public.assessment_assignments_id_seq'::regclass);


--
-- Name: assessment_attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_attempts ALTER COLUMN id SET DEFAULT nextval('public.assessment_attempts_id_seq'::regclass);


--
-- Name: assessment_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_questions ALTER COLUMN id SET DEFAULT nextval('public.assessment_questions_id_seq'::regclass);


--
-- Name: assessment_responses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses ALTER COLUMN id SET DEFAULT nextval('public.assessment_responses_id_seq'::regclass);


--
-- Name: assessment_submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_submissions ALTER COLUMN id SET DEFAULT nextval('public.assessment_submissions_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: calendar_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events ALTER COLUMN id SET DEFAULT nextval('public.calendar_events_id_seq'::regclass);


--
-- Name: certificates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates ALTER COLUMN id SET DEFAULT nextval('public.certificates_id_seq'::regclass);


--
-- Name: conversation_participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_participants ALTER COLUMN id SET DEFAULT nextval('public.conversation_participants_id_seq'::regclass);


--
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: discussion_replies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discussion_replies ALTER COLUMN id SET DEFAULT nextval('public.discussion_replies_id_seq'::regclass);


--
-- Name: discussion_threads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discussion_threads ALTER COLUMN id SET DEFAULT nextval('public.discussion_threads_id_seq'::regclass);


--
-- Name: employee_learning id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_learning ALTER COLUMN id SET DEFAULT nextval('public.employee_learning_id_seq'::regclass);


--
-- Name: employee_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_profiles ALTER COLUMN id SET DEFAULT nextval('public.employee_profiles_id_seq'::regclass);


--
-- Name: employee_skills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_skills ALTER COLUMN id SET DEFAULT nextval('public.employee_skills_id_seq'::regclass);


--
-- Name: event_participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_participants ALTER COLUMN id SET DEFAULT nextval('public.event_participants_id_seq'::regclass);


--
-- Name: goal_action_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_action_items ALTER COLUMN id SET DEFAULT nextval('public.goal_action_items_id_seq'::regclass);


--
-- Name: hr_announcement_reads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_announcement_reads ALTER COLUMN id SET DEFAULT nextval('public.hr_announcement_reads_id_seq'::regclass);


--
-- Name: hr_announcements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_announcements ALTER COLUMN id SET DEFAULT nextval('public.hr_announcements_id_seq'::regclass);


--
-- Name: knowledge_articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_articles ALTER COLUMN id SET DEFAULT nextval('public.knowledge_articles_id_seq'::regclass);


--
-- Name: knowledge_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_categories ALTER COLUMN id SET DEFAULT nextval('public.knowledge_categories_id_seq'::regclass);


--
-- Name: leadership_report_shares id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leadership_report_shares ALTER COLUMN id SET DEFAULT nextval('public.leadership_report_shares_id_seq'::regclass);


--
-- Name: learning_path_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_path_items ALTER COLUMN id SET DEFAULT nextval('public.learning_path_items_id_seq'::regclass);


--
-- Name: learning_paths id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_paths ALTER COLUMN id SET DEFAULT nextval('public.learning_paths_id_seq'::regclass);


--
-- Name: manager_course_recommendations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manager_course_recommendations ALTER COLUMN id SET DEFAULT nextval('public.manager_course_recommendations_id_seq'::regclass);


--
-- Name: mentee_skill_consents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentee_skill_consents ALTER COLUMN id SET DEFAULT nextval('public.mentee_skill_consents_id_seq'::regclass);


--
-- Name: mentor_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_assignments ALTER COLUMN id SET DEFAULT nextval('public.mentor_assignments_id_seq'::regclass);


--
-- Name: mentor_availability id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_availability ALTER COLUMN id SET DEFAULT nextval('public.mentor_availability_id_seq'::regclass);


--
-- Name: mentor_evaluations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_evaluations ALTER COLUMN id SET DEFAULT nextval('public.mentor_evaluations_id_seq'::regclass);


--
-- Name: mentor_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles ALTER COLUMN id SET DEFAULT nextval('public.mentor_profiles_id_seq'::regclass);


--
-- Name: mentorship_feedback id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_feedback ALTER COLUMN id SET DEFAULT nextval('public.mentorship_feedback_id_seq'::regclass);


--
-- Name: mentorship_goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_goals ALTER COLUMN id SET DEFAULT nextval('public.mentorship_goals_id_seq'::regclass);


--
-- Name: mentorship_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_requests ALTER COLUMN id SET DEFAULT nextval('public.mentorship_requests_id_seq'::regclass);


--
-- Name: mentorship_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_sessions ALTER COLUMN id SET DEFAULT nextval('public.mentorship_sessions_id_seq'::regclass);


--
-- Name: message_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_reports ALTER COLUMN id SET DEFAULT nextval('public.message_reports_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: password_reset_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens ALTER COLUMN id SET DEFAULT nextval('public.password_reset_tokens_id_seq'::regclass);


--
-- Name: platform_feedback id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_feedback ALTER COLUMN id SET DEFAULT nextval('public.platform_feedback_id_seq'::regclass);


--
-- Name: reassessment_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reassessment_requests ALTER COLUMN id SET DEFAULT nextval('public.reassessment_requests_id_seq'::regclass);


--
-- Name: role_skill_requirements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_skill_requirements ALTER COLUMN id SET DEFAULT nextval('public.role_skill_requirements_id_seq'::regclass);


--
-- Name: shared_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shared_resources ALTER COLUMN id SET DEFAULT nextval('public.shared_resources_id_seq'::regclass);


--
-- Name: skill_assessments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_assessments ALTER COLUMN id SET DEFAULT nextval('public.skill_assessments_id_seq'::regclass);


--
-- Name: skill_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_categories ALTER COLUMN id SET DEFAULT nextval('public.skill_categories_id_seq'::regclass);


--
-- Name: skill_evidence id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_evidence ALTER COLUMN id SET DEFAULT nextval('public.skill_evidence_id_seq'::regclass);


--
-- Name: skill_gaps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_gaps ALTER COLUMN id SET DEFAULT nextval('public.skill_gaps_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- Name: support_tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets ALTER COLUMN id SET DEFAULT nextval('public.support_tickets_id_seq'::regclass);


--
-- Name: team_memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships ALTER COLUMN id SET DEFAULT nextval('public.team_memberships_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: training_enrollments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_enrollments ALTER COLUMN id SET DEFAULT nextval('public.training_enrollments_id_seq'::regclass);


--
-- Name: training_programmes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_programmes ALTER COLUMN id SET DEFAULT nextval('public.training_programmes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: assessment_assignments assessment_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_assignments
    ADD CONSTRAINT assessment_assignments_pkey PRIMARY KEY (id);


--
-- Name: assessment_attempts assessment_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_attempts
    ADD CONSTRAINT assessment_attempts_pkey PRIMARY KEY (id);


--
-- Name: assessment_questions assessment_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_questions
    ADD CONSTRAINT assessment_questions_pkey PRIMARY KEY (id);


--
-- Name: assessment_responses assessment_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_pkey PRIMARY KEY (id);


--
-- Name: assessment_submissions assessment_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_submissions
    ADD CONSTRAINT assessment_submissions_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: calendar_events calendar_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT calendar_events_pkey PRIMARY KEY (id);


--
-- Name: certificates certificates_certificate_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_certificate_code_key UNIQUE (certificate_code);


--
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- Name: conversation_participants conversation_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT conversation_participants_pkey PRIMARY KEY (id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: departments departments_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_code_key UNIQUE (code);


--
-- Name: departments departments_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_name_key UNIQUE (name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: discussion_replies discussion_replies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_pkey PRIMARY KEY (id);


--
-- Name: discussion_threads discussion_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discussion_threads
    ADD CONSTRAINT discussion_threads_pkey PRIMARY KEY (id);


--
-- Name: employee_learning employee_learning_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_learning
    ADD CONSTRAINT employee_learning_pkey PRIMARY KEY (id);


--
-- Name: employee_profiles employee_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_profiles
    ADD CONSTRAINT employee_profiles_pkey PRIMARY KEY (id);


--
-- Name: employee_profiles employee_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_profiles
    ADD CONSTRAINT employee_profiles_user_id_key UNIQUE (user_id);


--
-- Name: employee_skills employee_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_skills
    ADD CONSTRAINT employee_skills_pkey PRIMARY KEY (id);


--
-- Name: event_participants event_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_participants
    ADD CONSTRAINT event_participants_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: goal_action_items goal_action_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_action_items
    ADD CONSTRAINT goal_action_items_pkey PRIMARY KEY (id);


--
-- Name: hr_announcement_reads hr_announcement_reads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_announcement_reads
    ADD CONSTRAINT hr_announcement_reads_pkey PRIMARY KEY (id);


--
-- Name: hr_announcements hr_announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_announcements
    ADD CONSTRAINT hr_announcements_pkey PRIMARY KEY (id);


--
-- Name: knowledge_articles knowledge_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_articles
    ADD CONSTRAINT knowledge_articles_pkey PRIMARY KEY (id);


--
-- Name: knowledge_categories knowledge_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_categories
    ADD CONSTRAINT knowledge_categories_name_key UNIQUE (name);


--
-- Name: knowledge_categories knowledge_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_categories
    ADD CONSTRAINT knowledge_categories_pkey PRIMARY KEY (id);


--
-- Name: leadership_report_shares leadership_report_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leadership_report_shares
    ADD CONSTRAINT leadership_report_shares_pkey PRIMARY KEY (id);


--
-- Name: learning_path_items learning_path_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_path_items
    ADD CONSTRAINT learning_path_items_pkey PRIMARY KEY (id);


--
-- Name: learning_paths learning_paths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_paths
    ADD CONSTRAINT learning_paths_pkey PRIMARY KEY (id);


--
-- Name: manager_course_recommendations manager_course_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manager_course_recommendations
    ADD CONSTRAINT manager_course_recommendations_pkey PRIMARY KEY (id);


--
-- Name: mentee_skill_consents mentee_skill_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentee_skill_consents
    ADD CONSTRAINT mentee_skill_consents_pkey PRIMARY KEY (id);


--
-- Name: mentor_assignments mentor_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_assignments
    ADD CONSTRAINT mentor_assignments_pkey PRIMARY KEY (id);


--
-- Name: mentor_availability mentor_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_availability
    ADD CONSTRAINT mentor_availability_pkey PRIMARY KEY (id);


--
-- Name: mentor_evaluations mentor_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_evaluations
    ADD CONSTRAINT mentor_evaluations_pkey PRIMARY KEY (id);


--
-- Name: mentor_profiles mentor_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_pkey PRIMARY KEY (id);


--
-- Name: mentor_profiles mentor_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_user_id_key UNIQUE (user_id);


--
-- Name: mentorship_feedback mentorship_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_feedback
    ADD CONSTRAINT mentorship_feedback_pkey PRIMARY KEY (id);


--
-- Name: mentorship_feedback mentorship_feedback_session_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_feedback
    ADD CONSTRAINT mentorship_feedback_session_id_key UNIQUE (session_id);


--
-- Name: mentorship_goals mentorship_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_goals
    ADD CONSTRAINT mentorship_goals_pkey PRIMARY KEY (id);


--
-- Name: mentorship_requests mentorship_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_requests
    ADD CONSTRAINT mentorship_requests_pkey PRIMARY KEY (id);


--
-- Name: mentorship_sessions mentorship_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_sessions
    ADD CONSTRAINT mentorship_sessions_pkey PRIMARY KEY (id);


--
-- Name: message_reports message_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_reports
    ADD CONSTRAINT message_reports_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: platform_feedback platform_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_feedback
    ADD CONSTRAINT platform_feedback_pkey PRIMARY KEY (id);


--
-- Name: reassessment_requests reassessment_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reassessment_requests
    ADD CONSTRAINT reassessment_requests_pkey PRIMARY KEY (id);


--
-- Name: role_skill_requirements role_skill_requirements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_skill_requirements
    ADD CONSTRAINT role_skill_requirements_pkey PRIMARY KEY (id);


--
-- Name: shared_resources shared_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shared_resources
    ADD CONSTRAINT shared_resources_pkey PRIMARY KEY (id);


--
-- Name: skill_assessments skill_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_assessments
    ADD CONSTRAINT skill_assessments_pkey PRIMARY KEY (id);


--
-- Name: skill_categories skill_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_categories
    ADD CONSTRAINT skill_categories_name_key UNIQUE (name);


--
-- Name: skill_categories skill_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_categories
    ADD CONSTRAINT skill_categories_pkey PRIMARY KEY (id);


--
-- Name: skill_evidence skill_evidence_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_evidence
    ADD CONSTRAINT skill_evidence_pkey PRIMARY KEY (id);


--
-- Name: skill_gaps skill_gaps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_gaps
    ADD CONSTRAINT skill_gaps_pkey PRIMARY KEY (id);


--
-- Name: skills skills_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_name_key UNIQUE (name);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


--
-- Name: system_configuration system_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_configuration
    ADD CONSTRAINT system_configuration_pkey PRIMARY KEY (config_key);


--
-- Name: team_memberships team_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: training_enrollments training_enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_enrollments
    ADD CONSTRAINT training_enrollments_pkey PRIMARY KEY (id);


--
-- Name: training_programmes training_programmes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_programmes
    ADD CONSTRAINT training_programmes_pkey PRIMARY KEY (id);


--
-- Name: hr_announcement_reads uq_announcement_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_announcement_reads
    ADD CONSTRAINT uq_announcement_user UNIQUE (announcement_id, user_id);


--
-- Name: conversation_participants uq_conv_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT uq_conv_user UNIQUE (conversation_id, user_id);


--
-- Name: event_participants uq_event_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_participants
    ADD CONSTRAINT uq_event_user UNIQUE (event_id, user_id);


--
-- Name: mentee_skill_consents uq_mentee_mentor_consent; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentee_skill_consents
    ADD CONSTRAINT uq_mentee_mentor_consent UNIQUE (employee_id, mentor_id);


--
-- Name: message_reports uq_msg_report; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_reports
    ADD CONSTRAINT uq_msg_report UNIQUE (message_id, reporter_id);


--
-- Name: learning_path_items uq_path_course; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_path_items
    ADD CONSTRAINT uq_path_course UNIQUE (learning_path_id, course_id);


--
-- Name: training_enrollments uq_programme_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_enrollments
    ADD CONSTRAINT uq_programme_user UNIQUE (programme_id, user_id);


--
-- Name: password_reset_tokens uq_prt_token_hash; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT uq_prt_token_hash UNIQUE (token_hash);


--
-- Name: role_skill_requirements uq_role_skill; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_skill_requirements
    ADD CONSTRAINT uq_role_skill UNIQUE (job_role, skill_id);


--
-- Name: team_memberships uq_team_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT uq_team_user UNIQUE (team_id, user_id);


--
-- Name: employee_learning uq_user_course; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_learning
    ADD CONSTRAINT uq_user_course UNIQUE (user_id, course_id);


--
-- Name: employee_skills uq_user_skill; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_skills
    ADD CONSTRAINT uq_user_skill UNIQUE (user_id, skill_id);


--
-- Name: skill_gaps uq_user_skill_gap; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_gaps
    ADD CONSTRAINT uq_user_skill_gap UNIQUE (user_id, skill_id);


--
-- Name: users uq_users_email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--
-- Name: users uq_users_employee_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_employee_id UNIQUE (employee_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_assessment_attempts_skill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assessment_attempts_skill ON public.assessment_attempts USING btree (skill_id);


--
-- Name: idx_assessment_attempts_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assessment_attempts_user ON public.assessment_attempts USING btree (user_id);


--
-- Name: idx_assessment_attempts_user_skill; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assessment_attempts_user_skill ON public.assessment_attempts USING btree (user_id, skill_id, started_at DESC);


--
-- Name: idx_assessment_attempts_user_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assessment_attempts_user_status ON public.assessment_attempts USING btree (user_id, status);


--
-- Name: idx_assessment_questions_attempt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assessment_questions_attempt ON public.assessment_questions USING btree (attempt_id);


--
-- Name: idx_assessment_questions_skill_diff; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_assessment_questions_skill_diff ON public.assessment_questions USING btree (skill_id, difficulty) WHERE (attempt_id IS NULL);


--
-- Name: idx_conversations_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conversations_team ON public.conversations USING btree (team_id);


--
-- Name: idx_employee_profiles_job_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_profiles_job_role ON public.employee_profiles USING btree (job_role);


--
-- Name: idx_employee_profiles_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_profiles_user ON public.employee_profiles USING btree (user_id);


--
-- Name: idx_feedback_author; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_feedback_author ON public.mentorship_feedback USING btree (author_id);


--
-- Name: idx_goal_action_items_goal; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_goal_action_items_goal ON public.goal_action_items USING btree (goal_id);


--
-- Name: idx_goals_assignment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_goals_assignment ON public.mentorship_goals USING btree (assignment_id);


--
-- Name: idx_hr_announcement_reads_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_announcement_reads_user ON public.hr_announcement_reads USING btree (user_id);


--
-- Name: idx_hr_announcements_author; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_announcements_author ON public.hr_announcements USING btree (author_id);


--
-- Name: idx_hr_announcements_dept; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hr_announcements_dept ON public.hr_announcements USING btree (department_id);


--
-- Name: idx_mentee_consent_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentee_consent_employee ON public.mentee_skill_consents USING btree (employee_id);


--
-- Name: idx_mentee_consent_mentor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentee_consent_mentor ON public.mentee_skill_consents USING btree (mentor_id);


--
-- Name: idx_mentor_assignments_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentor_assignments_employee ON public.mentor_assignments USING btree (employee_id);


--
-- Name: idx_mentor_assignments_mentor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentor_assignments_mentor ON public.mentor_assignments USING btree (mentor_id);


--
-- Name: idx_mentor_availability_mentor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentor_availability_mentor ON public.mentor_availability USING btree (mentor_id);


--
-- Name: idx_mentor_evaluations_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentor_evaluations_employee ON public.mentor_evaluations USING btree (employee_id);


--
-- Name: idx_mentor_evaluations_mentor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentor_evaluations_mentor ON public.mentor_evaluations USING btree (mentor_id);


--
-- Name: idx_mentor_profiles_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentor_profiles_active ON public.mentor_profiles USING btree (is_active);


--
-- Name: idx_mentor_profiles_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentor_profiles_user ON public.mentor_profiles USING btree (user_id);


--
-- Name: idx_mentorship_requests_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentorship_requests_employee ON public.mentorship_requests USING btree (employee_id);


--
-- Name: idx_mentorship_requests_mentor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mentorship_requests_mentor ON public.mentorship_requests USING btree (mentor_id);


--
-- Name: idx_messages_conversation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_conversation ON public.messages USING btree (conversation_id);


--
-- Name: idx_messages_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_created ON public.messages USING btree (created_at);


--
-- Name: idx_mgr_rec_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mgr_rec_employee ON public.manager_course_recommendations USING btree (employee_id);


--
-- Name: idx_mgr_rec_manager; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mgr_rec_manager ON public.manager_course_recommendations USING btree (manager_id);


--
-- Name: idx_msg_reports_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_msg_reports_status ON public.message_reports USING btree (status);


--
-- Name: idx_notifications_recipient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_recipient ON public.notifications USING btree (recipient_id);


--
-- Name: idx_prt_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_prt_user ON public.password_reset_tokens USING btree (user_id);


--
-- Name: idx_reassessment_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reassessment_employee ON public.reassessment_requests USING btree (employee_id);


--
-- Name: idx_reassessment_manager; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reassessment_manager ON public.reassessment_requests USING btree (manager_id);


--
-- Name: idx_report_shares_dept; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_report_shares_dept ON public.leadership_report_shares USING btree (department_id);


--
-- Name: idx_report_shares_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_report_shares_role ON public.leadership_report_shares USING btree (shared_with_role);


--
-- Name: idx_sessions_assignment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sessions_assignment ON public.mentorship_sessions USING btree (assignment_id);


--
-- Name: idx_sessions_scheduled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sessions_scheduled ON public.mentorship_sessions USING btree (scheduled_at);


--
-- Name: idx_skill_gaps_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_skill_gaps_user ON public.skill_gaps USING btree (user_id);


--
-- Name: idx_team_memberships_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_team_memberships_user ON public.team_memberships USING btree (user_id);


--
-- Name: idx_teams_department; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_teams_department ON public.teams USING btree (department_id);


--
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- Name: uq_active_employee_mentor; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_active_employee_mentor ON public.mentor_assignments USING btree (employee_id) WHERE ((status)::text = 'ACTIVE'::text);


--
-- Name: assessment_assignments assessment_assignments_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_assignments
    ADD CONSTRAINT assessment_assignments_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.skill_assessments(id) ON DELETE CASCADE;


--
-- Name: assessment_assignments assessment_assignments_assigned_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_assignments
    ADD CONSTRAINT assessment_assignments_assigned_by_id_fkey FOREIGN KEY (assigned_by_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: assessment_assignments assessment_assignments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_assignments
    ADD CONSTRAINT assessment_assignments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: assessment_attempts assessment_attempts_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_attempts
    ADD CONSTRAINT assessment_attempts_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.skill_assessments(id) ON DELETE SET NULL;


--
-- Name: assessment_attempts assessment_attempts_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_attempts
    ADD CONSTRAINT assessment_attempts_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.assessment_assignments(id) ON DELETE SET NULL;


--
-- Name: assessment_attempts assessment_attempts_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_attempts
    ADD CONSTRAINT assessment_attempts_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: assessment_attempts assessment_attempts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_attempts
    ADD CONSTRAINT assessment_attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: assessment_questions assessment_questions_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_questions
    ADD CONSTRAINT assessment_questions_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.skill_assessments(id) ON DELETE CASCADE;


--
-- Name: assessment_questions assessment_questions_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_questions
    ADD CONSTRAINT assessment_questions_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES public.assessment_attempts(id) ON DELETE CASCADE;


--
-- Name: assessment_questions assessment_questions_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_questions
    ADD CONSTRAINT assessment_questions_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: assessment_responses assessment_responses_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.assessment_questions(id) ON DELETE CASCADE;


--
-- Name: assessment_responses assessment_responses_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_responses
    ADD CONSTRAINT assessment_responses_submission_id_fkey FOREIGN KEY (submission_id) REFERENCES public.assessment_submissions(id) ON DELETE CASCADE;


--
-- Name: assessment_submissions assessment_submissions_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_submissions
    ADD CONSTRAINT assessment_submissions_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.skill_assessments(id) ON DELETE CASCADE;


--
-- Name: assessment_submissions assessment_submissions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_submissions
    ADD CONSTRAINT assessment_submissions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.assessment_assignments(id) ON DELETE SET NULL;


--
-- Name: assessment_submissions assessment_submissions_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_submissions
    ADD CONSTRAINT assessment_submissions_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES public.assessment_attempts(id) ON DELETE SET NULL;


--
-- Name: assessment_submissions assessment_submissions_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_submissions
    ADD CONSTRAINT assessment_submissions_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE SET NULL;


--
-- Name: assessment_submissions assessment_submissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_submissions
    ADD CONSTRAINT assessment_submissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: calendar_events calendar_events_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendar_events
    ADD CONSTRAINT calendar_events_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: certificates certificates_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: certificates certificates_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: conversation_participants conversation_participants_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT conversation_participants_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- Name: conversation_participants conversation_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT conversation_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: conversations conversations_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE SET NULL;


--
-- Name: courses courses_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE SET NULL;


--
-- Name: departments departments_head_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_head_user_id_fkey FOREIGN KEY (head_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: discussion_replies discussion_replies_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: discussion_replies discussion_replies_thread_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discussion_replies
    ADD CONSTRAINT discussion_replies_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.discussion_threads(id) ON DELETE CASCADE;


--
-- Name: discussion_threads discussion_threads_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discussion_threads
    ADD CONSTRAINT discussion_threads_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: employee_learning employee_learning_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_learning
    ADD CONSTRAINT employee_learning_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: employee_learning employee_learning_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_learning
    ADD CONSTRAINT employee_learning_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: employee_profiles employee_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_profiles
    ADD CONSTRAINT employee_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: employee_skills employee_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_skills
    ADD CONSTRAINT employee_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: employee_skills employee_skills_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_skills
    ADD CONSTRAINT employee_skills_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: employee_skills employee_skills_verified_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_skills
    ADD CONSTRAINT employee_skills_verified_by_id_fkey FOREIGN KEY (verified_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: event_participants event_participants_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_participants
    ADD CONSTRAINT event_participants_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.calendar_events(id) ON DELETE CASCADE;


--
-- Name: event_participants event_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_participants
    ADD CONSTRAINT event_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: goal_action_items goal_action_items_goal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goal_action_items
    ADD CONSTRAINT goal_action_items_goal_id_fkey FOREIGN KEY (goal_id) REFERENCES public.mentorship_goals(id) ON DELETE CASCADE;


--
-- Name: hr_announcement_reads hr_announcement_reads_announcement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_announcement_reads
    ADD CONSTRAINT hr_announcement_reads_announcement_id_fkey FOREIGN KEY (announcement_id) REFERENCES public.hr_announcements(id) ON DELETE CASCADE;


--
-- Name: hr_announcement_reads hr_announcement_reads_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_announcement_reads
    ADD CONSTRAINT hr_announcement_reads_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: hr_announcements hr_announcements_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_announcements
    ADD CONSTRAINT hr_announcements_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: hr_announcements hr_announcements_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hr_announcements
    ADD CONSTRAINT hr_announcements_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE;


--
-- Name: knowledge_articles knowledge_articles_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_articles
    ADD CONSTRAINT knowledge_articles_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: knowledge_articles knowledge_articles_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_articles
    ADD CONSTRAINT knowledge_articles_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.knowledge_categories(id) ON DELETE SET NULL;


--
-- Name: leadership_report_shares leadership_report_shares_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leadership_report_shares
    ADD CONSTRAINT leadership_report_shares_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE;


--
-- Name: leadership_report_shares leadership_report_shares_shared_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leadership_report_shares
    ADD CONSTRAINT leadership_report_shares_shared_by_id_fkey FOREIGN KEY (shared_by_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: learning_path_items learning_path_items_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_path_items
    ADD CONSTRAINT learning_path_items_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: learning_path_items learning_path_items_learning_path_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_path_items
    ADD CONSTRAINT learning_path_items_learning_path_id_fkey FOREIGN KEY (learning_path_id) REFERENCES public.learning_paths(id) ON DELETE CASCADE;


--
-- Name: learning_paths learning_paths_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_paths
    ADD CONSTRAINT learning_paths_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: learning_paths learning_paths_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.learning_paths
    ADD CONSTRAINT learning_paths_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE SET NULL;


--
-- Name: manager_course_recommendations manager_course_recommendations_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manager_course_recommendations
    ADD CONSTRAINT manager_course_recommendations_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: manager_course_recommendations manager_course_recommendations_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manager_course_recommendations
    ADD CONSTRAINT manager_course_recommendations_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: manager_course_recommendations manager_course_recommendations_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manager_course_recommendations
    ADD CONSTRAINT manager_course_recommendations_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: manager_course_recommendations manager_course_recommendations_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manager_course_recommendations
    ADD CONSTRAINT manager_course_recommendations_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE SET NULL;


--
-- Name: mentee_skill_consents mentee_skill_consents_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentee_skill_consents
    ADD CONSTRAINT mentee_skill_consents_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentee_skill_consents mentee_skill_consents_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentee_skill_consents
    ADD CONSTRAINT mentee_skill_consents_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentor_assignments mentor_assignments_assigned_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_assignments
    ADD CONSTRAINT mentor_assignments_assigned_by_id_fkey FOREIGN KEY (assigned_by_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: mentor_assignments mentor_assignments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_assignments
    ADD CONSTRAINT mentor_assignments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentor_assignments mentor_assignments_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_assignments
    ADD CONSTRAINT mentor_assignments_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentor_availability mentor_availability_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_availability
    ADD CONSTRAINT mentor_availability_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentor_evaluations mentor_evaluations_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_evaluations
    ADD CONSTRAINT mentor_evaluations_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentor_evaluations mentor_evaluations_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_evaluations
    ADD CONSTRAINT mentor_evaluations_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentor_evaluations mentor_evaluations_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_evaluations
    ADD CONSTRAINT mentor_evaluations_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.mentorship_sessions(id) ON DELETE SET NULL;


--
-- Name: mentor_profiles mentor_profiles_approved_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_approved_by_id_fkey FOREIGN KEY (approved_by_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: mentor_profiles mentor_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentor_profiles
    ADD CONSTRAINT mentor_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentorship_feedback mentorship_feedback_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_feedback
    ADD CONSTRAINT mentorship_feedback_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentorship_feedback mentorship_feedback_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_feedback
    ADD CONSTRAINT mentorship_feedback_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.mentorship_sessions(id) ON DELETE CASCADE;


--
-- Name: mentorship_goals mentorship_goals_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_goals
    ADD CONSTRAINT mentorship_goals_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.mentor_assignments(id) ON DELETE CASCADE;


--
-- Name: mentorship_goals mentorship_goals_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_goals
    ADD CONSTRAINT mentorship_goals_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE SET NULL;


--
-- Name: mentorship_requests mentorship_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_requests
    ADD CONSTRAINT mentorship_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentorship_requests mentorship_requests_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_requests
    ADD CONSTRAINT mentorship_requests_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentorship_sessions mentorship_sessions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mentorship_sessions
    ADD CONSTRAINT mentorship_sessions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.mentor_assignments(id) ON DELETE CASCADE;


--
-- Name: message_reports message_reports_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_reports
    ADD CONSTRAINT message_reports_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: message_reports message_reports_reporter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_reports
    ADD CONSTRAINT message_reports_reporter_id_fkey FOREIGN KEY (reporter_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: messages messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: password_reset_tokens password_reset_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: platform_feedback platform_feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_feedback
    ADD CONSTRAINT platform_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reassessment_requests reassessment_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reassessment_requests
    ADD CONSTRAINT reassessment_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reassessment_requests reassessment_requests_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reassessment_requests
    ADD CONSTRAINT reassessment_requests_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reassessment_requests reassessment_requests_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reassessment_requests
    ADD CONSTRAINT reassessment_requests_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: role_skill_requirements role_skill_requirements_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_skill_requirements
    ADD CONSTRAINT role_skill_requirements_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: shared_resources shared_resources_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shared_resources
    ADD CONSTRAINT shared_resources_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.mentor_assignments(id) ON DELETE CASCADE;


--
-- Name: shared_resources shared_resources_shared_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shared_resources
    ADD CONSTRAINT shared_resources_shared_by_id_fkey FOREIGN KEY (shared_by_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: shared_resources shared_resources_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shared_resources
    ADD CONSTRAINT shared_resources_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE SET NULL;


--
-- Name: skill_assessments skill_assessments_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_assessments
    ADD CONSTRAINT skill_assessments_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.skill_categories(id) ON DELETE SET NULL;


--
-- Name: skill_assessments skill_assessments_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_assessments
    ADD CONSTRAINT skill_assessments_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE SET NULL;


--
-- Name: skill_evidence skill_evidence_employee_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_evidence
    ADD CONSTRAINT skill_evidence_employee_skill_id_fkey FOREIGN KEY (employee_skill_id) REFERENCES public.employee_skills(id) ON DELETE CASCADE;


--
-- Name: skill_evidence skill_evidence_reviewed_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_evidence
    ADD CONSTRAINT skill_evidence_reviewed_by_id_fkey FOREIGN KEY (reviewed_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: skill_gaps skill_gaps_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_gaps
    ADD CONSTRAINT skill_gaps_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: skill_gaps skill_gaps_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_gaps
    ADD CONSTRAINT skill_gaps_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: skills skills_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.skill_categories(id) ON DELETE CASCADE;


--
-- Name: support_tickets support_tickets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: team_memberships team_memberships_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: team_memberships team_memberships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_memberships
    ADD CONSTRAINT team_memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: teams teams_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE;


--
-- Name: teams teams_manager_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_manager_user_id_fkey FOREIGN KEY (manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: training_enrollments training_enrollments_programme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_enrollments
    ADD CONSTRAINT training_enrollments_programme_id_fkey FOREIGN KEY (programme_id) REFERENCES public.training_programmes(id) ON DELETE CASCADE;


--
-- Name: training_enrollments training_enrollments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_enrollments
    ADD CONSTRAINT training_enrollments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: training_programmes training_programmes_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_programmes
    ADD CONSTRAINT training_programmes_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE SET NULL;


--
-- Name: training_programmes training_programmes_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_programmes
    ADD CONSTRAINT training_programmes_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: training_programmes training_programmes_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_programmes
    ADD CONSTRAINT training_programmes_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict 6By1Rf2lbbAkZ1iXOpeXR0FvFZ78eVYMGo3wgKcdp7ztZaskDbmZ85w2ER8TqRt

