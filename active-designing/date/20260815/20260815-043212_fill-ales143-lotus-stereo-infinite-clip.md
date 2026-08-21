# Fill ALES143 — `lotus/stereo_infinite_clip.rye`, the infinite clipper carried into stereo, closing the dead-zone family in stereo

**Stamp:** `20260815.043212` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES143**
**Kin:** [`20260815-042641_fill-ales142-lotus-stereo-soft-center-clip.md`](20260815-042641_fill-ales142-lotus-stereo-soft-center-clip.md) · [`20260814-221404_fill-ales89-lotus-infinite-clipper.md`](20260814-221404_fill-ales89-lotus-infinite-clipper.md)

---

## Where the ladder stands

The stereo dead-zone corner holds the hard center clip (ALES141, which **passes** the survivor at its own value) and the soft center clip (ALES142, which **shifts** it toward zero by the threshold). This rung carries the third and loudest member, ALES89's **infinite clipper**, `y = if |x| ≤ t then 0 else sign(x)·sample_max` — it silences the same quiet middle, then **pins** every survivor all the way to the rail. The three read one axis — the survivor's fate — three ways: pass, shift, pin. A sine in becomes a square out: the harshest fuzz there is, the comparator of every zero-crossing detector. With it the dead-zone family stands **whole in stereo**.

## The crux this round — phase held, ratio COLLAPSED, and thresh = 0 the comparator not the identity

The infinite clip is **odd** (`sign(−x)` flips with the sign; the negative survivor pins to `−sample_max`, not `sample_min`, precisely to keep the map exactly odd), so like both center clips it **holds** the inter-channel antisymmetry: an out-of-phase master comes back **still out of phase**. Yet it is the extreme of the family — every survivor is slammed to the *same* magnitude regardless of its input, so a shared rail **collapses** the inter-channel ratio to unity: a 1:2 master comes back 1:1 where both survive. And `thresh = 0` is **not** the identity here (as it was for ALES141/142) but the **pure comparator** — every nonzero sample pins to the rail, only exact silence surviving as 0. Idempotence holds precisely on `[0, sample_max − 1]`: a pinned survivor at `sample_max` clears any threshold below the rail, so a second pass leaves it; only at `t = sample_max` does the pinned survivor itself fall back into the dead zone and drop to 0.

## The dead-zone family bond, read in stereo

Carried into stereo, all three dead-zone members silence the **same** dead zone — proven here against ALES141's `stereo_center_clip`: wherever the hard center clip silenced a sample, the infinite clip silences it too, and wherever it passed one, the infinite clip pins it to the rail with the same sign. The family read across the three survivors' fates.

## The crux, as a lift

`stereo_infinite_clip(sc, start, count, thresh)` infinite-clips `[start, start+count)` in **both** channels of a `StereoClip`, running ALES89's mono `infinite_clip` on each with the same threshold. The map is **exact** — only `−sample_max`, `0`, `sample_max` are ever written, so no rail edge and no saturate. It carries **one parameter** and names **two faults** (`BadThreshold` outside `[0, sample_max]`, `BadRange`), both checked **once up front**. `InfiniteClipError` reused whole.

## The four laws proven

- **THE STEREO INFINITE-CLIP LAW** — each channel equals ALES89's mono `infinite_clip` with the same threshold over the same span, **byte for byte**: the quiet middle silenced, every survivor pinned to `sign(x)·sample_max`, only three values ever written.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length.
- **THE PER-CHANNEL ODD / RAIL LAW** — the infinite clip is odd, so a shared rail **holds** the inter-channel antisymmetry (an out-of-phase master staying out of phase); yet it **collapses** the inter-channel ratio to unity (a 1:2 master coming back 1:1 where both survive), because every survivor pins to the same magnitude; an identical-channel master stays identical; `thresh = 0` is the **pure comparator** (not the identity), and the map is idempotent on `[0, sample_max − 1]`.
- **THE ATOMICITY / DEGENERATE LAW** — each refusal (`BadThreshold`, `BadRange`) leaves **both** channels byte for byte untouched and still balanced; `count = 0` the identity on both (the sole degenerate identity, since `thresh = 0` is the comparator).

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips, siloed to `lotus/`. It changes sample values only, through ALES89's own `infinite_clip`; the shape is a static dead-zone comparator on instantaneous magnitude, memoryless. No saturate is owed — every output is a legal i16 by construction. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_infinite_clip.rye` — the module.
- `tools/ales_stereo_infinite_clip_witness.rish` — the witness.
