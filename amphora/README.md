# Amphora -- vessel software

**Language:** EN
**Stamp:** `20260710.161358`
**Last updated:** `20260801.035204` (e148 -- couples - Cellar supersede)
**Status:** Landed -- laps 1-3 + stamp + seal + chunk + purchase delivery; Pond customs gates scrub; forge view folds a live sealed pour - **CLI wave e150** Q6 pour parse - Class W parked - couples held (carry/restore wait)
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)

**Amphora** is **vessel software** -- preservation **in motion**. It carries sealed resins across a crossing (wire, dock, or pocket) under the same resins law and Kumara stamp as the cellar.

## CLI surface

Canonical roof: [`src/main.rye`](src/main.rye) -- `//!` header + Q3 metal. HTML comment twin retired by accretion (e144). This table is the README surface roof.

| Command | Duty |
|---------|------|
| `amphora version` | free version string on **stdout** - exit 0 |
| `amphora pour <season> <vessel>` | fill vessel - seal then stamp inside pour |
| `amphora carry <vessel> <dock>` | move to far dock - chunk inside carry |
| `amphora restore <vessel>` | cold scrub - verify - restore |

*Q3-Q6: version - bounds - CliError - couples - pour parse (`PourArgs`). Shared bounds agree via `tools/am/amphora_bounds_agree.rish` (path C - alias - couples). Pour/carry/restore wait their quests. Nested wave lean: **the Crossing Season** (seat Keaton's).*

| Lap | What |
|-----|------|
| **1 (landed)** | Manifest entry parse (wreck rule) + vessel `.bron` fields (format - stamp - shoulder - parent - cargo) |
| **2 (landed)** | Pour Cellar ring-1 season into vessel; carry to far dock; cold scrub + restore; 3-2-1 fixture scale |
| **3 (landed)** | Comlink hosted fetch-by-digest for vessel cargo (ports **38494**/**38495**); device-wire virtio lab (**15571**/**15572**) |
| **Stamp (landed)** | Kumara `stamp_sig` on canonical vessel body; verify on pour + scrub |
| **Seal (landed)** | Cellar ChaCha20-Poly1305 on cargo (`seal_nonce` - `seal_tag` - `seal_cargo`); shoulder stays clear; seal then stamp |
| **Chunk (landed)** | Large resin beyond one datagram -- kind **0x33** chunks + `ResinAssembler`; 400 B witness |
| **Purchase delivery (landed)** | Commerce slip binds `vessel_parent` + `payment` under Kumara; Granary is the sharing surface; Mandi is the vessel market floor (seated `165634`) |

**Forge surface:** Realidream `forgeviewtest` pours `amphora_lap3_tree` via `tools/fixtures/forge_view_pour.sh`, then folds the sealed bundle onto Skate (`tools/r/realidream_forge_view.rish`).

**Ground:** silo [`foundations/20260703-201612_the-sealed-crossing.md`](../foundations/20260703-201612_the-sealed-crossing.md) - study [`external-research/20260703-201612_the-amphora-and-the-crossing.md`](../external-research/20260703-201612_the-amphora-and-the-crossing.md) - sealed crossing plainly [`external-research/20260710-002952_sealed-crossing-plainly.md`](../external-research/20260710-002952_sealed-crossing-plainly.md) - crossing metal plainly [`external-research/20260710-145313_amphora-crossing-plainly.md`](../external-research/20260710-145313_amphora-crossing-plainly.md)

**Witnesses:** `tools/am/amphora_lap1.rish` - `tools/am/amphora_lap2.rish` - `tools/am/amphora_lap3.rish` - `tools/am/amphora_device_wire.rish` - `tools/am/amphora_vessel_stamp.rish` - `tools/am/amphora_vessel_seal.rish` - `tools/am/amphora_resin_chunk.rish` - `tools/am/amphora_purchase_delivery.rish` - `tools/p/pond_customs.rish` - `tools/r/realidream_forge_view.rish` - elder path `tools/cr/crossing_manifest_seed.rish`

**Tensegral Arc I r3** (`20260728.000659`): the `amphora_lap1/2/3` witnesses - vessel seal - resin chunk all **GREEN** this sitting -- Arc I (Brix - Cellar - Amphora) exits.

**Resin homes (one job each -- consolidated `20260728.003902`):**

| Home | Job |
|------|-----|
| [`../tools/am/amphora_resin_chunk.rish`](../tools/am/amphora_resin_chunk.rish) | Amphora chunk hand -- rebuild - chunkdemo - fixture scrub |
| [`../tools/r/resin_unit_witness.rish`](../tools/r/resin_unit_witness.rish) | Arc II public resin fold -- batch - granary - chunk fixture - TUBE3 |
| [`../tools/t/tensegral_arc_ii_witness.rish`](../tools/t/tensegral_arc_ii_witness.rish) | Arc II season fold -- resin unit + Glow floors |

*May every vessel stay sealed in motion. May every pour remember its cellar.*
