# STOA212 — FactFields Parse Surface (C2)

*An Acme Corporation employee reading this gets the Glow product surface that parses canonical FactFields and signed amounts through elder receipt_core, wired into the replay compose path.*

**Language:** EN  
**Version:** `20260721.193404` (UDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260721.193404`  
**Register:** Checkable (Two Rooms) — product wrap GREEN; elder parse bodies underneath  

**Grounds in:** sub-lean **C2** in [`20260721-193220_stoa210-replay-body-inventory.md`](20260721-193220_stoa210-replay-body-inventory.md) · STOA211 replay compose

**dated_guard:** Do **not** claim Glow-authored field parse or Glow source literals. JABS3 held.

---

## Verdict (one breath)

**FIELDS_SURFACE.** `linengrow/glow_sala_b0_fields.rye` wraps `parse_fact_fields` · `parse_amount_signed`. `claim_demo_fields` signs via STOA201 and checks faces. Replay uses this surface (no direct `rc.parse_fact_fields`).

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_sala_b0_fields_witness.rish
rishi/bin/rishi run tools/glow_sala_b0_replay_witness.rish
```

---

## Hold

Glow source literals. Desk deepen (C3). JABS3.
