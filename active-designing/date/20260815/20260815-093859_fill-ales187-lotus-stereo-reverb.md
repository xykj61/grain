# Fill ALES187 — Lotus's stereo reverb: Schroeder's network carried into stereo, the SAME bank on BOTH channels, each channel reverbed through ITS OWN network — the wing's keystone made stereo

**Stamp:** `20260815.093859` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES187
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260815-093042_fill-ales186-lotus-reverb.md`](20260815-093042_fill-ales186-lotus-reverb.md) · [`20260815-091646_fill-ales184-lotus-allpass.md`](20260815-091646_fill-ales184-lotus-allpass.md)

---

## The next crux, honestly chosen

ALES186 seated the mono reverb — Schroeder's network, parallel combs summed then diffused through series allpasses, the keystone the whole time-based wing was climbing toward. A reverb is heard in a room, and a room has two ears; the honest next rung is the stereo reverb, each channel reverbed through its own network. It is the exactly-tractable move now and was intractable an hour ago, because it is the same stereo carry the wing has proven six times — the stereo echo (ALES181), the stereo multi-tap (ALES183), the stereo allpass (ALES185) each ran a proven mono stage on both channels with one shared set of knobs, validated once against the shared length. The reverb is one more mono stage; carrying it into stereo is that same faithful gesture over the keystone.

Crux-first, the stereo reverb also *closes* the wing's stereo picture. The stereo comb and the stereo allpass stand alone; the stereo reverb is the network they were built to compose into, exactly as the mono reverb composed their mono forms. Once it stands, a stereo room preset and a real-time stereo face are thin twins over it, and the time-based wing is whole in both mono and stereo.

## The shape — the same bank on both channels, each through its own network

`stereo_reverb(sc, start, count, combs, allpasses)` runs ALES186's proven mono `reverb` on both channels of a `StereoClip` with the **same** comb-and-allpass bank:

- **The same bank on both channels is the linked stereo reverb.** The combs and the allpasses are counts of sample indices and named fractions the caller names, not scalars measured across the field, so the same bank on each channel gives each ear the same room — the stereo image held, both reverberant tails settling in lockstep. A keeper who wants a wider room widens the *content*, not the bank.
- **Each channel is reverbed through its own network — no cross-channel read.** Mono `reverb` runs every comb on a copy of *its own* clip and diffuses *its own* comb-bank sum; run once per channel, the left reverberates the left's audio and the right the right's, never crossed.
- **The bank and span are validated once against the shared length, before either channel is touched.** ALES186's `precheck` (factored `pub` this round, the mono witness re-run GREEN, mirroring ALES181/185) validates the whole bank and span against the shared length up front, so a refusal never reverbs one channel and leaves the other torn. `StereoReverbError = ReverbError`, reused whole — carrying the reverb into stereo adds no new fault.

## The laws proven

- **The stereo reverb law:** each channel equals ALES186's mono `reverb` with the same bank over the same span, byte for byte, proven side by side with genuinely different per-channel content — the left reverbed by the left's samples, the right by the right's, and the two channels genuinely differing (no crossing).
- **The identical-channel image law:** a centred master (both channels equal) stays identical through the reverb. Honestly noted, exactly as the stereo echo and stereo allpass note it: the reverb's combs and allpasses read their delayed output through a `@divTrunc` recirculation, so an exact panned integer ratio does **not** survive the feedback truncation — the image law claimed is the centred one, the sense a mix cares about, not the stronger both-cases ratio the linear snapshot rungs earn.
- **The silence / balance / atomicity / degenerate law:** an all-silent master reverbs to silence on both; `left.len == right.len` after; an empty bank refuses `NoCombs`, an over-long bank `TooManyStages`, a bad comb or allpass delay `BadDelay`, a feedback or gain at unity `BadGain`, an out-of-range span `BadRange` — each with **both** channels byte for byte untouched and still balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 `Clip`s (left, right), each reverbed through ALES186's own bounded network — bounded whole-clip comb copies, a bounded saturating comb-bank sum, and each allpass's bounded snapshot. It changes sample values only, never a length; the two channels leave balanced. The delays are counts of sample indices, not milliseconds against a clock (a real-time stereo twin through the ALES5 clock is a later rung, exactly as `stereo_echo_time` followed `stereo_echo`); the feedbacks and gains are named fractions, not room sizes in seconds. Because the reverb reads per-call copies and snapshots, split-equals-whole is not claimed; a single call is exact. No cross-channel read, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate reached — a self-approved design round. With the stereo reverb standing, the time-based wing is whole in mono and stereo, and a named-room preset becomes the next thin composition over a proven keystone.
