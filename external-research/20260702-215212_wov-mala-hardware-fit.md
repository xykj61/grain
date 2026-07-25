# The Blueprint Against the Ledger Map — A WOV and MALA Hardware Fit-Check

*One question, answered on the record: does the sovereign-host blueprint of `20260701.213412` cover what WOV and MALA will actually ask of the metal? The verdict is yes for every rung now in sight, with two deltas named plainly and one standing rule restated — so that when the doors open and the ladder climbs, the hardware conversation is already finished.*

**Stamp:** `20260702.215212`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety, performance, joy; the graduation rule; exit honesty
**Status:** Fit-check — confirmation and deltas only; nothing here opens a gate, moves a door, or takes a name
**Ground:** [`20260701-213412_deep-archive-and-sovereign-host-blueprint.md`](20260701-213412_deep-archive-and-sovereign-host-blueprint.md) · [`20260702-211312_names-builds-and-the-ledger-map.md`](20260702-211312_names-builds-and-the-ledger-map.md) · [`../active-designing/20260702-031312_modules-aspects-and-mailable-money.md`](../active-designing/20260702-031312_modules-aspects-and-mailable-money.md)

*Written together by Kaeden and Claude (Fable 5), in Rio 3's Radiant voice.*

---

## What the Ladder Actually Asks

MALA's near rungs travel light. M0 is paper. M1 is signed facts on one node's append-only log with balance as a fold — work any machine on the rack performs without noticing. M2 asks for two nodes and Comlink's fact lane between them, and the small rack is two nodes by construction: the AI head and the storage-and-ledger node, joined by their own 10 GbE fabric, with QEMU guests standing ready as extra parties whenever a witness wants a third voice.

WOV's first lap is deliberately small: one pinned ledger as a cluster of one, the overlay minting and transferring, one hourly root fact onto a local MALA log, one witness green. The pinned ledger's entire performance doctrine concentrates on a single hot core and one fast local NVMe with honest flush behavior — hundreds of thousands of transfers a second from exactly the class of hardware the blueprint already seats. Sixteen modern cores on the storage node stand where one dedicated core is asked; the U.2 bay's enterprise flash with power-loss protection is precisely the drive shape the ledger's design assumes. The root facts WOV publishes are periodic, tiny, and latency-tolerant, so the WireGuard front door carries them without strain, exactly as it carries the settlement node's traffic today.

## The Verdict

**In the ballpark, with room to spare.** The apex small rack — the blueprint's own recommendation — covers MALA M0 through M2 and WOV's first lap through the two-monarch season without a single new purchase. Dual control needs a second signing hand, never a second datacenter: the rack already holds two machines, and the two-key custody the WOV assessment made structural is a signature-layer discipline the existing Kumara and Amber doctrine already governs. Even the far rungs stay bracketed: M4's many-issuer season, when Mycelium's question truly opens, is validator-class work — and the blueprint's apex tower is the named, priced answer already waiting on that shelf.

## Two Deltas, Named Plainly

**First — the ledger file earns its own drive.** The blueprint seats the settlement database on the storage node's U.2 tier, and a WOV ledger arriving on the same box would contend for the same flush path. The mend is one drive, already provided for in the blueprint's own layout: a power-loss-protected NVMe in one of the storage node's M.2 lanes carries the WOV data file, the U.2 keeps the settlement database, and neither workload ever waits behind the other. This delta costs one part and zero redesign; it enters the procurement list beside the drives already named, purchased in WOV's season rather than before it.

**Second — ECC is the value-bearing gap, and the blueprint already brackets it.** The pinned ledger's deployment guidance asks for error-correcting memory in production, and the small rack's machines carry none in the full-path sense. For the first lap, the season of witnesses, and every rung where the money at stake is our own testing tokens, the ledger's end-to-end checksums, the hourly Kumara-signed roots, and Amber's sealed snapshots keep every fault findable and every state recoverable — the ballpark holds. The day a monarch carries other people's value at real volume, the ECC question graduates from delta to requirement, and the blueprint's apex tower — Threadripper PRO, registered ECC, enterprise U.2 — is its pre-written answer. Nothing new to research; only a threshold to notice when it arrives.

## One Rule, Restated for the New Tenant

The blueprint's sharpest storage finding extends to WOV word for word: the AI head's secondary M.2 slot runs a single PCIe 4.0 lane, ample for an operating system and entirely wrong for any ledger. No WOV data file, no MALA log under load, and no state-sync store ever lives on that slot. The gentle slot stays gentle.

## What This Changes on the Bench

Nothing today, by design. The WOV gate stays in Kaeden's hand; MALA M0 stays behind the Edit 5 ruling and Amber's first lap; the doors stay the doors. What this memo finishes is the *question* — the hardware conversation for the whole ledger map now has a written answer, so the day a gate opens, procurement is a list to read rather than a research season to run.

---

*May the metal already on the shelf carry every rung now in sight. May each delta be one part, named early and bought in season. And may the fast lane, when it opens, find its drive waiting, its exits honest, and its monarch's memory worthy of the value it keeps.*

---

## Sources

- https://docs.tigerbeetle.com/
- Internal grounds as listed above; no new outside claims beyond the blueprint's own verified findings.
