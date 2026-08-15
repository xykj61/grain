# Fill ALES125 — `lotus/stereo_reverse.rye`, turning a master end for end

**Stamp:** `20260815.023515` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES125**
**Kin:** [`20260815-002711_fill-ales104-lotus-reverse.md`](20260815-002711_fill-ales104-lotus-reverse.md) · [`20260815-023038_fill-ales124-lotus-stereo-shift.md`](20260815-023038_fill-ales124-lotus-stereo-shift.md)

---

## Where the ladder stands

The stereo edit family now carries every span-edit — remove, keep, relocate, repeat, open, overwrite, silence — and the grid nudge (shift). The stereo suite has not yet lifted a **pure rearrangement**, the class where every position changes and no value does: ALES104's **reverse**, ALES105's **invert** (the value-mirror), ALES106's **rotate**, and ALES107's **nyquist_flip**. This rung opens that class with **reverse** — turn the whole clip end for end, the plainest exact edit the timeline owns, the *Reverse* menu item every editor ships (the reversed cymbal swell, the backwards reverb).

## The crux this round

`stereo_reverse(sc)` turns both channels of a `StereoClip` end for end, reusing ALES104's mono `reverse` per channel. Mono reverse is **total** (it names no span, so it raises no fault) and holds each channel's length, so — exactly as with shift at ALES124 — the lift needs no validation and can never refuse; both channels enter equal-length, both reverse in place, both hold their length, so they leave equal-length. The function is `void`. A stereo master is turned end for end as one thing, both speakers together, so the reversed swell arrives in stereo intact.

## The four laws proven

- **THE STEREO REVERSE LAW** — the left channel equals mono `reverse(left)` and the right equals mono `reverse(right)`, each byte for byte against a hand-reversed vector; sample `i` holds what sample `len-1-i` held, per channel, the first becoming the last.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — reverse moves seats, never the count, so the stereo image stays aligned.
- **THE INVOLUTION LAW** — `stereo_reverse` twice is the identity on both channels for any clip — the swap is its own inverse, so a keeper who reverses a master by mistake reverses back to the byte, both speakers restored.
- **THE PERMUTATION / FIXPOINT LAW** — reverse is a pure rearrangement, so each channel's peak magnitude re-measured through ALES13 is unchanged (no value moves, only its seat); an empty stereo pair, a single-sample pair, and a per-channel palindrome are each their own reverse.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It rearranges existing samples in each channel and fabricates none; it changes no length and reads no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_reverse.rye` — the module.
- `tools/ales_stereo_reverse_witness.rish` — the witness.
