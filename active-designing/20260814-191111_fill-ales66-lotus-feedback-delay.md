# Fill ALES66 — Lotus's feedback delay: the echo that decays

**Stamp:** `20260814.191111` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; a new primitive built on `timeline.saturate`, the one true saturation)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES66**
**Kin:** [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, `saturate`, `max_clip`, the range law) · [`../lotus/mix.rye`](../lotus/mix.rye) (ALES3 — the same one true saturation reused, the summing lesson) · [`../lotus/README.md`](../lotus/README.md)

---

## Why this rung

The dynamics wing is whole — level (fader, pan), tone (shelf, stack, filters), and dynamics (limiter, compressor, gate, expander, sidechain, de-esser, keyed gate) all stand green. Every one of them changes a sample by reading **the present** — a gain, a threshold crossing, a band. Nothing yet lets a sample **return** — heard again a while later, a little quieter each time. That returning is the foundation of a whole second wing of the craft: the **echo**, and above it the chorus, the flanger, and the reverb, each one a delay line read a different way.

Lindy-first, this is the durable primitive under all of them; crux-first, its one hard, still-tractable correctness is the property a feedback loop owes on integer PCM: **the echo must decay to silence and never wrap**. This rung opens the time-based-effects wing exactly as ALES63's sidechain opened the keyed wing — one primitive, then compositions rather than new machinery.

## The crux — a bounded feedback loop that decays, exactly, on integer PCM

A feedback delay is `y[i] = x[i] + fb · y[i − d]` — each sample is the dry input plus a fraction `fb = num/den` of the **output** one delay `d` earlier, so each echo feeds the next and the train decays. Two facts make it exact and safe:

- **The delay line is the clip buffer itself.** Because the echo is applied **in place, left to right**, `buf[i − d]` for `i − d` inside the span already holds the **output** written earlier this pass — true feedback, no separate delay buffer to size or allocate. For `i − d` before the span it is the dry audio already there; before the clip (`i − d < 0`) it is silence. So the delay memory a keeper would carry across a call boundary lives in the samples themselves: **a span split in two equals the whole once, byte-for-byte, with no extra carried state** — an echo is a read of the samples already present.
- **Feedback below unity decays; the sum saturates once.** The one refusal that keeps the loop safe is `num < den` — a feedback at or above unity would grow without bound (a runaway), so it is refused `BadFeedback` before any write. Below unity each echo is strictly smaller than the last, shrinking to zero within the clip; and a constructive sum past the `i16` rail **saturates** through `timeline.saturate` (ALES3's one true saturation, reused — not re-derived) rather than wrapping.

`fb = 0` (a zero numerator) is the **identity** — the dry signal untouched, the echo turned fully off — the analog of `tone`'s pass-through and the fader column's unity.

## Shape

`lotus/echo.rye` offers `echo(clip, start, count, delay, fb_num, fb_den)`, editing `count` samples from `start` in place. For each sample it reads the dry input `x = buf[i]`, the delayed output `d_out` (`buf[i − delay]` when that index lands within the clip, else silence), and writes `saturate(x + fb·d_out)`. Faults, each refused before any write, the clip untouched on refusal:

- `BadDelay` — a delay of zero (a sample cannot feed back into itself) or longer than `max_clip`.
- `BadFeedback` — a zero denominator, or a numerator at or above the denominator (a feedback that would never decay).
- `BadRange` — a span outside the clip's samples.

No carried form is needed: the delay line is the buffer, so the from-silence form **is** the spanning form.

## The laws to prove

1. **Silence stays silence** — an all-zero clip echoes to all zeros under any legal knobs.
2. **`fb = 0` is the identity** — the dry signal byte-for-byte.
3. **A single impulse yields an exact decaying echo train** — an impulse at `p` with delay `d` and `fb = num/den` lands echoes at `p+d, p+2d, …`, each exactly `fb ×` the last (`@divTrunc`), computed by hand and demanded byte-for-byte.
4. **The echoes decay, never grow** — with `fb < 1` each successive echo's magnitude is strictly smaller, reaching zero within the clip.
5. **A loud constructive sum saturates rather than wraps** — reused from ALES3.
6. **Split equals whole** — echoing `[start, mid)` then `[mid, end)` equals one echo over `[start, end)`, byte-for-byte, with no carried state (the delay line is the buffer).
7. **Each fault refuses by name before any write** — `BadDelay`, `BadFeedback`, `BadRange`, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip, siloed to `lotus/`. The delay is a count of sample **indices**, not milliseconds against a clock (a real-time echo through the ALES5 clock is a later rung, exactly as `fade_ms` followed the index-named fade); the feedback is a plain fraction. No lookahead beyond the in-place delay read, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. This is the first rung of the time-based wing; the single-tap slapback (dry-keyed rather than output-keyed), the modulated delay (chorus, flanger), and the multi-tap and real-time forms follow as later rungs on this foundation.
