# The Sealed Crossing — Said Plainly

*A checkable-room note for anyone who hears "Amphora" or "vessel software" and wants the picture: the duty that appears five times, the six-part vessel, the four vows, and the three laps — now seated through hosted and device metal.*

**Stamp:** `20260710.002952`
**Voice:** Rio 3
**Editor:** Cursor · **Model:** Grok 4.5
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable-room research — explains **Landed** Amphora laps 1–3 + stamp + seal (module `amphora/`); commerce and packaging horizons remain open
**Last updated:** 2026-07-10 (affirmed after Amber vessel seal `153745`)
**Ground:** silo [`201612`](../active-designing/20260703-201612_the-sealed-crossing.md) · Amphora study [`201612`](20260703-201612_the-amphora-and-the-crossing.md) · crossing plainly [`145313`](20260710-145313_amphora-crossing-plainly.md) · resins plainly [`235931`](20260709-235931_resins-cellar-vessel-plainly.md) · amber seasons plainly [`002422`](20260710-002422_amber-seasons-plainly.md) · LEXICON Amphora · compass [`185112`](../foundations/20260706-185112_follow-our-compass.md)

*Written by Kaeden and Rio 3 (Grok). Creative climb inside the jail — oldest vessel duty, kitchen voice. Affirmed in place when metal landed.*

---

## In One Breath

**Amber** seals resins **in place** (cellar software).  
**Amphora** carries sealed cargo **in motion** (vessel software) — wire, dock, or coat pocket — and arrives provably whole.

The duty already showed up five ways before it had a home: nightly bench packets, the offsite copy in 3-2-1, the pocket device's "hand across," packaging's fetch-by-digest, commerce's future delivery. One duty, five appearances — the sealed crossing.

**Status today:** Landed through lap 3, Kumara stamp, Amber AEAD seal, large-resin chunking, and Pond customs at receipt. Module home `amphora/`; Pond's first policy lives in `pond/customs.rye`. This page teaches what metal already holds.

---

## The Everyday Picture

Think of a cellar of sealed jars and a traveling amphora. You seal at home (Amber season). When jars must reach another dock or cross a sea, you pour them into a **standard vessel**: one file, sealed, stamped, labeled on the shoulder so a person can read the label without breaking the seal. The road may be Comlink, a USB dock, or a drive in a pocket — the rite stays the same.

Ancient amphorae were standardized shapes with painted shoulders and maker stamps — format versioning and provenance two thousand years early. That archaeology is the metaphor, not a dependency.

---

## Six Parts of the Vessel

| Part | Job |
|------|-----|
| **Vessel** | One file, whole |
| **Seal** | Encryption under Amber's cellar law — ChaCha20-Poly1305 on cargo (`seal_nonce` · `seal_tag` · `seal_cargo`); shoulder stays clear (**landed** `20260710.153745`) |
| **Stamp** | Kumara signature — `stamp_sig` on canonical vessel body (**landed** `20260710.145843`); chrono `stamp` stays the one-clock field |
| **Manifest** | Each enclosed thing: type-mark + digest (working / forever tiers per resins law) |
| **Parent mark** | Lineage hash — today's zip-comment convention made a field |
| **Shoulder line** | Plain human label readable without opening |

---

## Four Vows

1. **Media-agnostic** — wire, dock, or hand; same rite  
2. **Verified twice** — at departure and at receipt  
3. **Fails whole** — damaged vessel refused entirely; no partial trust  
4. **Names its parent** — every vessel a child pointing home

---

## Three Laps (Landed)

| Lap | Completes | Witness |
|-----|-----------|---------|
| **1** | Nightly packet becomes a true vessel — parse + wreck rule | `tools/amphora_lap1.rish` · parity **222** |
| **2** | Amber season poured to a second dock — 3-2-1 fixture | `tools/amphora_lap2.rish` · parity **224** |
| **3** | Comlink fetch-by-digest, verified twice — hosted + device | `tools/amphora_lap3.rish` · `tools/amphora_device_wire.rish` · parity **225**–**226** |

Crossing-manifest seed (parity **151**) graduated into `amphora/manifest_entry.rye`. Elder path still green.

---

## Neighbors Keep Their Rooms

Bron = letter (one record). Amphora = crate (many). MALA = coin inside. Comlink = sea. Kumara = stamp. Amber = cellar left and returned to. Granary = weave-sharing surface (name seated). Mandi = vessel market floor (name seated). Pond = customs at receipt. No duty overlaps.

---

## What This Page Does Not Do

- Mandi market floor seated separately `20260710.165634`; Granary payments/federation still wait  
- Does **not** replace the silo or the study — those remain the design and research homes  

**Landed since first draft:** Kumara vessel stamp (`145843`) · Amber vessel seal (`153745`) · large-resin chunking (`154300`) · Pond customs (`161125`) · purchase delivery (`161358`) · Granary **name** (`163043`) · Granary **lap 1** (`163304`).

---

## Companions

- Silo: [`active-designing/20260703-201612_the-sealed-crossing.md`](../active-designing/20260703-201612_the-sealed-crossing.md)
- Study: [`20260703-201612_the-amphora-and-the-crossing.md`](20260703-201612_the-amphora-and-the-crossing.md)
- Crossing metal plainly: [`20260710-145313_amphora-crossing-plainly.md`](20260710-145313_amphora-crossing-plainly.md)
- Resins / cellar / vessel: [`20260709-235931_resins-cellar-vessel-plainly.md`](20260709-235931_resins-cellar-vessel-plainly.md)
- Amber seasons: [`20260710-002422_amber-seasons-plainly.md`](20260710-002422_amber-seasons-plainly.md)
- Graduation: [`20260709-231011_graduation-rule-plainly.md`](20260709-231011_graduation-rule-plainly.md)
- Module: [`amphora/README.md`](../amphora/README.md)

---

*May every vessel arrive whole or refuse loudly. And may what is sealed at home travel any road — and still be home wherever it lands.*
