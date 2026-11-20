import React, { useEffect, useState } from "react";
import DashboardLayout from "../components/DashboardLayout.jsx";
import { useNavigate, useParams } from "react-router-dom";
import Logo from "../components/Logo.jsx";
import Icon from "../components/Icons.jsx";
import NotificationsPopover from "../components/NotificationsPopover.jsx";
import { useAuth } from "../context/AuthContext.jsx";

// Import Department Head Styles
import "../styles/department-head.css";

// Import 10 Subviews
import DepartmentHeadDashboardOverviewView from "./department-head/DepartmentHeadDashboardOverviewView.jsx";
import DepartmentOverviewView from "./department-head/DepartmentOverviewView.jsx";
import DepartmentSkillMatrixView from "./department-head/DepartmentSkillMatrixView.jsx";
import DepartmentGapHeatmapView from "./department-head/DepartmentGapHeatmapView.jsx";
import WorkforceCapabilityView from "./department-head/WorkforceCapabilityView.jsx";
import LearningMentoringOverviewView from "./department-head/LearningMentoringOverviewView.jsx";
import RiskPriorityAlertsView from "./department-head/RiskPriorityAlertsView.jsx";
import DepartmentReportsAnalyticsView from "./department-head/DepartmentReportsAnalyticsView.jsx";
import DepartmentAnnouncementsView from "./department-head/DepartmentAnnouncementsView.jsx";
import DepartmentNotificationsView from "./department-head/DepartmentNotificationsView.jsx";

export const DH_NAV_GROUPS = [
  {
    category: "Strategic Overview",
    items: [
      { id: "overview", label: "Executive Dashboard", icon: "dashboard", path: "overview" },
      { id: "department", label: "Department & Teams", icon: "users", path: "department" },
      { id: "capability", label: "Workforce Capability", icon: "award", path: "capability" },
    ],
  },
  {
    category: "Competency Matrix & Heatmap",
    items: [
      { id: "skill-matrix", label: "Skill Matrix", icon: "clipboard", path: "skill-matrix" },
      { id: "heatmap", label: "Gap Heatmap", icon: "chart", path: "heatmap" },
      { id: "risks", label: "Risk & Priority Alerts", icon: "alert", path: "risks" },
    ],
  },
  {
    category: "Development & Governance",
    items: [
      { id: "learning-mentoring", label: "Learning & Mentoring", icon: "book", path: "learning-mentoring" },
      { id: "reports", label: "Reports & Analytics", icon: "file", path: "reports" },
      { id: "announcements", label: "Communications", icon: "message", path: "announcements" },
      { id: "notifications", label: "Notifications", icon: "bell", path: "notifications" },
    ],
  },
];

export const NAV_ITEMS = DH_NAV_GROUPS.flatMap((g) => g.items);

export default function DepartmentHeadDashboard() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const { tab } = useParams();

  // Active tab state synced with URL
  const [activeTab, setActiveTab] = useState(() => {
    if (!tab) return "overview";
    const found = NAV_ITEMS.find((n) => n.path === tab || n.id === tab);
    return found ? found.id : "overview";
  });

  useEffect(() => {
    if (tab) {
      const match = NAV_ITEMS.find((n) => n.path === tab || n.id === tab);
      if (match && match.id !== activeTab) {
        setActiveTab(match.id);
      }
    }
  }, [tab]);

  const handleSelectTab = (tabId) => {
    setActiveTab(tabId);
    const item = NAV_ITEMS.find((n) => n.id === tabId);
    if (item) {
      navigate(`/department-head/${item.path}`, { replace: true });
    }
  };

  const handleSignOut = async () => {
    try {
      await signOut();
      navigate("/login");
    } catch {
      navigate("/login");
    }
  };

  const activeItem = NAV_ITEMS.find((n) => n.id === activeTab) || NAV_ITEMS[0];

  return (
    <DashboardLayout
      role="DEPARTMENT_HEAD"
      roleLabel="DEPARTMENT HEAD LEADERSHIP"
      user={user}
      activeTab={activeTab}
      onSelectTab={handleSelectTab}
      navGroups={DH_NAV_GROUPS}
      onSignOut={handleSignOut}
      pageTitle={activeItem ? activeItem.label : "Department Head"}
    >
      <div className="dh-content" style={{ maxWidth: "100%", padding: 0 }}>
        {/* Subviews Container */}
          {activeTab === "overview" && (
            <DepartmentHeadDashboardOverviewView onNavigateTab={handleSelectTab} />
          )}
          {activeTab === "department" && (
            <DepartmentOverviewView onNavigateTab={handleSelectTab} />
          )}
          {activeTab === "skill-matrix" && <DepartmentSkillMatrixView />}
          {activeTab === "heatmap" && <DepartmentGapHeatmapView />}
          {activeTab === "capability" && (
            <WorkforceCapabilityView onNavigateTab={handleSelectTab} />
          )}
          {activeTab === "learning-mentoring" && <LearningMentoringOverviewView />}
          {activeTab === "risks" && <RiskPriorityAlertsView />}
          {activeTab === "reports" && <DepartmentReportsAnalyticsView />}
          {activeTab === "announcements" && <DepartmentAnnouncementsView />}
          {activeTab === "notifications" && <DepartmentNotificationsView />}
              </div>
    </DashboardLayout>
  );
}
