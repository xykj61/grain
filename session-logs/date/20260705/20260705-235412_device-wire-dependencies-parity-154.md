# Device wire dependencies survey and parity 154

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260705.235412

## Thinking trace

Kaeden asked for external research naming dependencies all the way down to Caravan and Tally for current work, then to continue on the best path. The handoff summary showed device wire sub-laps 1–3 GREEN but parity still at **153** and the ER doc not yet written.

I surveyed the landed stack from SLC-L2 horizon through Linengrow receipt, Comlink (`wire_format`, hosted wire, virtio guests), Aurora `layout.ld`, Rishi witnesses, host seams (QEMU, Zig crypto), and the Caravan/Tally horizon (capabilities table and gardens discipline expressed today as constants and `WireSubject`, not yet imported by freestanding guests).

Wrote [`external-research/20260705-235412_device-wire-dependencies-down-to-caravan-tally.md`](../external-research/20260705-235412_device-wire-dependencies-down-to-caravan-tally.md) with mermaid stack diagram, layer tables, SLC-L2 composition, and gratitude appendix.

Continued recommended path: wired `tools/comlink_device_wire.rish` into `tools/parity.rish` tail → **154**. Updated `work-in-progress/ROADMAP.md`, `TASKS.md`, lap brief ground link, and `external-research/README.md`.

First parity run failed on doorway scan — new ER `Status` line and two prior virtio docs (`231300`, `233012`) lacked room vocabulary post-TWO_ROOMS seating. Fixed Status lines to name **checkable-room** or **research for understanding**. Second parity run GREEN including device wire lab witness (~59s total).

## Observations

- Caravan and Tally are **design contracts** on the device wire hot path today, not runtime imports; the survey states that honestly.
- Doorway witness is a cheap guard — any forward-facing page after `20260705-203144` must name its room in `**Status:**`.
- SLC-L2 next lap is mechanical on hosted Comlink first; identity binding and Open Asks A4 may still need counsel before broad Linengrow feature work.

## Files

- `external-research/20260705-235412_device-wire-dependencies-down-to-caravan-tally.md` — dependency survey (new)
- `external-research/README.md` — index row
- `tools/parity.rish` — Comlink device wire witness block
- `work-in-progress/ROADMAP.md` — 154 witnesses
- `work-in-progress/TASKS.md` — device wire landed section; SLC-L2 next
- `active-designing/20260705-225412_comlink-device-wire.md` — parity 154 wired; ER ground link
- `active-designing/20260705-231300_virtio-tx-counsel-handoff.md` — doorway Status fix
- `active-designing/20260705-233012_virtio-tx-ruling.md` — doorway Status fix
- `session-logs/20260705-235412_device-wire-dependencies-parity-154.md` — this log

**Recommend:** keep going to **SLC-L2 lap brief** — seat `active-designing/` brief for Linengrow receipt over `hosted_wire` (hosted path first); reuse `slcl1_receipt` golden fact and existing seal/open; witness `tools/slcl2_receipt.rish` when the lap shape is clear — mechanical, single-module, follows SLC-L1 + Comlink patterns already landed.
