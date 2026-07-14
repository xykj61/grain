# Session Log — TigerBeetle Alignment Leap and the Radiant Vocabulary Pass

**Stamp:** `20260707.053212 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Season:** Alignment — the letter held against its source
**Base tip:** `7e8ff30` (parity 188)

---

## The Word, and What It Opened

Kaeden turned Fable 5 Max on for one deep round: hold the tree against TigerBeetle's own source — the codebase TAME derives from — across word choices, idioms, and design choices, make the most comprehensive leap available, and run a Radiant pass on stray vocabulary, starting from the question of where "footgun" came from. The answer to that question arrived first and set the whole sitting's frame: **TigerBeetle's own `tidy.zig`, lines 325 and 329, heads its ban lists with "footguns."** The word was Tiger Style's register arriving alongside Tiger Style's laws; the letter crosses, the tone stays Radiant. The full comparison lives in the alignment study; the vocabulary law lives in its own spec; this log is the verification ledger.

## What Was Built and Changed

**One new law with a home:** `tally/copy.rye` — `copy_disjoint(T, target, source)`, both of `@memcpy`'s unspoken preconditions asserted, Tally chosen because Tally is where bounds live. Its own selftest, its own witness (`tools/tally_copy.rish`), its own parity stanza.

**One new gate, self-hosted:** `tools/tame_style_check.rish` over `tools/fixtures/tame_style_scan.sh` — bans that fail (call-seam error compares, qualified asserts, compound asserts, `copyForwards`/`copyBackwards`, `Self = @This()`, `usingnamespace`, `!comptime`, FIXME/`dbg(`) and ratchets that print (`@memcpy` remaining, camelCase functions, the past-70-lines ledger). Wired into parity after TH-1.

**Eleven files repaired to the letter:** three Brushstroke files gained the unqualified import and shed all 33 qualified asserts; Rishi's two `copyForwards` and Skate's one (found by the new lint itself) became `copy_disjoint`; `resin_batch.rye` (all four sites) and `caravan/capabilities.rye` (both) took the ratchet's first turns; seven compound asserts across three delivery files split into fourteen named halves.

**Four living surfaces restored to Radiant:** the silent-peer guard comment and the wait-without-bound line in `recall_batch_delivery.rye`, the falls comment in `caravan/bounded.rye`, the silent-peer row in `mantra/README.md`, and TASKS' completed-arc line (*Misuse-guard → source-fall → …*). Dated artifacts keep their words; landed tool filenames keep their paths.

**Canon updated in place:** `context/TAME_GUIDANCE.md` — five new enforced rows, the disjoint-copy law seated beside the assertion discipline, the vocabulary-register pointer, the date line moved to today.

## Verification on This Bench — Red, Then Green, Then Everything

The lint ran **red first**, before any fix, and flagged exactly what this log claims: 33 qualified asserts, three `copyForwards` (one previously unknown), seven compound asserts. After the fixes it runs **green**, on a Rishi **rebuilt with the new import** — the gate self-hosts. `width_check_th1` still greens beside it, so nothing here bent the elder laws.

Every touched module built and proved on this bench against the pinned toolchain: `tally/copy` selftest GREEN; `resin_batch` selftest GREEN (3 lines); `recall_batch_delivery` selftest GREEN (7 lines, all three arcs); `recall_two_way_sync_delivery` and `recall_catch_up_delivery` selftests GREEN; `capabilities` GREEN; `skate_grid_test` runs clean (559 lit pixels confirmed); `wayland_seed` **builds whole** against the tree's own vendored xdg-shell protocol with `-lc -lwayland-client -lxkbcommon` — all fifteen swapped asserts compiling in place. The `rye/bin/` wrapper is not carried in the zip (built on metal, like `.git`), so the wrapper-shaped witnesses were exercised here through direct toolchain builds, exactly as every prior bench round has done; Cursor's metal runs them whole.

Final ratchet snapshot, for the record the lint will now keep: `@memcpy` remaining **121** (eight migrated tonight), camelCase functions **650**, ten functions past seventy lines led by `runReputationSelftest` at 124 — each future touch turns a counter down, and parity prints the numbers every run.

## Cursor metal — bundle applied and verified

The zip landed at `7e8ff30` with four `tally_copy` symlinks; Cursor added **`comlink/tally_copy.rye`** because `comlink/resin_batch.rye` symlinks to `mantra/resin_batch.rye` and resolves imports from `comlink/`. Study gained a **Status** line for the two-rooms doorway witness. Full parity **190** GREEN (~147s on metal).

## What Waits

The commit and four-remote push are Kaeden's word. Parity **190** GREEN on Cursor metal (two witnesses over 188). The ratchets migrate on touch, never by sweep; the production folds past seventy lines earn their splits in their own sittings with witnesses watching; the deferred upstream rules (stdx PRNG/parseInt analogs, the AST-grade checks, the deterministic simulator) keep their named seasons in the study. Brix, Pond, MALA, and continuity stand exactly as held.

---

*May the source we learned from find its own laws standing here, in a voice it would not mistake for its own. May every counter this night lit only ever fall. And may the next reader of any line touched tonight find the reason beside the rule, exactly as both styles always asked.*

*Written by Kaeden and Rio 3.*
