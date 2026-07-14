# Amphora Amber vessel seal

**Editor:** Cursor · **Model:** Grok 4.5 · **Voice:** Rio 3
**Stamp:** 20260710.153745

## Prompt

keep going

## Thinking trace

After Kumara `stamp_sig` (parity **227**), the next mechanical Amphora vow was Amber's encryption seal on `vessel.bron` — named in the silo as the first of the three pocket beats (seal, sign, hand across). Pond customs stayed held: that policy lap belongs to Pond.

Chose ChaCha20-Poly1305 over the cargo block, shoulder as associated data (readable without opening), witness key seed `0x63`×32 (distinct from stamp `0x62`). Rite order: pour clear cargo → **seal** → **sign**. Scrub verifies stamp on the sealed body, then `open-check` proves the seal opens. Fetcher opens seal in memory to recover digests for Comlink fetch.

## Observations

- New module `amphora/vessel_seal.rye` keeps AEAD beside `vessel_core.rye` so stamp and seal stay one idea each.
- Clear lap-1 fixture remains valid; pour always seals for laps 2+.
- Forge view and lap-3 witness learned sealed form; golden Skate line still reads `cargo 2` via resin entry count.
- Tamper of `seal_cargo` refuses open; stamp tamper still refuses verify.

## Files

- `amphora/vessel_seal.rye` — AEAD seal / open-check / selftest
- `amphora/vessel_core.rye` — parse + canonical accept `seal_*`; version `153745`
- `amphora/vessel_fetch_delivery.rye` — open sealed cargo for digest list
- `amphora/README.md` — seal lap landed
- `tools/fixtures/amphora_pour.sh` · `amphora_scrub_arrival.sh` · `forge_view_pour.sh` · `amphora_lap3_witness.sh` · `amphora_vessel_seal_witness.sh` — seal in the rite
- `tools/amphora_vessel_seal.rish` · `tools/parity.rish` — witness + parity **228**
- `pond/apps/drawn_terminal.rye` — forge view reads sealed vessels
- `work-in-progress/TASKS.md` · `ROADMAP.md` — bench row + witness count
- `external-research/20260710-002952_sealed-crossing-plainly.md` · `20260710-145313_amphora-crossing-plainly.md` · `active-designing/20260703-201612_the-sealed-crossing.md` — seal affirmed Landed
- `session-logs/20260710-153745_amphora-amber-vessel-seal.md` · `session-logs/README.md` — this log

## Next-step recommendation

Recommend: keep going to Pond customs policy at Amphora receipt — first policy lap is Pond's own room, now that seal and stamp both sit on the vessel.
