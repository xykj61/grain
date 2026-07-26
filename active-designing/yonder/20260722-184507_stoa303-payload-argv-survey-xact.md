# STOA303 — Payload Argv Survey · Xact Tag+Amount Reader

*An Acme Corporation employee reading this gets the Survey deepen after kind unit-tag argv: xact payload `$%` earns a reader that takes `mint <u32>` or `send`, while xfer and pair argv stay refused. Three argv families now sit beside each other without forcing one parse.*

**Language:** EN  
**Version:** `20260722.184507` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — survey seated · xact argv GREEN `20260722.184804`  
**Register:** Checkable (Two Rooms) — emit + desks + witnesses; xfer/pair Intent  

**Grounds in:** STOA302 lean **A** · STOA300 kind argv · STOA293 payload flip family  

**dated_guard:** Do **not** open xfer/pair argv this lap. Do **not** force xact through bare `parseInt` on argv[1]. Gold · fleets · JABS3 stay held.

---

## Survey — argv families (updated)

| Sample mold | Argv | Reader |
|---|---|---|
| `@u32` · amount · count | GREEN | `parseInt(u32, argv[1])` |
| kind (unit `$%`) | GREEN STOA300 | tag `mint`/`send` |
| **xact** (payload `$%`) | **GREEN** STOA303 | tag + amount: `mint <u32>` / `send` |
| xfer · pair…nona | refuse | held |

---

## First code lap (this GREEN)

`emit_xact_argv` on **bartis + barket** · desks `gate-xact-tag.glow` · `gate-barket-xact-tag.glow` · worker two-arg mint path · both lower witnesses GREEN · xfer refuse pinned.

| Later | Claim |
|---|---|
| Xfer argv | two mint faces — thicker |
| Pair…nona argv | multi-field `$:` |
| Held | gold · face_lit · fleets · JABS3 |

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_lower_bartis_witness.rish
rishi/bin/rishi run tools/glow_barket_lower_witness.rish
rishi/bin/rishi run tools/glow_run.rish glow/gen/gate-xact-tag.glow mint 5
```

---

*May every payload tag bring only the faces it needs.*
