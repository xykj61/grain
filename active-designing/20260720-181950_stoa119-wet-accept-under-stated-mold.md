# STOA119 — Wet-Sample Nest Accept Under Stated Mold

*An Acme Corporation employee reading this gets the thinnest honest nest/type deepen that earns wet *accept* under bounds — STOA102 checklist step 5 / STOA106 step 5 — without flipping `assert_sample_not_wet`, inventing Glow wet syntax, or shipping ambient gold polymorphism.*

**Language:** EN  
**Version:** `20260720.181950` (UTC · cloud host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — bound by `tools/glow_nest_type_witness.rish`  
**Register:** Checkable (Two Rooms) — wet-nests accept×2 molds · refuse×2 · STOA110 refuse held  
**Grounds in:** [`20260720-040700_stoa102-barket-horizon-wording.md`](20260720-040700_stoa102-barket-horizon-wording.md) · [`20260720-042931_stoa106-nest-type-surface-wording.md`](20260720-042931_stoa106-nest-type-surface-wording.md) · [`20260720-150635_stoa110-wet-refuse-nest.md`](20260720-150635_stoa110-wet-refuse-nest.md) · [`20260720-181347_stoa118-named-mold-barket.md`](20260720-181347_stoa118-named-mold-barket.md)

**dated_guard:** Do **not** edit the dated STOA102 / STOA106 / STOA110 wording artifacts. Seat this lap in *this* brief and living pins when GREEN.

---

## Verdict (one breath)

**WET_ACCEPT_THIN.** Add `nest_type.assert_sample_wet_nests` — when `is_wet=true`, accept only if the sample nests under a **stated** closed mold (`@u32` aura equality or `amount-mold` named-mold allowlist). When `is_wet=false`, return (dry path unchanged). Keep `assert_sample_not_wet(true)` as unconditional refuse. Witness proves **two molds share one wet path**. No Glow wet spelling. No gold cores. Barket/bartis keep hardcoding dry (`assert_sample_not_wet(false)`).

---

## Why not a boolean flip

STOA110 already seats refuse:

```71:73:glow/nest_type.rye
pub fn assert_sample_not_wet(is_wet: bool) NestError!void {
    if (is_wet) return error.SampleDoesNotNest;
}
```

Barket hardcodes the dry pin:

```153:153:glow/rune_barket.rye
    nest_type.assert_sample_not_wet(false) catch return error.SampleDoesNotNest;
```

Flipping that API so `is_wet=true` accepts would GREEN a boolean, not a nest. STOA106 step 5 asks for something stronger: *multiple molds share one wet path under witness*.

---

## API shape (implement lap)

```rye
/// Wet-sample accept under a stated closed mold.
/// Dry (`is_wet=false`): no-op success.
/// Wet (`is_wet=true`): sample must nest under stated_mold via
///   assert_aura_nests (aura path) or assert_bartis_named_mold (named path).
pub fn assert_sample_wet_nests(
    is_wet: bool,
    sample: []const u8,
    stated_mold: []const u8,
) NestError!void
```

Dispatch inside: if sample/`stated_mold` look like auras (`@…`), call `assert_aura_nests`; else call `assert_bartis_named_mold` on both (closed `amount-mold` only this lap). Mismatch → `SampleDoesNotNest`.

---

## What this lap lands (when GREEN)

| Item | Proof |
|------|-------|
| `assert_sample_wet_nests(false, …)` | accept (dry no-op) |
| wet + `@u32` under `@u32` | accept |
| wet + `amount-mold` under `amount-mold` | accept |
| wet + `@u64` under `@u32` | refuse `SampleDoesNotNest` |
| wet + `kind-mold` | refuse `SampleDoesNotNest` |
| `assert_sample_not_wet(true)` | still refuse (STOA110 pin held) |

---

## What stays horizon

| Item | Why held |
|------|----------|
| Glow wet syntax / wet spelling on desks | No token or desk opens wet |
| Ambient gold / free polymorphic samples | Port-order — accept is mold-bounded only |
| Barket/bartis calling wet=true | Still hardcode dry; wire later when syntax exists |
| `sample=kind-mold` gate samples | `$%` enum sample lower thicker |
| Open named-mold set beyond `amount-mold` | Closed allowlist |
| Sala B0 | Framework / product season |

---

## Files / APIs to change

| Path | Change |
|------|--------|
| `glow/nest_type.rye` | add `assert_sample_wet_nests`; bump module comment / version |
| `glow/nest_type_witness.rye` | accept×2 molds · refuse×2 · keep STOA110 refuse |
| `tools/glow_nest_type_witness.rish` | assert new GREEN strings; pin STOA119 |
| `context/TAME_GUIDANCE.md` | STOA119 row · held text (ambient gold still held) |
| `context/LEXICON.md` | Nest/type surface · wet accept under stated mold |
| `glow/README.md` | STOA119 pin |
| `work-in-progress/TASKS.md` · `ROADMAP.md` | GREEN row when landed |
| `active-designing/20260720-181950_stoa119-wet-accept-under-stated-mold.md` | Status → Checkable |

**Do not change this lap:** `glow/tokens.rye` · `rune_barket.rye` dry pin · `rune_bartis.rye` · gen desks · Sala / device.

---

## Alternate lean-A doors (deferred)

| Door | Why not thinner/more honest now |
|------|----------------------------------|
| `kind-mold` gate samples | Thicker `$%` enum sample lower — separate deepen |
| Open named-mold allowlist | Dry widen; does not earn STOA106 wet-path step 5 |
| Flip `assert_sample_not_wet` | False GREEN boolean — refused by this brief |
| Sala B0 | Not language-TAME lean A this season |

No thinner dry barket/bartis parity door remains after STOA118. This nest deepen is the honest next language rung.

---

## Witness (after implement)

```bash
rishi/bin/rishi run tools/glow_nest_type_witness.rish
rishi/bin/rishi run tools/glow_barket_lower_witness.rish
rishi/bin/rishi run tools/glow_lower_bartis_witness.rish
```

---

*May wet accept name its mold before it names itself free, and may refuse keep the door it already earned.*
