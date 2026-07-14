# TAME Tidy Rules — Brief for the Next Claude Round

*The machine canon borrowed from TigerBeetle `tidy.zig`, enforced in our voice through `tools/tame_style_check.rish`. This brief seats what agents must know when touching authored `.rye` — bans that fail, ratchets that count down, and the on-touch migration law.*

**Stamp:** `20260707.164612`
**Last updated:** 2026-07-07
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first; the lint governs when prose and scan disagree
**Status:** Checkable — landed; agent rules updated; parity witness live

*Written by Rio 3 for Kaeden and Claude.*

---

## Where the rules live

| Surface | Path |
|---------|------|
| **Parity witness** | `tools/tame_style_check.rish` |
| **Scan script** (hand-run) | `tools/fixtures/tame_style_scan.sh` (`advise`); `tools/tame_style_scan_bans.rish` (`bans`) |
| **Operational supplement** | `context/TAME_GUIDANCE.md` → **What We Check, and When** |
| **Cursor agent rule** | `.cursor/rules/tame-guidance.mdc` → **Tidy rules** |
| **Claude agent rule** | `.claude/rules/tame-guidance.md` → **Tidy rules** |
| **Alignment study** | `external-research/20260707-053212_tigerbeetle-alignment-study.md` |

Run by hand:

```bash
rishi/bin/rishi run tools/tame_style_check.rish
sh tools/fixtures/tame_style_scan.sh advise  # ratchet counts
rishi/bin/rishi run tools/tame_style_scan_bans.rish  # bans only
```

---

## Bans — any hit fails the witness

These string patterns are scanned across authored `.rye` under `mantra/`, `caravan/`, `linengrow/`, `comlink/`, `rishi/src/`, `tally/`, `aurora/`, `pond/`, `brushstroke/`, `rye/src/` (symlinks skipped).

| Ban | Why |
|-----|-----|
| `) == error.` / `) != error.` | call-result compared to an error silently widens to `anyerror` |
| `std.debug.assert(` | import `const assert = std.debug.assert` once; call bare `assert(...)` |
| `assert( ... and ... )` | split compound asserts so the failing half is named |
| `Self = @This()` | use the real type name |
| `usingnamespace` | banned outright, as upstream |
| `!comptime` | `!` belongs inside the comptime expression |
| `copyForwards` / `copyBackwards` | reach for `tally/copy.rye` `copy_disjoint` |
| `FIXME` / `dbg(` | welcome while iterating; gone before a bundle ships |

**Welcome refinement:** a captured `\|err\|` compared inside an assert on an unwelcome path is fine — the trap lives at the **call seam**, not inside the assert body.

---

## Ratchets — print every run, migrate on touch

Ratchets **never fail** parity. They only count downward as files are touched.

| Ratchet | On touch |
|---------|----------|
| `@memcpy(` application sites | replace with `copy_disjoint` from `tally/copy.rye`; repoint symlinks if needed |
| camelCase `fn` declarations | rename every camelCase `fn` in the touched file to `snake_case`; grep inbound references |
| functions past 70 lines | split at natural seams; run targeted witnesses after |
| zero `assert(` in core modules | import assert; add contract postconditions; exempt list in `tame_style_scan.sh` |

**Standing counts (2026-07-07 evening bench):** `@memcpy` application **0** + **1** canonical in `tally/copy.rye`; camelCase **0** in scan dirs; >70-line ledger **empty**; zero-assert non-exempt **0**. **`maybe`** parked RTAC (`counsel/20260707.183412`).

---

## Agent discipline on every touched `.rye` file

1. **Before commit** — run `rishi/bin/rishi run tools/tame_style_check.rish` when the change touches authored Rye.
2. **On rename** — grep the tree for inbound references; repoint every caller (collaboration rule: references are promises).
3. **On split** — one idea per function; preserve behavior; run the module's parity witnesses.
4. **On copy** — never add raw `@memcpy` in application code; call `copy_disjoint`.
5. **New functions** — `snake_case` from the first line; stay under 70 lines.

---

## What waits (honest horizon)

AST-grade rules from `tidy.zig` still wait for a Zig parser: parenthesized mixed-precedence, `defer` blank line, dead declarations, hard 70-line gate. The textual 70-line **advisory** carries intent until then.

PRNG/`parseInt`/`posix.send` bans from upstream are deferred until a real call site appears.

---

## Counsel ask for Claude

When reviewing a ratchet pass or planning the next bench:

- Confirm splits sit at **natural seams**, not arbitrary line cuts.
- Flag any cross-module rename that missed an inbound reference.
- Hold **MALA graduation**, **Brix first lap**, and **Pond customs** behind their existing counsel gates — tidy migration does not open new domains.

---

*May the lint and the supplement stay one voice — counted down one touched file at a time.*
