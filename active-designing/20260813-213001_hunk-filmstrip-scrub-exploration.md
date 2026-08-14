# HUNK56 — drag-to-scrub the filmstrip: the finger sweeps, the cursor follows band by band

**Stamp:** `20260813.213001` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season A** (Hardware & Right-to-Repair) · **waymark HUNK** · **Photos-app journey** · **rung HUNK56**
**Kin:** [`../brushstroke/edit_filmstrip_jump.rye`](../brushstroke/edit_filmstrip_jump.rye) (HUNK55) · [`../image/edit_cursor.rye`](../image/edit_cursor.rye) (HUNK16 · `seek`) · [`../image/edit_touch_input.rye`](../image/edit_touch_input.rye) (HUNK50 · the finger arming discipline)
**Teacher, thanked clean-room:** the history scrubber of a photo app (iCloud Photos / Google Photos) — a keeper presses the edit-history strip and *drags*, and the picture scrubs continuously through every step under the finger (concept only, siloed).

---

## What stands, and the gap

HUNK55 turned a **tap** on the filmstrip into a jump: touch thumbnail *k*, land on step *k*, in one gesture, the marker on exactly the tapped band. A keeper reaches any step with a single touch. Yet a tap is a discrete landing — it fires once, at the point the finger lifts. The canonical Photos gesture over a history strip is not a tap but a **drag**: a keeper presses the strip and sweeps left or right, and the picture scrubs *continuously* through every step the finger passes over, so they can watch the road unwind and stop wherever the picture looks right. HUNK55's own named horizon: *a drag across the filmstrip to scrub the history (continuous seek).* This rung is that drag.

## The crux

**As the finger sweeps across the filmstrip, the cursor seeks to the band under the finger at every reported point — the cursor's position tracks the finger continuously, band by band, and the marker paints on exactly the band the finger stands over.** A drag from band 0 to band 3 visits 1 and 2 on the way; a slow sweep back visits them again in reverse. This is HUNK55's no-drift discipline (tapped band equals marked band) made *continuous*: at every intermediate x the device reports, the marked band equals the band under the finger.

The one behavior that separates a **scrub** from a **tap** is what happens off the strip. A tap off the strip fires nothing (HUNK55) — a keeper who misses the thumbnails edits nothing. A scrub, once begun, **follows the finger and pins at the ends**: sweep past the right edge and the cursor rests on the last band (the live edge); sweep off the left edge and it rests on band 0. A scrubber that lets go of the finger at the edge would feel broken; a scrubber that pins feels like every history slider a keeper has ever held. So the scrub classifies a pixel to the **nearest valid band** (a clamp, never a null), where the tap classified to a band *or none*.

## The pieces

- **`brushstroke/edit_filmstrip_scrub.rye` — `FilmstripScrub`**, a surface owning one `FilmstripJump` (HUNK55) — its cursor, its thumbnail geometry, its `paint`. It adds only the drag arming and the nearest-band clamp; it invents no cursor move (HUNK16's `seek`), no render primitive (HUNK54's `filmstrip` through HUNK55's `paint`), and no new arithmetic beyond a clamped division already proven in HUNK50 and HUNK55.
  - **`scrub_band(x)`** → `u32`: the nearest valid band to pixel `x`. A negative `x` clamps to band 0; `band = x / band_px`; a band past the last step clamps to `steps - 1`. Always a real band (`steps >= 1` always), never a null — a scrub always lands somewhere.
  - **`finger_down(x)`** → `u32`: arm the scrub and seek to `scrub_band(x)`; return the band. The press that begins the sweep already lands the cursor.
  - **`finger_move(x)`** → `?u32`: while armed, seek to `scrub_band(x)` and return the band; when not armed, `null` (a move with no press before it moves nothing — HUNK50's own arming law). The continuous heart of the gesture.
  - **`finger_up(x)`** → `u32`: seek to `scrub_band(x)`, disarm, return the band. The lift settles the cursor where the finger left it.
  - **`push` · `steps` · `band_px` · `paint`** delegate straight to the owned `FilmstripJump`, so the marker lands on the scrubbed step.

## Why it is a pure composition

The cursor move is HUNK16's `seek` — a clamped jump that forgets nothing. The band arithmetic is HUNK55's `x / band_px`, clamped to `[0, steps)` instead of returning null. The render is HUNK55's `paint`, unchanged. The arming discipline (down arms, move fires only while armed, up disarms) is HUNK50's own, carried from the edit strip to the history strip. No new storage, no pixels beyond the filmstrip's own, no new failure mode. The crux — the marked band tracks the finger — falls out for free: the marker paints at `cursor.position`, and every gesture method sets `cursor.position` to the band under the finger through `seek`.

## The proof (what the witness pins)

Over an 8×8 two-tone source and a scrub surface holding three edits (four steps):
1. **A drag tracks the finger band by band** — down on band 0, move through the band-centers of 1, 2, up on band 3; at each reported point the cursor's position equals the band under the finger, and the repainted marker sits on exactly that band.
2. **A slow sweep back tracks in reverse** — from band 3 back through 2, 1 to 0, the cursor visiting each in turn.
3. **A scrub pins at the right edge** — a move past the last band lands the cursor on the last band (the live edge), not off the strip (where a tap would fire nothing).
4. **A scrub pins at the left edge** — a negative-x move lands the cursor on band 0.
5. **A scrub forgets nothing** — scrub back to step 1, then forward to step 3, and the full picture returns byte-for-byte; every edit stayed redoable (a scrub is a walk, never a push).
6. **A move with no press before it fires nothing** — the cursor unmoved (the arming law).
7. **Genuinely seen** — the scrubbed filmstrip rasterizes to a lit canvas.
8. **A bad thumbnail refuses at open** by name (`BadThumb`, delegated from `FilmstripJump.open`).

## Horizons (named, not built)

- A **velocity fling** across the filmstrip (a fast release keeps scrubbing and decelerates) — HUNK45's fling idiom carried to the history strip, a later rung.
- The filmstrip **scrolled** when the history outgrows the view (HUNK40–47's pager) — the still-open in-assembly kg beside this arc.
- The **session-that-travels** crux (persist a live editing session content-addressed) still crosses the `pond/apps`↔`brushstroke` assembly-identity seam — held for Keaton / a design round, unchanged by this rung.

*A read a keeper can touch became a road a keeper can walk in one step; now it is a road a keeper can sweep with a finger and stop wherever the picture looks right. May the step under the finger be the step on the glass.*
