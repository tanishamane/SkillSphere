import { useState, useEffect } from "react";
import Logo from "./Logo.jsx";
import Icon from "./Icons.jsx";
import NotificationsPopover from "./NotificationsPopover.jsx";

export default function DashboardLayout({
  role = "EMPLOYEE",
  roleLabel = "Employee Workspace",
  user,
  activeTab,
  onSelectTab,
  navItems = [],
  navGroups, // Optional: array of { category: string, items: Array }
  topbarExtra = null, // Optional custom element (e.g., team selector)
  onSignOut,
  children,
  pageTitle,
}) {
  const [mobileOpen, setMobileOpen] = useState(false);

  // Close mobile drawer on ESC key
  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === "Escape") setMobileOpen(false);
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, []);

  // Close mobile drawer when resizing back to desktop
  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth > 1024) setMobileOpen(false);
    };
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  const roleSlug = String(role).toLowerCase().replace(/_/g, "-");
  const userInitials = (user?.fullName || user?.name || "U")
    .split(" ")
    .map((n) => n[0])
    .join("")
    .slice(0, 2)
    .toUpperCase();

  const handleItemClick = (id) => {
    onSelectTab(id);
    setMobileOpen(false); // Auto close mobile drawer
  };

  // Render navigation item button
  const renderNavItem = (item) => {
    const isActive = activeTab === item.id;
    return (
      <button
        key={item.id}
        type="button"
        className={`dash-nav-item ${isActive ? "is-active" : ""}`}
        onClick={() => handleItemClick(item.id)}
        data-nav-id={item.id}
      >
        <span className="dash-nav-item__icon">
          <Icon name={item.icon || "dashboard"} size={18} />
        </span>
        <span className="dash-nav-item__label">{item.label}</span>
        {item.tag && <span className="dash-nav-item__tag">{item.tag}</span>}
        {item.badge != null && item.badge > 0 && (
          <span className="dash-nav-item__badge">{item.badge}</span>
        )}
      </button>
    );
  };

  return (
    <div className={`dash-app theme-${roleSlug}`}>
      {/* Mobile Backdrop */}
      {mobileOpen && (
        <div
          className="dash-sidebar-backdrop"
          onClick={() => setMobileOpen(false)}
          aria-hidden="true"
        />
      )}

      {/* Sidebar Navigation */}
      <aside className={`dash-sidebar ${mobileOpen ? "is-mobile-open" : ""}`}>
        {/* Brand Header */}
        <div className="dash-sidebar__brand">
          <div className="dash-sidebar__brand-logo">
            <Logo size="small" />
            <div>
              <span className="dash-sidebar__brand-title">SkillSphere</span>
              <span className="dash-sidebar__role-badge">{roleLabel}</span>
            </div>
          </div>
          {mobileOpen && (
            <button
              type="button"
              className="dash-sidebar__close-btn"
              onClick={() => setMobileOpen(false)}
              aria-label="Close navigation"
            >
              <Icon name="x" size={18} />
            </button>
          )}
        </div>

        {/* Navigation List */}
        <nav className="dash-sidebar__nav">
          {navGroups && navGroups.length > 0
            ? navGroups.map((group, idx) => (
                <div key={idx} className="dash-nav-group">
                  {group.category && (
                    <span className="dash-nav-group__title">{group.category}</span>
                  )}
                  <div className="dash-nav-group__items">
                    {group.items.map(renderNavItem)}
                  </div>
                </div>
              ))
            : navItems.map(renderNavItem)}
        </nav>

        {/* User Card Footer */}
        <div className="dash-sidebar__footer">
          <div className="dash-sidebar__avatar">{userInitials}</div>
          <div className="dash-sidebar__user-meta">
            <strong title={user?.fullName || user?.name || "User"}>
              {user?.fullName || user?.name || "User"}
            </strong>
            <small title={user?.role || role}>{user?.role || role}</small>
          </div>
          {onSignOut && (
            <button
              type="button"
              className="dash-sidebar__signout-btn"
              onClick={onSignOut}
              title="Sign out of SkillSphere"
              aria-label="Sign out"
            >
              <Icon name="logout" size={16} />
            </button>
          )}
        </div>
      </aside>

      {/* Main Workspace Area */}
      <div className="dash-main">
        {/* Top Utility Header */}
        <header className="dash-topbar">
          <div className="dash-topbar__left">
            <button
              type="button"
              className="dash-topbar__hamburger dash-hamburger-btn"
              onClick={() => setMobileOpen(true)}
              aria-label="Open mobile navigation"
            >
              <Icon name="menu" size={20} />
            </button>
            <div className="dash-topbar__heading">
              <span className="dash-topbar__title">{pageTitle || "Dashboard"}</span>
            </div>
          </div>

          <div className="dash-topbar__right">
            {topbarExtra && <div className="dash-topbar__extra">{topbarExtra}</div>}
            <div className="dash-topbar__notifications">
              <NotificationsPopover />
            </div>
            <div className="dash-topbar__user-pill">
              <div className="dash-topbar__pill-avatar">{userInitials}</div>
              <span className="dash-topbar__pill-name">
                {user?.fullName || user?.name || "User"}
              </span>
            </div>
            {onSignOut && (
              <button
                type="button"
                className="dash-topbar__logout-btn"
                onClick={onSignOut}
                title="Sign out"
                aria-label="Sign out"
              >
                <Icon name="logout" size={16} />
              </button>
            )}
          </div>
        </header>

        {/* Content Container */}
        <main className="dash-content">{children}</main>
      </div>
    </div>
  );
}
