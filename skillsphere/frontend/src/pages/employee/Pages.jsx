import { useState } from "react";
import Icon from "../../components/Icons.jsx";
import Alert from "../../components/Alert.jsx";
import { QUESTIONS } from "../../data/assessment.js";
import MentorshipHub from "./MentorshipHub.jsx";

const fmtDate = (iso) => (iso ? new Date(iso).toLocaleString([], { dateStyle: "medium", timeStyle: "short" }) : "");
export const slug = (t) => String(t).toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
const priorityClass = (p) => `priority priority--${String(p).toLowerCase().replaceAll(" ", "-")}`;

function PageHeader({ eyebrow, title, subtitle, action }) {
  return <div className="page-header"><div>{eyebrow && <p className="eyebrow">{eyebrow}</p>}<h1>{title}</h1>{subtitle && <p>{subtitle}</p>}</div>{action}</div>;
}

function EmptyState({ icon = "clipboard", title, text, actionLabel, onAction }) {
  return <div className="empty-state"><span className="empty-state__icon"><Icon name={icon} size={28}/></span><h2>{title}</h2><p>{text}</p>{onAction && <button className="btn btn--primary" onClick={onAction}>{actionLabel} <Icon name="arrow" size={16}/></button>}</div>;
}

function AiBadge({ source }) {
  return source === "gemini"
    ? <span className="ai-badge"><Icon name="sparkles" size={14}/> Powered by Google Gemini</span>
    : <span className="ai-badge ai-badge--rules">Standard recommendations</span>;
}

function CourseSkeleton() {
  return <div className="ai-loading" role="status" aria-live="polite">
    <div className="ai-loading__head"><span className="ai-spinner" aria-hidden="true"/><div><strong>Gemini is analysing your results…</strong><small>Building a learning path from your skill gaps. This usually takes a few seconds.</small></div></div>
    <div className="course-grid">{[0, 1, 2, 3].map((i) => <div className="course-card skeleton" key={i}><span className="sk sk--sm"/><span className="sk sk--lg"/><span className="sk"/><span className="sk sk--md"/></div>)}</div>
  </div>;
}

export function CourseCard({ course, done, onToggle }) {
  const link = `https://www.google.com/search?q=${encodeURIComponent(course.searchQuery || course.title)}`;
  return <article className="course-card">
    <div className="course-card__top"><span className={priorityClass(course.priority === "Low" ? "on-track" : course.priority)}>{course.priority} priority</span><span className="badge">{course.level}</span></div>
    <p className="eyebrow">{course.skill}</p>
    <h3>{course.title}</h3>
    <p className="course-reason">{course.reason}</p>
    {course.topics?.length > 0 && <ul className="chips">{course.topics.map((t) => <li key={t}>{t}</li>)}</ul>}
    <div className="course-meta"><span><Icon name="clock" size={15}/> {course.duration}</span><span><Icon name="book" size={15}/> {course.provider}</span></div>
    <div className="course-actions">
      <a className="btn btn--ghost" href={link} target="_blank" rel="noopener noreferrer">Find course <Icon name="external" size={15}/></a>
      <button className={`btn ${done ? "btn--complete" : "btn--primary"}`} onClick={onToggle} aria-pressed={done}>{done ? <><Icon name="check" size={16}/> Completed</> : "Mark complete"}</button>
    </div>
  </article>;
}

function RecommendationBlock({ recs, completed, toggleCourse, onRetry, limit }) {
  if (recs.status === "loading") return <CourseSkeleton/>;
  if (recs.status === "error") return <div className="ai-error"><Icon name="alert" size={22}/><div><strong>We couldn't generate recommendations</strong><p>{recs.error}</p></div><button className="btn btn--primary" onClick={onRetry}><Icon name="refresh" size={16}/> Try again</button></div>;
  if (!recs.data) return null;
  const list = limit ? recs.data.recommendations.slice(0, limit) : recs.data.recommendations;
  return <>
    <div className="ai-summary"><span className="ai-summary__icon"><Icon name="lightbulb" size={22}/></span><div><AiBadge source={recs.data.source}/><p>{recs.data.summary}</p></div></div>
    {recs.data.notice && <Alert type="success">{recs.data.notice}</Alert>}
    <div className="course-grid">{list.map((c) => <CourseCard key={slug(c.title)} course={c} done={completed.includes(slug(c.title))} onToggle={() => toggleCourse(slug(c.title))}/>)}</div>
  </>;
}

/* ------------------------------------------------------------------ Overview */
export function Overview({ user, assessment, recs, progress, completed, setActivePage }) {
  const gapCount = assessment ? assessment.skillResults.filter((s) => s.gap > 0).length : null;
  const courseCount = recs.data?.recommendations.length ?? 0;
  const steps = [
    { icon: "clipboard", title: "Take the assessment", text: "12 quick questions across 6 core skills." },
    { icon: "sparkles", title: "AI analyses your gaps", text: "Google Gemini studies your results and your role." },
    { icon: "book", title: "Follow your learning path", text: "Get courses ranked by what you need most." },
  ];
  return <>
    <section className="hero"><div><p className="eyebrow">SKILLSPHERE · EMPLOYEE WORKSPACE</p><h1>Welcome back, {user.fullName?.split(" ")[0] || "there"}</h1><p>Measure your skills, uncover knowledge gaps and get an AI-built learning path for your career.</p>
      <button className="btn btn--light" onClick={() => setActivePage("assessment")}>{assessment ? "Retake assessment" : "Start assessment"} <Icon name="arrow" size={16}/></button></div>
      <div className="hero__art" aria-hidden="true"><Icon name="sparkles" size={56} strokeWidth={1.4}/></div></section>
    <div className="stat-grid">
      <div className="stat-card"><span className="stat-icon"><Icon name="clipboard"/></span><span className="stat-label">Latest score</span><strong>{assessment ? `${assessment.score}%` : "—"}</strong><small>{assessment ? `${assessment.correct} of ${assessment.total} correct` : "No assessment taken yet"}</small></div>
      <div className="stat-card"><span className="stat-icon"><Icon name="target"/></span><span className="stat-label">Knowledge gaps</span><strong>{gapCount ?? "—"}</strong><small>{assessment ? "Skills below target" : "Available after assessment"}</small></div>
      <div className="stat-card"><span className="stat-icon"><Icon name="sparkles"/></span><span className="stat-label">AI recommendations</span><strong>{courseCount || "—"}</strong><small>{courseCount ? "Courses picked for you" : "Generated after assessment"}</small></div>
      <div className="stat-card"><span className="stat-icon"><Icon name="trending"/></span><span className="stat-label">Learning progress</span><strong>{progress}%</strong><small>{completed.length} course{completed.length === 1 ? "" : "s"} completed</small></div>
    </div>
    {!assessment ? <section className="panel"><div className="section-heading"><div><p className="eyebrow">HOW IT WORKS</p><h2>Your path in three steps</h2></div></div>
      <div className="steps">{steps.map((s, i) => <div className="step" key={s.title}><span className="step__num">{i + 1}</span><span className="step__icon"><Icon name={s.icon}/></span><strong>{s.title}</strong><p>{s.text}</p></div>)}</div></section>
    : <div className="two-col">
      <section className="panel"><div className="section-heading"><div><p className="eyebrow">SKILL SNAPSHOT</p><h2>Where you stand</h2></div><button className="text-action" onClick={() => setActivePage("gaps")}>Full summary <Icon name="arrow" size={14}/></button></div>
        <SkillBars results={assessment.skillResults}/></section>
      <section className="panel"><div className="section-heading"><div><p className="eyebrow">RECOMMENDED FOR YOU</p><h2>Next courses</h2></div><button className="text-action" onClick={() => setActivePage("courses")}>View all <Icon name="arrow" size={14}/></button></div>
        {recs.status === "loading" && <p className="muted"><span className="ai-spinner ai-spinner--inline"/> Gemini is preparing your recommendations…</p>}
        {recs.data?.recommendations.slice(0, 3).map((c) => <div className="mini-course" key={slug(c.title)}><span className="course-dot"><Icon name="book" size={18}/></span><div><strong>{c.title}</strong><small>{c.skill} · {c.duration}</small></div><span className={priorityClass(c.priority === "Low" ? "on-track" : c.priority)}>{c.priority}</span></div>)}
        {recs.status === "error" && <p className="muted">Recommendations are unavailable right now. Open the learning paths page to retry.</p>}
      </section></div>}
  </>;
}

/* -------------------------------------------------------------------- Profile */
export function Profile({ profile, setProfile, onSave, saved }) {
  const set = (k) => (e) => setProfile({ ...profile, [k]: e.target.value });
  return <>
    <PageHeader eyebrow="ACCOUNT" title="Employee Profile Management" subtitle="Your job role, department, and technical skills power personalized mentorship and course recommendations."/>
    <section className="panel">
      {saved && <Alert type="success">Profile saved successfully to your SkillSphere account.</Alert>}
      <div className="profile-grid">
        <label className="field"><span>Full name</span><input value={profile.fullName || ""} onChange={set("fullName")}/></label>
        <label className="field"><span>Employee ID</span><input value={profile.employeeId || ""} placeholder="Enter employee ID" onChange={set("employeeId")}/></label>
        <label className="field"><span>Email</span><input value={profile.email || ""} readOnly/></label>
        <label className="field"><span>Department</span><input value={profile.department || ""} placeholder="e.g. Engineering" maxLength={80} onChange={set("department")}/></label>
        <label className="field"><span>Job role</span><select value={profile.jobRole || "Software Developer"} onChange={set("jobRole")}><option>Software Developer</option><option>Data Analyst</option><option>QA Engineer</option><option>Support Engineer</option></select></label>
        <label className="field"><span>Experience level</span><select value={profile.experience || "Entry level"} onChange={set("experience")}><option>Entry level</option><option>Intermediate</option><option>Experienced</option></select></label>
      </div>
      <div style={{ marginTop: "1rem", display: "grid", gridTemplateColumns: "1fr 1fr", gap: "1rem" }}>
        <label className="field">
          <span>Technical Skills & Expertise (comma-separated)</span>
          <input value={profile.skills || ""} placeholder="e.g. Java, Spring Boot, SQL, Docker, React" onChange={set("skills")} />
        </label>
        <label className="field">
          <span>Professional Bio / Growth Goals</span>
          <input value={profile.bio || ""} placeholder="Brief statement about your career or mentoring focus" onChange={set("bio")} />
        </label>
      </div>
      <button className="btn btn--primary" style={{ marginTop: "1rem" }} onClick={onSave}>Save profile</button>
    </section></>;
}

/* ----------------------------------------------------------------- Assessment */
export function Assessment({ onSubmit, previous }) {
  const [answers, setAnswers] = useState({});
  const [index, setIndex] = useState(0);
  const q = QUESTIONS[index];
  const answered = Object.keys(answers).length;
  const last = index === QUESTIONS.length - 1;
  return <>
    <PageHeader eyebrow="STEP 1 OF 2" title="My Skills and Self-Assessment" subtitle="Answer all questions. When you submit, Gemini will analyse your results and recommend courses."/>
    <section className="panel quiz">
      <div className="quiz__top"><span className="badge">Question {index + 1} of {QUESTIONS.length}</span><span className="muted">{answered}/{QUESTIONS.length} answered</span></div>
      <div className="progress-track" role="progressbar" aria-valuemin={0} aria-valuemax={QUESTIONS.length} aria-valuenow={answered}><span style={{ width: `${(answered / QUESTIONS.length) * 100}%` }}/></div>
      <fieldset className="quiz__card" key={index}>
        <legend><span className="eyebrow">{q.skill}</span>{q.question}</legend>
        {q.options.map((o, oi) => <label className={`answer-option ${answers[index] === oi ? "is-selected" : ""}`} key={o}><input type="radio" name={`q-${index}`} checked={answers[index] === oi} onChange={() => setAnswers({ ...answers, [index]: oi })}/><span className="answer-option__key">{String.fromCharCode(65 + oi)}</span><span>{o}</span></label>)}
      </fieldset>
      <div className="quiz__dots" aria-label="Jump to question">{QUESTIONS.map((_, i) => <button key={i} className={`dot ${i === index ? "is-current" : ""} ${answers[i] !== undefined ? "is-done" : ""}`} onClick={() => setIndex(i)} aria-label={`Question ${i + 1}`}/>)}</div>
      <div className="quiz__nav">
        <button className="btn btn--ghost" disabled={index === 0} onClick={() => setIndex(index - 1)}><Icon name="arrowLeft" size={16}/> Previous</button>
        {last ? <button className="btn btn--primary" disabled={answered !== QUESTIONS.length} onClick={() => onSubmit(answers)}><Icon name="sparkles" size={16}/> Submit and get AI recommendations</button>
          : <button className="btn btn--primary" disabled={answers[index] === undefined} onClick={() => setIndex(index + 1)}>Next <Icon name="arrow" size={16}/></button>}
      </div>
      {previous && <p className="muted quiz__note">Your previous score was {previous.score}%. Submitting again will replace it.</p>}
    </section></>;
}

/* -------------------------------------------------------------------- Results */
export function SkillBars({ results }) {
  return <div className="skill-bars">{results.map((s) => <div className="skill-bar" key={s.skill}>
    <div className="skill-bar__head"><strong>{s.skill}</strong><span>{s.level}/5 <small>· target {s.required}</small></span></div>
    <div className="skill-bar__track"><span className={`skill-bar__fill ${s.gap >= 2 ? "is-high" : s.gap === 1 ? "is-medium" : "is-ok"}`} style={{ width: `${(s.level / 5) * 100}%` }}/><i style={{ left: `${(s.required / 5) * 100}%` }} title={`Target ${s.required}/5`}/></div>
  </div>)}</div>;
}

export function Results({ assessment, recs, completed, toggleCourse, onRetry, setActivePage }) {
  return <>
    <PageHeader eyebrow="STEP 2 OF 2" title="Assessment Results" subtitle={`Completed ${fmtDate(assessment.completedAt)}`}/>
    <section className="panel"><div className="result-banner"><span className="result-score" style={{ "--p": `${assessment.score}%` }}><b>{assessment.score}%</b></span>
      <div><h2>You answered {assessment.correct} of {assessment.total} correctly</h2><p>The bars below compare your level with the target for each skill.</p></div></div>
      <SkillBars results={assessment.skillResults}/></section>
    <section className="panel"><div className="section-heading"><div><p className="eyebrow">AI RECOMMENDATIONS</p><h2>Courses picked for you</h2></div>
      {recs.status === "done" && <button className="text-action" onClick={() => setActivePage("courses")}>Open learning paths <Icon name="arrow" size={14}/></button>}</div>
      <RecommendationBlock recs={recs} completed={completed} toggleCourse={toggleCourse} onRetry={onRetry} limit={3}/></section></>;
}

/* ----------------------------------------------------------------------- Gaps */
export function Gaps({ assessment, setActivePage }) {
  if (!assessment) return <><PageHeader eyebrow="ANALYSIS" title="Knowledge Gap Summary"/><section className="panel"><EmptyState icon="target" title="No gaps calculated yet" text="Complete the assessment and SkillSphere will compare your level with the target for each skill." actionLabel="Take assessment" onAction={() => setActivePage("assessment")}/></section></>;
  return <>
    <PageHeader eyebrow="ANALYSIS" title="Knowledge Gap Summary" subtitle="Your level compared with the target proficiency for each skill."/>
    <section className="panel"><div className="table-wrap"><table><thead><tr><th>Skill</th><th>Correct</th><th>Current</th><th>Target</th><th>Gap</th><th>Priority</th></tr></thead>
      <tbody>{assessment.skillResults.map((s) => <tr key={s.skill}><td><strong>{s.skill}</strong></td><td>{s.correct}/{s.total}</td><td>{s.level}/5</td><td>{s.required}/5</td><td>{s.gap}</td><td><span className={priorityClass(s.priority)}>{s.priority}</span></td></tr>)}</tbody></table></div>
      <button className="btn btn--ghost" onClick={() => setActivePage("assessment")}>Retake assessment</button></section></>;
}

/* -------------------------------------------------------------------- Courses */
export function Courses({ assessment, recs, completed, toggleCourse, onRetry, setActivePage }) {
  const action = assessment && recs.status !== "loading" && <button className="btn btn--ghost" onClick={onRetry}><Icon name="refresh" size={16}/> Regenerate</button>;
  return <>
    <PageHeader eyebrow="AI-POWERED" title="Recommended Training and Learning Paths" subtitle="Courses chosen by Google Gemini from your assessment result and job role." action={action}/>
    {!assessment ? <section className="panel"><EmptyState icon="sparkles" title="Take the assessment to unlock recommendations" text="Gemini needs your assessment result to build a personalised learning path." actionLabel="Start assessment" onAction={() => setActivePage("assessment")}/></section>
      : <section className="panel"><RecommendationBlock recs={recs} completed={completed} toggleCourse={toggleCourse} onRetry={onRetry}/></section>}
  </>;
}

/* ------------------------------------------------------------------- Progress */
export function Progress({ recs, completed, progress, toggleCourse, setActivePage }) {
  const list = recs.data?.recommendations || [];
  if (!list.length) return <><PageHeader eyebrow="TRACKING" title="Learning Progress Tracking"/><section className="panel"><EmptyState icon="trending" title="Nothing to track yet" text="Once you receive course recommendations, you can track your completion here." actionLabel="Start assessment" onAction={() => setActivePage("assessment")}/></section></>;
  return <>
    <PageHeader eyebrow="TRACKING" title="Learning Progress Tracking" subtitle="Mark courses as complete as you finish them."/>
    <section className="panel"><div className="progress-summary"><div><p className="eyebrow">COURSE COMPLETION</p><strong>{progress}%</strong><p>{list.filter((c) => completed.includes(slug(c.title))).length} of {list.length} recommended courses completed</p></div><div className="progress-ring" style={{ "--progress": `${progress}%` }}><span>{progress}%</span></div></div>
      <div className="progress-track"><span style={{ width: `${progress}%` }}/></div>
      {list.map((c) => { const done = completed.includes(slug(c.title)); return <div className="progress-course" key={slug(c.title)}><div><strong>{c.title}</strong><small>{c.skill} · {c.duration}</small></div>
        <button className={`btn ${done ? "btn--complete" : "btn--ghost"}`} onClick={() => toggleCourse(slug(c.title))}>{done ? <><Icon name="check" size={16}/> Completed</> : "Mark complete"}</button></div>; })}
    </section></>;
}

/* ----------------------------------------------------------------- Mentorship */
export function Mentorship() {
  return <MentorshipHub />;
}

/* -------------------------------------------------------------- Notifications */
export function Notifications({ assessment, recs, completed }) {
  const items = [{ icon: "sparkles", title: "Welcome to SkillSphere", text: "Take your first assessment to get AI-powered course recommendations.", when: "Getting started" }];
  if (assessment) items.unshift({ icon: "check", title: "Assessment completed", text: `Your latest score is ${assessment.score}%.`, when: fmtDate(assessment.completedAt) });
  if (recs.data) items.unshift({ icon: "book", title: "Recommendations ready", text: `${recs.data.recommendations.length} courses were recommended for you.`, when: "Learning paths" });
  if (completed.length) items.unshift({ icon: "trending", title: "Nice progress", text: `You have completed ${completed.length} course${completed.length === 1 ? "" : "s"}.`, when: "Progress" });
  return <><PageHeader eyebrow="UPDATES" title="Notifications"/><section className="panel">{items.map((n) => <div className="notice-item" key={n.title}><span className="notice-icon"><Icon name={n.icon} size={18}/></span><div><strong>{n.title}</strong><p>{n.text}</p><small>{n.when}</small></div></div>)}</section></>;
}

/* -------------------------------------------------------------------- Reports */
export function Reports({ user, profile, assessment, recs, completed, progress }) {
  const gaps = assessment ? assessment.skillResults.filter((s) => s.gap > 0).length : "—";
  return <>
    <PageHeader eyebrow="SUMMARY" title="Reports" subtitle="A printable summary of your assessment and learning progress." action={<button className="btn btn--primary" onClick={() => window.print()}><Icon name="print" size={16}/> Print / Save PDF</button>}/>
    <section className="panel"><div className="report-head"><div><strong>{user.fullName}</strong><small>{profile.jobRole} · {profile.experience}{profile.department ? ` · ${profile.department}` : ""}</small></div><small>{new Date().toLocaleDateString([], { dateStyle: "long" })}</small></div>
      <div className="report-grid"><div className="report-metric"><small>Latest assessment</small><strong>{assessment ? `${assessment.score}%` : "Not taken"}</strong></div><div className="report-metric"><small>Knowledge gaps</small><strong>{gaps}</strong></div><div className="report-metric"><small>Courses completed</small><strong>{completed.length}</strong></div><div className="report-metric"><small>Learning progress</small><strong>{progress}%</strong></div></div>
      {assessment && <><h2>Skill levels</h2><SkillBars results={assessment.skillResults}/></>}
      {recs.data && <><h2>Recommended courses</h2><ul className="report-list">{recs.data.recommendations.map((c) => <li key={slug(c.title)}><strong>{c.title}</strong><span>{c.skill} · {c.priority} priority · {completed.includes(slug(c.title)) ? "Completed" : "Not completed"}</span></li>)}</ul></>}
    </section></>;
}
