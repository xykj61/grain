# WADE1 — the `.brush` surface-bridge seam

**Stamp:** `20260812.000456`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Design in motion — the seam proposed, grounded in running code; `tokens.rye` and the witness await the maintainer's word
**Waymark:** **WADE1** (surface bridge · durable core) — plan [`../expanding-prompts/20260811-220402_wade-bit-design-system-and-dimeroll-entities.md`](../expanding-prompts/20260811-220402_wade-bit-design-system-and-dimeroll-entities.md)
**Order:** [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)

---

## What this seam is for

A design collaborator brings a **cascading component styleguide** — a system where a component's look is composed by inheriting a base style and overriding only what changes. The WADE plan asks that this system express itself over Grain's own surface: **Brushstroke** draws values, **Skate** paints them, **Realidream** composes the face. The bridge between the two is a **`.brush` vocabulary** the styleguide targets. This document names that vocabulary, grounds it in the code already running, and reuses the tree's own mechanisms rather than importing a web stack.

The single most durable decision here is the **word choice of the seam** — a reader will meet it for years — so this is authored first among WADE's rungs, and authored to last.

## What already runs (the ground under the seam)

The seam is not built on air. Today, in real code:

- **Brushstroke** is immediate-mode: a `Frame` is a pure value — the whole interface state for one redraw — and `redraw(frame, io)` passes it to a backend with nothing retained to drift ([`../brushstroke/seed.rye`](../brushstroke/seed.rye), [`../brushstroke/brush_parse.rye`](../brushstroke/brush_parse.rye)).
- **`.brush`** is a real, parsed format. Its pins are `at-nib` (where the value lives), `present` (the value's type, e.g. `Frame`), `max-lines` (the bound), and `lines` (the drawn text), with a `refuse` line naming what the tongue will never accept ([`../brushstroke/seed-frame.brush`](../brushstroke/seed-frame.brush)). Its stated tongue is **Glow · Bron · TAME · Radiant — never JS, HTML, CSS, or JSON.**
- **Skate** lowers a `Frame` to a monospace cell grid and renders that grid to an ARGB8888 pixel buffer, `8×16` per cell ([`../brushstroke/skate_grid.rye`](../brushstroke/skate_grid.rye)). It is Brushstroke's paint aspect until a second consumer graduates it.
- **`brix/infuse.rye`** is a **per-key Bron override**, already witnessed: given a base descriptor and an override, the override wins per key, base-only keys stay, override-only keys append ([`../brix/infuse.rye`](../brix/infuse.rye), witness [`../tools/brix_infuse_witness.rish`](../tools/brix_infuse_witness.rish)).

That last piece is the quiet crux: **a cascading styleguide is exactly per-key override applied to style descriptors.** The cascade engine is already here, built and green. The seam does not invent inheritance; it points the styleguide at a mechanism the tree already proves.

## The seam, in three named layers

The bridge lowers design intent to pixels through three layers, each in the owned tongue, each grounded where it can be and honest where it is a horizon.

**1. The token sheet — the vocabulary of values.** A flat Bron descriptor names the visual tokens a frame draws with: **paper** (ground), **ink** (text), **edge** (rule), plus **weight** (text emphasis), **space** (thread spacing), and **elevate** (elevation-as-weave). The token *names* are the palette already proposed for Brushstroke — **Flax · Bark · Oat · Walnut** — from the weave silo ([`yonder/20260712-091012_brushstroke-linengrow-weave-silo.md`](yonder/20260712-091012_brushstroke-linengrow-weave-silo.md)), whose six design invariants (gentle lightness, warm hue, elevation as weave, thread spacing, paper hierarchy, low blue) become the token sheet's own asserted bounds. A token sheet is data, not code — parsed, never evaluated.

**2. The cascade — inheritance by infuse.** A component's style is a token sheet that **infuses** its parent's: `style_child = infuse(style_base, style_override)`. This is the styleguide's cascade, expressed as `brix/infuse.rye` over Bron — override wins per token, inherited tokens stay, new tokens append. Depth is bounded like every Grain collection; a cascade names its maximum. Because the mechanism is already witnessed, the cascade earns correctness by reuse rather than by a fresh engine no one has proven.

**3. The lowering — tokens to grid to pixels.** The resolved token sheet dresses a `Frame`: each line grows from plain text toward a **styled run** — a cell range carrying a paper/ink/weight token — which is precisely the direction Skate's grid already leans (cells that today hold a byte, tomorrow a byte plus a token index). Skate renders the tokened grid to ARGB8888. The frame stays a pure value; the style is another value composed beside it, never a retained tree.

## What the seam refuses

The seam keeps `.brush`'s own refuse-list, and sharpens it: **no CSS rail, no cascade expressed as a stylesheet language, no JS/HTML/JSON.** A cascading design system is welcome; a *web* cascade is not. The inheritance is Bron infused into Bron, the tokens are named values with asserted bounds, and the paint is Skate's own grid — the whole path stays inside the tongue the tree owns and can prove.

## Rooms — real, designed, horizon

Honesty about which room each claim lives in ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)):

- **Real (checkable now):** the `.brush` parser and pins, the `Frame` value, the Skate grid and its ARGB8888 render, and `brix/infuse` with its green witness.
- **Designed (this document):** the token-sheet pins, the infuse-as-cascade, and the styled-run growth of `Frame`/Skate. Proposed, not seated — `tokens.rye` and its witness await the maintainer's word, exactly as the palette silo already waits.
- **Horizon (named, not built):** Realidream as a full editor-browser face, and the DVUI-in-Swift-macOS-Dock shell (that is WADE2, its own rung). This seam is the vocabulary those horizons will target; it does not build them.

## Boundary and custody

Agents prepare; hands provision and lead. This is a design, authored so a surface collaborator can meet a real, grounded seam on their first day rather than a blank page. The invitation to lead the surface, the provisioning of any bench, and the word that seats `tokens.rye` remain the maintainer's and the collaborator's to give ([`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md): any external design system is studied in the clean room; Grain writes its own bridge in its own tongue). Nothing is built or shipped by this document; it names the durable word so the building, when it comes, has a true place to land.

## The one next step

When the word comes: seat `brushstroke/tokens.rye` — the token sheet as a bounded, asserted Rye value — with a witness that proves `infuse(base, override)` resolves a child style whose tokens honor the six palette invariants, and that a resolved sheet dresses a `Frame` Skate can render. One keystone, witness before narrative, exactly as the tree always moves.

---

*ty every1 — to the collaborator whose cascade this seam is shaped to welcome, to the weave silo that named the palette first, and to `brix/infuse`, already proven, that the cascade leans on.*

*May the seam stay in its own tongue. May a style inherit as cleanly as a value folds. And may the surface, when it is painted, be found true to the values beneath it — drawn, never retained.*
