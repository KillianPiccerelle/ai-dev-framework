---
name: accessibility-audit
description: WCAG accessibility audit workflow for web applications.
---

# Workflow: accessibility audit

Audits web applications for WCAG compliance, tests for different disabilities, and provides actionable accessibility improvements.

## Step 1 — Determine audit scope (orchestrator)
1. Check if project has frontend components
2. Identify main user interfaces to audit
3. Determine WCAG compliance target (A, AA, AAA)
4. Check for existing accessibility documentation

## Step 2 — Automated accessibility testing (agent: frontend-dev)
Run automated accessibility tools:

### Primary tools:
1. **axe-core** (via browser DevTools or CLI)
2. **Lighthouse accessibility audit**
3. **WAVE evaluation tool** (if URL available)
4. **HTML CodeSniffer** (if static HTML)

### Commands to run:
```bash
# If using axe-core CLI
npx axe <url> --save <report>.json

# Lighthouse accessibility audit
npx lighthouse <url> --output=json --only-categories=accessibility

# Pa11y for multiple pages
npx pa11y <url> --reporter json
```

## Step 3 — Manual accessibility review (agent: qa-engineer)
Manual checks that automated tools often miss:

### Keyboard navigation:
1. Tab order logical and intuitive
2. All interactive elements reachable via keyboard
3. Visible focus indicators
4. No keyboard traps

### Screen reader testing:
1. Semantic HTML structure
2. Proper ARIA labels and roles
3. Heading hierarchy (h1-h6)
4. Landmark regions (header, main, nav, footer)

### Visual considerations:
1. Color contrast ratio (4.5:1 for normal text)
2. Text resize without breaking layout
3. No information conveyed by color alone
4. Text alternatives for non-text content

## Step 4 — WCAG compliance checking (orchestrator)
Check against WCAG 2.1/2.2 guidelines:

### Level A (basic accessibility):
- [ ] 1.1.1 Non-text content
- [ ] 1.3.1 Info and relationships
- [ ] 1.3.2 Meaningful sequence
- [ ] 1.4.1 Use of color
- [ ] 2.1.1 Keyboard
- [ ] 2.4.1 Bypass blocks
- [ ] 2.4.2 Page titled
- [ ] 3.1.1 Language of page

### Level AA (better accessibility - recommended):
- [ ] 1.2.4 Captions (live)
- [ ] 1.3.4 Orientation
- [ ] 1.3.5 Identify input purpose
- [ ] 1.4.3 Contrast (minimum)
- [ ] 1.4.4 Resize text
- [ ] 1.4.5 Images of text
- [ ] 2.4.5 Multiple ways
- [ ] 2.4.6 Headings and labels
- [ ] 2.4.7 Focus visible
- [ ] 3.1.2 Language of parts
- [ ] 3.2.3 Consistent navigation
- [ ] 3.2.4 Consistent identification
- [ ] 3.3.2 Labels or instructions
- [ ] 4.1.2 Name, role, value

### Level AAA (enhanced accessibility):
- [ ] 1.2.6 Sign language
- [ ] 1.4.6 Contrast (enhanced)
- [ ] 1.4.8 Visual presentation
- [ ] 1.4.9 Images of text (no exception)
- [ ] 2.1.3 Keyboard (no exception)
- [ ] 2.2.3 No timing
- [ ] 2.3.2 Three flashes
- [ ] 2.4.8 Location
- [ ] 2.4.9 Link purpose (link only)
- [ ] 3.1.3 Unusual words
- [ ] 3.1.4 Abbreviations
- [ ] 3.1.5 Reading level
- [ ] 3.1.6 Pronunciation
- [ ] 3.2.5 Change on request
- [ ] 3.3.5 Help
- [ ] 4.1.3 Status messages

## Step 5 — Disability-specific testing (agent: security-reviewer)
Test for specific disability categories:

### Visual impairments:
1. Screen magnifier compatibility
2. High contrast mode
3. Reduced motion preferences
4. Color blindness simulation

### Motor impairments:
1. Voice control compatibility
2. Switch access compatibility
3. Sufficient target sizes (min 44×44px)
4. Adequate time limits

### Cognitive impairments:
1. Clear, simple language
2. Consistent navigation patterns
3. Predictable interactions
4. Error prevention and recovery

### Hearing impairments:
1. Captions for audio/video
2. Visual alternatives to audio cues
3. Transcripts for audio content

## Step 6 — Generate accessibility report (agent: doc-writer)
Create `docs/accessibility-audit-YYYY-MM-DD.md` with:

### Executive summary
- Overall accessibility score
- WCAG compliance level achieved
- Critical issues summary

### Automated test results
- Tools used and versions
- Number of violations found
- Violations by severity (critical, serious, moderate, minor)

### Manual review findings
-- Keyboard accessibility issues
- Screen reader compatibility
- Color contrast violations
- Semantic HTML issues

### WCAG compliance matrix
- Level A: X/Y passed
- Level AA: X/Y passed  
- Level AAA: X/Y passed
- Priority 1 (must fix) issues
- Priority 2 (should fix) issues
- Priority 3 (could fix) issues

### Disability-specific findings
- Visual impairment compatibility
- Motor impairment compatibility  
- Cognitive impairment compatibility
- Hearing impairment compatibility

### Actionable recommendations
1. **Immediate fixes** (blocking accessibility)
2. **Short-term improvements** (1-2 weeks)
3. **Long-term enhancements** (1-3 months)
4. **Testing procedures** to implement

## Step 7 — Create remediation plan (orchestrator)
Prioritized fix plan:

### Critical (P0 - fix immediately):
- Keyboard traps
- Missing form labels
- Insufficient color contrast for critical information
- Missing alt text for essential images

### High (P1 - fix in current sprint):
- Incorrect heading hierarchy
- Missing ARIA labels
- Insufficient focus indicators
- Poor screen reader announcements

### Medium (P2 - plan for next sprint):
- Suboptimal color contrast
- Minor semantic HTML issues
- Inconsistent navigation
- Missing skip links

### Low (P3 - fix when possible):
- WCAG AAA compliance items
- Enhanced compatibility features
- Progressive enhancements

## Step 8 — Update memory (orchestrator)
Add to `memory/progress.md`:
- Date of accessibility audit
- WCAG compliance level achieved
- Number of issues found and fixed
- Link to full audit report
- Next scheduled accessibility review

## Memory update (mandatory)
- [x] Add accessibility audit entry to `memory/progress.md`
- [x] Link to `docs/accessibility-audit-YYYY-MM-DD.md`

## Tools and resources

### Automated testing tools:
- **axe-core** (Deque Systems) - Comprehensive testing
- **Lighthouse** (Google) - Built into Chrome DevTools
- **WAVE** (WebAIM) - Visual feedback tool
- **Pa11y** - CLI and dashboard tools
- **Accessibility Insights** (Microsoft) - Browser extension

### Manual testing tools:
- **NVDA** or **JAWS** screen readers
- **Color Contrast Analyzer** tools
- **Keyboard-only navigation** testing
- **Screen magnifier** simulation

### Development libraries:
- **eslint-plugin-jsx-a11y** (React)
- **vue-axe** (Vue)
- **angular-a11y** (Angular)
- **axe-core** integration for CI/CD

## Success criteria
- **Compliance**: Achieve WCAG 2.1 AA compliance
- **Testing**: Establish automated accessibility testing in CI/CD
- **Documentation**: Maintain accessibility statement and VPAT
- **Training**: Team awareness of accessibility requirements
- **Monitoring**: Regular accessibility audits scheduled

## Fallback for non-web projects
If project has no web interface:
1. Review documentation accessibility
2. Check CLI tool accessibility
3. API accessibility considerations
4. General disability inclusion practices