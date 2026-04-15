#!/usr/bin/env python3
"""
Dependency management helper for ai-dev-framework.
Detects package managers, checks for updates, and applies them safely.
"""

import os
import sys
import json
import subprocess
import datetime
from pathlib import Path
from typing import Dict, List, Tuple, Optional, Any

def get_project_root() -> Path:
    """Get the project root directory."""
    return Path.cwd()

def detect_package_manager() -> Dict[str, Any]:
    """Detect which package manager is used in the project."""
    root = get_project_root()
    results = {
        "detected": [],
        "files": {},
        "recommended": None
    }

    # Check for package files
    package_files = [
        ("package.json", ["npm", "yarn", "pnpm"]),
        ("package-lock.json", ["npm"]),
        ("yarn.lock", ["yarn"]),
        ("pnpm-lock.yaml", ["pnpm"]),
        ("pyproject.toml", ["poetry", "pip"]),
        ("requirements.txt", ["pip"]),
        ("requirements-dev.txt", ["pip"]),
        ("Pipfile", ["pipenv"]),
        ("Pipfile.lock", ["pipenv"]),
        ("composer.json", ["composer"]),
        ("composer.lock", ["composer"]),
        ("go.mod", ["go"]),
        ("Cargo.toml", ["cargo"]),
        ("Cargo.lock", ["cargo"]),
        ("Gemfile", ["bundler"]),
        ("Gemfile.lock", ["bundler"]),
    ]

    for filename, managers in package_files:
        filepath = root / filename
        if filepath.exists():
            results["detected"].extend(managers)
            results["files"][filename] = managers

    # Remove duplicates and prioritize
    results["detected"] = list(dict.fromkeys(results["detected"]))

    # Recommend based on lock files
    if "package-lock.json" in results["files"]:
        results["recommended"] = "npm"
    elif "yarn.lock" in results["files"]:
        results["recommended"] = "yarn"
    elif "pnpm-lock.yaml" in results["files"]:
        results["recommended"] = "pnpm"
    elif "poetry.lock" in results["files"]:
        results["recommended"] = "poetry"
    elif "composer.lock" in results["files"]:
        results["recommended"] = "composer"
    elif "Cargo.lock" in results["files"]:
        results["recommended"] = "cargo"
    elif "Gemfile.lock" in results["files"]:
        results["recommended"] = "bundler"
    elif results["detected"]:
        results["recommended"] = results["detected"][0]

    return results

def check_npm_updates() -> List[Dict[str, Any]]:
    """Check for npm package updates."""
    try:
        # Run npm outdated
        result = subprocess.run(
            ["npm", "outdated", "--json"],
            capture_output=True,
            text=True,
            cwd=get_project_root()
        )

        if result.returncode == 0 and result.stdout.strip():
            data = json.loads(result.stdout)
            updates = []

            for package, info in data.items():
                current = info.get("current", "")
                latest = info.get("latest", "")
                wanted = info.get("wanted", latest)
                type_ = info.get("type", "dependencies")

                # Determine update type
                update_type = "unknown"
                if current and latest:
                    try:
                        cur_parts = current.split(".")
                        lat_parts = latest.split(".")
                        if len(cur_parts) >= 3 and len(lat_parts) >= 3:
                            if cur_parts[0] != lat_parts[0]:
                                update_type = "major"
                            elif cur_parts[1] != lat_parts[1]:
                                update_type = "minor"
                            else:
                                update_type = "patch"
                    except:
                        update_type = "unknown"

                updates.append({
                    "package": package,
                    "current": current,
                    "latest": latest,
                    "wanted": wanted,
                    "type": type_,
                    "update_type": update_type
                })

            return updates
    except (subprocess.SubprocessError, json.JSONDecodeError) as e:
        print(f"Error checking npm updates: {e}", file=sys.stderr)

    return []

def check_pip_updates() -> List[Dict[str, Any]]:
    """Check for pip package updates."""
    try:
        # Try to get outdated packages
        result = subprocess.run(
            [sys.executable, "-m", "pip", "list", "--outdated", "--format=json"],
            capture_output=True,
            text=True,
            cwd=get_project_root()
        )

        if result.returncode == 0 and result.stdout.strip():
            data = json.loads(result.stdout)
            updates = []

            for item in data:
                package = item.get("name", "")
                current = item.get("version", "")
                latest = item.get("latest_version", "")
                latest_filetype = item.get("latest_filetype", "")

                if package and current and latest:
                    # Try to determine update type
                    update_type = "unknown"
                    try:
                        cur_parts = current.split(".")
                        lat_parts = latest.split(".")
                        if len(cur_parts) >= 3 and len(lat_parts) >= 3:
                            if cur_parts[0] != lat_parts[0]:
                                update_type = "major"
                            elif cur_parts[1] != lat_parts[1]:
                                update_type = "minor"
                            else:
                                update_type = "patch"
                    except:
                        update_type = "unknown"

                    updates.append({
                        "package": package,
                        "current": current,
                        "latest": latest,
                        "latest_filetype": latest_filetype,
                        "update_type": update_type
                    })

            return updates
    except (subprocess.SubprocessError, json.JSONDecodeError) as e:
        print(f"Error checking pip updates: {e}", file=sys.stderr)

    return []

def check_composer_updates() -> List[Dict[str, Any]]:
    """Check for composer package updates."""
    try:
        result = subprocess.run(
            ["composer", "outdated", "--format=json", "--direct"],
            capture_output=True,
            text=True,
            cwd=get_project_root()
        )

        if result.returncode == 0 and result.stdout.strip():
            data = json.loads(result.stdout)
            updates = []

            # Composer output has 'installed' array
            installed = data.get("installed", [])
            for item in installed:
                package = item.get("name", "")
                current = item.get("version", "")
                latest = item.get("latest", "")
                latest_status = item.get("latest-status", "")

                if package and current and latest:
                    update_type = "unknown"
                    try:
                        # Remove non-numeric prefixes
                        cur_clean = current.lstrip("vV")
                        lat_clean = latest.lstrip("vV")
                        cur_parts = cur_clean.split(".")
                        lat_parts = lat_clean.split(".")
                        if len(cur_parts) >= 3 and len(lat_parts) >= 3:
                            if cur_parts[0] != lat_parts[0]:
                                update_type = "major"
                            elif cur_parts[1] != lat_parts[1]:
                                update_type = "minor"
                            else:
                                update_type = "patch"
                    except:
                        update_type = "unknown"

                    updates.append({
                        "package": package,
                        "current": current,
                        "latest": latest,
                        "latest_status": latest_status,
                        "update_type": update_type
                    })

            return updates
    except (subprocess.SubprocessError, json.JSONDecodeError) as e:
        print(f"Error checking composer updates: {e}", file=sys.stderr)

    return []

def generate_update_report(manager: str, updates: List[Dict[str, Any]]) -> str:
    """Generate a markdown report of available updates."""
    date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    report = f"""# Dependency Update Report — {date}

## Package Manager
**Detected**: {manager}

## Summary
- **Total dependencies checked**: {len(updates)}
- **Updates available**: {sum(1 for u in updates if u.get('latest') and u.get('current') != u.get('latest'))}
- **Patch updates**: {sum(1 for u in updates if u.get('update_type') == 'patch')}
- **Minor updates**: {sum(1 for u in updates if u.get('update_type') == 'minor')}
- **Major updates**: {sum(1 for u in updates if u.get('update_type') == 'major')}

## Available Updates
"""

    if not updates:
        report += "\nNo updates available or could not check.\n"
        return report

    # Group by update type
    patch_updates = [u for u in updates if u.get("update_type") == "patch"]
    minor_updates = [u for u in updates if u.get("update_type") == "minor"]
    major_updates = [u for u in updates if u.get("update_type") == "major"]
    unknown_updates = [u for u in updates if u.get("update_type") not in ["patch", "minor", "major"]]

    if patch_updates:
        report += "\n### Patch Updates (Recommended)\n\n"
        report += "| Package | Current | Latest |\n"
        report += "|---------|---------|--------|\n"
        for update in sorted(patch_updates, key=lambda x: x["package"]):
            report += f"| {update['package']} | {update['current']} | {update['latest']} |\n"

    if minor_updates:
        report += "\n### Minor Updates (Usually Safe)\n\n"
        report += "| Package | Current | Latest |\n"
        report += "|---------|---------|--------|\n"
        for update in sorted(minor_updates, key=lambda x: x["package"]):
            report += f"| {update['package']} | {update['current']} | {update['latest']} |\n"

    if major_updates:
        report += "\n### Major Updates (Require Review)\n\n"
        report += "| Package | Current | Latest | Note |\n"
        report += "|---------|---------|--------|------|\n"
        for update in sorted(major_updates, key=lambda x: x["package"]):
            report += f"| {update['package']} | {update['current']} | {update['latest']} | Breaking changes possible |\n"

    if unknown_updates:
        report += "\n### Other Updates\n\n"
        report += "| Package | Current | Latest |\n"
        report += "|---------|---------|--------|\n"
        for update in sorted(unknown_updates, key=lambda x: x["package"]):
            report += f"| {update['package']} | {update['current']} | {update['latest']} |\n"

    # Recommendations
    report += "\n## Recommendations\n\n"
    if patch_updates:
        report += "1. **Apply all patch updates** - These are backwards-compatible bug fixes\n"
    if minor_updates:
        report += "2. **Review minor updates** - New features, usually backwards-compatible\n"
    if major_updates:
        report += "3. **Carefully review major updates** - May contain breaking changes\n"

    report += f"\n## Next Steps\n\n"
    report += f"To apply updates:\n\n"

    if manager == "npm":
        report += "```bash\nnpm update\n# Or for specific packages:\nnpm update package-name\n```\n"
    elif manager == "yarn":
        report += "```bash\nyarn upgrade\n# Or for specific packages:\nyarn upgrade package-name\n```\n"
    elif manager == "pip":
        report += "```bash\npip install -U package-name\n# Update requirements.txt if using it\n```\n"
    elif manager == "composer":
        report += "```bash\ncomposer update\n# Or for specific packages:\ncomposer update vendor/package\n```\n"

    report += f"\n---\n*Generated by ai-dev-framework /dependency-update workflow*"

    return report

def save_report(report: str, filename: Optional[str] = None) -> Path:
    """Save the update report to a file."""
    if not filename:
        date = datetime.datetime.now().strftime("%Y-%m-%d")
        filename = f"dependency-update-{date}.md"

    docs_dir = get_project_root() / "docs"
    docs_dir.mkdir(exist_ok=True)

    report_path = docs_dir / filename
    report_path.write_text(report)

    return report_path

def main():
    """Main function for testing."""
    print("Dependency Helper Utility")
    print("=" * 50)

    # Detect package manager
    detection = detect_package_manager()
    print(f"Detected package managers: {', '.join(detection['detected']) if detection['detected'] else 'None'}")
    print(f"Recommended: {detection['recommended']}")
    print(f"Files found: {list(detection['files'].keys())}")

    if not detection["recommended"]:
        print("\nNo supported package manager detected.")
        print("Supported: npm, yarn, pip, poetry, composer, cargo, bundler")
        return

    # Check for updates based on detected manager
    updates = []
    manager = detection["recommended"]

    print(f"\nChecking for updates using {manager}...")

    if manager in ["npm", "yarn", "pnpm"]:
        updates = check_npm_updates()
    elif manager in ["pip", "poetry", "pipenv"]:
        updates = check_pip_updates()
    elif manager == "composer":
        updates = check_composer_updates()
    else:
        print(f"Update checking not yet implemented for {manager}")
        return

    print(f"Found {len(updates)} packages with update information")

    # Generate and save report
    report = generate_update_report(manager, updates)
    report_path = save_report(report)

    print(f"\nReport saved to: {report_path}")
    print("\nSummary of updates:")

    # Count by type
    patch = sum(1 for u in updates if u.get("update_type") == "patch")
    minor = sum(1 for u in updates if u.get("update_type") == "minor")
    major = sum(1 for u in updates if u.get("update_type") == "major")

    print(f"  Patch updates:  {patch}")
    print(f"  Minor updates:  {minor}")
    print(f"  Major updates:  {major}")

if __name__ == "__main__":
    main()