# STOA305 — Payload Argv Survey · Xfer Tag+From+Amount Reader

*An Acme Corporation employee reading this gets the Survey deepen after xact payload argv: xfer’s multi-face mint earns a reader that takes `mint <from> <amount>` or `send`, while pair…nona argv stay refused. Four argv families now sit beside each other without forcing one parse.*

**Language:** EN  
**Version:** `20260722.185953` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — survey seated · xfer argv GREEN `20260722.185953`  
**Register:** Checkable (Two Rooms) — emit + desks + witnesses; pair…nona Intent  

**Grounds in:** STOA304 lean **C** · STOA303 xact argv · STOA125 xfer mold  

**dated_guard:** Do **not** open pair…nona argv this lap. Do **not** collapse xfer through xact’s one-face reader. Gold · fleets · JABS3 stay held.

---

## Survey — argv families (updated)

| Sample mold | Argv | Reader |
|---|---|---|
| `@u32` · amount · count | GREEN | `parseInt(u32, argv[1])` |
| kind (unit `$%`) | GREEN STOA300 | tag `mint`/`send` |
| xact (payload `$%`) | GREEN STOA303 | tag + amount: `mint <u32>` / `send` |
| **xfer** (multi-face payload `$%`) | **GREEN** STOA305 | tag + two faces: `mint <from> <amount>` / `send` |
| pair…nona | refuse | held |

---

## First code lap (this GREEN)

`emit_xfer_argv` on **bartis + barket** · desks `gate-xfer-tag.glow` · `gate-barket-xfer-tag.glow` · worker three-arg mint path · both lower witnesses GREEN · pair refuse pinned.

| Later | Claim |
|---|---|
| Pair…nona argv | multi-field `$:` |
| Held | gold · face_lit · fleets · JABS3 |

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_lower_bartis_witness.rish
rishi/bin/rishi run tools/glow_barket_lower_witness.rish
rishi/bin/rishi run tools/glow_run.rish glow/gen/gate-xfer-tag.glow mint 5 3
```

---

*May every mint face arrive in its own argv slot.*
