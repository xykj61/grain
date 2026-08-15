# Fill ALES92 — Lotus's Schmitt trigger: the hysteresis comparator that gives the square a memory against chatter

**Stamp:** `20260814.224452` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the rung is a bounded, in-process two-threshold comparator carrying one bit of state over one local i16 clip, and the ALES89 infinite-clipper doc named this rung in as many words — *a hysteresis comparator that gives ALES89's square a memory against chatter*)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES92**
**Kin:** [`../lotus/infinite_clip.rye`](../lotus/infinite_clip.rye) (ALES89 — the memoryless comparator this rung gives a memory) · [`../lotus/dc_block.rye`](../lotus/dc_block.rye) (ALES91 — the carried-state idiom this rung reuses, one bit where the blocker carries two i64 states) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, `sample_min`/`max`)

---

## Why this rung

ALES89 landed the **infinite clipper** — a comparator that keeps only the sign, a sine into a square. It is memoryless: every sample is judged against one threshold on its own, with no memory of the last. That is exactly right for a clean signal, and exactly wrong for a noisy one. A real signal riding near the comparator's threshold — a hum on a gate key, a slow envelope crossing zero, a sensor line trembling at its trip point — crosses that single threshold many times in a row, and the memoryless comparator **chatters**: the square output flips high-low-high-low on the noise rather than on the event. The classic answer, a century old in electronics and the front of every real zero-crossing detector, is **hysteresis**: give the comparator two thresholds and a memory of which side it is on. It flips up only when the signal rises past the **upper** threshold, and back down only when it falls past the **lower** one; between the two it holds. The band between the thresholds is a dead zone the noise cannot rattle. The ALES89 doc named this rung plainly — *a hysteresis comparator that gives the square a memory against chatter* — and this is that rung.

Lindy-first, a Schmitt trigger reads true for as long as a signal is a stream of samples judged against a level — it is the debounce at the front of every gate, trigger, tempo-tap, and zero-cross, and it will still be that in ten years. Crux-first, it is the hardest-still-tractable next Lotus move after the dead-zone trilogy and the DC removers: it is the first comparator in the suite to **carry state**, so it inherits ALES91's split-equals-whole discipline where ALES89 could not.

## The crux — a comparator with **hysteresis carries state**, so split equals whole

The infinite clipper is memoryless: run it on two halves of a span and the join is seamless only by accident, because no half remembers the other. This rung is its opposite — it has **memory**, exactly one bit: *which rail am I on right now.* The map is

```
if currently LOW  and x ≥ t_high → flip HIGH   (rise past the upper threshold)
if currently HIGH and x ≤ t_low  → flip LOW    (fall past the lower threshold)
otherwise → hold the current rail
output = +sample_max when HIGH, −sample_max when LOW
```

The band `[t_low, t_high]` is the hysteresis: a signal that only wanders **inside** it never flips, however much it dithers. To run the comparator across a span a caller must carry the one bit — and the moment it carries state, the ALES91 property returns:

> **A span compared in two pieces, the second continuing from the first's ending rail, equals the whole span compared once — byte-for-byte.** No spurious flip at the seam, the false trigger a per-span restart would invent.

That split-equals-whole property is what makes ALES92 the carried-state **sibling** of ALES89 rather than a copy. infinite_clip is memoryless (a comparator with no band); schmitt has memory (a comparator with a band and a remembered rail). The two answer the same word — *which side is the signal on* — for the two signals audio brings: a clean one a single threshold reads perfectly, and a noisy one only hysteresis reads without chatter.

## The from-silence convention — start on the low rail

A carried comparator needs a defined starting rail, the way ALES91 needs defined starting states (both zero). This rung's from-silence convention is the **low rail** (`high = false`, output `−sample_max`): before the signal has risen past `t_high` even once, it has not yet triggered, so it reads low. It is stated plainly rather than inferred, so a fresh `SchmittTrigger` and the from-silence `schmitt` cannot drift — the from-silence form is exactly the `high = false` case of the carried form, one implementation.

## Its own coefficient law — two ordered thresholds inside the rails

The infinite clipper's law is one magnitude threshold in `[0, sample_max]`. A Schmitt trigger's law is a **different** one, and the rung states it as its own — two **signed** comparison points on the raw sample (not a magnitude), ordered:

- `sample_min ≤ t_low` and `t_high ≤ sample_max` — both thresholds are legal sample levels.
- `t_low ≤ t_high` — the lower threshold is at or below the upper. `t_low = t_high` is **legal**: it is the zero-width band, the plain memoryless comparator (which chatters exactly at the shared level and behaves as a hard sign comparator everywhere else) — the degenerate this rung reduces to, exactly as ALES91's `R = 0` is the legal first difference. `t_low > t_high` is an **inverted** band, meaningless, and refuses `BadThreshold`.

## Shape

`lotus/schmitt.rye` offers three faces of one implementation, the ALES91 idiom exactly:

- `schmitt_carry(clip, start, count, high, t_low, t_high)` — the general carried form; the caller owns the one-bit rail.
- `schmitt(clip, start, count, t_low, t_high)` — the from-silence convenience, the `high = false` case of `schmitt_carry` (so the two can never drift).
- `SchmittTrigger { high, t_low, t_high }` — the tiny value a keeper holds beside a clip; `run` continues from the carried rail, `reset` returns it to the low rail.

Two faults, both refused before a sample is touched: `BadThreshold` (an inverted band or a threshold outside the rails) and `BadRange` (a span outside the samples).

## The laws to prove

1. **A fresh trigger is from-silence** — a `SchmittTrigger` on the low rail equals `schmitt` byte-for-byte (one implementation, cannot drift).
2. **Hysteresis resists chatter (the reason it exists)** — a signal that dithers *within* the band after triggering high never flips, where a single-threshold comparator on the same dither chatters flip after flip.
3. **Split equals whole (the crux)** — a span compared in two pieces, the second carrying the first's ending rail, equals the whole compared once, byte-for-byte.
4. **It flips exactly at the band edges** — `x ≥ t_high` forces high, `x ≤ t_low` forces low, and a sample strictly between holds the current rail. Read by hand.
5. **Reset re-opens the low rail** — after a run leaves the trigger high, `reset` returns it to the low rail, so the next run starts low again.
6. **The zero-width band is the plain comparator** — `t_low = t_high` reduces to a memoryless sign comparator away from the exact threshold (legal here, the degenerate).
7. **Only two values ever appear** — every output is `−sample_max` or `sample_max`, whatever the input and band.
8. **The span discipline holds** — only `[start, count)` changes; the samples outside are untouched.
9. **An illegal band refuses `BadThreshold`** — an inverted band (`t_low > t_high`), a `t_low` below the floor, and a `t_high` above the ceiling each refuse, the rail untouched.
10. **An out-of-range span refuses `BadRange`** — the clip untouched before any write.

## Honest scope

Software only, purely local. A bounded in-process buffer of i16 PCM on one bench, siloed to `lotus/`. One two-threshold comparison carrying one bit of state, run sample by sample; the comparison is in i32 so a threshold at the deep rail is representable; only two constants (`±sample_max`) are ever written, each a legal i16 by construction, so no saturate is owed. The "hysteresis" is a static band over instantaneous sample level, not a claim about any hardware comparator or slew rate; no real sample rate, no anti-aliasing, no debounce time constant (the band is over amplitude, not time — a timed debounce is a later rung), no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker.

## What this opens

With the memoryless comparator (ALES89) and the hysteresis comparator (ALES92) both in hand, the comparator family stands answered on both signals — the clean and the noisy. Beyond it the loop names its own next Lotus crux: a **zero-crossing counter** that reads this trigger's flips as a pitch estimate, a **timed debounce** that gives the band a time constant as well as an amplitude one, a **gate keyed on the trigger** (the trigger deciding open/closed for ALES65's keyed gate), or a fresh DSP family — each as its own self-approved design round.
