# Fill ALES131 — `lotus/stereo_crossfade.rye`, the equal-power crossfade carried into stereo, one shared law

**Stamp:** `20260815.031427` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES131**
**Kin:** [`20260815-030651_fill-ales130-lotus-stereo-fade.md`](20260815-030651_fill-ales130-lotus-stereo-fade.md) · [`20260814-fill-ales12-lotus-equal-power-crossfade.md`](20260814-fill-ales12-lotus-equal-power-crossfade.md)

---

## Where the ladder stands

ALES129 opened the stereo **amplitude** class on normalization (one measured scalar shared across both channels), and ALES130 carried the class's most-reached-for member, **fade**, into stereo (one positional ramp shared). ALES130's own closing line named the next crux plainly: *a stereo fade-out laid under a stereo fade-in is a stereo crossfade.* This rung makes that gesture its own primitive — the **equal-power crossfade** (ALES12) carried into stereo, so two whole masters cross without a dip and without splitting the image.

ALES12 crosses two equal-length overlap **Clips** with weights `power.split(i, den)` read at each sample — the overlap begins as pure outgoing, ends as pure incoming, and holds equal power (−3 dB) at the center where a linear cross would sag to −6 dB. Those weights are **positional**: identical at each seat regardless of channel. So, exactly as ALES130's shared ramp preserved the image for free, ALES12's shared weights preserve it here — no measurement, no linking needed.

## The crux this round

`stereo_crossfade(out_master, in_master, out)` crosses two `StereoClip` masters (ALES10) over their shared overlap into an output master, running ALES12's proven mono `crossfade` on each channel with the **same** equal-power weights. Because a Lotus master's defining invariant is that left and right hold the **same length**, and both masters enter balanced, the overlap length is checked **once** up front: the two masters must name the same overlap (`BadRange` on a mismatch) and an overlap needs at least two samples to have an interval (`BadRange`). That one check pre-validates both channel crosses, so a refusal never writes one channel and leaves the other stale. `timeline.EditError` is reused whole — the stereo lift invents no new fault and no new arithmetic.

## The four laws proven

- **THE STEREO CROSSFADE LAW** — each channel of `out` equals ALES12's mono `crossfade` of that channel's outgoing and incoming windows, byte for byte: the head pure outgoing, the tail pure incoming, the equal-power center between.
- **THE BALANCE / LENGTH LAW** — `out.left.len == out.right.len == count` (the shared overlap length), the output a legal balanced master, the two channels staying aligned in time.
- **THE SHARED-WEIGHT IMAGE LAW** — the crux made checkable: the same equal-power weights cross both channels at each seat, so the seam splices seamlessly on both speakers (head = the outgoing master, tail = the incoming master, per channel) and an identical-channel pair of masters crosses to an identical-channel output — the stereo image never splits through the cross.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal (an overlap-length mismatch between the two masters, a too-short overlap) leaves the output untouched and no channel half-written; a loud overlap saturates on both channels (ALES2's one true clamp), never wraps.

## Honest scope

Software only, purely local. Four bounded in-process i16 Clips (two masters, two channels each) crossed into two more on one bench, siloed to `lotus/`. It reads values from the two masters and writes values only into the output, through ALES12's own `crossfade` (itself running each scaled sample in a wide i64 before ALES2's single clamp), fabricating no sample and inventing no primitive; the overlap runs across sample **indices**, not seconds. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_crossfade.rye` — the module.
- `tools/ales_stereo_crossfade_witness.rish` — the witness.
