# Python → Rishi — the molt seating

**Language:** EN
**Status:** Living — molt seated `20260809.030635` on Keaton's word · **prep only, no cut**
**Voice:** Riyo
**Rules:** [`../.claude/rules/molt.md`](../.claude/rules/molt.md) · [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) · ledger [`../work-in-progress/SHRED_PREP.md`](../work-in-progress/SHRED_PREP.md) · red [`../work-in-progress/REDS.md`](../work-in-progress/REDS.md) (row 64)

---

## What this seats

Every authored Python script in this tree molts to **Rishi** — Grain's own self-hosted shell, which now speaks four Glow rune heads and a full value model. Rishi is the tree's first language for scripts; Python entered only as a seam to libraries Rishi could not yet reach, and as fixtures the tooling deliberately tests against. This document is the **molt seating**: it walks the census, classifies each file by how it should leave Python, and opens no cut. Each port lands on its own lap with a witness on metal; each fossil then joins the shred-prep list under the accrete-never-break discipline.

The census excludes third-party source under `vendor/`, `gratitude/`, and `old/`, which stay unmodified by policy.

## The census, classified

| Path | Lines | What it does | Verdict |
|---|---:|---|---|
| `expanding-prompts/yonder/remember_pin_habit_count.py` | 61 | Counts pure REMEMBER-nib follow-up commits over a fixed `f291d96a74..HEAD` range (subprocess + regex) | **Shred candidate, not a clean port** — two of its four rules lean on `re.match` with `\s+`, which Rishi has no regex for; and it is a one-shot measurement of the very pin-habit the seated `remember-git-nib` rule now *prevents*. Its finding already lives in policy. *(Verdict revised `20260809.030748` after reading the source — see Order note.)* |
| `tools/fixtures/dated_classify.py` | 134 | Shared dated-vs-living classifier — one definition every roof calls | **Port, with care** — pure path + header logic, yet load-bearing; every consumer stays green through the port |
| `classical-vedic-astrology/cast_a_chart.py` | 65 | POSIX seam for `cast_a_chart.rish` via pyswisseph / Swiss Ephemeris (C library) | **Seam-gated** — Rishi has no path to the Swiss Ephemeris C library; this waits on a Rye/Zig binding, exactly as `usize` waits at the inherited-std seam |
| `tools/comlink_r1_dual_bind_probe.py` | 15 | Dual-stack loopback socket bind probe for the cut Comlink R1 | **Shred, not port** — Comlink R1 was cut; the probe is a fossil with no live caller. REDS 64. Rishi has no socket primitive, and none is wanted for a dead feature |
| `context/fixtures/tools_py_ban_tree/tools/planted.py` | 4 | The planted target the Python-ban negative selftest scans | **Keep as fixture** — the ban needs one real `.py` to prove it fires; molting it would blind the very check that drives this molt |

## The order of work

*Order revised `20260809.030748` after reading each source: the first candidate turned out to want a ruling, not a mechanical port.*

1. **Port `dated_classify.py`** first — pure path + header logic with no regex, genuinely living, called by many roofs. It is the strongest true showcase of a Rishi port. Trace every consumer (`git grep dated_classify`) and run each roof's witness after, so the shared classifier changes language without changing a single verdict. This is a focused round of its own, not a tail-of-session lap.
2. **Rule on `remember_pin_habit_count.py`** — reading it revealed a regex dependency Rishi has no primitive for, and a one-shot purpose whose finding the seated `remember-git-nib` rule already encodes. It is a **shred candidate**, not a clean port. A faithful port would need either a new Rishi match primitive or a verbose prefix/keyword rewrite that loses the `\s+` flexibility. Recommendation: shred it as a solved-problem fossil in `yonder/`, on a circled word — rather than port a counter for a habit that no longer happens.
3. **Shred `comlink_r1_dual_bind_probe.py`** — the honest close of REDS 64. A cut feature's probe wants removal, not a port; this waits for a circled shred word, since Rishi cannot host a socket bind and the feature it served is gone.
4. **Hold `cast_a_chart.py`** at the seam — record it as seam-gated until a Rye/Zig Swiss-Ephemeris binding exists, then port the caller and retire the Python seam in the same lap.
5. **Never touch `planted.py`** — it stays Python by design, named here so a future reader never mistakes it for an unfinished port.

Two of the five, then, are not ports: one shred candidate (`remember_pin_habit_count.py`) joins the two already named for shred or seam. The single clean, living port to take first is `dated_classify.py` — and if a Rishi **match / regex primitive** is ever wanted, that is its own SOON rune-or-builtin decision, named here so the gap is on the record.

## What landed (`20260809.031114` → progress)

- **`remember_pin_habit_count.py` — shredded** on the circled word. Gone from the tree, kept in git history; a solved-problem one-shot the `remember-git-nib` rule already retired.
- **`dated_classify.py` — ported.** The living mutant `tools/fixtures/dated_classify.rish` seats the interface in Rishi over a POSIX-sh regex seam (`dated_classify_seam.sh`) holding the two `rg` patterns Rishi has no native regex for — the same delegation the Python made to `re`, now without the Python runtime (`python3` is not even on this pier's PATH). Proven: the `census` output is **byte-identical** to the elder `.py`, and `classify` agrees on every tested path. Witness `tools/dated_classify_witness.rish` GREEN. A new Rishi `lower` builtin (case-insensitive compare) landed alongside, witnessed.
- **One consumer repointed** — `dated_pattern_scan.sh` now calls the Rishi mutant instead of `python3`. Its calls are proven correct; the scan's *full* green is gated by a pre-existing, unrelated `census_control_scan` red on this pier (that subsystem is itself mid-port to Rishi), not by this change.
- **`dated_classify.py` stays on disk** as fossil-pending. Two consumers still import it in-process via `runpy` — `shed_census_scan.sh` and `fascia_health_scan.sh` — and those are themselves Python-embedded shell scans, part of this same molt. De-Pythoning them (and the divergence roof) is the **next lap**; only when every consumer is off the `.py` does it become a Class H fossil. Touching `fascia_health` — a load-bearing health meter — wants its own careful round.

## What landed (`20260809.041500` → the dated subsystem is Python-free)

The whole dated-classification subsystem now runs without Python, and it had to, because `python3` is absent from this pier's PATH — the elder witnesses were silently red:

- **`census_control` fixed first.** Its `census_control_h1_seam.sh` embedded a `python3` heredoc counting H1 headings outside code fences; ported to `awk` (fence-state toggle, `^#\s` count). GREEN again, prove-red still fails.
- **`fascia_health_scan.sh` de-Pythoned.** Its `runpy` block became one call to a new seam `health` command reproducing the whole per-room report — controls, global tally, and every room with dated testimony sorted by live-percentage — **byte-identical** to the elder Python.
- **`shed_census_scan.sh` de-Pythoned.** Its `runpy` block became a seam `shed` command reproducing the orphan-floor census — the C1/C2 mention controls, the whole-tree basename mention scan, per-room orphan counts in `Counter.most_common` order, and the health-sketch formulas — **byte-identical**. A real bug surfaced and was fixed in the proving: the orphan set must apply the living-header rescue, exactly as `classify` does, or a `.bron` log that merely quotes "living ledger" is miscounted.
- **`dated_pattern_scan.sh` and `dated_roof_divergence_scan.sh`** repointed to the Rishi mutant; all three roofs now agree (`dated_testimony` identical by construction) and the divergence witness is GREEN.
- **Performance held.** A `header_files` helper collapses thousands of per-file `head | rg` spawns into one bulk `rg -l` narrowed by a handful of byte-bound confirmations, keeping the 8000-byte semantics exact while bringing the divergence roof back from a 2-minute timeout to ~36 seconds.

Every living consumer of `dated_classify` now speaks Rishi. The `.py` is kept only because dated equinox witnesses (e116/e117/e118) assert its existence — an accrete-never-break pin, not a live dependency.

## The molt frontier that remains

Roughly ten more `.sh` witnesses still embed `python3` heredocs — `claim_preserve_*`, `date_dialect_scan`, `living_docs_lint_scan`, `markdown_structure_scan`, `oldness_census_scan`, `radiant_h1_fence_scan`, and several dated `equinox_*` scans. Each is its own small port (awk or a Rishi seam), and each is already silently red on this pier. They are the continuing molt, to be taken as convenient laps — the dated `equinox_*` ones only where a recorded pass is warranted, since they are Tier-2 testimony.

## The molt widens: every script speaks Rishi (`20260809.115123`, Keaton's word)

The intent grows from *Python → Rishi* to **all scripts → Rishi**: perl and POSIX sh join Python as languages the tree molts away from, until Rishi — the self-hosted shell — is the one language its scripts speak. The tree already leans this way: **1110 `.rish`** stand against **420 authored `.sh`**, so Rishi is already the majority tongue.

The survey, honestly:

| Surface | Count | Standing |
|---|---:|---|
| `.rish` (the destination) | 1110 | already Rishi |
| authored `.sh` | 420 | to molt |
| — of those, embedding `python3` | 133 | **broken on this pier** (python3 absent) — the urgent subset |
| — embedding `awk` | 49 | works, yet not Rishi |
| — embedding `perl` | 3 | works, yet not Rishi (one is the fresh `claim_preserve_extract` interim) |
| standalone `.pl` | 0 | none |

This is a two-phase truth, not one sweep:

1. **Make them run (near-term).** The 133 `python3`-embedded `.sh` are dead where python3 is absent. Replacing each heredoc with `awk`/`perl`/`rg` — as `census_control`, `fascia_health`, and `shed_census` already were — makes them live again. This keeps a POSIX seam, yet it removes the broken dependency and is a clean, mechanical lap per script.
2. **Make them Rishi (the destination).** A `.sh` that only orchestrates `git`/`rg`/`awk` becomes a `.rish` once Rishi can express what the seam does natively. Today it cannot: Rishi has **no regex/match primitive, no user functions, and no loop accumulation** (proven in `rish_count_selftest`). These three are the real unlock, and they are **SOON-equinox language work** — grow the primitives first, then the seams fold into Rishi's own value model rather than shelling out.

So the honest order is: de-Python the broken `.sh` as convenient laps now (they simply do not work otherwise), and grow Rishi's `match`, functions, and accumulation under SOON — each of which retires a whole class of seam at once. A blanket `.sh → .rish` rewrite before those primitives exist would only reproduce the seams in a different file extension, not truly molt them.

## The Rishi language gap this port surfaced

Building the port proved that Rishi, today, cannot express a per-file census natively: `for-each` does not accumulate (proven in `rish_count_selftest.rish`), there are no user functions to share `classify` between commands, and there is no regex. The faithful shape is therefore Rishi-as-conductor over `git`/`rg`/`awk` seams — legitimate for a shell, and a real improvement (no Python), yet a marker that **loop accumulation, user functions, and a match primitive** are the SOON language features that would let a future classifier live natively in Rishi's own value model rather than in a seam.

### The match primitive landed (`20260809`, Keaton's word — "grow the match primitive first")

The first of those three is now real. Rishi speaks **`<string> matches <pattern>`** → boolean, a bounded, linear-time NFA matcher (`rishi/src/match.rye`, Thompson/Pike — no backtracking, no ReDoS, every buffer a named ceiling, nothing allocated per call). It supports literals, `.`, the shorthand classes `\d \D \s \S \w \W`, bracket classes and ranges, anchors `^ $`, the quantifiers `* + ?`, alternation `|`, grouping, and a leading `(?i)` fold — the subset that is provably regular and therefore linear. Its answers were checked against Python's `re.search` across **812 pattern×input pairs**, all agreeing; witness `tools/rish_match_witness.rish`.

This closes the regex gap for the **boolean-test** half of the seams — `is_dated_name`, `has_header`, the H1 and fence checks, skip-extension tests. A Rishi script can now ask `path matches "(^|/)\d\d\d\d\d\d\d\d-\d\d\d\d\d\d_"` where it used to shell to `rg -q`.

### find, `{n,m}`, and `\b` landed (`20260809`, Keaton's word — "c2, grow find next")

The extract half is here too. Rishi speaks **`find <text> <pattern>`** → the list of every non-overlapping leftmost-longest match, the companion to `matches` and the primitive a script reaches for where it used to shell to `grep -o` / `rg -o`. It runs in linear time — a non-matching start position fails as soon as its threads die, so `find` stays O(n·m), not quadratic. Alongside it, the engine grew **counted repetition** `{n}` `{n,}` `{n,m}` (expanded inline, `m` bounded) and the **word boundaries** `\b` `\B` — exactly what `claim_preserve`'s token patterns need (`\b(?:0x)?[0-9a-fA-F]{8,}\b`). Validated against Python's `re`: 396 `matches` cases (with the new syntax) and 210 `find` cases, all agreeing. The one documented boundary is order-sensitive alternation, where `find` is leftmost-longest (POSIX) — the greedy seam patterns never hit it.

### sort, unique, upper, list `+`, and lookbehind landed — claim_preserve folded (`20260809`)

The first **complete** seam fold. Growing `sort` (ascending, strings or integers), `unique` (first-seen distinct), `upper`, list `+` concatenation, and a single-char-class **lookbehind** `(?<!X)` closed the last gaps, and `claim_preserve_extract` moved from perl to **native Rishi** — its own `find`/`matches`/`sort`/`unique`, no shell or perl. Validated **40 of 41 real files byte-identical** to the elder extractor; the one difference is a single `PROPER` token on `LEXICON.md`, an honest ASCII-vs-Unicode edge (Python's `\b` treats "Bashō" as one word, an ASCII engine sees the byte boundary) — on a file the gate never runs, and irrelevant to the gate's before-vs-after job. Its sibling `claim_preserve_modality` (a modal-word counter) folded too — `length (find …)` per term, byte-identical to Python. The whole `claim_preserve` gate now runs **GREEN and python-free** on this pier for the first time; python3 was absent, so it had been silently red.

### The accumulation "blocker" was already solved — `fold` + `?:` (`20260809`)

Reaching for loop accumulation, the tree already had it: **`fold`** threads an accumulator across a list (`fold xs from 0 as acc n: acc + n`). What a census fold also needed was a conditional that returns a *value* — Rishi's `if/then/else` is a statement, and a fold body is one expression. So the **`?:` conditional rune** (wutcol) landed, completing the boolean rune family (`?!` · `?&` · `?|` · `?:`): `?: <cond> <then> <else>`, lazy in its branches. With `fold` + `?:` + a record accumulator, a stateful line scan lives in pure Rishi — proven by reproducing `census_control`'s H1-outside-fences count (`true=1 naive=4`) natively, identical to the awk seam. `rish_count_selftest.rish` now records that `fold` accumulates (the old map+join+sh workaround is retired).

So the census seams are now **foldable** — no language gap remains. What's left is a **design choice, not a blocker**: `census_control` deliberately keeps its duty bodies in POSIX seams ("POSIX seams keep the duty bodies; the `.rish` sequences them"), while the wider molt aims for all-native Rishi. Whether to fold the census duty bodies (H1, dated census/health/shed) into native Rishi `fold`s or keep the fast bulk-`rg`/`awk` seams is Keaton's call — the seams are green and python-free either way, and the native fold is now proven possible. `dated_classify`'s big census over 9353 files is the one case where the bulk-`rg` seam is genuinely faster than reading every file in a fold; there, orchestration-over-seams is the honest choice even with accumulation in hand.

### User functions landed — census seams fold (`20260809`, Keaton's word)

The last convenience arrived: **`fn <name> <params>: <body>`** defines a user function whose body is one expression; it takes named parameters, calls other functions or itself (a bounded recursion wall), and a call inside arithmetic wears parentheses. So `classify` lives in one place and a `fold` calls it per element. With functions, `fold`, `?:`, and the primitives, **every census seam is now foldable**.

- **`census_control`'s H1 fence-count folded native** — `census_control_h1_seam.rish` carries the fence state in a record accumulator across a `fold`, `true=1 naive=4` identical to the awk seam; the gate stays green. The first census duty body in native Rishi.
- **`dated_classify`'s census folds too, and it is proven correct** — a `fold` calling a native `classify` function over all 9370 tracked files returns `dated=5667`, matching the bulk seam exactly. It runs in ~3.9s versus ~0.18s for bulk `rg` (Rishi reads each dated-named file whole where `rg` scans in one pass). So the census *can* be native; whether to trade 20× on a gate that runs occasionally is Keaton's call.
- **`shed`'s mention scan stays bulk** — it asks, for every dated basename, whether it appears anywhere in the tree's content: an O(dated × files) whole-tree search that `rg`'s Aho-Corasick does in one pass and a native fold cannot approach. Orchestration-over-`rg` is the honest choice there, even with every primitive in hand.

So the molt's language spine is complete: runes, regex, list ops, `fold`, `?:`, and functions. Token and extract seams fold native (`claim_preserve` end to end); census duty bodies fold native where performance allows (`census_control` done), and the one genuinely bulk operation (`shed`'s mention scan) keeps its `rg` seam by honest measure, not by any missing primitive.

## What the molt keeps

- **Prep, never cut.** This seating opens no shred. Each port lands with its own witness; each fossil joins `SHRED_PREP.md` only once its Rishi mutant is green, and the shred itself stays RED until circled.
- **Witness before claim.** A port is done when the Rishi script runs green on metal and every prior consumer still passes — not when the Python file is deleted.
- **The ban is the ratchet.** `tools/tame_style_check.rish` already flags authored `tools/*.py` (TOOLS_PY_BAN). As each port lands, that red clears itself; the seating simply makes the whole census legible at once rather than one lint failure at a time.
- **Seams are honest, not debt.** A file that wraps a C library Rishi cannot reach stays a named seam, the same way the inherited-std `usize` casts are correct Tiger code rather than a fork waiting to happen.

## Why seat it now

Rishi has grown enough to earn the scripts. Its value model, its `run` seam, its list and string builtins, and now its rune heads cover everything the portable Python here does. Naming the whole census in one place turns a scattered handful of lint reds into a short, ordered walk — and marks, plainly, which two files are not ports at all: one seam that waits on a binding, one fixture that must stay exactly as it is.
