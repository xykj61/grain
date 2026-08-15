# Fill ALES186 — Lotus's reverb: the Schroeder network, parallel combs summed then diffused through series allpasses — the wing's keystone, a bounded composition of proven stages

**Stamp:** `20260815.093042` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES186
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-091646_fill-ales184-lotus-allpass.md`](20260815-091646_fill-ales184-lotus-allpass.md)

---

## The next crux, honestly chosen

The time-based wing now holds every primitive the reverb was ever going to stand on. The comb is the feedback echo (ALES66) — a delay read as recirculating output, a decaying train. The allpass is Schroeder's diffusion stage (ALES184) — the delayed dry read against the delayed output, an inverted spike then a smooth dense tail. Both stand mono and both stand stereo (ALES181, ALES185). The reverb, named since ALES66 as the wing's large composition, was never one more read of the delay line; it is the **network** those two stage kinds compose into. With both stages proven, the network itself is the keystone crux — the decisive move the whole wing was climbing toward.

Crux-first, the reverb is exactly the tractable rung now and was intractable before, because it invents **no new arithmetic**. Every sample it writes is written by a stage the tree has already proven byte for byte. The reverb's own work is the *shape* of the composition — how the combs run in parallel and the allpasses run in series — not any new sample law. That is precisely the rung that opens the rest: once the network stands, a preset (a named room), a stereo reverb (each channel through its own network), and a real-time face (delays in milliseconds) are all thin twins over it.

## The shape — Schroeder's reverberator, combs in parallel then allpasses in series

`reverb(clip, start, count, combs, allpasses)` runs the classic Schroeder network over the span in place:

```
wet[n] = series_allpass( sum over k of comb_k(dry) )[n]
```

- **The combs run in parallel, each on its own copy of the dry.** A `CombSpec` is a `{ delay, fb_num, fb_den }` — one feedback echo (ALES66). Each comb is run on a fresh whole-clip copy of the dry so the combs never feed one another; their outputs over the span are summed sample by sample, the sum saturating **once** per sample through `timeline.saturate` (ALES3's one true saturation) so a constructive pile-up of comb trains pins to the i16 rail rather than wrapping. Parallel combs at chosen delays are what give a reverb its dense, uncorrelated body.
- **The allpasses run in series, in place, on the comb-bank sum.** An `AllpassSpec` is a `{ delay, num, den }` — one Schroeder allpass (ALES184). After the comb sum is written into the span, each allpass diffuses it in place, in order, so its inverted-spike-then-smooth-tail signature smears the comb train into a dense reverberant wash. Series allpasses are what turn a metallic comb bank into a smooth tail.
- **Every stage is validated before any write — the reverb is atomic.** A reverb carries many stages; a fault in the last allpass must never leave a clip half-reverbed. So the span, every comb, and every allpass are prechecked through the stages' own `precheck` functions (ALES66/ALES184, reused whole) **before** a single sample is written; on any refusal the clip is untouched.
- **The bank is bounded.** `combs.len` and `allpasses.len` are each bounded by `max_stages`; an empty comb bank refuses `NoCombs` (a reverb with nothing to reverberate is not a reverb — it would erase the span to silence), and an over-long bank refuses `TooManyStages`. A bank of one comb and no allpasses is the honest degenerate: exactly the feedback echo (ALES66), byte for byte — the reverb over a single comb with no diffusion *is* the echo.

`ReverbError = { NoCombs, TooManyStages, BadDelay, BadGain, BadRange }` — the two stage faults fold into one honest name each: a comb's or allpass's illegal delay is `BadDelay`, an illegal recirculation or diffusion fraction (a feedback or gain at unity, a zero denominator) is `BadGain`, a span outside the samples is `BadRange`; each refused before any write, the clip untouched on refusal.

## The laws proven

- **The reverb equals its explicit composition, byte for byte.** A reverb of two combs and one allpass over an impulse is computed independently by running ALES66's `echo` on two copies, summing them through `timeline.saturate`, and running ALES184's `allpass` on the sum — and the reverb is demanded equal to that composition sample for sample. The composition law is proven against the proven primitives, not against a hand transcription that could drift; one hand-computed spot value anchors it.
- **The single-comb, no-allpass degenerate is the plain echo.** A reverb of one comb (delay `d`, feedback `fb`) and zero allpasses equals ALES66's `echo` over the same span byte for byte — the reverb with nothing to diffuse and nothing to sum against is the comb it stands on, honestly.
- **Silence stays silence.** An all-zero clip reverbs to all zeros under any legal bank — the network adds nothing to nothing.
- **The reverb tail decays to silence within the clip.** An impulse reverbed through a comb bank and an allpass reaches silence and stays there before the clip ends — both stage kinds decay (feedback below unity, a gain below unity), so their composition decays; a reverb tail always settles, never grows.
- **A loud constructive sum saturates rather than wraps.** Two loud combs whose trains land in phase drive the comb-bank sum past the i16 rail; it pins to `sample_max`/`sample_min` (ALES3's ceiling and floor) rather than wrapping to the opposite sign.
- **The refusal laws, atomic.** An empty comb bank refuses `NoCombs`; a bank longer than `max_stages` refuses `TooManyStages`; a comb or allpass with a zero delay refuses `BadDelay`, one at unity or with a zero denominator `BadGain`, an out-of-range span `BadRange` — and a bad allpass listed **after** valid combs still leaves the clip untouched, proving every stage is validated before any write.

## Scope

Purely local, siloed to `lotus/`. One bounded i16 `Clip`, a `u32` span, and two bounded slices of plain-fraction stage specs; each comb run on one bounded whole-clip copy of the dry (the stack cost the echo/allpass tests already carry), the comb-bank sum accumulated in one bounded `[max_clip]i16` scratch and saturated once, each allpass run through ALES184's own bounded dry snapshot. Every stage's arithmetic is a stage already proven byte for byte; the reverb adds only the saturating parallel sum and the series ordering, so nothing new on the path can overflow. The delays are counts of sample **indices**, not milliseconds against a clock (a real-time twin `reverb_ms` through the ALES5 clock is a later rung, exactly as `echo_ms` followed the index-named echo); the feedbacks and gains are plain fractions, not room sizes in seconds. Because each comb reads a per-call dry copy and each allpass a per-call dry snapshot, a split across two calls re-reads already-written samples (the stages' own boundary) — so split-equals-whole is **not** claimed; a single call over the span is exact. No socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate reached — a self-approved design round. With the mono reverb standing, the stereo reverb (each channel through its own network) and a named-room preset become thin compositions over a proven keystone, ready to climb next.
