# ALES26 -- Lotus's crossfade join, the choice of law where an inserted span meets its neighbour

**Stamp:** `20260814.141500` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after ALES25
**Waymark:** ALES - rung ALES26
**Kin:** [`ALES25 -- the clipboard`](20260814-fill-ales25-lotus-clipboard.md) - [`ALES12 -- the equal-power crossfade`](20260814-fill-ales12-lotus-equal-power-crossfade.md) - [`lotus/join.rye`](../lotus/join.rye) - [`lotus/crossfade.rye`](../lotus/crossfade.rye) (ALES12, `crossfade` reused whole) - [`lotus/timeline.rye`](../lotus/timeline.rye) (ALES2, `splice` and `max_clip` reused whole)

---

## Why this round

Every edit the suite has grown so far butts its samples hard against the audio already there. ALES2's `splice` drops the incoming span in at a point and shifts the tail aside; the graft (ALES24) and the clipboard (ALES25) paste through that same hard butt. A butt splice is exact, and where the outgoing tail's last sample and the incoming head's first sample already agree it is exactly right. Yet where they disagree -- a +30000 tail meeting a -30000 head -- the waveform steps, and a step in a waveform is a click a keeper hears at the seam.

The recommendation the clipboard round left named this crux plainly: **the choice of law where a pasted or grafted edit meets its neighbour -- a crossfade join rather than a hard butt splice.** It is the higher-Lindy move because it is not one more edit gesture; it is the *law a seam is allowed to follow*, a law every insert can reach for. And it is already proven: ALES12 carried equal power from the stereo field into time, so a crossfade holds constant power across an overlap and begins as pure outgoing, ends as pure incoming. This rung reads that law at a splice point.

Lindy-first, crux-first: the join reuses ALES12's `crossfade` whole over its public API and ALES2's `splice` to fill the windows and append the remainder -- no new arithmetic, no new bound, no module seam, no gate.

## The one crux this rung fixes

**An inserted span meets the audio before it through equal power rather than a step -- the join's head still continues the clip, its tail still continues the span, and the two neighbours share the overlap in time.** Three facts make this exact:

- **The seam moves through power, not a step.** The clip's last `overlap` samples (the outgoing tail) cross ALES12-equal-power with the span's first `overlap` samples (the incoming head). Because that crossfade begins as pure outgoing and ends as pure incoming, the crossed window's first sample is still the clip's original tail sample, and its last is still the span's overlap-th sample -- so the boundary flows into the appended remainder rather than jumping.
- **The neighbours share the overlap in time.** The new length is `clip.len + span - overlap`, not `clip.len + span`: the crossed window overwrites the tail *in place*, and only `ins[overlap..]` appends after it. A full overlap (`overlap == span`) is a pure crossfade over the join with nothing appended.
- **The outgoing tail is read before it is overwritten.** Both overlap windows are snapshotted into their own Clips before the crossfade writes, so the cross sees the true tail, never a half-written one -- the same read-before-write discipline the graft used against self-overlap.

## The shape

`lotus/join.rye`:

- `join(clip, ins, overlap)` -- append `ins` to `clip`, crossing the last `overlap` samples of the clip with the first `overlap` samples of `ins` equal-power, the crossed window overwriting the tail in place and `ins[overlap..]` appending after. Refuses `BadRange` when `overlap < 2` (no interval to cross), when `overlap` exceeds the clip's tail or the incoming head, or when `overlap - 1` exceeds the equal-power denominator cap; refuses `ClipFull` when the shared-overlap result would overflow the fixed buffer -- each before any write, a refused join leaving the clip untouched.

Errors are ALES2's `timeline.EditError` reused whole (`BadRange`, `ClipFull`) -- the join names no new fault, because a seam law owes only the two the splice already owes.

## What the witness proves (GREEN on metal)

`tools/al/ales_join_witness.rish`: a five-sample clip joined to a five-sample span over a two-sample overlap lands at length 8, not 10 (the neighbours share the overlap, they do not sum); the join's overlap head equals the clip's original tail sample (pure outgoing) and its overlap tail equals the span's overlap-th sample (pure incoming), with the remainder appended after; a hard butt splice steps the full 60000 swing between +30000 and -30000 where the join's seam sample sits strictly inside that step (the choice of law, shown); a full overlap is a pure crossfade with nothing appended and the length unchanged; a self-join lifts the middle at or above the shared level, never below (the equal-power promise, no dip); and an overlap under two, past the tail, past the head, or an overflow each refuses by name leaving the clip exactly as it was. Purely local -- no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With the join, an edit chooses its law at the seam: a hard butt where the samples already meet, a crossfade where they would step. The next rung can carry the join into **stereo** (both channels crossed in lockstep, the graft/clipboard pattern over the join), offer the **graft or paste its own crossfade seam** (an edit that joins rather than butts by default), or name a **trailing-seam law** where the audio after an inserted span rejoins the timeline. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
