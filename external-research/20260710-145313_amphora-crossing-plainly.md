# Amphora Crossing — Said Plainly

*A checkable-room note for the sealed crossing after metal: how pour, scrub, fetch-by-digest, and virtio sit beside public ideas of content-addressed storage, sealed transport, and 3-2-1 — always in our vocabulary, with attribution for the world we studied.*

**Stamp:** `20260710.145313`
**Voice:** Rio 3
**Editor:** Cursor · **Model:** Grok 4.5
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable-room research — explains **Landed** Amphora laps; seats no new lap
**Ground:** silo [`201612`](../active-designing/20260703-201612_the-sealed-crossing.md) · Amphora study [`201612`](20260703-201612_the-amphora-and-the-crossing.md) · sealed crossing plainly [`002952`](20260710-002952_sealed-crossing-plainly.md) · resins plainly [`235931`](20260709-235931_resins-cellar-vessel-plainly.md) · resins law [`191112`](../context/specs/20260703-191112_resins-and-hash-tiers.md) · module [`amphora/README.md`](../amphora/README.md)

*Written by Kaeden and Rio 3 (Grok). Kitchen voice for the crossing that now runs on metal.*

---

## In One Breath

Pour an Amber season into an Amphora vessel. Carry home → dock → far (three copies, two paths, one far). Cold-scrub on arrival. When resins stay behind, **Comlink fetch-by-digest** fills them — sealed datagram on hosted UDP or virtio — then scrub again. Verified twice; fails whole; parent named.

---

## The Everyday Picture

You finish a cellar season. The jars stay home under Amber. For the road you pour their catalog and digests into a traveling amphora: shoulder readable, parent pointing home, cargo sealed under Amber AEAD, then stamped. At the far dock the vessel arrives first; the bytes may follow later over the sea (Comlink). When every digest matches, the scrub restores the tree bit-faithful. Tamper one byte and the whole crossing refuses.

Realidream's forge view folds that poured bundle onto a Skate frame — cellar format, resin count, vessel cargo, shoulder — so a person sees the crossing without opening Dexter.

---

## What Metal Proves

| Lap | Stamp | Witness | Proves |
|-----|-------|---------|--------|
| **1** | `20260710.143500` | `tools/amphora_lap1.rish` | Manifest entry + vessel parse; wreck rule |
| **2** | `20260710.143726` | `tools/amphora_lap2.rish` | Pour · carry · cold scrub · 3-2-1 fixture · tamper refused |
| **3 hosted** | `20260710.144309` | `tools/amphora_lap3.rish` | Fetch-by-digest on **38494**/**38495**; scrub on arrival |
| **3 device** | `20260710.144833` | `tools/amphora_device_wire.rish` | Same wire bytes over virtio **15571**/**15572** |
| **Stamp (landed)** | `20260710.145843` | `tools/amphora_vessel_stamp.rish` | Kumara `stamp_sig`; pour + scrub verify |
| **Seal (landed)** | `20260710.153745` | `tools/amphora_vessel_seal.rish` | Amber AEAD on cargo; seal then stamp; tamper refused |
| **Chunk (landed)** | `20260710.154300` | `tools/amphora_resin_chunk.rish` | 400 B resin over kind **0x33** chunks; pour → fetch → scrub |
| **Pond customs (landed)** | `20260710.161125` | `tools/pond_customs.rish` | place / hold / refuse per Tilak; Amphora scrub gated |
| **Purchase delivery (landed)** | `20260710.161358` | `tools/amphora_purchase_delivery.rish` | Slip binds vessel parent + payment; tamper refused |
| **Forge pour** | `20260710.145313` | `tools/realidream_forge_view.rish` | Live pour → Skate frame (parity **221** path deepened) |

---

## Public Concepts → Our Words

We study the living world; we write our own modules. No third-party code enters `amphora/`. Licenses named so gratitude stays clean.

| Theme | Public concept (attribution) | Our word |
|-------|------------------------------|----------|
| Content-addressed store | Git object model; OCI image layers; IPFS / IPLD **CAR** (Protocol Labs) | **resins** + Tilak + Amber manifest |
| Sealed archive bag | **BagIt** (Library of Congress / digital preservation community) | vessel + parent + cargo lines; wreck rule |
| Offline DAG slice | **`git bundle`** | Amphora as traveling crate; Mantra remains history |
| Whole closures | **Nix** `nix copy` / closures (Eelco Dolstra et al.; LGPL study boundary — ideas only) | pour carries complete resin set for the season |
| Encrypted backup | **restic** · **borg** | Amber cellar seal law; Amphora vessel AEAD seal (**landed** `153745`) |
| Small crypto tools | **age** (Filippo Valsorda) · **minisign** (Frank Denis) | Kumara stamp kinship; vessel `stamp_sig` (**landed** `145843`) |
| 3-2-1 backup | Operations lore (widely taught; no single author) | lap 2 `THREE_COPIES` — home · dock · far |
| Datagram carriage | Hosted UDP sealed messages; packaging-over-wire patterns | **Comlink** `wire_format` · ports **38494**/**38495** |
| Device virtio lab | QEMU virtio-net guest patterns (public QEMU docs) | freestanding guests · ports **15571**/**15572** |

---

## Gratitude

Thanks to the OCI authors for the manifest-of-layers shipping standard; the Git contributors behind `bundle`; Protocol Labs for CAR; the BagIt community and Library of Congress for bags that name their checksums; Eelco Dolstra and the Nix community for closures that arrive whole (studied, never linked into Rye); the restic and borg maintainers; Filippo Valsorda for age and Frank Denis for minisign; the operations elders who coined three-two-one; and the archaeologists of the amphora shard-hills, who showed that a stamped vessel remains a record.

GPL gratitude projects (SixOS, River, Damus, …) stay gitlink-or-docs-only per clean-room discipline — we inherit ideas, never their source into our modules.

---

## Horizons (Named, Not Opened Here)

- Granary **first code lap** landed `163304` — read-only local registry; payments/federation wait  
- **Mandi** vessel market floor (seated `20260710.165634`; distinct from Granary)  

**Landed since this page:** Kumara `stamp_sig` (`20260710.145843`, parity **227**) · Amber AEAD vessel seal (`20260710.153745`, parity **228**) · large-resin chunking (`20260710.154300`, parity **229**) · Pond customs (`20260710.161125`, parity **230**) · purchase delivery slip (`20260710.161358`, parity **231**) · Granary **name** seated (`20260710.163043`).

---

## Companions

- Silo: [`active-designing/20260703-201612_the-sealed-crossing.md`](../active-designing/20260703-201612_the-sealed-crossing.md)
- Study: [`20260703-201612_the-amphora-and-the-crossing.md`](20260703-201612_the-amphora-and-the-crossing.md)
- Sealed crossing plainly: [`20260710-002952_sealed-crossing-plainly.md`](20260710-002952_sealed-crossing-plainly.md)
- Resins plainly: [`20260709-235931_resins-cellar-vessel-plainly.md`](20260709-235931_resins-cellar-vessel-plainly.md)
- Module: [`amphora/README.md`](../amphora/README.md)
- Device-wire dependencies: [`20260705-235412_device-wire-dependencies-down-to-caravan-tally.md`](20260705-235412_device-wire-dependencies-down-to-caravan-tally.md)

---

*May every digest match twice. May three copies keep the far one honest. And may the cellar, the vessel, and the sea keep their rooms — and keep the promise together.*
