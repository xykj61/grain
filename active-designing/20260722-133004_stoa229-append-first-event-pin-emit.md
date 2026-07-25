# STOA229 — Append First Event from Pin Emit

*An Acme Corporation employee reading this gets the thin append wire after STOA228 lean B: the three-event demo log’s first event is copied from `format_demo_line_from_pins`; events 2–3 still sign+line; HAWM1 root stays.*

**Language:** EN  
**Version:** `20260722.133004` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260722.133004`  
**Register:** Checkable (Two Rooms) — first event from pins; fold still claim path; `.glow` not read at runtime  

**Grounds in:** STOA228 lean **B** · STOA227 pin emit · STOA203 sign+line compose · HAWM1 root

**dated_guard:** Do **not** claim events 2–3 come from pins. Do **not** claim fold rewrites to pin emit. Do **not** claim runtime `.glow` parse. JABS3 held.

---

## Verdict (one breath)

**APPEND_PIN_WIRE.** `append_demo_log` seeds event 1 from seated pin emit; root still `99b3ae96…c5fe`.

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_sala_b0_append_witness.rish
```

---

## Hold

Wire fold demo path to pin emit (or rest). Runtime `.glow` file parse. Events 2–3 pin twins. JABS3.
