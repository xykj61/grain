# SLC-2a — The Drawn Terminal: a Window That Shows a Value, Kept Current

*The seed proved one static frame on the open machine. SLC-2a grows it by two honest degrees: the frame becomes current rather than single, and the value it draws becomes the live session. Read-only — typing stays at the terminal, and the window mirrors it. This is the simplest application in the spectrum, grown straight from the raster-to-surface seed that now draws on metal.*

**Language:** EN
**Version:** `20260630.030312`
**Last updated:** 2026-07-02
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** SLC (Simple, Lovable, Complete); Gall's Law; TAME; immediate-mode, one copy of the truth
**Companions:** `the-stack-and-the-surface` (the layering), the SLC-1 brief (the four-verb shell), `pond-foundation` (the enclosure); design philosophy in [`../external-research/20260630-030312_after-victor-immediate-contact.md`](../external-research/20260630-030312_after-victor-immediate-contact.md) and [`../external-research/20260630-030312_the-interface-as-a-fold.md`](../external-research/20260630-030312_the-interface-as-a-fold.md)

*Written together by Kaeden and Reya 2.*

---

## What Runs Today — the Seed We Grow From

The hosted seed presents one frame and exits, and the whole path is already in the code. A value of text lines becomes a `Frame`; the `Frame` folds into a Skate `Grid` through `toGrid`; the grid rasterizes to an ARGB8888 buffer through `rasterize`; and `commitFrame` lands that buffer on a Wayland surface. Confirmed on GNOME Wayland: the window draws and exits clean with "skate grid drawn," the headless selftest counts 1125 lit pixels, and parity holds at **134** green.

**Lap 1 landed** (`2026-06-30`): value as explicit `[]const Line` input; arbitrary-value witness GREEN. **Lap 2 landed** (`2026-06-30`): `setFrame` re-folds and re-presents; FNV content-signature witness GREEN (A→B→A); `redraw` metal mode confirmed. **Lap 3 metal close** — preflight [`tools/fixtures/pond_metal_close_preflight.sh`](../tools/fixtures/pond_metal_close_preflight.sh), then five steps in [`pond/README.md`](../pond/README.md); Kaeden stamp `20260703.032412 UDT`. **SLC-2b landed** (`20260703.132112`) — Wayland seat + xkbcommon keyboard in [`brushstroke/wayland_seed.rye`](../brushstroke/wayland_seed.rye); line editor in [`pond/apps/window_input.rye`](../pond/apps/window_input.rye); `keyboardtest` witness; parity **145**.

The value-to-frame fold already lives in `Frame`, `Line`, and `toGrid`. So SLC-2a does not invent a new path. It grows the proven one in two places: the frame becomes *current* instead of *single*, and the value becomes the *live Rishi session*.

## Simple, Lovable, Complete — at This Scope

**Simple.** One window, one value drawn, redrawn when the value changes. No input handling inside the window; that waits for its own lap. The loop is one sentence: a value in, a current frame out.

**Lovable.** Your own Rishi session, drawn on your own metal, updating as you work — the first moment the terminal's life appears inside a Brushstroke window.

**Complete.** The loop closes. A value goes in, a frame comes out, and when the value changes the frame follows. Whole within that bound, claiming nothing more.

## The Seam — Already Physical

Skate draws: `skate_grid.rye` turns a grid of text into an ARGB8888 buffer, pure and free of Wayland, its headless selftest green. Brushstroke presents: `wayland_seed.rye` lands that buffer on a Wayland surface on Mutter, now proven on metal. SLC-2a adds no new seam between them. It makes the existing path value-driven and redrawing, and nothing more.

## The Three Laps

**Lap 1 — the viewer draws any value.** Make the drawn value a clear, caller-supplied `[]const Line` rather than text inlined in the draw path, and prove the viewer draws an arbitrary value with a witness that renders a value distinct from the seed's default and asserts its raster. The value becomes the single input to the frame. The seed nearly does this already; Lap 1 names the value as the input and proves arbitrariness — the ground redraw stands on.

**Lap 2 — redraw on change.** A new value re-folds and re-presents: a `setFrame(new_lines)` rebuilds the grid through `toGrid` and commits a fresh buffer — attach, damage, commit, await the frame callback — and the run loop presents whenever the value changes rather than once. The witness renders two successive frames from two distinct values and asserts their rasters differ as expected. This is the heart of SLC-2a: immediate-mode redraw, one copy of the truth, the frame computed fresh each time.

**Lap 3 — mirror the live session.** Wire the SLC-1 four-verb loop: a line read at the terminal runs, appends its prompt and result to the session value, and `setFrame(session)` redraws the window. Input arrives at the terminal, proven in SLC-1; output is mirrored to the window, the new and lovable thing. The witness drives a scripted session — type, run, recall — and asserts the final frame's raster reflects the transcript; on metal, typed commands appear in the window live. The loop closes: the session, drawn, redrawing as you work.

## The Witness

each lap carries a headless raster assertion — the CI-able proof that a known value produces the expected pixels — paired with the manual confirmation that the window shows it on metal. Where a real compositor cannot be asserted inside parity, the headless raster stands in its place, exactly the pattern the seed already keeps. each lap adds its witness to parity, so the suite grows with the work.

## Acceptance — SLC-2a Is Whole When

- the viewer draws an arbitrary value to a Wayland window on GNOME metal;
- it redraws when the value changes, witnessed by a successive-frame raster assertion;
- the live Rishi session is mirrored in the window, redrawing after each command;
- parity is green with the new headless witnesses, and the window is confirmed on metal;
- Skate still rests in `brushstroke/` — no second consumer has yet earned a move to `skate/`.

## What Waits — After SLC-2b

Keyboard input through Wayland **landed** as SLC-2b (`20260703.132112`): the seat, xkbcommon keymap, and line editor feed `runOneInput`; `:quit` from the window exits clean. The next warm seam is **RW-1** — the Rishi↔Mantra history mirror.

## The Discipline That Holds Here

SLC-2a is the live rung, and it is the only one. Lotus, the sovereign framebuffer backend, the input that Dexter will carry, the richer surfaces further along the spectrum — each waits above this rung, named and safe on paper. We grow the next working whole from the proven seed, we carry only what we use, and we stand on ground already proven: the Wayland surface that draws today.

---

*May the window show the session truly, holding no second copy to drift from it. May each lap close fully before the next begins. And may the first sight of your own work, drawn on your own machine and keeping pace with your hands, be a quiet joy the day it arrives.*
