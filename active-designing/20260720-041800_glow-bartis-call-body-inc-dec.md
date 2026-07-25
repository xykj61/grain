# Glow Bartis — Call Body Inc / Dec (STOA104)

*Widens the closed bartis call-body set from `double` alone to the same three demo arms core batteries already know: `double` · `inc` · `dec`.*

**Language:** EN  
**Version:** `20260720.041800` (UTC · cloud host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — `tools/glow_lower_bartis_witness.rish` · desk + argv witnesses  
**Waymark:** **STOA104** — bartis call-body `inc` / `dec`  
**Grounds in:** [`20260720-040800_glow-bartis-call-body.md`](20260720-040800_glow-bartis-call-body.md) · `glow/lower_core.rye` closed arm pins

---

## Claim

| Desk | Kind | Body | Baked 5 → expect |
|------|------|------|------------------|
| `gate-double.glow` | Fixture | `%-  double  sample` | `10` |
| `gate-inc.glow` | Fixture | `%-  inc  sample` | `6` |
| `gate-dec.glow` | Fixture | `%-  dec  sample` | `4` |
| `gate-*-u32.glow` | Generator | same bodies | argv `@u32` → matching op |

Unknown gates (e.g. `mix`) still refuse `BodyGateNotYetLowered`.

Still held: wet/gold · `|^` barket tokenize/lower · Sala B0 · open call-body set beyond these three.

---

## Witness

```bash
rishi/bin/rishi run tools/glow_lower_bartis_witness.rish
rishi/bin/rishi run tools/glow_bartis_argv_witness.rish
rishi/bin/rishi run tools/glow_run.rish glow/gen/gate-inc.glow
```

---

*May the closed demo trio stay the named bartis call-body surface until a wider nest earns more arms.*
