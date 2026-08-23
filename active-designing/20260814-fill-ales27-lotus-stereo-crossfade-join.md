# ALES27 — Lotus's stereo crossfade join, both channels crossed in lockstep

**Stamp:** `20260814.142200` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES26
**Waymark:** ALES · rung ALES27
**Kin:** [`ALES26 — the crossfade join`](20260814-fill-ales26-lotus-crossfade-join.md) · [`lotus/stereo_join.rye`](../lotus/stereo_join.rye) · [`lotus/join.rye`](../lotus/join.rye) (ALES26, `join` run once per channel) · [`lotus/pan.rye`](../lotus/pan.rye) (ALES10, the `StereoClip` whose channels share one length)

---

## Why this round

ALES26 gave a mono `Clip` the choice of law at a seam: where an inserted span's head disagrees with the outgoing tail, overlap the two and cross them equal-power, so the boundary flows through ALES12's −3 dB curve rather than stepping into a click. Yet a Lotus master is a `StereoClip` — two Clips heard together — and a keeper joins a stereo span, not one channel. The graft (ALES24) and clipboard (ALES25) already carried the copy and the paste into stereo, keeping both channels in lockstep; the join owes the same.

Lindy-first, crux-first: the stereo join is the highest-Lindy next move on the edit side — it makes the seam law usable on the object a keeper actually edits — and it reuses ALES26's mono `join` whole over its public API, adding no new arithmetic and no new seam. It stays wholly local, touching no gate.

## The one crux this rung fixes

**A stereo join runs the same seam law on both channels and grows them by the same shared-overlap count — or touches neither.** Two facts make this exact:

- **The seam law is per-channel, the lockstep is shared.** Each channel crosses its own outgoing tail with its own incoming head over the *same* `overlap`, so each channel carries its own audio through its own equal-power seam while both end one length (`clip + span − overlap`).
- **Atomicity from two shared lengths.** A `StereoClip`'s two channels are always one length (ALES10's invariant), and a stereo span is one length (the two incoming heads must match, refused `BadRange` otherwise). So ALES26's guards read identically for left and right — the join is validated once against the shared length *before either channel is touched*, and a bad request leaves both channels untouched and aligned. This is the "capacity checked first" discipline the graft and clipboard already keep.

## The shape

`lotus/stereo_join.rye`:

- `join_stereo(master, ins_left, ins_right, overlap)` — crossfade-join a stereo span onto a stereo master, both channels in lockstep. Refuses `BadRange` when the two incoming channels differ in length, when `overlap < 2`, when `overlap` exceeds the master's tail or the incoming head, or when `overlap − 1` exceeds the equal-power denominator cap; refuses `ClipFull` when the shared-overlap result would overflow — each validated once against the shared length before either channel is edited. Applies ALES26's `join.join` to each channel; `try` still honours the mono join's untouched-on-error contract, keeping the lockstep even were a guard to disagree.

Errors are ALES2's `timeline.EditError` reused whole — the stereo join, like the mono join it wraps, names no new fault.

## What the witness proves (GREEN on metal)

`tools/al/ales_stereo_join_witness.rish`: a five-sample master joined to a five-sample span over a two-sample overlap lands both channels at length 8 and still aligned; each channel carries its own audio through its own equal-power seam (left crossing 1000→200, right crossing 4000→800), its seam head pure outgoing and seam tail pure incoming with its own remainder appended; a full overlap is a pure crossfade with nothing appended in both channels; and an unequal-length span, an overlap under two, an overlap past the tail, and an overflow each refuse by name leaving both channels untouched and aligned. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With the stereo join, an edit chooses its law at the seam on the object a keeper works with. The next rung can let the **graft or paste join rather than butt** by default (an edit that crossfades its seams when they would step), name a **trailing-seam law** where the audio after an inserted span rejoins the timeline, or carry a held span across the ALES0 audio **wire** as its own framed payload (a module seam, taken on Keaton's word). The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
