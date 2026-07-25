# Cursor Prompt — SLC-2a Ring 1: The Value-Driven Viewer

*The first build ring of the drawn terminal, and a small one by design. The seed already folds a value into a presented frame; Ring 1 names that value as the explicit input and proves the viewer draws an arbitrary one, laying the ground that redraw will stand on. We change only what makes the value the input, and we prove it with a witness.*

**Stamp:** `20260630.030312`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Brief:** the SLC-2a scope record (`active-designing/20260630-030312_slc-2a-the-drawn-terminal.md`)

*Written together by Kaeden and Reya 2.*

---

## What Runs, and What This Ring Adds

`brushstroke/wayland_seed.rye` presents a `Frame` once and exits — proven on GNOME metal. The path is `Frame.init(lines)` → `toGrid` → `rasterize` → `commitFrame`. Today the default lines are inlined in `main`. Ring 1 makes the drawn value a clear, caller-supplied input and proves the viewer draws an arbitrary value. No redraw yet; no new seam.

## Edit 1 — Name the value as the viewer's input

In `brushstroke/wayland_seed.rye`:

- Lift the default lines out of `main` into a named default value (for example `default_lines`), so the text the viewer draws arrives as a `[]const Line` rather than living inside the draw path.
- Confirm the draw path renders from `self.grid` built from the supplied lines — `fillBuffer` and `commitFrame` should already draw from `self.grid`; change only what is needed to make the lines the explicit input. Recognize what is already there; resist a larger refactor.
- Keep the default-value behavior on metal identical: the window still draws the same default frame and exits clean.

## Edit 2 — A witness that the viewer draws an arbitrary value

Add a headless parity witness (extend the existing selftest path or add a sibling witness in the parity suite) that:

- builds a `Frame` from a value *distinct* from the default — for example two lines `["rye", "lotus"]`;
- folds it through `toGrid` and rasterizes it through the same Skate path;
- asserts a stable property of the resulting raster — a lit-pixel count within an expected band, or specific expected lit cells — proving the viewer renders an arbitrary value, not only the seed's default.

Wire it into `tools/parity.rish` so the suite grows by one witness (132 → 133), gated like the rest.

## Edit 3 — Hold the discipline

- Skate stays in `brushstroke/` — no `skate/` graduation; no second consumer has earned it.
- TAME at the seam: unqualified `assert`, fixed widths with the bound asserted before any `@intCast` (reuse `bufLenU32`), every collection bounded.
- Affirmative, woven comments where a reader meets a reason.

## Verify

- The new headless witness is green; the viewer renders both the default and the distinct value correctly.
- `rye build` is clean; `tools/parity.rish` is green on metal at its new count.
- The window still draws the default frame on GNOME Wayland, unchanged.

## Propose, Then Confirm

Gate every irreversible step — show the diff and wait for Kaeden's word before writing to the tree, per the collaboration rule.

## Record and Push

Commit as one honest unit — the value-as-input edit, the witness, the parity wiring, and the session log. Log at `session-logs/archive/20260630/20260630-030312_slc-2a-ring-1-value-driven-viewer.md`: the value named as the viewer's input, the arbitrary-value witness added and green, the window unchanged on metal. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

## Before You Move On — Recommend the Next Step

End with one line. Ring 1 establishes the value-as-input seam; Ring 2 is the redraw — the heart of SLC-2a — and the witness shape for "two successive frames differ" is worth confirming with Claude before building. So: *"Recommend: check in with Claude before Ring 2 (redraw on change)."*

---

## Definition of Done

- [ ] The drawn value is a clear caller-supplied `[]const Line`; the draw path renders from it; default behavior unchanged on metal
- [ ] A headless witness renders a value distinct from the default and asserts its raster; wired into parity (132 → 133)
- [ ] Skate stays in `brushstroke/`; TAME held at the seam
- [ ] `rye build` clean; parity green on metal; the window still draws on GNOME
- [ ] Gated propose-then-confirm honored; session log shipped; four remotes pushed; check-in with Claude before Ring 2 recommended
