import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import Logo from "../components/Logo.jsx";
import Icon from "../components/Icons.jsx";
import Alert from "../components/Alert.jsx";
import { useAuth } from "../context/AuthContext.jsx";
import { getAiRecommendations, parseApiError } from "../services/authService.js";
import { getEmployeeProfile, updateEmployeeProfile } from "../services/mentorshipService.js";
import { scoreAssessment } from "../data/assessment.js";
import {
  Assessment, Courses, Gaps, Mentorship, Notifications, Overview, Profile, Progress, Reports, Results, slug,
} from "./employee/Pages.jsx";

const NAV_ITEMS = [
  { id: "overview", label: "Dashboard", icon: "dashboard" },
  { id: "profile", label: "Employee Profile Management", icon: "user" },
  { id: "assessment", label: "My Skills and Self-Assessment", icon: "clipboard" },
  { id: "gaps", label: "Knowledge Gap Summary", icon: "chart" },
  { id: "courses", label: "Recommended Training and Learning Paths", icon: "sparkles", tag: "AI" },
  { id: "progress", label: "Learning Progress Tracking", icon: "trending" },
  { id: "mentorship", label: "Knowledge Sharing and Mentorship", icon: "users" },
  { id: "notifications", label: "Notifications", icon: "bell" },
  { id: "reports", label: "Reports", icon: "file" },
];

const storageKey = (id) => `skillsphere.employee.${id}`;
function loadSaved(id) {
  try { return JSON.parse(localStorage.getItem(storageKey(id))) || {}; } catch { return {}; }
}

export default function EmployeeDashboard() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const saved = useMemo(() => loadSaved(user.id), [user.id]);

  const [activePage, setActivePage] = useState("overview");
  const [profile, setProfile] = useState(saved.profile || {
    fullName: user.fullName || "", employeeId: user.employeeId || "", email: user.email || "",
    department: "", jobRole: "Software Developer", experience: "Entry level", bio: "", skills: "",
  });
  const [profileSaved, setProfileSaved] = useState(false);
  const [assessment, setAssessment] = useState(saved.assessment || null);
  const [recs, setRecs] = useState(saved.recs ? { status: "done", data: saved.recs, error: "" } : { status: "idle", data: null, error: "" });
  const [completed, setCompleted] = useState(saved.completed || []);
  const latestRequest = useRef(0);

  // Sync profile from backend on mount
  useEffect(() => {
    getEmployeeProfile()
      .then((p) => {
        setProfile((prev) => ({
          ...prev,
          fullName: p.fullName || prev.fullName,
          email: p.email || prev.email,
          employeeId: p.employeeId || prev.employeeId,
          jobRole: p.jobRole || prev.jobRole,
          department: p.department || prev.department || "",
          experience: p.experienceLevel || prev.experience,
          bio: p.bio || prev.bio || "",
          skills: p.skills || prev.skills || "",
        }));
      })
      .catch(() => {});
  }, []);

  // Keep results on this device so a refresh does not lose them.
  useEffect(() => {
    try {
      localStorage.setItem(storageKey(user.id), JSON.stringify({ profile, assessment, recs: recs.data, completed }));
    } catch { /* storage unavailable: the app still works for this session */ }
  }, [user.id, profile, assessment, recs.data, completed]);

  const requestRecommendations = useCallback(async (result, currentProfile) => {
    const ticket = ++latestRequest.current;
    setRecs((r) => ({ ...r, status: "loading", error: "" }));
    try {
      const data = await getAiRecommendations({
        jobRole: currentProfile.jobRole, experience: currentProfile.experience, department: currentProfile.department,
        overallScore: result.score,
        skillResults: result.skillResults.map(({ skill, correct, total, level, required }) => ({ skill, correct, total, level, required })),
      });
      if (ticket !== latestRequest.current) return;
      setRecs({ status: "done", data, error: "" });
      setCompleted([]);
    } catch (e) {
      if (ticket !== latestRequest.current) return;
      setRecs((r) => ({ ...r, status: "error", error: parseApiError(e).message }));
    }
  }, []);

  const submitAssessment = (answers) => {
    const result = scoreAssessment(answers);
    setAssessment(result);
    setActivePage("results");
    requestRecommendations(result, profile);
  };
  const retry = () => assessment && requestRecommendations(assessment, profile);
  const toggleCourse = (id) => setCompleted((list) => (list.includes(id) ? list.filter((x) => x !== id) : [...list, id]));

  const saveProfile = async () => {
    try {
      await updateEmployeeProfile({
        jobRole: profile.jobRole || "Software Developer",
        department: profile.department || null,
        experienceLevel: profile.experience || "Entry level",
        bio: profile.bio || null,
        skills: profile.skills || null,
      });
    } catch {
      // Local fallback continues gracefully
    }
    setProfileSaved(true);
    setTimeout(() => setProfileSaved(false), 4000);
  };

  const courseList = recs.data?.recommendations || [];
  const progress = courseList.length ? Math.round((courseList.filter((c) => completed.includes(slug(c.title))).length / courseList.length) * 100) : 0;
  const onSignOut = async () => { await signOut(); navigate("/login", { replace: true }); };
  const goTo = (id) => { setActivePage(id); window.scrollTo({ top: 0 }); };

  const shared = { user, profile, assessment, recs, completed, progress, toggleCourse, setActivePage: goTo, onRetry: retry };
  const activeNav = activePage === "results" ? "assessment" : activePage;
  const pageTitle = activePage === "results" ? "Assessment Results" : NAV_ITEMS.find((n) => n.id === activePage)?.label;

  return <div className="employee-app">
    <aside className="employee-sidebar">
      <div className="sidebar-brand"><Logo/><span>EMPLOYEE WORKSPACE</span></div>
      <nav aria-label="Employee navigation">{NAV_ITEMS.map((item) => <button key={item.id} className={`nav-item ${activeNav === item.id ? "is-active" : ""}`} aria-current={activeNav === item.id ? "page" : undefined} onClick={() => goTo(item.id)}>
        <Icon name={item.icon} size={19}/><span className="nav-label">{item.label}</span>{item.tag && <em className="nav-tag">{item.tag}</em>}</button>)}</nav>
      <div className="sidebar-bottom"><span className="sidebar-avatar">{(user.fullName || "E").slice(0, 1).toUpperCase()}</span><div><strong>{user.fullName}</strong><small>{user.email}</small></div>
        <button className="sidebar-signout" onClick={onSignOut} aria-label="Sign out" title="Sign out"><Icon name="logout" size={18}/></button></div>
    </aside>
    <main className="employee-main">
      <header className="employee-topbar"><div><span className="mobile-brand">SkillSphere</span><span className="topbar-title">{pageTitle}</span></div>
        <div className="topbar-user"><span className="badge">Employee</span><span className="topbar-name">{user.fullName}</span><button className="btn btn--ghost" onClick={onSignOut}>Sign out</button></div></header>
      <div className="employee-content">
        {activePage === "overview" && <Overview {...shared}/>}
        {activePage === "profile" && <Profile profile={profile} setProfile={setProfile} onSave={saveProfile} saved={profileSaved}/>}
        {activePage === "assessment" && <Assessment onSubmit={submitAssessment} previous={assessment}/>}
        {activePage === "results" && (assessment ? <Results {...shared}/> : <Alert type="error">No assessment found. Please take the assessment first.</Alert>)}
        {activePage === "gaps" && <Gaps {...shared}/>}
        {activePage === "courses" && <Courses {...shared}/>}
        {activePage === "progress" && <Progress {...shared}/>}
        {activePage === "mentorship" && <Mentorship/>}
        {activePage === "notifications" && <Notifications {...shared}/>}
        {activePage === "reports" && <Reports {...shared}/>}
        <p className="demo-disclaimer">Assessment results and progress are saved in this browser. AI recommendations are generated by Google Gemini — review them before enrolling.</p>
      </div>
    </main>
  </div>;
}
