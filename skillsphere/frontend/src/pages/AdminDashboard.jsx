import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import Logo from "../components/Logo.jsx";
import Icon from "../components/Icons.jsx";
import NotificationsPopover from "../components/NotificationsPopover.jsx";
import { useAuth } from "../context/AuthContext.jsx";
import DashboardLayout from "../components/DashboardLayout.jsx";

// Import Admin Styles
import "../styles/admin.css";

// Import All 12 Administrative Views
import AdminDashboardOverviewView from "./admin/AdminDashboardOverviewView.jsx";
import UserManagementView from "./admin/UserManagementView.jsx";
import RolePermissionManagementView from "./admin/RolePermissionManagementView.jsx";
import DepartmentTeamSetupView from "./admin/DepartmentTeamSetupView.jsx";
import SkillCatalogueSettingsView from "./admin/SkillCatalogueSettingsView.jsx";
import ChatCommunicationSettingsView from "./admin/ChatCommunicationSettingsView.jsx";
import NotificationSettingsView from "./admin/NotificationSettingsView.jsx";
import AdminAuditLogsView from "./admin/AdminAuditLogsView.jsx";
import SecurityMonitoringView from "./admin/SecurityMonitoringView.jsx";
import SystemConfigurationView from "./admin/SystemConfigurationView.jsx";
import BackupRecoveryView from "./admin/BackupRecoveryView.jsx";
import SupportIssueLogsView from "./admin/SupportIssueLogsView.jsx";

export const ADMIN_NAV_GROUPS = [
  {
    category: "Identity & Organization",
    items: [
      { id: "overview", label: "Executive Dashboard", icon: "dashboard", path: "overview" },
      { id: "users", label: "User Management", icon: "user", path: "users" },
      { id: "roles", label: "Role & Permissions", icon: "shield", path: "roles" },
      { id: "organization", label: "Departments & Teams", icon: "clipboard", path: "organization" },
    ],
  },
  {
    category: "Platform Governance",
    items: [
      { id: "skills", label: "Skill Catalogue", icon: "layers", path: "skills" },
      { id: "communications", label: "Chat & Communications", icon: "message-square", path: "communications" },
      { id: "notifications", label: "Notification Settings", icon: "bell", path: "notifications" },
    ],
  },
  {
    category: "Security & Infrastructure",
    items: [
      { id: "audit-logs", label: "Audit Logs", icon: "file", path: "audit-logs" },
      { id: "security", label: "Security Monitoring", icon: "lock", path: "security" },
      { id: "configuration", label: "System Configuration", icon: "settings", path: "configuration" },
      { id: "backup", label: "Backup & Recovery", icon: "database", path: "backup" },
      { id: "support", label: "Support & Issues", icon: "help-circle", path: "support" },
    ],
  },
];

export const ADMIN_NAV_ITEMS = ADMIN_NAV_GROUPS.flatMap((g) => g.items);

export default function AdminDashboard() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const { tab } = useParams();

  // Active tab state synced with URL parameter
  const [activeTab, setActiveTab] = useState(() => {
    if (!tab) return "overview";
    const found = ADMIN_NAV_ITEMS.find((n) => n.path === tab || n.id === tab);
    return found ? found.id : "overview";
  });

  useEffect(() => {
    if (tab) {
      const match = ADMIN_NAV_ITEMS.find((n) => n.path === tab || n.id === tab);
      if (match && match.id !== activeTab) {
        setActiveTab(match.id);
      }
    }
  }, [tab]);

  const handleSelectTab = (tabId) => {
    setActiveTab(tabId);
    const item = ADMIN_NAV_ITEMS.find((n) => n.id === tabId);
    if (item) {
      navigate(`/admin/${item.path}`, { replace: true });
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

  const activeItem = ADMIN_NAV_ITEMS.find((n) => n.id === activeTab) || ADMIN_NAV_ITEMS[0];

  return (
    <DashboardLayout
      role="ADMIN"
      roleLabel="SYSTEM ADMINISTRATION"
      user={user}
      activeTab={activeTab}
      onSelectTab={handleSelectTab}
      navGroups={ADMIN_NAV_GROUPS}
      onSignOut={handleSignOut}
      pageTitle={activeItem.label}
    >
      <div className="adm-content">
        {activeTab === "overview" && (
          <AdminDashboardOverviewView onNavigateTab={handleSelectTab} />
        )}
        {activeTab === "users" && <UserManagementView />}
        {activeTab === "roles" && <RolePermissionManagementView />}
        {activeTab === "organization" && <DepartmentTeamSetupView />}
        {activeTab === "skills" && <SkillCatalogueSettingsView />}
        {activeTab === "communications" && <ChatCommunicationSettingsView />}
        {activeTab === "notifications" && <NotificationSettingsView />}
        {activeTab === "audit-logs" && <AdminAuditLogsView />}
        {activeTab === "security" && <SecurityMonitoringView />}
        {activeTab === "configuration" && <SystemConfigurationView />}
        {activeTab === "backup" && <BackupRecoveryView />}
        {activeTab === "support" && <SupportIssueLogsView />}
      </div>
    </DashboardLayout>
  );
}
