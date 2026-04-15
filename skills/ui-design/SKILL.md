---
name: ui-design
description: >
  UX/UI design guidelines for frontend-dev agent. Covers layout principles,
  color usage, typography, component patterns, accessibility, and responsive
  design. Produces professional-quality UI instead of generic defaults.
tags: [ui, ux, design, frontend, accessibility, components]
---

# Skill: ui-design

Enforce professional UX/UI quality when building frontend interfaces. This skill is read by `frontend-dev` before implementing any UI component or screen.

---

## Quick start

Invoke before any UI implementation task:

```
/ui-design
Then implement [component/page description]
```

Or reference explicitly when delegating to `frontend-dev`:

```
Use frontend-dev with /ui-design guidelines to build the dashboard page.
```

---

## Core principles

### 1. Visual hierarchy
- One primary action per screen — never two equal-weight CTAs
- F-pattern or Z-pattern reading flow depending on content density
- Size contrast ratio: primary element should be 3–4× larger than supporting text
- Group related elements with consistent spacing (8px grid system)

### 2. Spacing — 8px grid
Use multiples of 8 for all spacing:
- `4px` — micro spacing (icon gaps, tight labels)
- `8px` — small (padding inside compact components)
- `16px` — base unit (standard padding, gaps)
- `24px` — medium (section padding, card gaps)
- `32px` — large (section breaks)
- `48px` — xlarge (page sections)
- `64px` — hero sections

Never use arbitrary values like `13px`, `22px`, `37px`.

### 3. Typography scale
```
Display:  48–72px  font-weight: 700–900
H1:       36–48px  font-weight: 700
H2:       28–36px  font-weight: 600–700
H3:       22–28px  font-weight: 600
Body lg:  18px     font-weight: 400
Body:     16px     font-weight: 400
Body sm:  14px     font-weight: 400
Caption:  12px     font-weight: 400–500
```
- Line height: 1.5× font size for body, 1.2× for headings
- Max line length: 65–75 characters for body text

### 4. Color system

#### Semantic palette (required)
Always define these semantic tokens — never hardcode hex values in components:
```
--color-primary        Main brand action
--color-primary-hover  Hover state (10% darker)
--color-secondary      Secondary actions
--color-success        #22c55e or equivalent
--color-warning        #f59e0b or equivalent
--color-error          #ef4444 or equivalent
--color-text-primary   Main text (contrast ≥ 7:1 on background)
--color-text-secondary Muted text (contrast ≥ 4.5:1)
--color-surface        Card/panel background
--color-border         Subtle dividers
--color-background     Page background
```

#### Color usage rules
- Max 3 colors in a single component (primary, neutral, semantic)
- Never use pure black (`#000`) — use `#0f172a` or similar
- Never use pure white (`#fff`) on white backgrounds — use `#f8fafc`
- Error states: red background at 10% opacity + red border + red text
- Success states: green background at 10% opacity + green border

### 5. Component patterns

#### Buttons
```
Primary:   Filled, high contrast, rounded (6–8px radius)
Secondary: Outlined or ghost, same radius as primary
Danger:    Red fill, only for destructive actions
Disabled:  50% opacity, cursor-not-allowed, no hover effect
Loading:   Spinner replaces icon, text changes to "Saving...", disabled
```
- Minimum touch target: 44×44px (mobile), 32×32px (desktop)
- Button text: sentence case, not ALL CAPS, not Title Case CTA

#### Forms
- Label always above input, never inside (placeholder ≠ label)
- Error message directly below the field it relates to
- Success state: green checkmark on valid blur, not on every keystroke
- Required fields: asterisk (*) next to label, explained once at top of form
- Input height: 40px (default), 36px (compact), 48px (large/mobile)

#### Cards
- Consistent border radius (12–16px for cards, 8px for inputs)
- Subtle shadow: `0 1px 3px rgba(0,0,0,0.1), 0 1px 2px rgba(0,0,0,0.06)`
- Hover shadow: `0 4px 6px rgba(0,0,0,0.07), 0 2px 4px rgba(0,0,0,0.06)`
- Never mix card styles in the same list

#### Tables
- Zebra striping for > 5 rows
- Sticky header for > 10 rows
- Right-align numbers, left-align text
- Sortable columns: show sort indicator on hover, active state when sorted

#### Empty states
Every list/table must have an empty state:
- Illustration or icon (not just text)
- Friendly message explaining why it's empty
- Primary CTA to fill the empty state

#### Loading states
- Skeleton screens for content (not spinners for page-level loads)
- Spinner only for button actions and small isolated areas
- Never show a blank page while loading — skeleton or fade-in

### 6. Responsive design

#### Breakpoints
```
sm:   640px   Mobile landscape
md:   768px   Tablet
lg:   1024px  Desktop
xl:   1280px  Wide desktop
2xl:  1536px  Ultra-wide
```

#### Mobile-first rules
- Design for 375px width first
- Touch targets ≥ 44×44px
- Bottom navigation for mobile (thumb-friendly zone)
- No hover-only interactions on mobile
- Font size ≥ 16px for inputs (prevents iOS zoom)

### 7. Motion & transitions

```css
/* Standard transitions */
--transition-fast:   150ms ease-in-out   /* hover states */
--transition-base:   200ms ease-in-out   /* standard interactions */
--transition-slow:   300ms ease-in-out   /* panels, modals */
--transition-layout: 400ms ease-in-out   /* layout changes */
```

- Never animate layout (width/height) — use transform/opacity
- `prefers-reduced-motion`: wrap all animations in `@media (prefers-reduced-motion: no-preference)`
- Page transitions: fade (150ms) or slide (200ms) — never bounce on data

### 8. Accessibility baseline (WCAG AA minimum)
- Contrast ratio ≥ 4.5:1 for body text, ≥ 3:1 for large text (18px+)
- All interactive elements keyboard-navigable (Tab, Enter, Space, Escape)
- Focus ring always visible — never `outline: none` without alternative
- `aria-label` on icon-only buttons
- Form inputs linked to labels via `for`/`id` or `aria-labelledby`
- Error messages linked to inputs via `aria-describedby`
- Images have meaningful `alt` text (empty `alt=""` for decorative images)

---

## Anti-patterns — never do these

| Anti-pattern | Why | Instead |
|-------------|-----|---------|
| Placeholder as label | Disappears on focus, inaccessible | Label above input |
| Disabled buttons with no tooltip | Users don't know why | Show tooltip explaining requirement |
| Infinite scroll without position save | Users lose their place on back | Pagination or save scroll position |
| Modal on mobile | Hard to dismiss, keyboard issues | Bottom sheet or full-screen page |
| > 3 font sizes in one component | Visual noise | Stick to 2 sizes max per component |
| Red as brand color | Conflict with error states | Use for errors only |
| No loading state | Perceived lag | Always indicate async operations |
| Generic "Error occurred" messages | Unhelpful | "Invalid email format" / "Session expired" |

---

## Checklist before shipping any UI

- [ ] 8px grid respected throughout
- [ ] Color contrast ≥ 4.5:1 verified
- [ ] Empty state implemented
- [ ] Loading state implemented
- [ ] Error state implemented
- [ ] Keyboard navigation tested
- [ ] Mobile layout tested (375px)
- [ ] Focus rings visible
- [ ] No hardcoded hex values in components (use CSS variables)
- [ ] Reduced-motion respected for animations
