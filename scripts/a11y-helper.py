#!/usr/bin/env python3
"""
Accessibility audit helper for ai-dev-framework.
Helps with WCAG compliance checking and accessibility tool recommendations.
"""

import os
import sys
import json
import subprocess
import datetime
from pathlib import Path
from typing import Dict, List, Optional, Any

def get_project_root() -> Path:
    """Get the project root directory."""
    return Path.cwd()

def detect_web_framework() -> Dict[str, Any]:
    """Detect web framework for accessibility considerations."""
    root = get_project_root()
    results = {
        "framework": "unknown",
        "version": None,
        "a11y_libraries": [],
        "has_frontend": False,
        "html_files": [],
        "urls_to_test": []
    }

    # Check for frontend framework indicators
    framework_files = [
        ("package.json", ["react", "vue", "angular", "svelte", "generic"]),
        ("next.config.js", ["nextjs"]),
        ("next.config.ts", ["nextjs"]),
        ("nuxt.config.js", ["nuxt"]),
        ("nuxt.config.ts", ["nuxt"]),
        ("angular.json", ["angular"]),
        ("vue.config.js", ["vue"]),
        ("svelte.config.js", ["svelte"]),
        ("svelte.config.ts", ["svelte"]),
        ("gatsby-config.js", ["gatsby"]),
        ("remix.config.js", ["remix"]),
        ("astro.config.mjs", ["astro"]),
    ]

    # Find HTML files
    html_files = list(root.glob("*.html")) + list(root.glob("**/*.html"))
    results["html_files"] = [str(f.relative_to(root)) for f in html_files[:10]]  # Limit to 10

    # Check for frontend build output
    build_dirs = ["dist", "build", "public", "out", ".next"]
    for build_dir in build_dirs:
        if (root / build_dir).exists():
            results["has_frontend"] = True
            # Look for index.html in build dir
            index_html = root / build_dir / "index.html"
            if index_html.exists():
                results["urls_to_test"].append(f"file://{index_html.absolute()}")

    # Check package.json for frameworks
    package_json = root / "package.json"
    if package_json.exists():
        try:
            with open(package_json, 'r') as f:
                data = json.load(f)
                dependencies = data.get("dependencies", {})
                dev_dependencies = data.get("devDependencies", {})

                # Detect framework from dependencies
                if "react" in dependencies or "react" in dev_dependencies:
                    results["framework"] = "react"
                elif "vue" in dependencies or "vue" in dev_dependencies:
                    results["framework"] = "vue"
                elif "@angular/core" in dependencies or "@angular/core" in dev_dependencies:
                    results["framework"] = "angular"
                elif "svelte" in dependencies or "svelte" in dev_dependencies:
                    results["framework"] = "svelte"
                elif "next" in dependencies or "next" in dev_dependencies:
                    results["framework"] = "nextjs"
                elif "nuxt" in dependencies or "nuxt" in dev_dependencies:
                    results["framework"] = "nuxt"

                # Check for accessibility libraries
                a11y_libs = [
                    "eslint-plugin-jsx-a11y",  # React
                    "vue-axe",  # Vue
                    "angular-a11y",  # Angular
                    "@axe-core/react", "@axe-core/vue", "@axe-core/angular",
                    "pa11y", "axe-core", "lighthouse",
                    "storybook-addon-a11y", "cypress-axe"
                ]

                for lib in a11y_libs:
                    if lib in dependencies or lib in dev_dependencies:
                        results["a11y_libraries"].append(lib)

        except json.JSONDecodeError:
            pass

    # If we have HTML files but no framework detected, mark as static/vanilla
    if results["html_files"] and results["framework"] == "unknown":
        results["framework"] = "static"

    return results

def check_a11y_tools_installed() -> List[Dict[str, str]]:
    """Check which accessibility testing tools are installed."""
    tools = []

    # Check for globally installed tools
    tool_checks = [
        ("axe", "npx axe --version", "axe-core CLI"),
        ("pa11y", "npx pa11y --version", "Pa11y accessibility tool"),
        ("lighthouse", "npx lighthouse --version", "Lighthouse (Google)"),
        ("wave", "", "WAVE evaluation tool (browser extension)"),
    ]

    for tool_name, version_cmd, description in tool_checks:
        if version_cmd:
            try:
                result = subprocess.run(
                    version_cmd,
                    shell=True,
                    capture_output=True,
                    text=True,
                    timeout=5
                )
                if result.returncode == 0:
                    tools.append({
                        "tool": tool_name,
                        "installed": True,
                        "description": description
                    })
                else:
                    tools.append({
                        "tool": tool_name,
                        "installed": False,
                        "description": description
                    })
            except (subprocess.SubprocessError, subprocess.TimeoutExpired):
                tools.append({
                    "tool": tool_name,
                    "installed": False,
                    "description": description
                })
        else:
            # Browser extensions can't be checked via CLI
            tools.append({
                "tool": tool_name,
                "installed": "browser_extension",
                "description": description
            })

    return tools

def generate_wcag_checklist() -> Dict[str, List[Dict[str, Any]]]:
    """Generate a WCAG 2.1 checklist."""
    wcag = {
        "level_a": [],
        "level_aa": [],
        "level_aaa": []
    }

    # WCAG 2.1 Level A (basic)
    wcag["level_a"] = [
        {"id": "1.1.1", "title": "Non-text Content", "description": "Provide text alternatives for non-text content"},
        {"id": "1.2.1", "title": "Audio-only and Video-only", "description": "Provide alternatives for time-based media"},
        {"id": "1.3.1", "title": "Info and Relationships", "description": "Information, structure, and relationships can be programmatically determined"},
        {"id": "1.3.2", "title": "Meaningful Sequence", "description": "Present content in a meaningful order"},
        {"id": "1.4.1", "title": "Use of Color", "description": "Color is not used as the only visual means of conveying information"},
        {"id": "1.4.2", "title": "Audio Control", "description": "Provide control for audio that plays automatically"},
        {"id": "2.1.1", "title": "Keyboard", "description": "All functionality operable through a keyboard interface"},
        {"id": "2.1.2", "title": "No Keyboard Trap", "description": "Keyboard focus not trapped in any component"},
        {"id": "2.2.1", "title": "Timing Adjustable", "description": "Allow users to adjust time limits"},
        {"id": "2.2.2", "title": "Pause, Stop, Hide", "description": "Provide controls for moving, blinking, or updating content"},
        {"id": "2.3.1", "title": "Three Flashes or Below", "description": "No content flashes more than three times per second"},
        {"id": "2.4.1", "title": "Bypass Blocks", "description": "Provide skip links to bypass repetitive content"},
        {"id": "2.4.2", "title": "Page Titled", "description": "Web pages have descriptive titles"},
        {"id": "2.4.3", "title": "Focus Order", "description": "Logical tab order"},
        {"id": "2.4.4", "title": "Link Purpose", "description": "Link purpose clear from link text alone"},
        {"id": "3.1.1", "title": "Language of Page", "description": "Default language programmatically determinable"},
        {"id": "3.2.1", "title": "On Focus", "description": "No unexpected change of context on focus"},
        {"id": "3.2.2", "title": "On Input", "description": "No unexpected change of context on input"},
        {"id": "3.3.1", "title": "Error Identification", "description": "Errors identified and described to user"},
        {"id": "3.3.2", "title": "Labels or Instructions", "description": "Labels or instructions provided"},
        {"id": "4.1.1", "title": "Parsing", "description": "Markup validated and well-formed"},
        {"id": "4.1.2", "title": "Name, Role, Value", "description": "Name, role, value programmatically determinable"},
    ]

    # WCAG 2.1 Level AA (recommended)
    wcag["level_aa"] = [
        {"id": "1.2.4", "title": "Captions (Live)", "description": "Provide captions for live audio"},
        {"id": "1.2.5", "title": "Audio Description", "description": "Audio description for video"},
        {"id": "1.3.4", "title": "Orientation", "description": "Content not restricted to portrait/landscape"},
        {"id": "1.3.5", "title": "Identify Input Purpose", "description": "Input purpose programmatically determinable"},
        {"id": "1.4.3", "title": "Contrast (Minimum)", "description": "Contrast ratio at least 4.5:1 (normal text)"},
        {"id": "1.4.4", "title": "Resize Text", "description": "Text resizeable up to 200% without assistive tech"},
        {"id": "1.4.5", "title": "Images of Text", "description": "Use text instead of images of text"},
        {"id": "1.4.10", "title": "Reflow", "description": "Content reflows without loss at 320px width"},
        {"id": "1.4.11", "title": "Non-text Contrast", "description": "Contrast for UI components and graphics"},
        {"id": "1.4.12", "title": "Text Spacing", "description": "Text spacing adjustable"},
        {"id": "1.4.13", "title": "Content on Hover or Focus", "description": "Content revealable and dismissable"},
        {"id": "2.4.5", "title": "Multiple Ways", "description": "Multiple ways to locate pages"},
        {"id": "2.4.6", "title": "Headings and Labels", "description": "Headings and labels descriptive"},
        {"id": "2.4.7", "title": "Focus Visible", "description": "Keyboard focus visible"},
        {"id": "3.1.2", "title": "Language of Parts", "description": "Language changes programmatically determinable"},
        {"id": "3.2.3", "title": "Consistent Navigation", "description": "Navigation consistent across pages"},
        {"id": "3.2.4", "title": "Consistent Identification", "description": "Components identified consistently"},
        {"id": "3.3.3", "title": "Error Suggestion", "description": "Suggest corrections for errors"},
        {"id": "3.3.4", "title": "Error Prevention (Legal)", "description": "Legal/financial transactions reversible"},
    ]

    # WCAG 2.1 Level AAA (enhanced)
    wcag["level_aaa"] = [
        {"id": "1.2.6", "title": "Sign Language", "description": "Sign language interpretation for audio"},
        {"id": "1.2.7", "title": "Extended Audio Description", "description": "Extended audio description for video"},
        {"id": "1.2.8", "title": "Media Alternative", "description": "Text alternative for time-based media"},
        {"id": "1.2.9", "title": "Audio-only (Live)", "description": "Alternative for live audio-only"},
        {"id": "1.4.6", "title": "Contrast (Enhanced)", "description": "Contrast ratio at least 7:1 (normal text)"},
        {"id": "1.4.7", "title": "Low or No Background Audio", "description": "Background audio quiet or optional"},
        {"id": "1.4.8", "title": "Visual Presentation", "description": "User control over text presentation"},
        {"id": "1.4.9", "title": "Images of Text (No Exception)", "description": "No images of text unless essential"},
        {"id": "2.1.3", "title": "Keyboard (No Exception)", "description": "All functionality keyboard operable"},
        {"id": "2.2.3", "title": "No Timing", "description": "No time limits (with exceptions)"},
        {"id": "2.2.4", "title": "Interruptions", "description": "Allow postponement of interruptions"},
        {"id": "2.2.5", "title": "Re-authenticating", "description": "Preserve data after re-authentication"},
        {"id": "2.3.2", "title": "Three Flashes", "description": "No content flashes three times per second"},
        {"id": "2.4.8", "title": "Location", "description": "User's location within set of pages"},
        {"id": "2.4.9", "title": "Link Purpose (Link Only)", "description": "Link purpose clear from link text"},
        {"id": "2.4.10", "title": "Section Headings", "description": "Section headings used to organize"},
        {"id": "3.1.3", "title": "Unusual Words", "description": "Definitions for unusual words/phrases"},
        {"id": "3.1.4", "title": "Abbreviations", "description": "Expansion/explanation of abbreviations"},
        {"id": "3.1.5", "title": "Reading Level", "description": "Content readable by lower secondary education"},
        {"id": "3.1.6", "title": "Pronunciation", "description": "Pronunciation of unusual words indicated"},
        {"id": "3.2.5", "title": "Change on Request", "description": "Changes of context only on user request"},
        {"id": "3.3.5", "title": "Help", "description": "Context-sensitive help available"},
        {"id": "3.3.6", "title": "Error Prevention (All)", "description": "All submissions reversible/checked"},
    ]

    return wcag

def generate_disability_checklist() -> Dict[str, List[str]]:
    """Generate a disability-specific accessibility checklist."""
    checklist = {
        "visual_impairments": [
            "Screen reader compatibility tested with NVDA/JAWS",
            "Screen magnifier compatibility (up to 400%)",
            "High contrast mode compatibility",
            "Color blindness simulation (protanopia, deuteranopia, tritanopia)",
            "Text resize to 200% without horizontal scrolling",
            "No information conveyed by color alone",
            "Sufficient color contrast (4.5:1 for normal text)",
            "Text alternatives for images, icons, and graphics",
            "Proper heading hierarchy (h1-h6)",
            "Descriptive link text (avoid 'click here')"
        ],
        "motor_impairments": [
            "Full keyboard navigation possible",
            "No keyboard traps",
            "Visible focus indicators for all interactive elements",
            "Sufficient target sizes (minimum 44×44px)",
            "Adequate time limits or ability to extend",
            "Voice control compatibility testing",
            "Switch access compatibility",
            "Avoidance of complex gestures as only input method",
            "Error recovery without fine motor control"
        ],
        "cognitive_impairments": [
            "Clear, simple language used",
            "Consistent navigation patterns",
            "Predictable interactions",
            "Error prevention and clear recovery paths",
            "No distracting animations/flashing content",
            "Clear labeling of forms and controls",
            "Progressive disclosure of complex information",
            "Memory aids for multi-step processes",
            "Clear instructions and help text"
        ],
        "hearing_impairments": [
            "Captions provided for all video content",
            "Transcripts provided for audio content",
            "Visual alternatives to audio cues/alerts",
            "No essential information in audio-only format",
            "Volume controls for media players",
            "Sign language interpretation for important content"
        ]
    }

    return checklist

def generate_a11y_audit_template(project_info: Dict[str, Any]) -> str:
    """Generate an accessibility audit template."""
    date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    template = f"""# Accessibility Audit Report — {date}

## Project Information
- **Framework**: {project_info['framework']}
- **Has frontend**: {project_info['has_frontend']}
- **HTML files found**: {len(project_info['html_files'])}
- **URLs to test**: {', '.join(project_info['urls_to_test'][:3])}
- **Accessibility libraries**: {', '.join(project_info['a11y_libraries'])}

## Recommended Testing Tools

### Automated Testing
1. **axe-core** - Comprehensive accessibility testing
   ```bash
   npx axe <url> --save accessibility-report.json
   ```

2. **Lighthouse** - Built into Chrome DevTools
   ```bash
   npx lighthouse <url> --output=json --only-categories=accessibility
   ```

3. **Pa11y** - CLI and dashboard tools
   ```bash
   npx pa11y <url> --reporter json
   ```

### Manual Testing Tools
1. **Screen Readers**: NVDA (Windows), VoiceOver (macOS), JAWS
2. **Color Contrast**: Color Contrast Analyzer (Chrome extension)
3. **Keyboard Testing**: Tab through entire interface
4. **Zoom Testing**: 200% zoom without horizontal scroll

## WCAG 2.1 Compliance Checklist

### Level A (Basic Accessibility) - MUST FIX
"""

    wcag = generate_wcag_checklist()
    for item in wcag["level_a"][:10]:  # Show first 10
        template += f"- [ ] **{item['id']}** {item['title']}: {item['description']}\n"

    template += """
### Level AA (Recommended) - SHOULD FIX
"""

    for item in wcag["level_aa"][:10]:  # Show first 10
        template += f"- [ ] **{item['id']}** {item['title']}: {item['description']}\n"

    template += """
## Disability-Specific Testing Checklist
"""

    disability_checklist = generate_disability_checklist()
    for disability, items in disability_checklist.items():
        disability_name = disability.replace("_", " ").title()
        template += f"\n### {disability_name}\n"
        for item in items[:5]:  # Show first 5 per category
            template += f"- [ ] {item}\n"

    template += """
## Common Accessibility Issues to Check

### Critical Issues (Blocking)
1. **Missing alternative text** for informative images
2. **Empty links and buttons** with no accessible name
3. **Missing form labels** for input fields
4. **Low contrast text** that's difficult to read
5. **Keyboard traps** that prevent navigation

### High Priority Issues
1. **Poor heading structure** (skipping levels h1 → h3)
2. **Insufficient color contrast** for non-text elements
3. **Missing ARIA labels** for custom components
4. **Inaccessible error messages**
5. **Inconsistent navigation**

### Framework-Specific Issues
"""

    framework = project_info["framework"]
    if framework == "react":
        template += """1. **Missing `alt` text** on `<img>` tags
2. **Non-semantic HTML** (using `<div>` for everything)
3. **Missing `key` props** affecting screen reader announcements
4. **Improper use of ARIA** (aria-hidden, aria-label misuse)
5. **Dynamic content updates** without proper announcements
"""
    elif framework == "vue":
        template += """1. **`v-bind` without accessibility attributes**
2. **Event handlers without keyboard support**
3. **Dynamic components without proper labeling**
4. **Transition effects that interfere with focus**
"""
    elif framework == "angular":
        template += """1. **Angular Material accessibility issues**
2. **Router focus management**
3. **Form validation accessibility**
4. **Dynamic template rendering**
"""
    else:
        template += "1. **Semantic HTML structure**\n2. **Proper form labeling**\n3. **Keyboard navigation**\n4. **Color contrast compliance**\n"

    template += """
## Testing Procedure

### 1. Automated Testing
- Run axe-core on all major pages
- Check Lighthouse accessibility scores
- Validate HTML with W3C validator

### 2. Manual Testing
- Navigate entire site using only keyboard
- Test with screen reader (NVDA/VoiceOver)
- Check color contrast of all text
- Verify form accessibility

### 3. User Testing
- Include users with disabilities if possible
- Test with different assistive technologies
- Gather feedback on navigation and comprehension

## Report Template

### Findings Summary
- **Total issues found**: [number]
- **Critical issues**: [number]
- **WCAG Level A compliance**: [X/Y criteria met]
- **WCAG Level AA compliance**: [X/Y criteria met]

### Detailed Issues
| Issue | Location | WCAG Criteria | Severity | Recommendation |
|-------|----------|---------------|----------|----------------|
| Example | homepage.html | 1.1.1 | Critical | Add alt text to logo |
| ... | ... | ... | ... | ... |

### Action Plan
1. **Immediate (this week)**: Fix critical issues
2. **Short-term (1-2 weeks)**: Address high priority issues
3. **Medium-term (1 month)**: Achieve WCAG Level A compliance
4. **Long-term (3 months)**: Achieve WCAG Level AA compliance

---

*Generated by ai-dev-framework /accessibility-audit workflow*
*Template for conducting comprehensive accessibility audit*
"""

    return template

def save_template(template: str, filename: Optional[str] = None) -> Path:
    """Save the audit template to a file."""
    if not filename:
        date = datetime.datetime.now().strftime("%Y-%m-%d")
        filename = f"accessibility-audit-template-{date}.md"

    docs_dir = get_project_root() / "docs"
    docs_dir.mkdir(exist_ok=True)

    template_path = docs_dir / filename
    template_path.write_text(template)

    return template_path

def main():
    """Main function for testing."""
    print("Accessibility Audit Helper")
    print("=" * 50)

    # Detect project framework
    project_info = detect_web_framework()
    print(f"Framework: {project_info['framework']}")
    print(f"Has frontend: {project_info['has_frontend']}")
    print(f"HTML files: {len(project_info['html_files'])}")
    print(f"A11y libraries: {', '.join(project_info['a11y_libraries'])}")

    # Check installed tools
    tools = check_a11y_tools_installed()
    installed_tools = [t["tool"] for t in tools if t["installed"]]
    print(f"Installed a11y tools: {', '.join(installed_tools)}")

    # Generate and save template
    template = generate_a11y_audit_template(project_info)
    template_path = save_template(template)

    print(f"\nAccessibility audit template saved to: {template_path}")

    # Show WCAG summary
    wcag = generate_wcag_checklist()
    print(f"\nWCAG checklist items:")
    print(f"  Level A: {len(wcag['level_a'])} criteria")
    print(f"  Level AA: {len(wcag['level_aa'])} criteria")
    print(f"  Level AAA: {len(wcag['level_aaa'])} criteria")

    # Show disability checklist summary
    disability_checklist = generate_disability_checklist()
    print(f"\nDisability-specific checks:")
    for disability, items in disability_checklist.items():
        disability_name = disability.replace("_", " ").title()
        print(f"  {disability_name}: {len(items)} items")

    print(f"\nNext steps:")
    print(f"  1. Review the template at: {template_path}")
    print(f"  2. Install recommended tools if missing")
    print(f"  3. Begin with automated testing using axe-core")
    print(f"  4. Follow up with manual testing checklist")

if __name__ == "__main__":
    main()