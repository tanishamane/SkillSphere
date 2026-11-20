import EmptyState from "./EmptyState.jsx";
import Spinner from "./Spinner.jsx";

export default function DataTable({
  columns = [],
  children,
  loading = false,
  empty = false,
  emptyTitle = "No records found",
  emptyText = "There are no entries matching your current filters.",
  className = "",
  style = {},
}) {
  return (
    <div className={`dash-table-wrap ${className}`} style={style}>
      {loading ? (
        <div className="dash-table-loading" role="status" aria-live="polite">
          <Spinner size="md" />
          <span>Loading records...</span>
        </div>
      ) : empty ? (
        <EmptyState title={emptyTitle} description={emptyText} />
      ) : (
        <div className="dash-table-scroll">
          <table className="dash-table">
            {columns.length > 0 && (
              <thead>
                <tr>
                  {columns.map((col, idx) => {
                    const label = typeof col === "string" ? col : col.label;
                    const align = typeof col === "object" && col.align ? col.align : "left";
                    return (
                      <th key={idx} style={{ textAlign: align }}>
                        {label}
                      </th>
                    );
                  })}
                </tr>
              </thead>
            )}
            <tbody>{children}</tbody>
          </table>
        </div>
      )}
    </div>
  );
}
