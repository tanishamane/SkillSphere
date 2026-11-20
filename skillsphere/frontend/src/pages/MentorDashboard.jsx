import React, { useEffect, useState } from "react";
import DashboardLayout from "../components/DashboardLayout.jsx";
import { useNavigate, useParams } from "react-router-dom";
import Logo from "../components/Logo.jsx";
import Icon from "../components/Icons.jsx";
import Alert from "../components/Alert.jsx";
import NotificationsPopover from "../components/NotificationsPopover.jsx";
import { useAuth } from "../context/AuthContext.jsx";

// Import Mentor CSS
import "../styles/mentor.css";

// Import Subviews
import DashboardOverviewView from "./mentor/DashboardOverviewView.jsx";
import MentorProfileView from "./mentor/MentorProfileView.jsx";
import MentorshipRequestsView from "./mentor/MentorshipRequestsView.jsx";
import MyMenteesView from "./mentor/MyMenteesView.jsx";
import MenteeSkillOverviewView from "./mentor/MenteeSkillOverviewView.jsx";
import DevelopmentGoalsView from "./mentor/DevelopmentGoalsView.jsx";
import MentoringSessionsView from "./mentor/MentoringSessionsView.jsx";
import MentorChatView from "./mentor/MentorChatView.jsx";
import SharedResourcesView from "./mentor/SharedResourcesView.jsx";
import KnowledgeContributionsView from "./mentor/KnowledgeContributionsView.jsx";
import MentoringFeedbackView from "./mentor/MentoringFeedbackView.jsx";
import MentorNotificationsView from "./mentor/MentorNotificationsView.jsx";

import { getMentorOverview, getMentorProfile } from "../services/mentorService.js";
import { parseApiError } from "../services/apiClient.js";

export const MENTOR_NAV_GROUPS = [
  {
    category: "Mentorship Core",
    items: [
      { id: "overview", label: "Dashboard", icon: "dashboard", path: "dashboard" },
      { id: "profile", label: "Mentor Profile", icon: "user", path: "profile" },
      { id: "requests", label: "Mentorship Requests", icon: "clipboard", path: "requests" },
    ],
  },
  {
    category: "Mentees & Development",
    items: [
      { id: "mentees", label: "My Mentees", icon: "users", path: "mentees" },
      { id: "mentee-skills", label: "Mentee Skill Overview", icon: "target", path: "mentee-skills" },
      { id: "goals", label: "Development Goals", icon: "clipboard", path: "goals" },
      { id: "sessions", label: "Mentoring Sessions", icon: "clock", path: "sessions" },
    ],
  },
  {
    category: "Knowledge & Community",
    items: [
      { id: "chat", label: "Messages / Chatbox", icon: "message", path: "chat" },
      { id: "resources", label: "Shared Resources", icon: "book", path: "resources" },
      { id: "contributions", label: "Knowledge Contributions", icon: "award", path: "contributions" },
      { id: "feedback", label: "Feedback", icon: "star", path: "feedback" },
      { id: "notifications", label: "Notifications", icon: "bell", path: "notifications" },
    ],
  },
];

export const NAV_ITEMS = MENTOR_NAV_GROUPS.flatMap((g) => g.items);

export default function MentorDashboard() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const { tab } = useParams();

  // Active Tab state synced with URL
  const [activeTab, setActiveTab] = useState(() => {
    if (!tab) return "overview";
    const found = NAV_ITEMS.find((n) => n.path === tab || n.id === tab);
    return found ? found.id : "overview";
  });

  const [overview, setOverview] = useState(null);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [triggerScheduleModal, setTriggerScheduleModal] = useState(false);

  useEffect(() => {
    if (tab) {
      const found = NAV_ITEMS.find((n) => n.path === tab || n.id === tab);
      if (found && found.id !== activeTab) {
        setActiveTab(found.id);
      }
    }
  }, [tab]);

  const loadBaseData = async () => {
    setLoading(true);
    try {
      const [ov, pr] = await Promise.all([
        getMentorOverview().catch(() => null),
        getMentorProfile().catch(() => null),
      ]);
      setOverview(ov);
      setProfile(pr);
    } catch (err) {
      setError(parseApiError(err).message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadBaseData();
  }, []);

  const handleNavClick = (id) => {
    setActiveTab(id);
    const item = NAV_ITEMS.find((n) => n.id === id);
    if (item) {
      navigate(`/mentor/${item.path}`);
    }
  };

  const onSignOut = async () => {
    await signOut();
    navigate("/login", { replace: true });
  };

  const pendingRequestsCount = overview ? overview.pendingRequestsCount : 0;

  const mentorNavGroups = MENTOR_NAV_GROUPS.map((group) => ({
    ...group,
    items: group.items.map((item) => ({
      ...item,
      badge: item.id === "requests" && pendingRequestsCount > 0 ? pendingRequestsCount : undefined,
    })),
  }));

  const activeNavObj = NAV_ITEMS.find((n) => n.id === activeTab) || NAV_ITEMS[0];
  const pageTitle = activeNavObj ? activeNavObj.label : "Mentor Workspace";

  return (
    <DashboardLayout
      role="MENTOR"
      roleLabel="MENTOR WORKSPACE"
      user={user}
      activeTab={activeTab}
      onSelectTab={handleNavClick}
      navGroups={mentorNavGroups}
      onSignOut={onSignOut}
      pageTitle={pageTitle}
    >
      <div className="mentor-content" style={{ maxWidth: "100%", padding: 0 }}>
        {error && <Alert type="error">{error}</Alert>}

          {/* Module 1: Dashboard */}
          {activeTab === "overview" && (
            <DashboardOverviewView
              overview={overview}
              user={user}
              onNavigateTab={handleNavClick}
              onOpenScheduleModal={() => {
                setTriggerScheduleModal(true);
                handleNavClick("sessions");
              }}
            />
          )}

          {/* Module 2: Mentor Profile */}
          {activeTab === "profile" && (
            <MentorProfileView
              profile={profile}
              onProfileUpdated={(updated) => {
                setProfile(updated);
                loadBaseData();
              }}
            />
          )}

          {/* Module 3: Mentorship Requests */}
          {activeTab === "requests" && (
            <MentorshipRequestsView onRequestsUpdated={loadBaseData} />
          )}

          {/* Module 4: My Mentees */}
          {activeTab === "mentees" && (
            <MyMenteesView onNavigateTab={handleNavClick} />
          )}

          {/* Module 5: Mentee Skill Overview */}
          {activeTab === "mentee-skills" && (
            <MenteeSkillOverviewView />
          )}

          {/* Module 6: Development Goals */}
          {activeTab === "goals" && (
            <DevelopmentGoalsView />
          )}

          {/* Module 7: Mentoring Sessions */}
          {activeTab === "sessions" && (
            <MentoringSessionsView
              showScheduleModal={triggerScheduleModal}
              onCloseScheduleModal={() => setTriggerScheduleModal(false)}
            />
          )}

          {/* Module 8: Messages / Chatbox */}
          {activeTab === "chat" && (
            <MentorChatView user={user} />
          )}

          {/* Module 9: Shared Resources */}
          {activeTab === "resources" && (
            <SharedResourcesView />
          )}

          {/* Module 10: Knowledge Contributions */}
          {activeTab === "contributions" && (
            <KnowledgeContributionsView />
          )}

          {/* Module 11: Feedback */}
          {activeTab === "feedback" && (
            <MentoringFeedbackView />
          )}

          {/* Module 12: Notifications */}
          {activeTab === "notifications" && (
            <MentorNotificationsView onNavigateTab={handleNavClick} />
          )}
              </div>
    </DashboardLayout>
  );
}
