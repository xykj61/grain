# Glow Bartis — Argv Sample (STOA101)

*Deepens the thin `|=` identity gate so a generator desk reads one `@u32` from Rishi argv, matching G3's cast precursor without rewriting `sample-u32.glow`.*

**Language:** EN  
**Version:** `20260720.040200` (UTC · cloud host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — `tools/glow_bartis_argv_witness.rish` binds fixture vs generator  
**Waymark:** **STOA101** — bartis argv sample beside baked fixture  
**Grounds in:** [`20260720-033852_glow-bartis-g1-row.md`](20260720-033852_glow-bartis-g1-row.md) · [`20260720-022956_stoa92-thin-argv-sample-g3-plan.md`](20260720-022956_stoa92-thin-argv-sample-g3-plan.md) · [`../glow/lower_bartis.rye`](../glow/lower_bartis.rye)

---

## Claim

| Desk | Kind | Sample |
|------|------|--------|
| `glow/gen/gate-sample.glow` | Fixture | Baked `5` (STOA100) |
| `glow/gen/gate-sample-u32.glow` | Generator | One decimal `@u32` from Rishi argv (STOA101) |

Both desks share the same Glow text shape (`|=  sample=@u32` / `sample`). `glow_run --sample-argv` selects the argv emit path; the ordinary lower keeps the baked welcome.

Still held: wet/gold polymorphism · `|^` barket · Sala B0 on Framework.

---

## Witness

```bash
rishi/bin/rishi run tools/glow_bartis_argv_witness.rish
rishi/bin/rishi run tools/glow_lower_bartis_witness.rish
```

---

*May every gate name its sample, and may argv carry it cleanly when the desk asks.*
