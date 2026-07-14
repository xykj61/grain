# RW-2 — Mirrored Pair Contract (Drawn Terminal ↔ Brushstroke Surface)

*Witness contract on paper — collaboration and contract twins for the app↔surface seam at `setFrame`, drawn only from Lap 2's golden, the SLC-2a scope note, and the testing audit. Implementation waits on the standing one-pair-per-season rule after RW-1; the mirror lands while the seam is warm from SLC-2b.*

**Stamp:** `20260702.205630`
**Voice:** Rio 3
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · happy zone · mirrored pair
**Status:** Landed — parity **150** (`20260703.235512 UDT`, Cursor metal)

**Ground:** [`20260702-180812_testing-audit-first-pass.md`](20260702-180812_testing-audit-first-pass.md) · [`../active-designing/20260630-030312_slc-2a-the-drawn-terminal.md`](../active-designing/20260630-030312_slc-2a-the-drawn-terminal.md) · [`../tools/slc2a_ring2_redraw.rish`](../tools/slc2a_ring2_redraw.rish)

---

## The Seam

**Asker:** `pond/apps/drawn_terminal.rye` — builds `sessionLines` from Rishi transcript, calls `app.setFrame(lines)` on each change.

**Answerer:** Brushstroke Wayland seed — `setFrame` re-folds lines through `toGrid`, commits buffer, FNV **content signature** changes when raster changes.

**Contract:** `sessionLines` shape and `setFrame` behavior — the app may rely on exactly this value flow; the surface must redraw when content signature differs.

---

## Witness 1 — `tools/rw2_app_collab.rish` (collaboration)

The drawn-terminal app (or a headless stub invoking the same `sessionLines` + `setFrame` path) runs against a real or test compositor surface.

### Welcome paths

| Action | App must |
|--------|----------|
| Boot frame | `setFrame` with initial lines; signature A pinned |
| Append one session line | rebuild lines; `setFrame`; signature B ≠ A |
| Same lines again | signature stable (no spurious redraw storm) |
| Empty line batch | signature matches prior empty contract |

### Unwelcome path

| Action | App must |
|--------|----------|
| `setFrame` with malformed line record | survive; surface unchanged or error surfaced kindly |

**Fixtures:** extend `tools/fixtures/` with line batches matching Lap 3 session golden fragments.

**Commit message:** `Add RW-2 app collaboration witness — parity +1` (first of two).

---

## Witness 2 — `tools/rw2_surface_contract.rish` (contract)

Exercises Brushstroke surface API directly — no full Pond app — proving the answerer side mirrors collaboration claims.

### Welcome demonstrations

| Contract call | Surface must |
|---------------|--------------|
| `setFrame(lines_a)` then `contentSignature` | digest equals pinned golden A |
| `setFrame(lines_b)` where b ≠ a | signature B ≠ A |
| `setFrame(lines_a)` again | signature returns to A |
| Headless `redrawtest` path | output contains `GREEN` (extends Lap 2) |

### Unwelcome demonstration

| Probe | Surface must |
|-------|--------------|
| Lines exceeding grid bounds | fail loudly or clamp per scope note — pinned in witness |

**Commit message:** `Add RW-2 surface contract witness — parity +1` (second of two).

---

## Relation to Lap 2 today

[`tools/slc2a_ring2_redraw.rish`](../tools/slc2a_ring2_redraw.rish) already proves the **contract fragment** (redrawtest GREEN). RW-2 **splits** the seam: collaboration isolates the app's obligation to call `setFrame` when session changes; contract isolates the surface's signature obligation — mirrored line for line with RW-1's pattern.

---

## What Stays Outside This Contract

- Full Wayland metalsmoke (thin edge — stays in Lap 3 witness)
- Keyboard-from-window (SLC-2b Dexter)
- RW-1 history seam (parallel season, earlier in ladder)

---

*May the session value and the frame stay one truth, and may each side of the seam carry its two small answers.*
