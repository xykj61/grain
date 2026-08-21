# Fill ALES184 — Lotus's allpass: Schroeder's diffusion filter, the delayed dry read against the delayed output — the missing primitive the reverb stands on

**Stamp:** `20260815.091646` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES184
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-090818_fill-ales183-lotus-stereo-multi-tap.md`](20260815-090818_fill-ales183-lotus-stereo-multi-tap.md)

---

## The next crux, honestly chosen

The stereo time-based wing now holds both of its read-a-delay-line-differently primitives carried into stereo: the feedback echo (ALES181) and the snapshot multi-tap (ALES183). Above the wing stands the reverb — named since ALES66 as the wing's large composition, "each one a delay line read a different way." A reverb is not one more read of the delay line, though; it is a **network** of two kinds of stage — parallel **comb** stages (the feedback echo already gives the comb) and series **allpass** stages that *diffuse* the comb train into a smooth dense tail. The tree holds the comb (`echo.rye`) and the early-reflection cluster (`taps.rye`), yet it does **not** hold the allpass. So the honest crux before the reverb is the allpass itself — the one missing primitive the whole composition stands on.

Crux-first, the allpass is also the exactly-tractable rung: it is the clean **fusion of the two idioms already proven**. It reads a **delayed dry input** `x[n-d]` — the multi-tap's frozen-snapshot read — and a **delayed output** `y[n-d]` — the echo's in-place read — in one difference equation. Neither idiom is new; the allpass is what happens when a single rung needs both at once. That makes it the decisive move: once the allpass stands beside the comb, the reverb is a bounded composition of stages the tree has already proven, not new machinery.

## The shape — the Schroeder allpass difference equation, both delayed reads at once

`allpass(clip, start, count, delay, num, den)` runs Schroeder's allpass over the span in place:

```
y[n] = -g·x[n] + x[n-d] + g·y[n-d],   g = num/den,   0 <= num < den
```

- **The delayed dry `x[n-d]` reads a frozen snapshot** — the whole dry prefix `[0, end)` is copied into one bounded `[max_clip]i16` scratch **before any write** (the graft/multi-tap snapshot-before-write idiom, ALES24/68), so the delayed *input* term is always the original audio, never a sample this pass just wrote.
- **The delayed output `y[n-d]` reads the clip buffer in place** — for `n-d` inside the span it is the output already written this pass (true feedback, the echo idiom ALES66); before the span it is the dry audio there; before the clip it is silence.
- **The gain sign is honest** — `-g·x[n]` and `+g·y[n-d]` are computed in i64 as `@divTrunc(num·s, den)` and combined with the delayed dry; the whole sum saturates **once** through `timeline.saturate` (ALES3), so a constructive pile-up pins to the i16 rail rather than wrapping.
- **`g` strictly below unity keeps the pole safe** — `num >= den` (or `den == 0`) refuses `BadGain`, exactly as the echo refuses a runaway feedback; an allpass at unity sits on the unit circle and can grow without bound. `num == 0` is the legal degenerate: a **pure delay** of the dry (`y[n] = x[n-d]`), not the dry identity — the allpass with no diffusion is a delay line, which is the honest thing it becomes.

`AllpassError = { BadDelay, BadGain, BadRange }` — a delay of zero or wider than `max_clip`, a gain at or above unity or with a zero denominator, a span outside the samples; each refused before any write, the clip untouched on refusal.

## The laws proven

- **The allpass impulse response, exact:** an impulse `V` at index 0 (delay 2, `g = 1/2`) lands `-g·V` at 0, then `V(1-g²)` at the first delay, then a tail that halves each delay after — `[-4000, 0, 6000, 0, 3000, 0, 1500, 0]` for `V = 8000`, computed by hand and demanded byte for byte. This is the defining signature: an initial inverted spike, then a smoothly decaying diffuse tail.
- **The pure-delay degenerate:** `g = 0` (`num = 0`) is a clean delay of the dry by `d`, silence before it — `[100,200,300,…]` delayed 3 becomes `[0,0,0,100,200,…]`, no diffusion added.
- **The decay and silence law:** the diffuse tail (the even lane past the first delay) strictly shrinks and reaches zero within the clip — the allpass tail always ends, never grows.
- **The saturation law:** a loud constructive combination pins to the i16 rail rather than wrapping — a crafted `[-32000, 32000, …]` at `g = 3/4` drives one sample to `-32768`, the whole array demanded byte for byte.
- **The refusal law:** a zero or too-wide delay refuses `BadDelay`, a gain at unity or a zero denominator `BadGain`, an out-of-range span `BadRange`, each leaving the clip untouched.

## Scope

Purely local, siloed to `lotus/`. One bounded i16 `Clip`, a `u32` span, a `u32` delay and a plain `u32/u32` gain; the dry prefix snapshotted into one bounded `[max_clip]i16` scratch (graft's width and stack cost), both delayed reads bounded, the sum run in i64 and saturated once so nothing on the path overflows. The delay is a count of sample **indices**, not milliseconds against a clock (a real-time twin through the ALES5 clock is a later rung, exactly as `echo_ms` followed the index-named echo); the gain is a plain fraction, not a diffusion coefficient in seconds. Because the allpass reads a per-call dry snapshot, a split across two calls re-snapshots already-written samples (the multi-tap's own boundary) — so it is **not** claimed split-equals-whole; a single call over the span is exact. No socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate reached — a self-approved design round. With the allpass beside the comb, the reverb (parallel combs diffused through series allpasses) becomes a bounded composition of proven stages, ready to climb next.
