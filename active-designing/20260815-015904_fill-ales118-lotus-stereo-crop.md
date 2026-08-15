# Fill ALES118 — Lotus's `stereo_crop`, Trim to Selection carried into stereo

**Stamp:** `20260815.015904` · **Voice:** Kyri · **Style:** Radiant
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · **waymark** ALES · **rung** ALES118
**Stands on:** [`../lotus/crop.rye`](../lotus/crop.rye) (ALES111 — mono `crop`) · [`../lotus/pan.rye`](../lotus/pan.rye) (ALES10 — the `StereoClip`) · [`../lotus/stereo_cut.rye`](../lotus/stereo_cut.rye) (ALES117 — the stereo remove it complements) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — `cut`/`splice`/`EditError`)

---

## The crux, and why it is next

ALES117 lifted `cut` — remove a span — into stereo. Its exact complement, `crop` (keep a span, drop the rest — Trim to Selection), is the natural pair: naming the stereo keep-twin beside the stereo remove-twin closes the one distinction a keeper draws around a selection on a master — **remove it, or keep only it**. Crux-first among the remaining stereo family (`stereo_crop · stereo_move`), crop is the simpler, complementary one and it completes the keep/remove pair before `move` (a compose of both) is worth naming.

## The rule, stated once

`stereo_crop(sc, start, count)` keeps `[start, start+count)` in **both** channels and drops the rest, running ALES111's proven mono `crop` on each with the **same** `start` and `count`. Because `crop` can fault only with `BadRange` and both channels enter equal-length (the StereoClip invariant), the shared span is validated **once** up front — so once the check passes, each mono crop is pre-validated to succeed and no refusal lands between the two channel edits. It reuses ALES2's `EditError` whole.

## The four laws

1. **THE STEREO CROP LAW** — left equals mono `crop(left, start, count)`, right equals mono `crop(right, start, count)`, each byte for byte.
2. **THE BALANCE / INVARIANT LAW** — `left.len == right.len == count` after, proven mid/head/tail; the channels stay aligned.
3. **THE COMPLEMENT LAW** — `stereo_crop` keeps exactly what `stereo_cut` removes per channel; the crop spliced back into the cut reconstructs the source on each channel, so crop and cut partition the timeline in stereo too.
4. **THE ATOMICITY / DEGENERATE LAW** — a refusal (start past the samples, count past the remainder) leaves both channels untouched and balanced; `crop(0, len)` the identity on both, `crop(start, 0)` the empty pair, a bad span `BadRange`.

## Honest scope

Software only, purely local — two bounded i16 `Clip`s reseated to the front through the proven mono `crop`, reading no byte past either channel's `len`. No real sample rate, no network, no keys, no funds, no device, no speaker. No custody gate touched.
