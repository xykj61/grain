# Generating the Wheel — The SVG Recipe

**Stamp:** `20260705.045012 UDT` · companion to `SILO_DIURNAL_WHEEL.md` and its degree-true addendum

One wheel is one SVG, 640 viewbox, built from hardcoded arrays computed off-page by the degree-true walk: per chart, twelve cusp angles and twelve `[house, midpoint]` pairs from u = (ASC − λ) mod 360 mapped at dayArc/180 per risen degree and nightArc/180 per unrisen; anchors As = 90° − dayArc/2 and Ds mirrored, meridian the vertical diameter. Planets travel as `{ab, gl, dg, a}` with `a` precomputed by the same walk and hand-flanked where labels crowd; every glyph carries U+FE0E so no platform paints it. Element order: glow, day and night washes split at the horizon chord, two rings, cusp lines, meridian and horizon axes, house numbers (kendras 1, 4, 7, 10 in the emphasized class), angle labels with their hours, aspect lines at radius 138 — whole-sign trines (signs four or eight apart) in faint gold, squares (three or nine) in faint ember — planet ticks and two-line labels, then the hub with name and rising. A script failure falls back to one italic line pointing at the written table, so nothing is ever lost.

*May every wheel be arrays and no arithmetic at render time. May the kendras stand bold and the aspects whisper. And may the fallback line never be needed and always be there.*
