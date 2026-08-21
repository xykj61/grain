# Fill ALES144 — `lotus/stereo_schmitt.rye`, the Schmitt trigger carried into stereo, the first state-carrying comparator in stereo

**Stamp:** `20260815.044135` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES144**
**Kin:** [`20260815-043212_fill-ales143-lotus-stereo-infinite-clip.md`](20260815-043212_fill-ales143-lotus-stereo-infinite-clip.md) · [`20260814-224452_fill-ales92-lotus-schmitt-trigger.md`](20260814-224452_fill-ales92-lotus-schmitt-trigger.md)

---

## Where the ladder stands

The stereo dead-zone family closed last round (hard center clip ALES141 · soft ALES142 · infinite clip ALES143) — three readings of the survivor's fate, all **memoryless**: each sample judged on its own. This rung crosses to the class's **state-carrying** sibling, ALES92's **Schmitt trigger**, and lifts it to stereo. A comparator with hysteresis flips **high** on a rise past `t_high`, **low** on a fall past `t_low`, and **holds** between — the band `[t_low, t_high]` a dead zone the noise cannot rattle. It is the crux-first next step: harder than a memoryless map precisely because it carries a bit, which makes the stereo lift genuinely new rather than a fourth copy of the same shape.

## The crux this round — two independent rails, and the honest parting from the memoryless family

Carried into stereo, the trigger carries **one bit per channel**. Each channel remembers its **own** rail, both opened from the same low-rail convention (`high = false` at silence), so the two rails advance **independently**:

- An **identical-channel master** (`left = right`) stays identical — the two rails track together, a mono-in-stereo signal never splits.
- An **out-of-phase master** (`right = −left`) does **not** in general come back out of phase. This is where the state-carrying member honestly **parts** from the memoryless family: the three clips are **odd** maps, so a shared rail held the inter-channel antisymmetry; the from-silence convention opens **both** channels on the **low** rail, so the Schmitt map is not odd about the band. Each channel simply remembers its own crossing history. Stated positively: both channels agree on the shared low start rather than negating it.

## The carried-state crux, in stereo

Because each channel carries its own bit, a stereo span run in **two pieces** through `StereoSchmitt` — each channel's second piece continuing **that channel's** ending rail — equals the whole run **once**, byte for byte on both channels: no spurious flip at the seam on either speaker. That is ALES92's own crux (the ALES91 shape, one bit per channel) carried faithfully into stereo, and it is the whole reason `StereoSchmitt` holds two `SchmittTrigger`s rather than restarting from silence each call.

## The crux, as a lift

`stereo_schmitt(sc, start, count, t_low, t_high)` triggers `[start, start+count)` in **both** channels of a `StereoClip`, each channel from silence, running ALES92's mono `schmitt` with the same band. `StereoSchmitt` mirrors ALES92's carried `SchmittTrigger` — two triggers built with one shared band through a single `init`, so left and right can never drift; `run` continues each channel's own rail, `reset` re-opens both low. Both forms validate the shared band and length **once** via ALES92's own `precheck` before either channel is touched, so a refusal never triggers one channel, or advances one rail, and leaves the other whole. `SchmittError` reused whole — the stereo lift adds no fault.

## The four laws proven

- **THE STEREO SCHMITT LAW** — each channel equals ALES92's mono `schmitt` (from silence) with the same band over the same span, **byte for byte**.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length (a trigger writes values only).
- **THE INDEPENDENT-RAIL LAW** — each channel carries its own bit from the shared low-rail convention, so an identical-channel master stays identical while the two rails otherwise advance independently (an out-of-phase master **not** held out of phase — the honest parting from the memoryless odd family); the zero-width band (`t_low = t_high`) is the plain comparator on both.
- **THE CARRIED-STATE / ATOMICITY / DEGENERATE LAW** — a two-piece `StereoSchmitt` run equals the whole once byte for byte on both channels (no seam flip); any refusal (`BadThreshold`, `BadRange`) leaves **both** channels byte for byte untouched, **both** rails untouched, and the pair balanced; `count = 0` the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips, siloed to `lotus/`. It changes sample values only, through ALES92's own `schmitt`; the shape is a static two-threshold hysteresis band over instantaneous amplitude carrying one bit of rail state per channel, with no time constant and no debounce interval (a timed debounce is a later rung). No saturate is owed — every output is one of the two rails, a legal i16 by construction. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_schmitt.rye` — the module.
- `tools/ales_stereo_schmitt_witness.rish` — the witness.
