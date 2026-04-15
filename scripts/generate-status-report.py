#!/usr/bin/env python3
"""
Generate a timestamped status report for ai-dev-framework.
To be called from the orchestrator agent.
"""

import os
import sys
import datetime
import subprocess
from pathlib import Path

def get_project_root() -> Path:
    """Get the project root directory."""
    return Path(__file__).parent.parent

def run_command(cmd: str, cwd: str = None) -> str:
    """Run a shell command and return output."""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=cwd)
        return result.stdout.strip()
    except Exception as e:
        return f"Error: {e}"

def get_git_info() -> dict:
    """Get git information for the project."""
    root = get_project_root()
    info = {
        "branch": run_command("git branch --show-current", str(root)),
        "commit": run_command("git rev-parse --short HEAD", str(root)),
        "status": run_command("git status --porcelain", str(root)).split('\n') if run_command("git status --porcelain", str(root)) else [],
        "recent_commits": run_command("git log --oneline -5", str(root)).split('\n') if run_command("git log --oneline -5", str(root)) else []
    }
    return info

def count_todos_fixmes() -> int:
    """Count TODO and FIXME comments in the codebase."""
    root = get_project_root()

    # Count in various file types
    patterns = [
        "*.py", "*.js", "*.ts", "*.tsx", "*.jsx", "*.md",
        "*.java", "*.go", "*.rs", "*.rb", "*.php", "*.cs"
    ]

    count = 0
    for pattern in patterns:
        cmd = f"grep -r -i 'TODO\\|FIXME' --include='{pattern}' . 2>/dev/null | wc -l"
        result = run_command(cmd, str(root))
        if result.isdigit():
            count += int(result)

    return count

def get_large_files(threshold_lines: int = 300) -> list:
    """Get files larger than threshold lines."""
    root = get_project_root()

    # Find all source files
    cmd = f"find . -type f \\( -name '*.py' -o -name '*.js' -o -name '*.ts' -o -name '*.tsx' -o -name '*.jsx' -o -name '*.java' -o -name '*.go' -o -name '*.rs' -o -name '*.rb' -o -name '*.php' -o -name '*.cs' \\) -exec wc -l {{}} \\; 2>/dev/null"
    output = run_command(cmd, str(root))

    large_files = []
    for line in output.split('\n'):
        if line.strip():
            parts = line.strip().split()
            if len(parts) >= 2:
                try:
                    lines = int(parts[0])
                    filename = ' '.join(parts[1:])
                    if lines > threshold_lines:
                        large_files.append((filename, lines))
                except ValueError:
                    continue

    # Sort by line count descending
    large_files.sort(key=lambda x: x[1], reverse=True)
    return large_files[:10]  # Return top 10 largest

def read_memory_file(filename: str) -> str:
    """Read a memory file and return its content."""
    path = get_project_root() / "memory" / filename
    if path.exists():
        return path.read_text().strip()
    return "Not found"

def get_adr_count() -> int:
    """Count ADR files in memory/decisions/."""
    decisions_dir = get_project_root() / "memory" / "decisions"
    if decisions_dir.exists():
        return len(list(decisions_dir.glob("*.md")))
    return 0

def get_convention_count() -> int:
    """Count convention files in memory/conventions/."""
    conventions_dir = get_project_root() / "memory" / "conventions"
    if conventions_dir.exists():
        return len(list(conventions_dir.glob("*.md")))
    return 0

def generate_status_report() -> str:
    """Generate a comprehensive status report."""
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    current_time = datetime.datetime.now().strftime("%H:%M:%S")

    # Read memory files
    project_context = read_memory_file("project-context.md")
    stack = read_memory_file("stack.md")
    progress = read_memory_file("progress.md")

    # Extract project name
    project_name = "Unknown"
    if project_context != "Not found":
        for line in project_context.split('\n'):
            if line.startswith("# "):
                project_name = line[2:].strip()
                break

    # Get metrics
    todo_count = count_todos_fixmes()
    large_files = get_large_files()
    adr_count = get_adr_count()
    convention_count = get_convention_count()
    git_info = get_git_info()

    # Build report
    report = f"""# Project Status Report — {current_date} {current_time}

## Project Overview
**Project**: {project_name}
**Generated**: {current_date} {current_time}
**Git**: {git_info['branch']} @ {git_info['commit']}

## Architecture & Decisions
**ADRs (Architecture Decision Records)**: {adr_count}
**Conventions documented**: {convention_count}

## Codebase Health
**TODO/FIXME count**: {todo_count}
**Large files (>300 lines)**: {len(large_files)}
"""

    if large_files:
        report += "\n```\n"
        for filename, lines in large_files:
            # Remove leading ./
            clean_name = filename[2:] if filename.startswith("./") else filename
            report += f"{clean_name}: {lines} lines\n"
        report += "```\n"

    # Recent changes
    if git_info['recent_commits']:
        report += "\n## Recent Changes\n"
        for commit in git_info['recent_commits'][:5]:
            report += f"- {commit}\n"

    # Uncommitted changes
    if git_info['status']:
        report += "\n## Uncommitted Changes\n"
        for status in git_info['status'][:10]:  # Show first 10
            report += f"- {status}\n"
        if len(git_info['status']) > 10:
            report += f"- ... and {len(git_info['status']) - 10} more\n"

    # Stack summary (first few lines)
    if stack != "Not found":
        stack_lines = stack.split('\n')[:10]
        report += "\n## Stack Summary\n```\n"
        report += '\n'.join(stack_lines)
        if len(stack.split('\n')) > 10:
            report += "\n... (truncated)"
        report += "\n```\n"

    # Progress summary (first few lines)
    if progress != "Not found":
        progress_lines = progress.split('\n')[:10]
        report += "\n## Progress Summary\n```\n"
        report += '\n'.join(progress_lines)
        if len(progress.split('\n')) > 10:
            report += "\n... (truncated)"
        report += "\n```\n"

    # Test coverage (placeholder - would need actual test runner)
    report += "\n## Test Coverage\n*Test coverage analysis requires test runner configuration*\n"

    # Recommended next action
    report += "\n## Recommended Next Action\n"

    if todo_count > 20:
        report += "**High priority**: Address technical debt (TODO/FIXME count is high)\n"
    elif large_files:
        report += "**Consider**: Refactor large files to improve maintainability\n"
    elif len(git_info['status']) > 5:
        report += "**Consider**: Commit or stash uncommitted changes\n"
    else:
        report += "**Continue**: Project appears healthy, proceed with next feature\n"

    # Add link to full memory files
    report += f"""
## Full Details
- [project-context.md](../../memory/project-context.md)
- [stack.md](../../memory/stack.md)
- [progress.md](../../memory/progress.md)
- [decisions/](../../memory/decisions/) ({adr_count} ADRs)
- [conventions/](../../memory/conventions/) ({convention_count} conventions)

---
*Generated by ai-dev-framework /project-status workflow*
"""

    return report

def main():
    """Generate and save status report."""
    # Create docs directory if it doesn't exist
    docs_dir = get_project_root() / "docs"
    docs_dir.mkdir(exist_ok=True)

    # Generate report
    report = generate_status_report()

    # Save to file
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    filename = docs_dir / f"status-{current_date}.md"

    filename.write_text(report)
    print(f"Status report saved to: {filename}")

    # Keep only last 10 reports
    import subprocess
    subprocess.run([sys.executable, str(get_project_root() / "scripts" / "status-history.py")], check=False)

    print("\n" + "="*60)
    print(report[:500] + "..." if len(report) > 500 else report)
    print("="*60)
    print(f"\nReport saved to {filename.name}")
    print("Link added to memory/progress.md")

if __name__ == "__main__":
    main()