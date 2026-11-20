import React from "react";
import Icon from "../../components/Icons.jsx";
import KpiCard from "../../components/KpiCard.jsx";

export default function DashboardOverviewView({
  overview,
  user,
  onNavigateTab,
  onOpenScheduleModal,
}) {
  if (!overview) return <div className="mentor-panel">Loading mentor workspace...</div>;

  const {
    activeMenteesCount,
    pendingRequestsCount,
    completedSessionsCount,
    upcomingSessionsCount,
    goalCompletionRate,
    sharedResourcesCount,
    knowledgeArticlesCount,
    upcomingSessions = [],
    pendingRequests = [],
    activeMentees = [],
    recentActivities = [],
  } = overview;

  return (
    <div style={{ display: "flex", flexDirection: "column", gap: "24px" }}>
      {/* Hero Welcome */}
      <div className="mentor-hero">
        <div>
          <h1>Welcome, {user.fullName.split(" ")[0]}</h1>
          <p>
            Guiding enterprise talent, tracking milestone completions, and closing knowledge gaps.
          </p>
        </div>
        <div style={{ display: "flex", gap: "10px" }}>
          <button
            type="button"
            className="mt-btn"
            style={{ background: "#ffffff", color: "#0f766e" }}
            onClick={() => onNavigateTab("requests")}
          >
            Review Requests ({pendingRequestsCount})
          </button>
          <button
            type="button"
            className="mt-btn"
            style={{ background: "#042f2e", color: "#ffffff" }}
            onClick={onOpenScheduleModal}
          >
            Schedule Session &rarr;
          </button>
        </div>
      </div>

      {/* Standardized KPI Cards Grid */}
      <div className="dash-kpi-grid">
        <KpiCard
          title="Active Mentees"
          value={activeMenteesCount}
          subtext="Currently paired mentees"
          icon="users"
          colorVariant="primary"
          onClick={() => onNavigateTab("mentees")}
        />
        <KpiCard
          title="Pending Requests"
          value={pendingRequestsCount}
          subtext="Awaiting your response"
          icon="clipboard"
          colorVariant={pendingRequestsCount > 0 ? "blue" : "primary"}
          onClick={() => onNavigateTab("requests")}
        />
        <KpiCard
          title="Completed Sessions"
          value={completedSessionsCount}
          subtext={`${upcomingSessionsCount} upcoming scheduled`}
          icon="clock"
          colorVariant="emerald"
          onClick={() => onNavigateTab("sessions")}
        />
        <KpiCard
          title="Goal Completion Rate"
          value={`${goalCompletionRate}%`}
          subtext="Milestones achieved"
          icon="target"
          colorVariant="indigo"
          onClick={() => onNavigateTab("goals")}
        />
        <KpiCard
          title="Shared Resources"
          value={sharedResourcesCount}
          subtext="Curated docs & repos"
          icon="book"
          colorVariant="blue"
          onClick={() => onNavigateTab("resources")}
        />
        <KpiCard
          title="Knowledge Articles"
          value={knowledgeArticlesCount}
          subtext="Published best practices"
          icon="award"
          colorVariant="amber"
          onClick={() => onNavigateTab("contributions")}
        />
      </div>

      {/* Main Split Grid */}
      <div className="dash-grid-2col">
        {/* Upcoming Mentoring Sessions */}
        <div className="mentor-panel">
          <div className="mentor-panel-header">
            <h2>Upcoming Sessions</h2>
            <button type="button" className="mt-btn mt-btn--outline" onClick={() => onNavigateTab("sessions")}>
              View All &rarr;
            </button>
          </div>

          {upcomingSessions.length === 0 ? (
            <p style={{ color: "var(--mt-soft)", fontStyle: "italic", padding: "16px 0" }}>
              No upcoming mentoring sessions. Click "Schedule Session" to coordinate with your mentees.
            </p>
          ) : (
            <div style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
              {upcomingSessions.map((s) => (
                <div
                  key={s.id}
                  style={{
                    padding: "12px 16px",
                    borderRadius: "8px",
                    border: "1px solid var(--mt-line)",
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    gap: "10px",
                  }}
                >
                  <div>
                    <strong style={{ display: "block", fontSize: "0.95rem" }}>{s.title}</strong>
                    <span style={{ fontSize: "0.82rem", color: "var(--mt-soft)" }}>
                      with {s.employeeName} &bull; {new Date(s.scheduledAt).toLocaleString()} ({s.durationMinutes} min)
                    </span>
                  </div>
                  {s.meetingLink && (
                    <a
                      href={s.meetingLink}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="mt-btn mt-btn--outline"
                      style={{ fontSize: "0.78rem" }}
                    >
                      Join Link
                    </a>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Pending Requests Preview */}
        <div className="mentor-panel">
          <div className="mentor-panel-header">
            <h2>Pending Requests ({pendingRequests.length})</h2>
            <button type="button" className="mt-btn mt-btn--outline" onClick={() => onNavigateTab("requests")}>
              Manage &rarr;
            </button>
          </div>

          {pendingRequests.length === 0 ? (
            <p style={{ color: "var(--mt-soft)", fontStyle: "italic", padding: "16px 0" }}>
              No pending mentorship requests. All requests have been addressed.
            </p>
          ) : (
            <div style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
              {pendingRequests.map((r) => (
                <div
                  key={r.id}
                  style={{
                    padding: "12px 16px",
                    borderRadius: "8px",
                    background: "#f8fafc",
                    border: "1px solid var(--mt-line)",
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    gap: "10px",
                  }}
                >
                  <div>
                    <div style={{ display: "flex", gap: "8px", alignItems: "center" }}>
                      <strong>{r.employeeName}</strong>
                      <span className="mt-badge mt-badge--neutral">{r.employeeJobRole}</span>
                    </div>
                    <p style={{ margin: "4px 0 0", fontSize: "0.82rem", color: "var(--mt-soft)" }}>
                      &ldquo;{r.message || "Mentorship requested."}&rdquo;
                    </p>
                  </div>
                  <button
                    type="button"
                    className="mt-btn mt-btn--primary"
                    style={{ fontSize: "0.78rem" }}
                    onClick={() => onNavigateTab("requests")}
                  >
                    Respond
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Active Mentees Table */}
      <div className="mentor-panel">
        <div className="mentor-panel-header">
          <h2>Active Mentees ({activeMentees.length})</h2>
          <button type="button" className="mt-btn mt-btn--outline" onClick={() => onNavigateTab("mentees")}>
            View Mentees Directory &rarr;
          </button>
        </div>

        {activeMentees.length === 0 ? (
          <p style={{ color: "var(--mt-soft)", fontStyle: "italic" }}>
            No active mentees. Accept incoming requests to establish new mentorship pairings.
          </p>
        ) : (
          <div className="mentor-table-wrap">
            <table className="mentor-table">
              <thead>
                <tr>
                  <th>Mentee</th>
                  <th>Role & Dept</th>
                  <th>Paired Since</th>
                  <th>Goals</th>
                  <th>Sessions</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {activeMentees.map((m) => (
                  <tr key={m.assignmentId}>
                    <td>
                      <strong>{m.employeeName}</strong>
                      <div style={{ fontSize: "0.78rem", color: "var(--mt-faint)" }}>{m.email}</div>
                    </td>
                    <td>
                      <div>{m.jobRole}</div>
                      <small style={{ color: "var(--mt-faint)" }}>{m.department}</small>
                    </td>
                    <td>{new Date(m.assignedAt).toLocaleDateString()}</td>
                    <td>
                      <span className="mt-badge mt-badge--neutral">
                        {m.completedGoals} / {m.totalGoals} Completed
                      </span>
                    </td>
                    <td>{m.totalSessions} total</td>
                    <td>
                      <button
                        type="button"
                        className="mt-btn mt-btn--outline"
                        style={{ fontSize: "0.78rem" }}
                        onClick={() => onNavigateTab("mentees")}
                      >
                        View Dossier &rarr;
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
