# STOA211 — Replay Line·Sign·Digest Compose (C1)

*An Acme Corporation employee reading this gets the Glow replay path that scans the demo log through product line parse, sign verify, and digest — without calling elder `sala.replay`.*

**Language:** EN  
**Version:** `20260721.193303` (UDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260721.193303`  
**Register:** Checkable (Two Rooms) — product compose GREEN; FactFields/amount parse still elder  

**Grounds in:** sub-lean **C1** in [`20260721-193220_stoa210-replay-body-inventory.md`](20260721-193220_stoa210-replay-body-inventory.md) · STOA202 · STOA201 · STOA204

**dated_guard:** Do **not** claim Glow-rune crypto. FactFields parse: STOA212. JABS3 held.

---

## Verdict (one breath)

**REPLAY_COMPOSE.** `glow_sala_b0_replay.replay` splits lines, then `line.parse_log_line` · actor check · `sign.verify_record` · strict seq · `digest.digest_log_bytes`. No `sala.replay(`. Fixture + elder fold agree.

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_sala_b0_replay_witness.rish
rishi/bin/rishi run tools/glow_sala_b0_fold_witness.rish
```

---

## Hold

Glow source literals. Desk deepen (C3). JABS3. (Fields surface: STOA212.)
