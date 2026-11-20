import Icon from "./Icons.jsx";

export default function EmptyState({
  icon = "clipboard",
  title = "No data found",
  description = "There are no records to display at this time.",
  actionLabel,
  onAction,
  className = "",
  style = {},
}) {
  return (
    <div className={`dash-empty-state ${className}`} style={style} role="status" aria-live="polite">
      <div className="dash-empty-state__icon-wrap">
        <Icon name={icon} size={32} />
      </div>
      <h3 className="dash-empty-state__title">{title}</h3>
      {description && <p className="dash-empty-state__desc">{description}</p>}
      {actionLabel && onAction && (
        <button type="button" className="btn btn--primary dash-empty-state__btn" onClick={onAction}>
          {actionLabel}
          <Icon name="arrow" size={16} />
        </button>
      )}
    </div>
  );
}
