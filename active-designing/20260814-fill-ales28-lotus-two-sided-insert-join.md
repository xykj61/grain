# ALES28 -- Lotus's two-sided insert-join, the trailing-seam law

**Stamp:** `20260814.142637` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after ALES27
**Waymark:** ALES - rung ALES28
**Kin:** [`ALES26 -- the crossfade join`](20260814-fill-ales26-lotus-crossfade-join.md) - [`ALES27 -- the stereo crossfade join`](20260814-fill-ales27-lotus-stereo-crossfade-join.md) - [`lotus/insert_join.rye`](../lotus/insert_join.rye) - [`lotus/join.rye`](../lotus/join.rye) (ALES26, `join` run once per seam) - [`lotus/timeline.rye`](../lotus/timeline.rye) (ALES2, the `Clip` and `max_clip`)

---

## Why this round

ALES26 gave an inserted span the choice of law where its **head** meets the outgoing tail -- overlap the two, cross them equal-power, and the boundary flows through ALES12's -3 dB curve rather than stepping into a click. Yet `join` only crosses the **leading** seam: it appends a span to the very end of a clip, where there is no audio after it. A keeper rarely inserts at the end -- they drop a span into the **middle**, and the moment they do a **second** seam appears, where the span's **tail** meets the audio that follows. ALES26 leaves that trailing seam a hard butt, and a butt is a click. The README's own "road on" named this exact gap: *a trailing-seam law where the audio after an insert rejoins the timeline.*

Lindy-first, crux-first: the trailing-seam law is the highest-Lindy next move on the edit side -- it closes the seam story `join` opened, so every mid-clip insert a keeper makes can flow at both edges rather than only where it happens to append. And it reuses ALES26's `join` whole over its public API, adding no new arithmetic and no new seam law. It stays wholly local, touching no gate.

## The one crux this rung fixes

**A span inserted into the middle of a clip crosses BOTH its seams equal-power -- or the clip is left exactly as it was.** Two facts make this exact:

- **The two-sided insert is `join` applied twice, once per seam.** Split the clip at `at` into a head `A = clip[0..at]` and a following `B = clip[at..]`. Crossfade-join the span onto `A` over `lead` (the leading seam, exactly ALES26), then crossfade-join `B` onto that over `trail` (the trailing seam, ALES26 again). The result `A~S~B` flows through power at both boundaries, and the new length shares both overlaps: `clip.len + span - lead - trail`.
- **Atomicity from a scratch build.** An insert touches the middle of the clip, so a half-done insert would corrupt audio a keeper already holds. This rung builds the whole result in its **own** scratch `Clip` and copies it back only on full success -- the real clip is never written until both seams are proven legal. Any refusal (a past-the-master position, a lead wider than the head, a trail wider than the following audio, a short overlap, an overflow) leaves the clip untouched. This is the "capacity checked first" discipline the graft and clipboard already keep, carried to two seams at once.

## The shape

`lotus/insert_join.rye`:

- `insert_join(clip, at, ins, lead, trail)` -- insert `ins` at offset `at`, crossing the leading seam over `lead` and the trailing seam over `trail`. Refuses `BadRange` when `at` names a sample past the clip; when `lead` exceeds the head `A` or the span's head; when `trail` exceeds the built head~span tail or the following `B`; or when either overlap is under two (ALES26's own per-seam guards). Refuses `ClipFull` when the two-seam result would overflow. Applies ALES26's `join.join` once per seam against a scratch `Clip`, so a refusal leaves the real clip untouched; on full success the proven result is copied back in one write.

Errors are ALES2's `timeline.EditError` reused whole -- the two-sided insert, like the one-sided join it wraps, names no new fault.

## What the witness proves (GREEN on metal)

`tools/al/ales_insert_join_witness.rish`: a 10-sample clip with a 5-sample span inserted at the middle over lead 2 and trail 2 lands at length 11 (`10 + 5 - 2 - 2`, both overlaps shared, not summed to 15); a span whose head disagrees with the head-clip's tail *and* whose tail disagrees with the following audio's head lands with **both** seam samples strictly inside their raw 60000 steps, where a butt insert leaves both adjacent and unblended; the leading seam still continues the clip before the insert (pure outgoing) and the trailing seam still continues the audio after it (pure incoming); and a past-the-master position, a lead wider than the head, a trail wider than the following audio, a short lead, and an overflow each refuse by name leaving the clip untouched. Purely local -- no socket, no network, no keys, no funds, no real device, no real speaker.

## The road on

With the trailing-seam law, every mid-clip insert can flow at both edges -- the seam story `join` opened is closed for mono. The next rung can carry the two-sided insert into **stereo** (both channels, both seams, in lockstep -- the twin of ALES27's move), let the **graft or paste** join rather than butt by default (an edit that crossfades its seams whenever they would step), or carry a held span across the ALES0 audio **wire** as its own framed payload (a module seam, taken on Keaton's word). The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
