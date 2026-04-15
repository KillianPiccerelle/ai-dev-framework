#!/usr/bin/env python3
"""
Status report history management for ai-dev-framework.
Generates ASCII progress charts and manages the last 10 reports.
"""

import os
import re
import glob
import datetime
from pathlib import Path
from typing import List, Dict, Optional, Tuple

def get_project_root() -> Path:
    """Get the project root directory."""
    return Path(__file__).parent.parent

def get_status_dir() -> Path:
    """Get the docs directory for status reports."""
    return get_project_root() / "docs"

def get_current_date() -> str:
    """Get current date in YYYY-MM-DD format."""
    return datetime.datetime.now().strftime("%Y-%m-%d")

def get_status_filename(date: Optional[str] = None) -> str:
    """Get status filename for a given date (default: today)."""
    if date is None:
        date = get_current_date()
    return f"status-{date}.md"

def list_status_reports() -> List[Tuple[str, Path]]:
    """List all status reports sorted by date (newest first)."""
    status_dir = get_status_dir()
    if not status_dir.exists():
        return []

    pattern = status_dir / "status-*.md"
    reports = []

    for filepath in glob.glob(str(pattern)):
        filename = os.path.basename(filepath)
        # Extract date from filename: status-YYYY-MM-DD.md
        match = re.match(r"status-(\d{4}-\d{2}-\d{2})\.md", filename)
        if match:
            date_str = match.group(1)
            reports.append((date_str, Path(filepath)))

    # Sort by date descending (newest first)
    reports.sort(key=lambda x: x[0], reverse=True)
    return reports

def keep_last_n_reports(n: int = 10) -> None:
    """Keep only the last N reports, delete older ones."""
    reports = list_status_reports()
    if len(reports) <= n:
        return

    for date_str, filepath in reports[n:]:
        try:
            filepath.unlink()
            print(f"Deleted old report: {filepath.name}")
        except Exception as e:
            print(f"Error deleting {filepath.name}: {e}")

def extract_metrics_from_report(filepath: Path) -> Dict[str, float]:
    """Extract metrics from a status report file."""
    metrics = {}

    try:
        content = filepath.read_text()

        # Extract test coverage percentage
        coverage_match = re.search(r"Test coverage:\s*(\d+)%", content)
        if coverage_match:
            metrics["coverage"] = float(coverage_match.group(1))

        # Extract TODO/FIXME count
        todo_match = re.search(r"TODO/FIXME count:\s*(\d+)", content)
        if todo_match:
            metrics["todos"] = float(todo_match.group(1))

        # Extract date from filename
        date_match = re.search(r"status-(\d{4}-\d{2}-\d{2})\.md", filepath.name)
        if date_match:
            metrics["date"] = date_match.group(1)

    except Exception as e:
        print(f"Error reading {filepath}: {e}")

    return metrics

def generate_ascii_chart(metric_name: str, data: List[Tuple[str, float]], width: int = 50) -> str:
    """Generate ASCII bar chart for a metric over time."""
    if not data:
        return f"No {metric_name} data available"

    # Sort by date
    data.sort(key=lambda x: x[0])

    # Extract dates and values
    dates = [d[0] for d in data]
    values = [d[1] for d in data]

    # Find min and max for scaling
    min_val = min(values)
    max_val = max(values)

    # Handle case where all values are the same
    if max_val == min_val:
        scaled_values = [width // 2] * len(values)
    else:
        scaled_values = [int((v - min_val) / (max_val - min_val) * width) for v in values]

    # Build chart
    chart_lines = []
    chart_lines.append(f"{metric_name} over time:")
    chart_lines.append("")

    for date, value, scaled in zip(dates, values, scaled_values):
        bar = "█" * scaled
        # Format value based on metric
        if metric_name == "coverage":
            value_str = f"{value:.1f}%"
        else:
            value_str = f"{int(value)}"

        chart_lines.append(f"{date}: {bar} {value_str}")

    chart_lines.append("")
    chart_lines.append(f"Min: {min_val:.1f}, Max: {max_val:.1f}")

    return "\n".join(chart_lines)

def generate_progress_charts() -> str:
    """Generate ASCII charts for all available metrics."""
    reports = list_status_reports()
    if len(reports) < 2:
        return "Not enough historical data for charts (need at least 2 reports)"

    # Collect metrics
    coverage_data = []
    todos_data = []

    for date_str, filepath in reports:
        metrics = extract_metrics_from_report(filepath)
        if "coverage" in metrics:
            coverage_data.append((date_str, metrics["coverage"]))
        if "todos" in metrics:
            todos_data.append((date_str, metrics["todos"]))

    charts = []

    if coverage_data:
        charts.append(generate_ascii_chart("coverage", coverage_data))

    if todos_data:
        charts.append(generate_ascii_chart("todos", todos_data))

    if not charts:
        return "No metric data found in reports"

    return "\n\n".join(charts)

def update_memory_progress_link() -> None:
    """Update memory/progress.md with link to latest status report."""
    memory_file = get_project_root() / "memory" / "progress.md"
    if not memory_file.exists():
        return

    reports = list_status_reports()
    if not reports:
        return

    latest_date, latest_path = reports[0]
    link_line = f"Latest status report: [status-{latest_date}.md](../../docs/status-{latest_date}.md)"

    content = memory_file.read_text()

    # Remove existing link if present
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        if line.startswith("Latest status report:"):
            continue
        new_lines.append(line)

    # Add new link at the top
    if new_lines and new_lines[0].startswith("# "):
        # Insert after title
        new_lines.insert(1, "")
        new_lines.insert(2, link_line)
    else:
        # Add at beginning
        new_lines.insert(0, link_line)
        new_lines.insert(1, "")

    memory_file.write_text('\n'.join(new_lines))
    print(f"Updated memory/progress.md with link to status-{latest_date}.md")

def main():
    """Test the status history functions."""
    print("Status history utility test")
    print("=" * 40)

    status_dir = get_status_dir()
    print(f"Status directory: {status_dir}")

    reports = list_status_reports()
    print(f"Found {len(reports)} status reports:")
    for date, path in reports[:5]:  # Show first 5
        print(f"  - {date}: {path.name}")

    if len(reports) > 5:
        print(f"  ... and {len(reports) - 5} more")

    print("\n" + generate_progress_charts())

    # Test cleanup
    print("\nCleaning up old reports (keeping last 10)...")
    keep_last_n_reports(10)

    print("\nUpdating memory progress link...")
    update_memory_progress_link()

if __name__ == "__main__":
    main()