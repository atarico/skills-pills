---
name: frontend-design
description: >
  Create distinctive, production-grade frontend interfaces with high design quality.
  Trigger: When building web components, pages, or applications — avoids generic AI aesthetics.
license: Apache-2.0
metadata:
  author: atarico
  version: "1.0"
  based-on: Anthropic frontend-design plugin (Apache-2.0)
---

## When to Use

Use this skill when:
- Building any UI component, page, or full application
- The result needs to look genuinely designed, not AI-generated
- Working with HTML/CSS/JS, React, Vue, or any frontend framework

---

## Protocol

### Step 1 — Design Thinking (before writing a single line)

Understand the context and commit to a BOLD aesthetic direction:

- **Purpose**: What problem does this interface solve? Who uses it?
- **Tone**: Pick an extreme and own it — brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian. Use these as inspiration, not as a checklist.
- **Constraints**: Framework, performance requirements, accessibility needs.
- **Differentiation**: What's the ONE thing someone will remember about this interface?

**CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work — the key is intentionality, not intensity.

### Step 2 — Implement

Produce working code (HTML/CSS/JS, React, Vue, etc.) that is:
- Production-grade and functional
- Visually striking and memorable
- Cohesive with a clear aesthetic point-of-view
- Meticulously refined in every detail

Match implementation complexity to the vision: maximalist designs need elaborate animations and effects; minimalist designs need restraint, precision, and careful spacing.

---

## Frontend Aesthetics Guidelines

### Typography
Choose fonts that are beautiful, unique, and characterful. Pair a distinctive display font with a refined body font. Avoid generic choices that lack personality.

### Color & Theme
Commit to a cohesive palette. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes.

### Motion
Use animations for effects and micro-interactions. Prioritize CSS-only solutions. Use the Motion library for React when available. Focus on high-impact moments — one well-orchestrated page load with staggered reveals creates more delight than scattered micro-interactions.

### Spatial Composition
Unexpected layouts. Asymmetry. Overlap. Diagonal flow. Grid-breaking elements. Generous negative space OR controlled density. Never default to predictable column grids.

### Backgrounds & Visual Details
Create atmosphere and depth. Apply gradient meshes, noise textures, geometric patterns, layered transparencies, dramatic shadows, decorative borders, custom cursors, grain overlays — whatever matches the aesthetic direction.

---

## Rules

- Commit to the aesthetic direction BEFORE coding — no "safe" defaults
- NEVER use: Inter, Roboto, Arial, or system-ui as primary fonts
- NEVER use: purple gradients on white backgrounds (the AI slop signature)
- NEVER use: Space Grotesk as a convergent safe choice
- NEVER produce cookie-cutter layouts that look like every other AI-generated UI
- Vary between light and dark themes across different designs
- No two designs should look the same — context-specific character is non-negotiable
- Elegance comes from executing the vision well, not from playing it safe
