# ?? Vercel Design System Specification & Guidelines

> **Project:** `secure-code` Interactive Studio (`https://carbonthecoder.github.io/secure-code/`)  
> **Aesthetic Standard:** Vercel Geist Design Language (Minimalist, True Black, Radiant Accents, Precision Typography)

---

## 1. Core Philosophy

The `secure-code` interactive studio strictly adheres to the **Vercel Design System (Geist)** principles:
- **True Black & Dark Surfaces:** High-contrast, pure `#000000` base with `#0a0a0a` card surfaces and `rgba(255, 255, 255, 0.08)` hairline borders.
- **Lighting & Depth:** Subtle ambient radial spotlights (`radial-gradient(ellipse at 50% -20%, rgba(255,255,255,0.12), transparent 70%)`) without garish drop shadows.
- **Typography Precision:** Strict letter-spacing (`letter-spacing: -0.025em` for headings, `letter-spacing: 0.05em` for uppercase badges) using Geist Sans / Inter and Geist Mono / Fira Code.
- **Micro-Interactions:** Instant copy feedback, smooth tab transitions (`cubic-bezier(0.16, 1, 0.3, 1)`), subtle border glow on hover, and tactile keyboard shortcuts.
- **Performance First:** Zero heavy JavaScript frameworks, zero layout shifts (CLS = 0), and instant paint under 50ms.

---

## 2. Color Palette & Design Tokens

```css
:root {
  /* Surfaces */
  --geist-background: #000000;
  --geist-surface: #0a0a0a;
  --geist-surface-hover: #121212;
  --geist-card-border: rgba(255, 255, 255, 0.08);
  --geist-card-border-hover: rgba(255, 255, 255, 0.2);

  /* Typography */
  --geist-foreground: #ededed;
  --geist-muted: #888888;
  --geist-subtle: #555555;

  /* Accent Colors */
  --geist-accent-blue: #0070f3;
  --geist-accent-emerald: #00dc82;
  --geist-accent-danger: #ff453a;
  --geist-accent-warning: #f5a623;

  /* Fonts */
  --font-sans: 'Geist Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  --font-mono: 'Geist Mono', ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
}
```

---

## 3. Component Architecture

### A. Navigation Header
- **Backdrop Blur:** `backdrop-filter: blur(16px); background: rgba(0, 0, 0, 0.8);`
- **Branding:** Minimal geometric triangle/shield logo with subtle gradient.
- **GitHub Star Button:** Native Vercel-style pill button with GitHub Octocat icon and real-time link to `carbonthecoder/secure-code`.

### B. Hero Section
- **Spotlight Beam:** Top-centered radial gradient creating high-end studio lighting.
- **Pill Badge:** Glassmorphic container with an active glowing green dot indicating `v1.0.0 Production Standard`.
- **Headline:** Clean, confident Geist typography: *"Stop AI assistants from shipping vulnerable code."*
- **Terminal Command Bar:** 1-Click copy box for `npx github:carbonthecoder/secure-code inject` with interactive clipboard checkmark feedback.

### C. Interactive Dual-Panel Studio
- **Vercel Segmented Tabs:** Smooth pill selection for flaw presets (IDOR, Timing Attack, Float Money, SQLi, Clean Code).
- **Code Terminal Cards:** Monospace code surface with mock macOS/Vercel header and file indicator (`api/document.ts`).
- **Live Audit Engine:** Real-time regex scanner that updates on every keystroke with categorized danger/warning/success pill cards.
- **Auto-Hardener Button:** Instant 1-click transformation of vulnerable code into hardened production code.

### D. Invariant Comparison Grid
- High-contrast matrix showcasing before-and-after differences with green/red syntax indicators.

---

## 4. Verification & Standards
- **Contrast Ratio:** AAA Accessible (> 7:1 contrast on all text elements).
- **Responsiveness:** Fluid grid collapsing from 2-column studio layout to 1-column on mobile (< 900px).
- **Deployment:** Live on GitHub Pages at `https://carbonthecoder.github.io/secure-code/`.
