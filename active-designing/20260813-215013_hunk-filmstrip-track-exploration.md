# HUNK58 — a tracking window that follows the cursor

**Stamp:** `20260813.215013` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season A (Hardware & Right-to-Repair) · waymark HUNK · Photos-app journey · rung HUNK58**
**Kin:** [`edit_filmstrip.rye`](../brushstroke/edit_filmstrip.rye) (HUNK54/57) · [`edit_filmstrip_scrub.rye`](../brushstroke/edit_filmstrip_scrub.rye) (HUNK56) · [`edit_filmstrip_jump.rye`](../brushstroke/edit_filmstrip_jump.rye) (HUNK55)

## The gap this rung closes

HUNK57 gave the filmstrip a **bounded window** — `filmstrip_window(first, count)` — so a history longer than the strip is wide is paintable a slice at a time. It forced no interaction decision on purpose: it paints whatever window it is handed, and blanks the marker row honestly when the current step is scrolled off-view.

Yet nothing yet decides *which* window to show. A keeper walking a sixty-four-edit history one step at a time still needs the strip to **follow them** — to keep the step they stand on in view, scrolling only as far as it must, pinning at both ends. That following rule is the crux the window primitive was built toward, and it is this rung.

## The move

`FilmstripTrack` owns one `FilmstripJump` (its cursor and thumbnail geometry) and one number, `win_bands` — how many thumbnails the window shows at once. It invents one pure function, `window_first`, and overrides `paint` to draw the following window through HUNK57's `filmstrip_window`. Every other surface — building the history (`push`), navigating it (`seek` / `undo` / `redo`), the band geometry (`band_px`) — delegates unchanged.

`window_first` **centers the cursor and clamps to the edges**:

- when the whole history fits (`steps <= win_bands`), the window is the whole strip, `first = 0`;
- otherwise `first = clamp(position - win_bands/2, 0, steps - win_bands)`.

This one line proves the rung's promise: the cursor is **always inside the window**, so — unlike HUNK57's fixed window — the tracking window **never blanks the marker**. It pins at `0` while the cursor is near the original, climbs by one as the cursor crosses the middle, and pins at `steps - win_bands` near the live edge. Monotonic, stateless, and re-derived from the cursor on every paint.

## Why this shape

- **Lindy-first.** A following window is the durable primitive every long-history surface reuses; the pixel-level windowed-finger classification (a drag whose coordinates are relative to the shown window) is a smaller, later rung (HUNK59) that rides on this one.
- **Crux-first.** The hardest still-tractable move is proving the marker stays in view for *every* step of a full history the whole strip cannot paint — that is the selftest's spine.
- **Pure composition.** No new cursor move, no new render primitive, no new arithmetic beyond a clamped subtraction. The window is a *view* over proven seams; the history is read, never moved, the source never mutated. No network, no key, no funds.

## The proof (selftest)

1. A full **64-edit history** (65 steps): the whole `filmstrip` refuses `FilmstripTooWide` at a four-cell thumbnail, yet `FilmstripTrack` paints GREEN at **every** step 0..64 — the window is `win_bands·tcols` wide throughout, the marker always in view, the marked band equal to a direct preview of `window_first()+band` cell-for-cell (no drift), and each window rasterizes to a lit canvas.
2. **Following:** `window_first` is monotonically non-decreasing as the cursor climbs, pinning at `0` early and at `steps - win_bands` late.
3. **Marker never blanks:** the honest contrast to HUNK57 — the tracking window keeps the current step visible, so the marker shows at every step.
4. **Short-history parity:** when the whole history fits (`steps <= win_bands`), the tracking window equals HUNK54's whole `filmstrip` cell-for-cell.
5. **Refusals by name:** `win_bands = 0` refuses `BadWindow`; a window wider than the map ceiling refuses `WindowTooWide`; a zero-dimension thumbnail refuses `BadThumb`.
