---
name: i18n-check
description: >
  Internationalization audit for web applications. Detects hardcoded strings,
  missing locale keys, RTL layout issues, date/number formatting problems,
  and missing plural forms. Produces a remediation report.
tags: [i18n, l10n, accessibility, frontend, audit]
---

# Skill: i18n-check

Audit a web application for internationalization (i18n) and localization (l10n) completeness. Identifies what blocks a multilingual release.

---

## Quick start

```
/i18n-check
```

Invokes `frontend-dev` or `codebase-analyst` to scan the codebase and produce `docs/i18n-report.md`.

---

## What this skill checks

### 1. Hardcoded strings
Scan source files for user-visible text that is not routed through the translation system:

```bash
# React/Vue — strings outside t() / $t() / i18n.t()
grep -r '"[A-Z][a-z]' src/ --include="*.tsx" --include="*.jsx" --include="*.vue"

# Check for hardcoded English in JSX/template attributes
grep -r 'placeholder="[A-Z]' src/
grep -r 'aria-label="[A-Z]' src/
grep -r 'title="[A-Z]' src/
```

Report every hardcoded string with file path and line number.

### 2. Missing translation keys
Compare the base locale file (usually `en.json`) against all other locale files:

- Keys present in `en.json` but missing in `fr.json`, `es.json`, etc. → untranslated
- Keys present in locale files but absent in source → dead keys (cleanup candidates)
- Nested key depth inconsistencies between locales

### 3. Plural forms
Check that plural-form keys exist for all locales that need them:
- English: `one` / `other`
- French: `one` / `other`
- Arabic: `zero` / `one` / `two` / `few` / `many` / `other`
- Russian/Polish/Czech: `one` / `few` / `many` / `other`

Flag any `count`-dependent string that uses simple string interpolation instead of a pluralization function.

### 4. Date, time, and number formatting
Look for hardcoded formatting instead of locale-aware APIs:

```javascript
// Bad — hardcoded
new Date().toLocaleDateString('en-US')
price.toFixed(2) + ' USD'

// Good — locale-aware
new Date().toLocaleDateString(locale)
new Intl.NumberFormat(locale, { style: 'currency', currency: 'USD' }).format(price)
```

Check for:
- Hardcoded locale strings in `toLocaleDateString()`, `toLocaleString()`
- `toFixed()` used for display (not locale-aware)
- Currency symbols hardcoded in UI strings
- Hardcoded date formats (`MM/DD/YYYY` — US-only)

### 5. RTL layout
If supporting Arabic, Hebrew, Persian, or Urdu:

- CSS uses `margin-left`/`margin-right` instead of `margin-inline-start`/`margin-inline-end`
- `text-align: left` instead of `text-align: start`
- Directional icons (arrows, chevrons) not mirrored for RTL
- Missing `dir="rtl"` on root element or `<html lang="ar">`
- Absolute-positioned elements with hardcoded `left:` values

### 6. Font and character support
- Non-Latin scripts (Arabic, CJK, Devanagari) need matching font loading
- Font stack fallbacks for missing glyphs
- Text overflow with longer translations (German text is ~30% longer than English)

### 7. Image and content localization
- Images containing embedded text (not localizable)
- Currency symbols or country-specific content hardcoded in assets
- Legal text (GDPR notices, cookie banners) varies by region

---

## Output format

Produce `docs/i18n-report.md`:

```markdown
# i18n Audit Report — [Project Name]
Date: YYYY-MM-DD
Base locale: en
Target locales: fr, es, de, ...

## Summary
| Check | Status | Issues |
|-------|--------|--------|
| Hardcoded strings | ⚠️ | 47 |
| Missing keys | ⚠️ | 12 |
| Plural forms | ✅ | 0 |
| Date/number formatting | ❌ | 8 |
| RTL layout | N/A | — |

## Hardcoded strings
[file:line — string content]

## Missing translation keys
[key path — present in en, missing in: fr, de]

## Plural form issues
[key path — description]

## Formatting issues
[file:line — description]

## Recommended next steps
1. ...
```

---

## Common i18n libraries reference

| Framework | Library | Key function |
|-----------|---------|-------------|
| React | react-i18next | `useTranslation()` → `t('key')` |
| React | react-intl (FormatJS) | `<FormattedMessage id="key" />` |
| Vue 3 | vue-i18n | `$t('key')` / `useI18n()` |
| Next.js | next-intl | `useTranslations('namespace')` |
| Angular | @angular/localize | `$localize` / `i18n` attribute |
| Python/Django | gettext | `_('string')` / `{% trans %}` |
| Python/Flask | Flask-Babel | `gettext('string')` |

---

## Integration with framework agents

- `codebase-analyst` — run the grep patterns to find hardcoded strings
- `frontend-dev` — implement fixes after audit
- `doc-writer` — update translation contributor guide
- `/accessibility-audit` — run after i18n fixes (RTL + ARIA labels often overlap)
