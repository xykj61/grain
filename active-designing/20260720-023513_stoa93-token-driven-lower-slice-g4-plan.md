# STOA93 / G4 — Token-Driven Lower Slice Plan

*An Acme Corporation employee reading this gets the thinnest honest lap that opens the lexer→lower seam past dispatch peeks: one lower's parse consumes the shared token stream. Peeks already win (STOA84–85). This brief is the implementable plan — not the GREEN close.*

**Language:** EN  
**Version:** `20260720.023513` (UTC · cloud host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Design — implementable plan; checkable once the witnesses below are GREEN  
**Register:** Mixed (Two Rooms) — file paths and parse seam are **design** until the witnesses bind them  
**Grounds in:** [`20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) **G4** · STOA83–87 tidy tokens + named-cast · [`../work-in-progress/20260719-204650_cursor-ios-handoff-glow-language.md`](../work-in-progress/20260719-204650_cursor-ios-handoff-glow-language.md) pitfalls · [`../glow/tokens.rye`](../glow/tokens.rye) · [`../glow/lower_named_cast.rye`](../glow/lower_named_cast.rye) · [`../glow/glow_run.rye`](../glow/glow_run.rye)

**dated_guard:** Do **not** edit the dated `20260719-204001_*` files. Seat G4 progress in living docs and in *this* new dated brief.

---

## Verdict (one breath)

Today `glow_run` peeks named-cast / cross-desk via tokens, yet `parse_cross_desk` still splits lines and scans `/+` / `^-` as bytes. STOA93 lean A rewrites **only** that cross-desk parse to walk `tokens.tokenize` spans. Emit paths, mold-library lower, same-desk mold-body join, and the digraph cascade for other desks stay exactly as they are.

---

## 1. Exact one-slice claim

| Today | After STOA93 lean A |
|-------|---------------------|
| STOA84–85: `tokens.looks_like_*` drives **dispatch** only | Unchanged — peeks still win before mold digraphs |
| `lower_named_cast.parse_cross_desk` → `collect_lines` + `parse_import_stem` + `rune_cast.parse` | Builds `CrossDeskSpec` from token kinds/spans: `rune2 /+` · `ident` · newline · `rune2 ^-` · `ident` |
| Same-desk `lower_source_welcome` still line-joins mold body | Unchanged this lap |
| `glow_run` mold / `\|%` / compose arms still first-line digraphs | Unchanged this lap |

**What becomes token-driven that is not today:** the **parse** of a cross-desk named-cast consumer desk (`/+ <stem>` then `^- <mold>`), not merely its peek.

This matches the STOA85/86 check-in wording: peeks seated · “token-driven lower slice — deeper than dispatch” · lowers still parse bytes until this lap.

---

## 2. Files to add / change

### New

| Path | Role |
|------|------|
| `active-designing/20260720-023513_stoa93-token-driven-lower-slice-g4-plan.md` | This plan (already seated) |

No new generator desk — `glow/gen/cast-import-*.glow` already exercise the shape.

### Changed (implementation lap)

| Path | Change |
|------|--------|
| `glow/tokens.rye` | Add `CrossDeskParts` (`stem` · `mold` as `Token`) and `cross_desk_parts(src) ?CrossDeskParts` that tokenizes once, requires exactly two Glow lines, head `rune2` `/+`, next non-newline `ident` (stem), last-line head `rune2` `^-`, next `ident` (mold), no trailing junk on either line. Refactor `looks_like_cross_desk` to `cross_desk_parts(src) != null`. Header comment: cross-desk parse joins the lexer→lower seam; other lowers may still parse bytes. |
| `glow/lower_named_cast.rye` | Rewrite `parse_cross_desk` to call `tokens.cross_desk_parts`, copy spans via `tokens.slice_of` + `tally_copy.copy_disjoint` into `CrossDeskSpec`, refuse aura molds (`mold[0] == '@'` → `NamedCastNeedsTuple` — same as today). Retire `parse_import_stem` if unused. Keep `looks_like_*` as thin delegates. Emit helpers unchanged. |
| `glow/tokens_witness.rye` | Assert `cross_desk_parts` on the `cross_desk` fixture yields stem `mold-amount` and mold `amount-mold`; assert null / false on `mold_only`, same-desk named-cast, and a junk tail after the stem. Keep existing peek asserts (they share the new helper). |
| `glow/lower_named_cast_witness.rye` | One GREEN line that `parse_cross_desk` still binds `cast-import-amount` shape; bump witness version stamp when touching. Existing emit asserts stay. |
| `glow/README.md` | Living: G4 / STOA93 — cross-desk named-cast parse is token-driven; cite this brief. |
| `context/TAME_GUIDANCE.md` | Living Glow pin one-liner: lexer→lower seam opened at cross-desk parse (STOA93). |
| `work-in-progress/TASKS.md` · `ROADMAP.md` · `REMEMBER.md` · `docs/STOA.md` | Living ledger GREEN close (merge STOA row under ≤80-line law). |

### Do not change

| Path | Why |
|------|-----|
| `glow/glow_run.rye` digraph arms | Peeks already ordered correctly; no cascade rewrite |
| `glow/lower_mold.rye` | Tidy mold is a separate lean; mold body parse stays byte-shaped |
| `glow/lower_named_cast.rye` same-desk `lower_source_welcome` | Mold-body join + `rm.parse_source` is the next lexer→lower slice, not this one |
| `glow/tokens.rye` `match_rune2` table | No bartis `\|=` / `\|^` this lap |
| `glow/gen/*.glow` | Existing import desks are the product surface |
| `active-designing/20260719-204001_*.md` | dated_guard — cite only |

---

## 3. Concrete API sketch (implement against this)

```rye
/// Spans into `src` for a cross-desk named-cast consumer desk.
pub const CrossDeskParts = struct {
    stem: Token,
    mold: Token,
};

/// Exactly two Glow lines: `/+ <stem>` then `^- <mold-name>`.
/// Returns null when the shape fails (peek and parse share this gate).
pub fn cross_desk_parts(src: []const u8) ?CrossDeskParts

pub fn looks_like_cross_desk(src: []const u8) bool {
    return cross_desk_parts(src) != null;
}
```

`parse_cross_desk` then:

1. `parts = tokens.cross_desk_parts(src) orelse return error.NotACrossDesk`
2. Copy `slice_of(src, parts.stem)` / `parts.mold` into `CrossDeskSpec` (length bounds unchanged)
3. If mold leads with `@`, `return error.NamedCastNeedsTuple`
4. Return spec — `bind_cross_desk` / emit paths untouched

**Invariant:** Named-cast and cross-desk peeks still run **before** the mold-only `+$` digraph arm in `glow_run` (handoff pitfall).

---

## 4. Witness asserts

Run device-free:

```bash
rishi/bin/rishi run tools/glow_tokens_witness.rish
rishi/bin/rishi run tools/glow_lower_named_cast_witness.rish
rishi/bin/rishi run tools/glow_run_desk_witness.rish
```

| Assert | Where |
|--------|--------|
| `cross_desk_parts("/+  mold-amount\\n^-  amount-mold")` → stem `mold-amount`, mold `amount-mold` | `tokens_witness` |
| `looks_like_cross_desk` true on that desk; false on mold-only and same-desk `+$`…`^-` | `tokens_witness` (keep) |
| Junk after stem (`/+  mold-amount extra`) → null parts | `tokens_witness` |
| `parse_cross_desk` on `cast-import-amount` shape still yields stem/mold; aura cast still refused | `lower_named_cast_witness` |
| Full desk suite: `cast-import-amount` · `cast-import-kind` · `cast-import-xact` still EXIT:0 | `glow_run_desk_witness` |
| Same-desk named-cast desks still GREEN (peek path unchanged) | desk suite |

No new top-level `tools/glow_*_witness.rish` required unless the existing witnesses cannot carry the new strings — prefer extending `glow_tokens_witness` / `glow_lower_named_cast_witness`.

---

## 5. What NOT to do this lap

- **Bartis** `|=` / wet cores / gold polymorphism — horizon (handoff + G0 brief).
- **Mold-only `+$` token peek** — that was STOA86 lean B (“widen dispatch without lower rewrite”); do not substitute it for lean A.
- **Same-desk mold-body parse from tokens** — needs token→`rm.MoldSpec` or a careful join; second slice after this one lands.
- **Full `glow_run` rewrite** onto a general token-driven dispatcher — digraph arms for `\|%`, compose, multi stay.
- **TAME tidy `lower_mold`** — separate lean; roster ceiling 256 still binds.
- **Sala B0 rewrite in Glow** — product lap, not this language seam.
- **Growing whole `glow/` onto style/width rosters** — only touch files already rostered or newly needed.
- **Rewriting `rune_cast.parse` / `rune_mold` to tokens** — out of scope; cross-desk no longer calls `rc.parse` for the consumer desk.

---

## 6. Does a designing brief already exist?

| Artifact | Role for G4 / token-driven lower |
|----------|----------------------------------|
| [`20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) | Names **G4** as “Token-driven lower slice on tidy ground” — **no** file list, API, or witness plan |
| STOA84–89 session logs + REMEMBER | Recommend the lean repeatedly; do not specify the slice |
| iOS handoff | Lists the lean; pitfall on peek order |
| **This brief** | First implementable STOA93 / G4 plan |

---

## 7. Suggested check-in leans (after GREEN, next rung)

| Lean | Claim |
|------|--------|
| **A** (natural follow) | Same-desk named-cast: resolve cast-line mold name from tokens (still join mold body as bytes) |
| B | Mold-only `+$` peek via tokens (dispatch widen) |
| C | TAME tidy `lower_mold` |
| D | Sala B0 |

---

## Smoke while implementing

```bash
rishi/bin/rishi run tools/glow_tokens_witness.rish
rishi/bin/rishi run tools/glow_lower_named_cast_witness.rish
# after wire:
rishi/bin/rishi run tools/glow_run_desk_witness.rish
```

---

*May every peek stay ahead of every digraph, and may the first lower that trusts its tokens earn the next.*
