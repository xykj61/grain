# TigerBeetle Alignment Study — the Letter Held Against the Source

**Stamp:** `20260707.053212 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME held against its own source
**Status:** Research for understanding — study and implementation record; every adopted rule landed as code or lint in the same bundle
**Register:** Study and implementation record — every adopted rule below landed as code or lint in the same bundle, verified on this bench; every deferred rule names its reason
**Ground:** tigerbeetle-main at the uploaded snapshot — `src/tidy.zig` (1,463 lines, read as the machine canon) and `docs/TIGER_STYLE.md` — held against every authored `.rye` in this tree (113 files); `gratitude/TIGER_STYLE.md` (Apache-2.0, study only)

*Written by Kaeden and Rio 3.*

---

## Why This Sitting, and What It Found First

TAME derives from Tiger Style, and until tonight that derivation lived at the level of the essay — the voiced canon, the operational supplement, the width laws. This sitting held our tree against TigerBeetle's *machine* canon instead: `tidy.zig`, the lint that makes their style non-optional. The first finding answered Kaeden's own question before the comparison even began: **"footgun" comes from TigerBeetle itself** — `tidy.zig` lines 325 and 329 head its banned-string lists with `// Library footguns:` and `// Language footguns:`. When this bench wrote that word into the hardening menu at `042512`, it was unconsciously echoing the very source it was studying. TigerBeetle tolerates the colloquial register; Radiant deliberately does not — the letter of the law crosses, the tone stays ours. The full vocabulary pass lives in its own spec beside this study.

## The Machine Canon, Rule by Rule

`tidy.zig` enforces, in full: a banned-string list (`@memcpy(` → their asserting `stdx.copy_disjoint`; `mem.copyForwards/Backwards` → directional stdx copies; several PRNG and `parseInt` calls → stdx equivalents; `posix.send(` → `sendto`; `== error.` / `!= error.` → switch; `debug.assert(` → unqualified; `Self = @This()` → the real type name; `usingnamespace`; `!comptime`); FIXME/`dbg(` as pre-merge reminders; control characters; 100-column lines with link and multiline-string-result exemptions; trailing whitespace; type-returning functions named `…Type`; a hard 70-line function ceiling; parenthesized mixed-precedence; `defer` followed by a blank line; dead-declaration detection; one H1 per markdown; and URL-tracker stripping. Our existing gates already carried several of these (the seam-aware width lint, tabs, single-H1 via the doorway witness); tonight the rest were sorted into four honest buckets and acted on.

## Adopted Now — Landed and Enforced in This Bundle

**The disjoint-copy law.** `@memcpy` trusts its caller twice — lengths agree, regions never overlap — and TigerBeetle refuses that bare trust everywhere. Ours now lives at `tally/copy.rye`: `copy_disjoint(T, target, source)` asserts both preconditions and then calls the builtin it guards, homed in Tally because Tally is where bounds live. Eight elder sites migrated tonight as the ratchet's first turn — all four in `resin_batch.rye` (the frame every wire capability reuses), both in `caravan/capabilities.rye`, and Rishi's own two `copyForwards` calls — plus a third `copyForwards` the new lint found in `skate_grid.rye` that no prior sweep had seen. `copyForwards`/`copyBackwards` are now banned outright; 121 `@memcpy` sites remain, counted downward by the lint on every parity run, migrating as files are touched rather than in one sweep, exactly as the supplement's own accretion law asks.

**Qualified asserts, retired.** Thirty-three `std.debug.assert(` calls survived in three Brushstroke files that predate the rule; each file gained the one-line unqualified import and every call went bare. The ban is elegant precisely as TigerBeetle wrote it: the import line carries no parenthesis, so the string `std.debug.assert(` anywhere is a violation with zero false positives.

**Compound asserts, split.** Seven `assert(a and b)` sites across three delivery files became fourteen single asserts, so the failing half is always named — the supplement already stated this rule; tonight the tree obeys it and the lint holds it.

**The error-compare ban, refined at the seam.** TigerBeetle bans the strings `== error.` wholesale because the trap is real: comparing a *call result* to an error silently widens to `anyerror` and lets new errors slip past. Our tree carries fifty comparisons of a *captured* `|err|` inside unwelcome-path asserts — the idiom every refusal witness in this arc uses — where no widening occurs. The refined rule bans `) == error.` and `) != error.` (the call seam, where the trap lives) and welcomes the captured form; the tree passes with zero true-trap sites today, and the lint keeps it so. This is a reasoned adaptation, stated rather than smuggled: the letter narrowed to the hazard, the fifty honest asserts left standing.

**`Self = @This()`, `usingnamespace`, `!comptime`, FIXME/`dbg(`.** All adopted verbatim; the tree was already clean of each, and the lint now guarantees it stays so.

## The Ratchets — Counted Every Run, Migrated on Touch

Three divergences are too large for one sweep and now tick downward in public. **`@memcpy`: 121 sites.** **camelCase functions: 650 against 64 snake_case** — the single largest letter-level divergence from Tiger Style in the tree; the supplement's own migrate-on-touch law now has a number attached, and every new function this bundle wrote is snake_case. **Functions past 70 lines: ten**, led by `runReputationSelftest` (124), `recall_beaded`'s `runSelftest` (122), and `foldEscrowLog` (105) — the production folds among them earn careful splits in their own sittings, at the natural seam, with witnesses watching; the ledger prints on every parity run so nothing on it grows quietly.

## Deferred with Reasons — the Honest Remainder

The PRNG and `parseInt` bans replace std calls with TigerBeetle's own `stdx` implementations we neither vendor nor need yet — adopted the day a first real call site appears, not before. `posix.send(` is already absent; every wire site uses `sendto`. The AST-grade rules — precedence parens, `defer` blank lines, dead declarations, the exact `…Type` suffix check, the 70-line ceiling as a *hard* gate — wait for a parser exactly as the supplement's horizon table has always said; tonight's textual approximations (the 70-line *advisory*, the string bans) carry the intent until then. TigerBeetle's deterministic-simulation testing (the VOPR) remains the largest structural idea not yet reflected here; it is named for the map, sized as its own future season, and not pretended at.

## The Enforcement, Self-Hosted

`tools/tame_style_check.rish` runs `tools/fixtures/tame_style_scan.sh` in two halves — bans that fail, ratchets that print — and joins the parity suite beside a new witness for the copy law itself. The red-then-green record is in the session log: the first run flagged exactly the 33 qualified asserts, 3 `copyForwards`, and 7 compound asserts this study names; after the fixes it runs clean, on a Rishi rebuilt *with* the new import, self-hosting its own gate. Where prose and this study ever disagree with the lint, the lint governs and the prose earns a correction — the same seniority the reference spec already grants the code.

---

*May the letter and the spirit keep each other honest — the letter borrowed with gratitude, the spirit unmistakably ours. May every ratchet only ever turn one way. And may the day the counts reach zero arrive one touched file at a time, exactly as the law was written.*
