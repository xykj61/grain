# STOA203 — Append via Sign+Line Compose

*An Acme Corporation employee reading this gets the Glow append path that builds the three-event demo log through product sign and line surfaces, with elder sign/format bodies underneath those wraps.*

**Language:** EN  
**Version:** `20260721.190527` (UDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260721.190527`  
**Register:** Checkable (Two Rooms) — product compose GREEN; elder bodies still underneath sign/line/replay  

**Grounds in:** inventory hold “wire sign+line into append” · [`20260721-190209_stoa201-sign-verify-surface.md`](20260721-190209_stoa201-sign-verify-surface.md) · [`20260721-190240_stoa202-line-format-parse.md`](20260721-190240_stoa202-line-format-parse.md) · STOA195 append port

**dated_guard:** Do **not** claim Glow-rune crypto or a Glow-authored replay body. HAWM1 hex still rests on elder sign/format/replay/digest guts. JABS3 held.

---

## Verdict (one breath)

**APPEND_COMPOSE.** `glow_sala_b0_append.append_event` signs via `glow_sala_b0_sign.sign_fact`, formats via `glow_sala_b0_line.format_log_line`, copies with `tally_copy` — no `sala.append_event`. Demo root still matches fixture and elder `run_demo_fold`. Replay remains elder wrap (STOA196).

---

## Call stack (product path after this lap)

```
NativeActivity
  → glow_sala_b0_fold.run_demo_fold
    → glow_sala_b0_claim.claim_demo_fold
      → glow_sala_b0_replay.claim_replay…
        → glow_sala_b0_append.append_demo…
          → sign.sign_fact → line.format_log_line → copy   # STOA203
        → sala.replay (×2)                                   # still ELDER body
```

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_sala_b0_append_witness.rish
rishi/bin/rishi run tools/glow_sala_b0_fold_witness.rish
```

---

## Hold

Glow-rune crypto jets. Rest / desk deepen (B3) / JABS3. (Replay digest honesty: STOA204.)

---

*May every append name the surfaces it composes, while elder jets still earn the bytes.*
