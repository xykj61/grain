# Amphora — vessel software

**Language:** EN
**Stamp:** `20260710.161358`
**Last updated:** 2026-07-10 (Radiant pass `182821`)
**Status:** Landed — laps 1–3 + stamp + seal + chunk + purchase delivery; Pond customs gates scrub; forge view folds a live sealed pour
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)

**Amphora** is **vessel software** — preservation **in motion**. It carries sealed resins across a crossing (wire, dock, or pocket) under the same resins law and Kumara stamp as Amber's cellar.

| Lap | What |
|-----|------|
| **1 (landed)** | Manifest entry parse (wreck rule) + vessel `.bron` fields (format · stamp · shoulder · parent · cargo) |
| **2 (landed)** | Pour Amber ring-1 season into vessel; carry to far dock; cold scrub + restore; 3-2-1 fixture scale |
| **3 (landed)** | Comlink hosted fetch-by-digest for vessel cargo (ports **38494**/**38495**); device-wire virtio lab (**15571**/**15572**) |
| **Stamp (landed)** | Kumara `stamp_sig` on canonical vessel body; verify on pour + scrub |
| **Seal (landed)** | Amber ChaCha20-Poly1305 on cargo (`seal_nonce` · `seal_tag` · `seal_cargo`); shoulder stays clear; seal then stamp |
| **Chunk (landed)** | Large resin beyond one datagram — kind **0x33** chunks + `ResinAssembler`; 400 B witness |
| **Purchase delivery (landed)** | Commerce slip binds `vessel_parent` + `payment` under Kumara; Granary is the sharing surface; Mandi is the vessel market floor (seated `165634`) |

**Forge surface:** Realidream `forgeviewtest` pours `amphora_lap3_tree` via `tools/fixtures/forge_view_pour.sh`, then folds the sealed bundle onto Skate (`tools/realidream_forge_view.rish`).

**Ground:** silo [`active-designing/20260703-201612_the-sealed-crossing.md`](../active-designing/20260703-201612_the-sealed-crossing.md) · study [`external-research/20260703-201612_the-amphora-and-the-crossing.md`](../external-research/20260703-201612_the-amphora-and-the-crossing.md) · sealed crossing plainly [`external-research/20260710-002952_sealed-crossing-plainly.md`](../external-research/20260710-002952_sealed-crossing-plainly.md) · crossing metal plainly [`external-research/20260710-145313_amphora-crossing-plainly.md`](../external-research/20260710-145313_amphora-crossing-plainly.md)

**Witnesses:** `tools/amphora_lap1.rish` · `tools/amphora_lap2.rish` · `tools/amphora_lap3.rish` · `tools/amphora_device_wire.rish` · `tools/amphora_vessel_stamp.rish` · `tools/amphora_vessel_seal.rish` · `tools/amphora_resin_chunk.rish` · `tools/amphora_purchase_delivery.rish` · `tools/pond_customs.rish` · `tools/realidream_forge_view.rish` · elder path `tools/crossing_manifest_seed.rish`

*May every vessel stay sealed in motion. May every pour remember its cellar.*
