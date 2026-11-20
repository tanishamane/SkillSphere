import Icon from "./Icons.jsx";

export default function KpiCard({
  title,
  label,
  value,
  subtext,
  meta,
  icon = "chart",
  colorVariant = "primary",
  trend,
  onClick,
  className = "",
  style = {},
}) {
  const displayTitle = title || label || "";
  const displayMeta = subtext || meta || "";
  const isClickable = typeof onClick === "function";

  return (
    <div
      className={`dash-kpi-card dash-kpi-card--${colorVariant} ${isClickable ? "is-clickable" : ""} ${className}`}
      style={style}
      onClick={onClick}
      role={isClickable ? "button" : undefined}
      tabIndex={isClickable ? 0 : undefined}
      onKeyDown={isClickable ? (e) => e.key === "Enter" && onClick(e) : undefined}
    >
      <div className="dash-kpi-card__header">
        <span className="dash-kpi-card__label" title={displayTitle}>
          {displayTitle}
        </span>
        <div className={`dash-kpi-card__icon-wrap dash-kpi-card__icon-wrap--${colorVariant}`}>
          <Icon name={icon} size={20} />
        </div>
      </div>

      <div className="dash-kpi-card__value-wrap">
        <span className="dash-kpi-card__value">{value ?? 0}</span>
        {trend && (
          <span className={`dash-kpi-card__trend dash-kpi-card__trend--${trend.direction || "neutral"}`}>
            {trend.label}
          </span>
        )}
      </div>

      {displayMeta && (
        <div className="dash-kpi-card__meta" title={displayMeta}>
          {displayMeta}
        </div>
      )}
    </div>
  );
}
