# STOA197 — Claim Compose onto Append + Replay

*An Acme Corporation employee reading this gets the claim shell that builds and proves the Sala B0 demo root through Glow append and replay ports, while still agreeing bit-for-bit with elder `run_demo_fold`.*

**Language:** EN  
**Version:** `20260721.183253` (UDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260721.183253`  
**Register:** Checkable (Two Rooms) — compose GREEN; NativeActivity pack GREEN; Glow-authored fold body held  

**Grounds in:** [`20260721-183126_stoa196-replay-thin-port.md`](20260721-183126_stoa196-replay-thin-port.md) · [`20260721-175857_stoa185-glow-sala-b0-claim-shell.md`](20260721-175857_stoa185-glow-sala-b0-claim-shell.md) · STOA191 wire

**dated_guard:** Do **not** rewrite elder `sala_b0_fold`. Fixture no longer imports claim (cycle break). JABS3 held.

---

## Verdict (one breath)

**CLAIM_COMPOSE.** `claim_demo_fold` calls `replay.claim_replay_demo_root` (append fixture log → double elder replay → HAWM1 pin). Witness asserts agreement with elder `run_demo_fold`. `stoa191_native_claim_wire_witness` pack GREEN. Fixture `root_pin_agrees` checks fold · HAWM1 only.

---

## Witness

```bash
rishi/bin/rishi run tools/glow_sala_b0_claim_witness.rish
rishi/bin/rishi run tools/stoa191_native_claim_wire_witness.rish
```

---

## Hold

Glow-authored fold body (replace elder append/sign/replay internals). Pixel eyes. JABS3.

---

*May every claim compose its ports before the fold earns a Glow body.*
