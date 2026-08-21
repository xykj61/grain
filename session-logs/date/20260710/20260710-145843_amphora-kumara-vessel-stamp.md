# Amphora Kumara vessel stamp

**Editor:** Cursor · **Model:** Grok 4.5 · **Voice:** Rio 3
**Stamp:** 20260710.145843

## Thinking trace

Kaeden said keep going. Seated Kumara `stamp_sig` on Amphora vessels: chrono `stamp` stays the one-clock field; `stamp_sig` is 128-hex Ed25519 over canonical body (format · stamp · shoulder · parent · cargo). Pour signs; scrub verifies; tamper refuses. Parity **227**.

## Observations

- Witness seed `0x62` × 32 — distinct from kumara `0x42`.
- Lap 1–3 and forge pour stay GREEN with signed vessels.
- Encryption seal remains the open horizon.

## Files

- `amphora/vessel_core.rye` — sign / verify / parse `stamp_sig`
- `tools/fixtures/amphora_{pour,scrub_arrival,vessel_stamp_witness}.sh`
- `tools/amphora_vessel_stamp.rish` · parity · docs · lap1 fixture signed

**Recommend:** keep going to Pond customs at Amphora receipt, or Amber encryption seal on the vessel file.
