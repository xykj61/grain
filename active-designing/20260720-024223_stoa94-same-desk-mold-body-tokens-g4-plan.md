# STOA94 / G4 — Same-Desk Mold-Body from Tokens Plan

*An Acme Corporation employee reading this gets the thinnest honest lap that opens the lexer→lower seam for same-desk named-cast: the mold-body byte span and cast-mold name come from one tokenize, while `rune_mold.parse_source` still reads that span as bytes. Cross-desk already walks tokens (STOA93). This brief is the implementable plan — not the GREEN close.*

**Language:** EN  
**Version:** `20260720.024223` (UTC · cloud host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Design — implementable plan; checkable once the witnesses below are GREEN  
**Register:** Mixed (Two Rooms) — file paths and parse seam are **design** until the witnesses bind them  
**Grounds in:** [`20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) **G4** · [`20260720-023513_stoa93-token-driven-lower-slice-g4-plan.md`](20260720-023513_stoa93-token-driven-lower-slice-g4-plan.md) deferred same-desk slice · [`../glow/tokens.rye`](../glow/tokens.rye) · [`../glow/lower_named_cast.rye`](../glow/lower_named_cast.rye) · [`../glow/gen/cast-named-amount.glow`](../glow/gen/cast-named-amount.glow)

**dated_guard:** Do **not** edit the dated `20260719-204001_*` or `20260720-023513_*` files. Seat G4 progress in living docs and in *this* new dated brief.

---

## Verdict (one breath)

Today same-desk `lower_source_welcome` still `collect_lines` → `collect_mold_src` (join) → `rm.parse_source` → `rc.parse` on the cast line. STOA94 lean A rewrites **only** that path to take mold-body bytes and cast-mold span from `tokens.named_cast_parts`. Emit paths, `rune_mold` itself, cross-desk (already token-driven), and the digraph cascade stay exactly as they are.

**Why this lean, not STOA93 §7's thinner "cast-line only":** the STOA93 deferred wording and living TASKS already name *mold-body from tokens*. The cast-line alone would leave the join buffer as the last byte-shaped seam in this lower. A contiguous mold-body span from the token stream retires both the join and `rc.parse` in one honest slice, while `rm.parse_source` stays byte-shaped (careful span, not token→`MoldSpec`).

---

## 1. Exact one-slice claim

| Today | After STOA94 lean A |
|-------|---------------------|
| STOA84: `tokens.looks_like_named_cast` drives **dispatch** only | Unchanged intent — peek shares the new parts gate |
| `lower_source_welcome` → `collect_lines` + `collect_mold_src` + `rm.parse_source` + `rc.parse` | Builds mold slice + cast name from `tokens.named_cast_parts`; still `rm.parse_source(mold_slice)` |
| Cross-desk `parse_cross_desk` / `cross_desk_parts` | Unchanged (STOA93) |
| `rune_mold.parse_source` line/byte parse | Unchanged this lap |
| `glow_run` digraph cascade | Unchanged this lap |

**What becomes token-driven that is not today:** locating the same-desk named-cast **mold-body byte span** (`+$` … `==`, everything before the `^-` line) and the **cast-mold** token — not merely the peek, and not a rewrite of mold grammar into tokens.

Product surface already exists: `glow/gen/cast-named-amount.glow` (also kind / xact same-desk desks).

---

## 2. Files to add / change

### New

| Path | Role |
|------|------|
| `active-designing/20260720-024223_stoa94-same-desk-mold-body-tokens-g4-plan.md` | This plan (already seated) |

No new generator desk.

### Changed (implementation lap)

| Path | Change |
|------|--------|
| `glow/tokens.rye` | Add `NamedCastParts` (`mold_start` · `mold_len` · `cast_mold: Token`) and `named_cast_parts(src) ?NamedCastParts`. Tokenize once; require 4–5 Glow lines; head `rune2` `+$`; last-line head `rune2` `^-`; next token `ident` or `aura` (cast mold); refuse trailing junk on the cast line (same discipline as `cross_desk_parts`). Mold body = contiguous bytes `src[0 .. last_line_start]` (start of the `^-` token). Refactor `looks_like_named_cast` to `named_cast_parts(src) != null`. Header: same-desk named-cast parse joins the lexer→lower seam beside cross-desk. |
| `glow/lower_named_cast.rye` | Rewrite `lower_source_welcome` to call `tokens.named_cast_parts`, slice mold body via `mold_start`/`mold_len`, `rm.parse_source` on that view, compare `tokens.slice_of(src, parts.cast_mold)` to mold name. Retire `collect_mold_src`, the `max_mold_src` join buffer, and the `rc` / `lower_multi` imports if unused. Add `NotANamedCast` (parallel to `NotACrossDesk`) when parts is null. Emit helpers unchanged. |
| `glow/tokens_witness.rye` | Assert `named_cast_parts` on `amount_cast` yields mold slice that starts with `+$` / contains `==` / excludes `^-`, and cast mold `amount-mold`; assert null on `mold_only`, `cross_desk`, and cast-line junk (`^-  amount-mold extra`). Keep existing peek asserts (they share the helper). Bump witness version stamp. |
| `glow/lower_named_cast_witness.rye` | One GREEN line that same-desk lower still binds `cast-named-amount` shape via token parts (emit asserts stay). Bump witness version stamp. |
| `glow/README.md` | Living: G4 / STOA94 — same-desk named-cast mold-body span is token-driven; cite this brief. |
| `context/TAME_GUIDANCE.md` | Living Glow pin one-liner: lexer→lower seam also at same-desk mold-body span (STOA94). |
| `work-in-progress/TASKS.md` · `ROADMAP.md` · `REMEMBER.md` · `docs/STOA.md` | Living ledger GREEN close (merge STOA row under ≤80-line law). |

### Do not change

| Path | Why |
|------|-----|
| `glow/rune_mold.rye` | Mold grammar stays byte-shaped; no token→`MoldSpec` this lap |
| `glow/lower_mold.rye` | Tidy mold is a separate lean |
| `glow/glow_run.rye` digraph arms | Peeks already ordered; no cascade rewrite |
| `glow/tokens.rye` `match_rune2` table | No bartis `\|=` / `\|^` this lap |
| `glow/gen/*.glow` | Existing same-desk desks are the product surface |
| Cross-desk path | Already token-driven (STOA93) |
| `active-designing/20260719-204001_*.md` · `20260720-023513_*.md` | dated_guard — cite only |

---

## 3. Concrete API sketch (implement against this)

```rye
/// Spans into `src` for a same-desk named-cast desk (STOA94).
/// mold_start/mold_len cover `+$` … `==` (bytes before the `^-` line).
pub const NamedCastParts = struct {
    mold_start: u32 = 0,
    mold_len: u32 = 0,
    cast_mold: Token = .{},
};

/// 4–5 Glow lines: head `+$`, last line `^- <mold-name>`, no cast-line junk.
/// Returns null when the shape fails (peek and lower share this gate).
pub fn named_cast_parts(src: []const u8) ?NamedCastParts

pub fn looks_like_named_cast(src: []const u8) bool {
    return named_cast_parts(src) != null;
}
```

`lower_source_welcome` then:

1. `parts = tokens.named_cast_parts(src) orelse return error.NotANamedCast`
2. `mold_src = src[parts.mold_start ..][0..parts.mold_len]` (view — no join buffer)
3. `mold_spec = try rm.parse_source(mold_src)`
4. `cast_mold = tokens.slice_of(src, parts.cast_mold)`; length / `@` rules as today (name compare → `CastMoldMismatch`; aura still reaches mismatch rather than inventing a new refuse)
5. Emit switch unchanged

**Algorithm detail for `named_cast_parts`:** reuse `glow_line_count` · `first_content` · last-line index walk from today's peek. `mold_len = toks[last_line_head_index].start` (byte offset of `^-`). After `^-`, require `ident` or `aura`, then only newlines through end.

**Invariant:** Named-cast and cross-desk peeks still run **before** the mold-only `+$` digraph arm in `glow_run` (handoff pitfall).

**Leading `::` comments:** gen desks carry them; `mold_start = 0` keeps comments inside the mold slice; `rm.parse_source` → `collect_lines` already skips `::` lines — same as today.

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
| `named_cast_parts(amount_cast)` → cast mold `amount-mold`; mold slice contains `+$` · `amount=@u32` · `==`; mold slice has no `^-` | `tokens_witness` |
| `named_cast_parts(xact_desk)` → cast mold `xact-mold`; mold slice includes `$%` arms and `==` | `tokens_witness` |
| `looks_like_named_cast` true on amount/xact; false on mold-only and cross-desk | `tokens_witness` (keep) |
| Cast-line junk (`^-  amount-mold extra`) → null parts | `tokens_witness` |
| `lower_source_welcome(desk_src)` still emits `AmountMold` named-cast; mismatch still `CastMoldMismatch` | `lower_named_cast_witness` |
| Full desk suite: `cast-named-amount` · `cast-named-kind` · `cast-named-xact` (+ import desks) still EXIT:0 | `glow_run_desk_witness` |

No new top-level `tools/glow_*_witness.rish` — extend the two existing witnesses.

---

## 5. What NOT to do this lap

- **Rewrite `rune_mold.parse_source` onto tokens** — that is token→`MoldSpec`; a later G4 rung if ever needed.
- **TAME tidy `lower_mold`** — separate lean; roster ceiling still binds.
- **Bartis** `|=` / wet cores / gold polymorphism — horizon.
- **Mold-only `+$` token peek** — STOA86 lean B; do not substitute it for this lap.
- **Full `glow_run` rewrite** onto a general token-driven dispatcher — digraph arms stay.
- **Sala B0 rewrite in Glow** — product lap, not this language seam.
- **Cross-desk rework** — already GREEN on tokens (STOA93).
- **Growing whole `glow/` onto style/width rosters** — only touch files already rostered or newly needed.
- **Cast-line-only half-slice** — do not stop at replacing `rc.parse` while leaving `collect_mold_src`; this lap is the mold-body span.

---

## 6. Does a designing brief already exist?

| Artifact | Role for same-desk mold-body tokens |
|----------|-------------------------------------|
| G4 roadmap brief `20260719-204001_*` | Names token-driven lower — **no** same-desk file list |
| STOA93 plan `20260720-023513_*` | Defers mold-body; §7 lean A suggested cast-line-only (superseded by this choice) |
| Living TASKS / REMEMBER | Name STOA94 as same-desk mold-body from tokens |
| **This brief** | First implementable STOA94 / same-desk mold-body plan |

---

## 7. Suggested check-in leans (after GREEN, next rung)

| Lean | Claim |
|------|--------|
| **A** (natural follow) | Mold-only `+$` peek via tokens (dispatch widen — STOA86 lean B) |
| B | TAME tidy `lower_mold` |
| C | Token→`MoldSpec` inside `rune_mold` (only if a lower still needs it) |
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

*May every same-desk cast trust the same stream its peek already reads, and may the mold body arrive as a span rather than a second join.*
