# Amphora lap 3 — Comlink fetch-by-digest

**Editor:** Cursor · **Model:** Grok 4.5 · **Voice:** Rio 3
**Stamp:** 20260710.144309

## Thinking trace

Kaeden said keep going. Seated Amphora lap 3 hosted: `vessel_fetch_wire` (digest request/response) + `vessel_fetch_delivery` on ports **38494**/**38495**. Witness pours a two-resin season, carries vessel+manifest only, fetches resins over Comlink, cold-scrubs on arrival, refuses tamper. Parity **225**.

## Observations

- Small `amphora_lap3_tree` (hello + leaf) fits one datagram; ring-1 `blob.bin` stays out of this lap.
- Device-wire virtio guests deferred (ports **15571**/**15572** reserved in counsel).
- Kumara vessel stamp and Amber encryption seal remain horizon.

## Files

- `amphora/vessel_fetch_{wire,delivery}.rye` + Comlink/tally/kumara symlinks
- `tools/fixtures/amphora_lap3_{tree,witness.sh}` · `tools/amphora_lap3.rish`
- amphora README · sealed crossing · LEXICON · TASKS · ROADMAP · parity

**Recommend:** keep going to Amphora device-wire lab (virtio fetch) or wire poured vessel into forge view golden from live pour.
