# Amphora — vessel software

**Language:** EN
**Stamp:** `20260710.161358`
**Last updated:** `20260801.030237` (Q3 — `amphora version` on stdout · J1 Q4–Q16 in charter)
**Status:** Landed — laps 1–3 + stamp + seal + chunk + purchase delivery; Pond customs gates scrub; forge view folds a live sealed pour · **CLI wave Q3** version metal (pour/carry/restore wait)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)

**Amphora** is **vessel software** — preservation **in motion**. It carries sealed resins across a crossing (wire, dock, or pocket) under the same resins law and Kumara stamp as Amber's cellar.

## CLI surface

Canonical roof: [`src/main.rye`](src/main.rye) — `//!` header + Q3 metal. HTML comment twin retired by accretion (e144). This table is the README surface roof.

| Command | Duty |
|---------|------|
| `amphora version` | free version string on **stdout** · exit 0 |
| `amphora pour <season> <vessel>` | fill vessel · seal then stamp inside pour |
| `amphora carry <vessel> <dock>` | move to far dock · chunk inside carry |
| `amphora restore <vessel>` | cold scrub · verify · restore |

*Q3 lands `version`. Pour/carry/restore wait their quests. Nested wave lean: **the Crossing Season** (seat Keaton's).*

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

**Tensegral Arc I r3** (`20260728.000659`): lap 1 · lap 2 · lap 3 · vessel seal · resin chunk all **GREEN** this sitting — Arc I (Brix · Amber · Amphora) exits.

**Resin homes (one job each — consolidated `20260728.003902`):**

| Home | Job |
|------|-----|
| [`../tools/amphora_resin_chunk.rish`](../tools/amphora_resin_chunk.rish) | Amphora chunk hand — rebuild · chunkdemo · fixture scrub |
| [`../tools/resin_unit_witness.rish`](../tools/resin_unit_witness.rish) | Arc II public resin fold — batch · granary · chunk fixture · TUBE3 |
| [`../tools/tensegral_arc_ii_witness.rish`](../tools/tensegral_arc_ii_witness.rish) | Arc II season fold — resin unit + Glow floors |

*May every vessel stay sealed in motion. May every pour remember its cellar.*
