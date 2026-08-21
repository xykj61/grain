# Fill ALES145 — `lotus/stereo_zero_cross.rye`, the zero-crossing counter carried into stereo, the suite's first stereo analysis rung

**Stamp:** `20260815.044940` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES145**
**Kin:** [`20260815-044135_fill-ales144-lotus-stereo-schmitt.md`](20260815-044135_fill-ales144-lotus-stereo-schmitt.md) · [`20260814-225557_fill-ales93-lotus-zero-crossing-counter.md`](20260814-225557_fill-ales93-lotus-zero-crossing-counter.md)

---

## Where the ladder stands

Last round carried the Schmitt trigger's **write** into stereo (ALES144 `stereo_schmitt`: two rails writing two clips). This round carries its **read**. ALES93's `zero_cross` is the suite's first **analysis** rung — it walks a span, counts how many times the trigger flips rail, and returns that count with the clip untouched. A zero crossing in the hysteresis sense *is* a rail flip, so counting flips reads how many times the signal genuinely crossed, past the noise the band already suppresses: the oldest activity/pitch estimate there is. Carried into stereo, it is the suite's **first stereo analysis rung** — two counters reading two channels, writing not one sample.

## The crux this round — two independent counts, and the seam flip counted once per channel

Each channel carries its **own** counter (trigger rail, running count, previous-rail memory), so the two counts are **independent**: an identical-channel master reads **equal** counts, while a busy left over a calm right reports **more** crossings on the left. A keeper reads left and right apart, exactly as the stereo meter (ALES17) reads two levels — this rung mirrors that analysis shape.

ALES93's crux is that a flip can land exactly at the **seam** between two counted pieces, so its counter carries both the rail and the previous output rail across a call, and a span counted in two pieces equals the whole counted once. Carried into stereo, `StereoZeroCounter` holds that carried state **per channel**, so a stereo span counted in two pieces — each channel's second piece continuing **that channel's** rail and previous-rail memory — equals the whole counted once **on both** channels: neither speaker's seam flip is missed or doubled. ALES93's crux made stereo.

## The crux, as a lift

`count_crossings_stereo(sc, start, count, t_low, t_high)` counts both channels of a `StereoClip` from silence and returns the pair `StereoCrossings{left, right}`. `StereoZeroCounter` mirrors ALES93's carried `ZeroCounter` — two counters built with one shared band through a single `init` (so left and right can never drift), `feed` continuing each channel's own state, `crossings_left`/`crossings_right` reading the two counts apart, `reset` returning both to silence. Both forms validate the shared band and length **once** via ALES92's own `precheck` before either channel is read, so a refusal never counts one channel and leaves the other's state moved. `ZeroCrossError` reused whole.

## The four laws proven

- **THE STEREO ZERO-CROSS LAW** — each channel's count equals ALES93's mono `count_crossings` (from silence) with the same band over the same span.
- **THE READ-ONLY / BALANCE LAW** — the source `StereoClip` is byte for byte unchanged after counting (both channels), and the two channels stay balanced (reading writes nothing).
- **THE INDEPENDENT-COUNTER LAW** — each channel carries its own counter, so an identical-channel master gives equal counts while a busier channel counts more; hysteresis suppresses chatter counting on each; silence and in-band-only count zero on both.
- **THE CARRIED-STATE / ATOMICITY / DEGENERATE LAW** — a two-piece `StereoZeroCounter` count equals the whole count once on both channels (each seam flip counted once); any refusal (`BadThreshold`, `BadRange`) leaves both counters untouched and the clip unchanged; `count = 0` the identity (zero crossings) on both.

## Honest scope

Software only, purely local, **read-only**. Two bounded in-process i16 Clips, siloed to `lotus/`, never mutated by this rung. Each count is a pure sample count of rail flips over the trigger's hysteresis band (so it already resists the chatter a raw sign change would miscount), **not** a pitch in Hz — a real pitch is `crossings / (2 · duration · sample_rate)`, and there is no real sample rate in the suite yet, so this reports the raw honest count per channel and names the pitch conversion a later rung. No anti-aliasing, no windowing, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_zero_cross.rye` — the module.
- `tools/ales_stereo_zero_cross_witness.rish` — the witness.
