#!/usr/bin/env python3
"""
Performance audit helper for ai-dev-framework.
Helps identify performance tools and metrics for different project types.
"""

import os
import sys
import json
import subprocess
import datetime
import shutil
from pathlib import Path
from typing import Dict, List, Optional, Any

def get_project_root() -> Path:
    """Get the project root directory."""
    return Path.cwd()

def detect_project_type() -> Dict[str, Any]:
    """Detect project type for performance analysis."""
    root = get_project_root()
    results = {
        "type": "unknown",
        "subtype": None,
        "indicators": [],
        "tools_available": [],
        "tools_recommended": []
    }

    # Frontend indicators
    frontend_files = [
        "package.json",  # Node.js project
        "vite.config.js", "vite.config.ts",  # Vite
        "webpack.config.js", "webpack.config.ts",  # Webpack
        "next.config.js", "next.config.ts",  # Next.js
        "nuxt.config.js", "nuxt.config.ts",  # Nuxt
        "angular.json",  # Angular
        "vue.config.js",  # Vue
        "index.html",  # HTML entry point
    ]

    # Backend/API indicators
    backend_files = [
        "package.json",  # Node.js backend
        "pyproject.toml", "requirements.txt",  # Python
        "composer.json",  # PHP
        "go.mod",  # Go
        "Cargo.toml",  # Rust
        "build.gradle", "build.gradle.kts",  # Java/Kotlin
        "project.clj", "deps.edn",  # Clojure
    ]

    # CLI tool indicators
    cli_indicators = [
        "bin/",  # Binary directory
        "src/cli", "src/bin",  # CLI source
        "cmd/",  # Go CLI pattern
        "Cargo.toml",  # Rust CLI
    ]

    # Check for frontend files
    frontend_count = 0
    for filename in frontend_files:
        if (root / filename).exists():
            frontend_count += 1
            results["indicators"].append(f"frontend:{filename}")

    # Check for backend files
    backend_count = 0
    for filename in backend_files:
        if (root / filename).exists():
            backend_count += 1
            results["indicators"].append(f"backend:{filename}")

    # Check for CLI indicators
    cli_count = 0
    for indicator in cli_indicators:
        indicator_path = root / indicator
        if indicator_path.exists():
            cli_count += 1
            results["indicators"].append(f"cli:{indicator}")

    # Determine project type
    if frontend_count > 0 and backend_count == 0:
        results["type"] = "frontend"
        # Try to detect framework
        if (root / "next.config.js").exists() or (root / "next.config.ts").exists():
            results["subtype"] = "nextjs"
        elif (root / "nuxt.config.js").exists() or (root / "nuxt.config.ts").exists():
            results["subtype"] = "nuxt"
        elif (root / "angular.json").exists():
            results["subtype"] = "angular"
        elif (root / "vue.config.js").exists():
            results["subtype"] = "vue"
        elif (root / "vite.config.js").exists() or (root / "vite.config.ts").exists():
            results["subtype"] = "vite"
        elif (root / "webpack.config.js").exists() or (root / "webpack.config.ts").exists():
            results["subtype"] = "webpack"
        else:
            results["subtype"] = "generic-frontend"

    elif backend_count > 0 and frontend_count == 0:
        results["type"] = "backend"
        # Detect language/framework
        if (root / "package.json").exists():
            results["subtype"] = "nodejs"
        elif (root / "pyproject.toml").exists() or (root / "requirements.txt").exists():
            results["subtype"] = "python"
        elif (root / "composer.json").exists():
            results["subtype"] = "php"
        elif (root / "go.mod").exists():
            results["subtype"] = "go"
        elif (root / "Cargo.toml").exists():
            results["subtype"] = "rust"
        else:
            results["subtype"] = "generic-backend"

    elif frontend_count > 0 and backend_count > 0:
        results["type"] = "fullstack"
        results["subtype"] = "mixed"

    elif cli_count > 0:
        results["type"] = "cli"
        results["subtype"] = "command-line-tool"

    else:
        results["type"] = "unknown"
        results["subtype"] = "generic"

    # Check for available performance tools
    results["tools_available"] = check_available_tools(results["type"])
    results["tools_recommended"] = recommend_tools(results["type"], results["subtype"])

    return results

def check_available_tools(project_type: str) -> List[str]:
    """Check which performance tools are available."""
    available = []

    # General tools
    if shutil.which("node"):
        available.append("node")
    if shutil.which("python3") or shutil.which("python"):
        available.append("python")

    # Web performance tools
    if project_type in ["frontend", "fullstack"]:
        if shutil.which("lighthouse"):
            available.append("lighthouse")
        # Check for npm packages that might be installed
        root = get_project_root()
        if (root / "node_modules").exists():
            # Common performance-related packages
            perf_packages = [
                "webpack-bundle-analyzer",
                "source-map-explorer",
                "lighthouse-ci",
                "speed-measure-webpack-plugin",
            ]
            for package in perf_packages:
                if (root / "node_modules" / package).exists():
                    available.append(package)

    # Backend/CLI profiling tools
    if project_type in ["backend", "cli", "fullstack"]:
        if shutil.which("perf"):
            available.append("perf")
        if shutil.which("valgrind"):
            available.append("valgrind")
        if shutil.which("time"):
            available.append("time")

    return available

def recommend_tools(project_type: str, subtype: Optional[str] = None) -> List[Dict[str, str]]:
    """Recommend performance tools based on project type."""
    recommendations = []

    if project_type == "frontend":
        recommendations.extend([
            {
                "tool": "Lighthouse",
                "purpose": "Core Web Vitals, performance scoring",
                "command": "npx lighthouse <url> --output=json --output-path=report.json",
                "install": "npm install -g lighthouse"
            },
            {
                "tool": "Webpack Bundle Analyzer",
                "purpose": "Bundle size analysis",
                "command": "npx webpack-bundle-analyzer stats.json",
                "install": "npm install --save-dev webpack-bundle-analyzer"
            },
            {
                "tool": "Source Map Explorer",
                "purpose": "Visualize bundle composition",
                "command": "npx source-map-explorer 'dist/*.js'",
                "install": "npm install --save-dev source-map-explorer"
            }
        ])

        if subtype == "nextjs":
            recommendations.append({
                "tool": "Next.js Analytics",
                "purpose": "Real Core Web Vitals from production",
                "command": "Enable in next.config.js",
                "install": "Built into Next.js"
            })

    elif project_type == "backend":
        recommendations.extend([
            {
                "tool": "k6",
                "purpose": "Load testing",
                "command": "k6 run script.js",
                "install": "brew install k6 or see k6.io"
            },
            {
                "tool": "autocannon",
                "purpose": "HTTP benchmarking",
                "command": "npx autocannon -c 100 -d 30 <url>",
                "install": "npm install -g autocannon"
            }
        ])

        if subtype == "nodejs":
            recommendations.append({
                "tool": "clinic.js",
                "purpose": "Node.js performance profiling",
                "command": "npx clinic doctor -- node server.js",
                "install": "npm install -g clinic"
            })
        elif subtype == "python":
            recommendations.append({
                "tool": "cProfile",
                "purpose": "Python profiling",
                "command": "python -m cProfile -o profile.stats script.py",
                "install": "Built into Python"
            })

    elif project_type == "cli":
        recommendations.extend([
            {
                "tool": "hyperfine",
                "purpose": "Benchmarking CLI tools",
                "command": "hyperfine './my-cli --version'",
                "install": "brew install hyperfine or cargo install hyperfine"
            },
            {
                "tool": "time",
                "purpose": "Execution time measurement",
                "command": "time ./my-cli",
                "install": "Built into Unix systems"
            }
        ])

    # General recommendations for all types
    recommendations.extend([
        {
            "tool": "Chrome DevTools",
            "purpose": "Profiling, memory analysis, network inspection",
            "command": "Open Chrome → F12 → Performance/Memory tabs",
            "install": "Built into Chrome"
        },
        {
            "tool": "System monitoring",
            "purpose": "CPU, memory, disk I/O",
            "command": "htop, atop, or OS-specific tools",
            "install": "System package manager"
        }
    ])

    return recommendations

def generate_perf_checklist(project_type: str, subtype: Optional[str] = None) -> Dict[str, List[str]]:
    """Generate a performance checklist for the project type."""
    checklist = {
        "critical": [],
        "high": [],
        "medium": [],
        "low": []
    }

    if project_type in ["frontend", "fullstack"]:
        checklist["critical"].extend([
            "Measure Core Web Vitals (LCP, FID, CLS)",
            "Check bundle size (main bundle < 250KB)",
            "Ensure images are properly optimized"
        ])
        checklist["high"].extend([
            "Implement code splitting",
            "Enable compression (gzip/brotli)",
            "Setup caching headers"
        ])
        checklist["medium"].extend([
            "Minify CSS/JS",
            "Remove unused CSS/JS",
            "Optimize font loading"
        ])

    if project_type in ["backend", "fullstack"]:
        checklist["critical"].extend([
            "Monitor response time percentiles (p95, p99)",
            "Check for memory leaks",
            "Ensure database queries are indexed"
        ])
        checklist["high"].extend([
            "Implement caching for expensive operations",
            "Use connection pooling",
            "Monitor error rates"
        ])
        checklist["medium"].extend([
            "Optimize serialization/deserialization",
            "Batch operations where possible",
            "Use async processing for non-critical tasks"
        ])

    if project_type == "cli":
        checklist["critical"].extend([
            "Measure execution time for common operations",
            "Check memory usage patterns",
            "Profile startup time"
        ])
        checklist["high"].extend([
            "Optimize I/O operations",
            "Implement progress indicators for long operations",
            "Add --help with performance tips"
        ])

    # General performance checklist
    checklist["low"].extend([
        "Remove console.log in production",
        "Optimize regular expressions",
        "Use appropriate data structures",
        "Avoid synchronous operations in hot paths"
    ])

    return checklist

def generate_audit_template(project_info: Dict[str, Any]) -> str:
    """Generate a performance audit report template."""
    date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    template = f"""# Performance Audit Report — {date}

## Project Information
- **Type**: {project_info['type']}
- **Subtype**: {project_info.get('subtype', 'N/A')}
- **Detected indicators**: {', '.join(project_info['indicators'][:5])}

## Available Tools
{', '.join(project_info['tools_available']) if project_info['tools_available'] else 'No specific performance tools detected'}

## Recommended Tools
"""

    for tool in project_info['tools_recommended']:
        template += f"\n### {tool['tool']}"
        template += f"\n**Purpose**: {tool['purpose']}"
        template += f"\n**Command**: `{tool['command']}`"
        if tool.get('install'):
            template += f"\n**Install**: {tool['install']}"
        template += "\n"

    ## Performance Checklist
    checklist = generate_perf_checklist(project_info['type'], project_info.get('subtype'))

    template += "\n## Performance Checklist\n"

    for priority, items in checklist.items():
        if items:
            template += f"\n### {priority.title()} Priority\n"
            for item in items:
                template += f"- [ ] {item}\n"

    ## Metrics to Collect
    template += "\n## Metrics to Collect\n"

    if project_info['type'] in ["frontend", "fullstack"]:
        template += """
### Web Performance
- [ ] Largest Contentful Paint (LCP) — should be < 2.5s
- [ ] First Input Delay (FID) — should be < 100ms
- [ ] Cumulative Layout Shift (CLS) — should be < 0.1
- [ ] Total bundle size — main bundle < 250KB
- [ ] Time to Interactive (TTI)
- [ ] First Contentful Paint (FCP)
"""

    if project_info['type'] in ["backend", "fullstack"]:
        template += """
### API Performance
- [ ] Average response time — target < 200ms
- [ ] 95th percentile response time — target < 500ms
- [ ] Error rate — target < 1%
- [ ] Requests per second
- [ ] Database query performance
- [ ] Memory usage over time
"""

    if project_info['type'] == "cli":
        template += """
### CLI Performance
- [ ] Execution time for common operations
- [ ] Peak memory usage
- [ ] Startup time
- [ ] I/O throughput
- [ ] CPU usage profile
"""

    ## Action Plan
    template += """
## Action Plan

### Immediate (1-2 days)
1. Run initial performance tests with recommended tools
2. Identify critical bottlenecks
3. Document baseline metrics

### Short Term (1-2 weeks)
1. Implement high-priority optimizations
2. Set up performance monitoring
3. Run A/B tests for optimization impact

### Long Term (1-3 months)
1. Architectural improvements if needed
2. Continuous performance monitoring
3. Performance regression testing in CI

---

*Generated by ai-dev-framework /perf-audit workflow*
*Use this template to guide your performance audit*
"""

    return template

def save_template(template: str, filename: Optional[str] = None) -> Path:
    """Save the audit template to a file."""
    if not filename:
        date = datetime.datetime.now().strftime("%Y-%m-%d")
        filename = f"performance-audit-template-{date}.md"

    docs_dir = get_project_root() / "docs"
    docs_dir.mkdir(exist_ok=True)

    template_path = docs_dir / filename
    template_path.write_text(template)

    return template_path

def main():
    """Main function for testing."""
    print("Performance Audit Helper")
    print("=" * 50)

    # Detect project type
    project_info = detect_project_type()
    print(f"Project type: {project_info['type']}")
    print(f"Subtype: {project_info.get('subtype', 'N/A')}")
    print(f"Indicators: {', '.join(project_info['indicators'][:3])}...")
    print(f"Tools available: {', '.join(project_info['tools_available'])}")

    # Generate and save template
    template = generate_audit_template(project_info)
    template_path = save_template(template)

    print(f"\nPerformance audit template saved to: {template_path}")

    # Show checklist summary
    checklist = generate_perf_checklist(project_info['type'], project_info.get('subtype'))
    print("\nChecklist summary:")
    for priority in ["critical", "high", "medium", "low"]:
        items = checklist[priority]
        if items:
            print(f"  {priority.title()}: {len(items)} items")

    print(f"\nRecommended tools: {len(project_info['tools_recommended'])}")
    for tool in project_info['tools_recommended'][:3]:
        print(f"  - {tool['tool']}: {tool['purpose']}")

if __name__ == "__main__":
    main()