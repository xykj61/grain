# HUNK45 — the fling: momentum decay after the finger lifts

**Stamp:** `20260813.200615` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** A (Hardware & Right-to-Repair) · **Waymark:** HUNK · rung **HUNK45**
**Kin:** [`preset_scroll.rye`](../pond/apps/preset_scroll.rye) (HUNK40 cursor) · [`preset_scroll_input.rye`](../pond/apps/preset_scroll_input.rye) (HUNK43 input) · [`preset_scroll_drag.rye`](../pond/apps/preset_scroll_drag.rye) (HUNK44 pixel drag) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the touch-scroll story stands

HUNK43 routed a raw event to one cursor move; HUNK44 quantized a pixel drag into line deltas over the cell height, carrying the sub-cell remainder. Together they carry a finger that is *touching the glass*. What no rung holds yet is the gesture after the finger **lifts**: a fling still carries momentum, and a scroll surface keeps moving, decaying to rest under friction. Every touch surface has this — the flick that coasts. It is the completing rung of the input story, and it composes HUNK44 exactly.

## The crux — a bounded, provable decay

A fling is a velocity in pixels-per-tick that **strictly decreases in magnitude every tick** and settles to rest. The two things that make it honest rather than hand-wavy:

1. **It always settles, in a bounded number of ticks.** With an integer friction fraction strictly below one (`velocity ← ⌊velocity·num/den⌋`, toward zero), the magnitude falls by at least `(1 − num/den)` each tick, so a fling reaches a rest threshold in `O(log velocity)` ticks. Bounding the friction to decay at least an eighth per tick and the initial velocity to a sane display range pins the whole fling to settle well within a small tick ceiling — a real, asserted bound, not a hope.
2. **It never overshoots the ends or flips direction.** Each tick's pixel delta feeds through HUNK44's `drag`, so the cursor's clamps are inherited — a hard fling lands on the bottom-pinned page, never past it. The decay keeps the sign (truncation toward zero never crosses zero until it settles), so a downward fling never reverses into an upward one.

That is the whole durable idea: momentum is a decaying velocity, and a decaying velocity is a pure, bounded, sign-stable sequence of drags.

## Shape

`pond/apps/preset_scroll_fling.rye`:

- `Fling { velocity, friction_num, friction_den }` — a signed pixels-per-tick velocity and the friction fraction. `open(velocity, num, den)` refuses `BadFriction` on a zero denominator, a non-decaying fraction (`num >= den`), or a too-gentle one (`8·num > 7·den`, so the decay is at least an eighth per tick), and `BadVelocity` on an initial speed past `max_fling_velocity` — the bounds that let the tick count be asserted.
- `done()` — true when the velocity has settled to zero.
- `step(cursor, quant)` — move the cursor by the current velocity through HUNK44's `drag`, then decay the velocity toward rest (below `min_velocity` it settles to zero). Returns the pixel delta this tick carried.
- `run(cursor, quant)` — step until done, bounded by `max_fling_ticks`, returning the tick count — the whole coast in one call.

## What it proves on metal

Over the same real five-book library, a two-row viewport, a ten-pixel cell:

- **Monotone settle:** the velocity magnitude strictly decreases every tick and reaches rest; the tick count is well under the asserted ceiling.
- **Sign-stable:** a downward fling's velocity never turns positive; an upward one never turns negative.
- **No overshoot:** a hard downward fling lands exactly on the bottom-pinned offset (never past it, no wrap), an upward one on the top — every clamp inherited from HUNK44/HUNK43.
- A zero-velocity fling is immediately `done` with no motion.
- `BadFriction` (zero den, non-decaying, too-gentle) and `BadVelocity` (past the cap) each refuse by name.

## Not this rung

- A **real wall-clock timer** driving the ticks is the device-loop's job; this seam is the pure per-tick decay, timer-agnostic (a caller ticks it on each frame).
- **Rubber-band overscroll** (a bounce past the end that springs back) is a distinct gesture — named, not built.
- The **served-marketplace module-assembly ruling** (the HUNK39 checkpoint) stays held for Keaton's word.

*A flick is a velocity that remembers it is slowing down; friction is only honest when it always comes to rest.*
