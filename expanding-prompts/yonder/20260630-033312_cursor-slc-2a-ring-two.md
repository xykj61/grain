# Cursor Prompt — SLC-2a Ring 2: Redraw on Change

*The heart of the drawn terminal. Ring 1 made the value the viewer's explicit input; Ring 2 lets a new value re-fold and re-present, so the window keeps pace with the truth. The risk this ring carries is staleness — a redraw that does not actually re-fold — so the witness is built to catch exactly that.*

**Stamp:** `20260630.033312`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Brief:** `active-designing/20260630-030312_slc-2a-the-drawn-terminal.md` (Ring 2)

*Written together by Kaeden and Reya 2.*

---

## What Runs, and What This Ring Adds

Ring 1 left `brushstroke/wayland_seed.rye` drawing a caller-supplied `[]const Line` once and exiting, witnessed by `tools/slc2a_ring1_arbitrary.rish`. Ring 2 lets the value change and the frame follow: a new value re-folds through `toGrid` and re-presents, and the run loop redraws when the value changes rather than committing once.

## Edit 1 — `setFrame`, the re-fold

Add a method to `App` — `setFrame(new_lines: []const Line) !void` — that:

- rebuilds the grid from the new value (`Frame.init(new_lines).toGrid(...)`), replacing `self.grid`;
- re-presents through the existing commit path (`commitFrame`): map a buffer, `fillBuffer` from the new grid, `attach`, `damage`, `commit`, and await the frame callback before returning.

Two disciplines the witness shape implies:

- **Keep the frame-callback gate.** Commit, await `done`, and only then may the next frame commit — so a buffer the compositor may still be reading is never overwritten.
- **Damage the whole surface** for this ring. The simplest honest choice is that the whole frame may have changed; minimal-damage rectangles are a later concern, not Ring 2's.

The run loop redraws on change: where Ring 1 committed once, Ring 2 presents whenever the value moves.

## Edit 2 — A content signature over the buffer

Add a small helper that reduces a pixel buffer to a stable scalar **signature** — a checksum or FNV-1a hash over the bytes. Lit-pixel *count* is too weak here: two different frames can share a count, and a stale frame could pass. A content hash distinguishes the frame's actual pixels, which is what redraw must prove.

## Edit 3 — The redraw witness (the confirmed shape)

Add a headless witness — extend the Ring-1 path or add `tools/slc2a_ring2_redraw.rish` — driving a **bounded three-step sequence** and asserting on the signature:

1. set value A, capture `sig_a`;
2. `setFrame(B)`, capture `sig_b`;
3. `setFrame(A)` again, capture `sig_a2`.

Assert three things:

- `sig_b` equals an independent fresh rasterization of B — the re-fold is correct and not stale;
- `sig_a != sig_b` — the frame genuinely changed;
- `sig_a2 == sig_a` — redraw is repeatable and returns correctly, pairing the assertion across both directions.

Bound it — three `setFrame` calls, no open loop. Wire it into `tools/parity.rish` (133 → 134).

## Edit 4 — The metal confirmation

Add a `redraw` mode to `main`: draw value A, await a beat, draw value B through the commit-and-frame-callback cycle, exit clean. On GNOME Wayland you watch the window update A → B — the proof a compositor surface cannot give inside parity.

## Edit 5 — Hold the discipline

- Skate stays in `brushstroke/`; no `skate/` graduation.
- TAME: unqualified `assert`, fixed widths with the bound asserted before any `@intCast` (reuse `bufLenU32`), every loop and buffer bounded.

## Verify

- The redraw witness is green: `sig_b` matches fresh B, differs from `sig_a`, and `sig_a2` returns to `sig_a`.
- `rye build` clean; `tools/parity.rish` green on metal at 134.
- On GNOME Wayland, the `redraw` mode visibly updates A → B and exits 0; the default and `selftest` modes are unchanged.

## Propose, Then Confirm

Gate every irreversible step — show the diff and wait for Kaeden's word before writing to the tree.

## Record and Push

Commit as one honest unit — `setFrame`, the signature helper, the witness, the parity wiring, the metal mode, and the session log. Log at `session-logs/archive/20260630/20260630-033312_slc-2a-ring-2-redraw.md`: redraw on change landed, staleness witness green at 134, the window updating on metal. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

## Before You Move On — Recommend the Next Step

End with one line. Ring 2 proves redraw; Ring 3 mirrors the live Rishi session in the window, and wiring the SLC-1 loop to `setFrame` is worth confirming with Claude first: *"Recommend: when Ring 2 lands, check in with Claude before Ring 3 (mirror the live session)."*

---

## Definition of Done

- [ ] `setFrame(new_lines)` re-folds and re-presents; frame-callback gate kept; whole-surface damage for this ring
- [ ] A content-signature helper (checksum/hash) over the buffer
- [ ] The three-step redraw witness green and wired into parity (133 → 134); bounded, no open loop
- [ ] A `redraw` metal mode that updates A → B on GNOME and exits 0; default and selftest unchanged
- [ ] Skate stays in `brushstroke/`; TAME held at the seam
- [ ] `rye build` clean; parity green on metal; gated propose-then-confirm honored; session log shipped; four remotes pushed; Ring 3 check-in recommended
