# Glow Bartis — TAME Tidy (STOA105)

*An Acme Corporation employee reading this gets the tidy claim for `rune_bartis` / `lower_bartis` after the call-body widen: u32 cursors, `append_print`, `copy_disjoint`, overflow seat — behavior unchanged.*

**Language:** EN  
**Version:** `20260720.042300` (UTC · cloud host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — `tools/glow_lower_bartis_witness.rish` TAME gates · `tools/tame_style_check.rish` overflow seat  
**Waymark:** **STOA105** — TAME tidy bartis modules  
**Grounds in:** STOA96 `lower_mold` tidy · [`20260707-164612_tame-tidy-rules-brief.md`](20260707-164612_tame-tidy-rules-brief.md)

---

## Claim

| Surface | Tidy |
|---------|------|
| `glow/lower_bartis.rye` | `zig_safe_ident` → `u32` · `append_print` · split prelude/gate/main emitters |
| `glow/rune_bartis.rye` | `copy_disjoint` retires memcpy · `parse_body` split |
| Ban overflow | `tools/tame_style_scan_bans.rish` one-file pass (256 roster unchanged) |
| Width list | `tools/width-check.rish` names `glow/lower_bartis.rye` |

Desks and call-body semantics unchanged from STOA100–104.

---

## Witness

```bash
rishi/bin/rishi run tools/glow_lower_bartis_witness.rish
rishi/bin/rishi run tools/tame_style_check.rish
rishi/bin/rishi run tools/glow_run_desk_witness.rish
```

---

*May every widen earn its tidy before the next surface opens.*
