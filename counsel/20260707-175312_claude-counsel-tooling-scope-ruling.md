# Claude Counsel — the Ratchet Closes, and Where Its Next Line Should Sit

**Stamp:** `20260707.175312 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · Gall's Law · accrete-never-break
**Register:** Acknowledgment, then a scoping ruling on the seam explicitly flagged for it
**Ground:** `tools/fixtures/tame_style_scan.sh` run live on this bench (bans clean, both ratchets confirmed) · `rye/src/main.rye` (read in full, 351 lines) · `tools/align_session_logs.rye`, `tools/tame_usize_audit.rye`, `tools/enrich/*` (15 files, read for shape and scope) · `linengrow/open_asks.rye`'s reputation fold (verified split, not merely renamed)

*Written by Kaeden and Rio 3.*

---

## First, What Actually Landed

This bench did not take the report's word for the ratchet's close — it ran the scan fresh, on the tree as it stands, and found exactly what the report claimed: `@memcpy` at one site, the canonical one inside `tally/copy.rye` itself; camelCase functions at zero across every scanned directory; the past-seventy-line ledger empty. The last of these deserved a closer look, because an empty ledger can mean a function was genuinely split or can mean a detector quietly stopped matching — this bench checked `runReputationSelftest` by name and found the honest version: it did not merely shrink or get renamed, it became `run_reputation_selftest` at forty-four lines *and* five newly named fold helpers, one per fact kind, plus a separate tally step — the exact shape TAME's own "push the `if`s up and the `for`s down" asks for, not a cosmetic trim. Four commit clusters, roughly four hundred and sixty-two functions, carried through to a genuinely clean, genuinely verified close. This is real, and it is finished.

## The Scoping Question, Answered in Three Parts

**`rye/src/main.rye` joins now.** This bench read it in full rather than judge it by its address outside the scan list. It is not adjacent scaffolding — its own header says plainly that Rye, from this file forward, builds itself, and every other file in this tree passes through what it does. Eight functions, all camelCase, all named clearly enough to give their snake_case forms directly rather than leave the naming as a second decision: `printUsage` → `print_usage`, `printVersion` → `print_version`, `bridgeToZig` → `bridge_to_zig`, `resolveRyeLib` → `resolve_rye_lib`, `bridgeZigPath` → `bridge_zig_path`, `rewriteRyeImports` → `rewrite_rye_imports`, `bridgeAlreadyStaged` → `bridge_already_staged`, `bridgeRyeTree` → `bridge_rye_tree`. Small, foundational, and the compiler that holds every other file to this law should not be the one file exempted from it. Add `rye/src` to `tame_style_scan.sh`'s scanned roster alongside the nine already there, migrate the eight names, and the ratchet's zero stays a true zero rather than a zero with an asterisk.

**`tools/` does not join today, and the reason is not that it matters less.** This bench read past the two files the report named and found `tools/enrich/` behind them — fifteen files, plus `align_session_logs.rye` at over five hundred lines and `tame_usize_audit.rye` beside it, together a real, maintained subsystem that keeps session logs aligned, a lexicon synchronized, and usize violations audited for the strengthening docs. This is not disposable scaffolding, and this bench will not call it that — precisely *because* it is load-bearing, it deserves the same bar eventually. The reason to hold it separate is not disdain, though; it is honesty about size. A single spot check of one file alone turned up nineteen camelCase functions this bench has not yet counted across the other fourteen. Folding an unsized surface into "the same pass" the moment the last one closes is the breadth this tree's own graduation rule already warns against elsewhere. The work is entirely welcome — a pass sized before it is counted is simply a promise made before it is known it can be kept. **Recommend:** let this ratchet's zero stand as its own completed thing, and open the tools surface as its own next season, counted honestly first — this bench is glad to do that counting whenever it is wanted.

**One category is exempt on principle, permanently, not provisionally.** `tools/fixtures/width_check_authored_usize.rye` exists to fail a witness on purpose — its entire reason for being is to carry the violation the width lint must catch. Migrating its internals toward compliance would not clean the tree; it would quietly disable the very proof it exists to supply. The same logic already protects the elder Amber goldens from modernization, and it deserves to be named as a standing rule rather than rediscovered file by file: a fixture built to hold a wrong state on purpose stays exactly as wrong as its purpose requires, forever, and no ratchet ever reaches for it.

## What This Leaves

One nine-line edit to the scanned-directories list, eight names to change in one small file, and a ratchet that was already true becomes true without qualification. The tools surface waits, named honestly rather than folded in by momentum, for its own counted season. Nothing else about this tree's held items moved tonight — Brix, Pond, MALA, and continuity stand exactly where they were left.

---

*May a compiler hold itself to the law it enforces on everything that passes through it. May a season's scope be counted before it is promised, not after. And may a fixture built to be wrong stay wrong for exactly as long as its wrongness is doing honest work.*
