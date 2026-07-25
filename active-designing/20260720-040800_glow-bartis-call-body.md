# Glow Bartis — Call Body Beyond Identity (STOA103)

*Deepens the thin `|=` gate so the body may be a closed one-arg call (`%-  double  sample`) rather than bare identity — still dry, still `@u32`, still fixture + argv.*

**Language:** EN  
**Version:** `20260720.040800` (UTC · cloud host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — `tools/glow_lower_bartis_witness.rish` · desk + argv witnesses  
**Waymark:** **STOA103** — bartis call-body `%-  double`  
**Grounds in:** [`20260720-033852_glow-bartis-g1-row.md`](20260720-033852_glow-bartis-g1-row.md) · [`20260720-040200_glow-bartis-argv-sample.md`](20260720-040200_glow-bartis-argv-sample.md) · STOA6 `%-` closed demo gate

---

## Claim

| Desk | Kind | Body | Sample |
|------|------|------|--------|
| `glow/gen/gate-sample.glow` | Fixture | identity | Baked `5` → expect `5` |
| `glow/gen/gate-sample-u32.glow` | Generator | identity | Argv `@u32` |
| `glow/gen/gate-double.glow` | Fixture | `%-  double  sample` | Baked `5` → expect `10` |
| `glow/gen/gate-double-u32.glow` | Generator | `%-  double  sample` | Argv `@u32` → expect `sample *% 2` |

Only the closed demo gate `double` is accepted in a bartis call body this lap (same pin as STOA6). Unknown gates refuse `BodyGateNotYetLowered`. Call-sample face must match the bartis sample face.

Still held: wet/gold · `|^` barket tokenize/lower · Sala B0 · open call-body gate set.

---

## Witness

```bash
rishi/bin/rishi run tools/glow_lower_bartis_witness.rish
rishi/bin/rishi run tools/glow_bartis_argv_witness.rish
rishi/bin/rishi run tools/glow_run.rish glow/gen/gate-double.glow
```

---

*May every gate body stay named and closed until a wider surface earns the next arm.*
