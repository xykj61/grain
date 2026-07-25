# STOA92 / G3 — Thin Parameterized Generator Plan

*Keaton asked for the thinnest honest lap: one desk reads one `@u32` sample from Rishi argv; the matching fixture desk stays GREEN; Glow still does not tokenize `|=` (bartis). This brief is the implementable plan — not the GREEN close.*

**Language:** EN  
**Version:** `20260720.022956` (UTC · cloud host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Design — implementable plan; checkable once the witness below is GREEN  
**Register:** Mixed (Two Rooms) — file paths and argv seam are **design** until the witness binds them  
**Grounds in:** [`20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) G3 · [`../expanding-prompts/20260719-204001_glow-fixture-desks-and-parameterized-generators.md`](../expanding-prompts/20260719-204001_glow-fixture-desks-and-parameterized-generators.md) · [`../tools/glow_run.rish`](../tools/glow_run.rish) · [`../glow/glow_run.rye`](../glow/glow_run.rye) · [`../glow/lower_cast.rye`](../glow/lower_cast.rye) · [`../tools/glow_run_desk_witness.rish`](../tools/glow_run_desk_witness.rish)

**dated_guard:** Do **not** edit the dated `20260719-204001_*` files. Seat G3 progress in living docs (`glow/README.md`, `context/TAME_GUIDANCE.md` Now lines, work-in-progress ledgers) and in *this* new dated brief.

---

## Verdict (one breath)

Keep `glow/gen/cast-u32.glow` as the baked fixture. Add a twin generator desk whose lowered binary reads one decimal `@u32` from process argv. Rishi forwards that word; Glow lower emits the argv-reading `main`; no bartis token, no source rewrite that bakes the sample before lower.

---

## 1. Exact new / changed file paths

### New

| Path | Role |
|------|------|
| `glow/gen/sample-u32.glow` | Generator desk — same rune body as the cast fixture (`^-  @u32`); comments name G3, argv sample, fixture twin, bartis horizon |
| `tools/glow_sample_argv_witness.rish` | Device-free witness for the argv path (fixture + generator + refuse) |
| `active-designing/20260720-022956_stoa92-thin-argv-sample-g3-plan.md` | This plan (already seated) |

### Changed (implementation lap)

| Path | Change |
|------|--------|
| `tools/glow_run.rish` | Accept `args.len == 1` (fixture) or `args.len == 2` (generator sample); when 2, lower with `--sample-argv` and run `${bin} ${sample}` |
| `glow/glow_run.rye` | Parse optional leading `--sample-argv`; on that flag, require a single `^-  @u32` Glow line and call `lower_cast.lower_line_argv_sample` |
| `glow/lower_cast.rye` | Add `lower_line_argv_sample` + `emit_from_argv_u32` (parse mold, refuse non-`@u32`) |
| `glow/lower_cast_witness.rye` | Assert argv emit contains `minimal.args` / `parseInt(u32` and still keeps baked welcome `raw: u64 = 42` |
| `tools/glow_lower_cast_witness.rish` | Assert new GREEN substring for argv-sample emit |
| `glow/README.md` | Living: G3 checkable; name fixture vs generator desks; link this brief |
| `context/TAME_GUIDANCE.md` | Living Glow pin: "Argv sample remains G3" → G3 seated with witness path |
| `work-in-progress/TASKS.md` · `ROADMAP.md` · `REMEMBER.md` | Living ledger: STOA92 G3 plan seated / GREEN when witness lands |

### Do not change

| Path | Why |
|------|-----|
| `glow/gen/cast-u32.glow` | Matching fixture — baked welcome path unchanged |
| `tools/glow_run_desk_witness.rish` | Stays argv-free; continues to prove `cast-u32.glow` GREEN |
| `glow/tokens.rye` | No `|=` / bartis this lap |
| `active-designing/20260719-204001_*.md` · `expanding-prompts/20260719-204001_*.md` | dated_guard — cite only |

Optional later (not this lap): a thin Acme expanding-prompt *new* stamp restating the hand; never rewrite the `204001` prompt.

---

## 2. How argv reaches the sample

### Settled seam (honest)

```
rishi run tools/glow_run.rish glow/gen/sample-u32.glow 42
        │
        ▼
Rishi binds script args  →  args[0]=glow path  args[1]="42"
        │
        ▼
glow_run.rish
  1. build glow/bin/glow_run  (driver)
  2. run: glow/bin/glow_run --sample-argv glow/gen/sample-u32.glow
        → lower_cast.lower_line_argv_sample("^-  @u32")
        → writes glow/.cache/sample-u32.rye  (main reads process argv)
  3. rye build → glow/bin/sample-u32
  4. run: glow/bin/sample-u32 42     ← sample is process argv[1]
        → parseInt(u32) → checked cast boundary → exit 0
```

| Layer | Does | Does not |
|-------|------|----------|
| **Rishi** (`glow_run.rish`) | Own orchestration; forward the decimal string; assert arity | Parse/validate `@u32` (binary owns that) |
| **Glow lower** (`lower_cast` + `glow_run.rye --sample-argv`) | Emit `main` that reads `init.minimal.args` | Tokenize `|=`; invent bartis syntax |
| **Rewrite** (inject literal into `.glow` then ordinary lower) | — | **Rejected** — binary never sees argv; not "desk reads sample" |

### Fixture path (unchanged)

```
rishi run tools/glow_run.rish glow/gen/cast-u32.glow
  → glow_run (no --sample-argv) → lower_line_welcome → baked raw 42 → binary with no argv → EXIT:0
```

### CLI contracts

**`tools/glow_run.rish`**

```
usage: rishi run tools/glow_run.rish <file.glow> [<sample-u32-decimal>]
assert (args.len == 1 or args.len == 2)
# when basename is sample-u32.glow: assert args.len == 2
# when args.len == 2: lower via --sample-argv; run "${bin} ${args[1]}"
# when args.len == 1: today's path (no args to binary)
```

**`glow/bin/glow_run`**

```
usage: glow_run [--sample-argv] <file.glow>
# --sample-argv: only ^- @u32; emit argv-sample rye; print rye path
# default: today's dispatch (cast welcome etc.)
```

### Exact emit shape (`emit_from_argv_u32`)

Mirror today's cast welcome shape; replace baked `raw` with argv parse. Target text (agents may adjust whitespace to match `bufPrint` style in `lower_cast.rye`):

```rye
const std = @import("std");

/// Lowered from Glow `^-  @u32` — sample from process argv (G3).
pub fn main(init: std.process.Init) !u8 {
    const alloc = init.arena.allocator();
    const argv = try init.minimal.args.toSlice(alloc);
    if (argv.len < 2) return 2;
    const sample = std.fmt.parseInt(u32, argv[1], 10) catch return 2;
    const raw: u64 = sample;
    const casted: u32 = std.math.cast(u32, raw) orelse return 1;
    return if (@as(u64, casted) == raw) 0 else 1;
}
```

Bounds: `rye_buf` stays `[4096]u8`; this emit fits. Refuse non-`@u32` molds with a named error (e.g. `ArgvSampleAuraNotYetLowered`) so `@u8`/`@u64` do not pretend to share the lap.

### Generator desk source (`glow/gen/sample-u32.glow`)

```
::  Thin parameterized generator (G3): one @u32 sample from Rishi argv.
::  Matching fixture desk: cast-u32.glow (baked welcome). Not bartis — |= horizon.
^-  @u32
```

Same first Glow line as the fixture so `rune_cast.parse` stays shared. Mode is selected by `--sample-argv`, not by a new rune.

---

## 3. Witness asserts

### A. Keep fixture GREEN (existing suite)

`tools/glow_run_desk_witness.rish` already runs:

```
rishi run tools/glow_run.rish glow/gen/cast-u32.glow
```

Asserts: `ok`, stdout contains `GREEN`, contains `cast-u32.glow`. **Do not add** `sample-u32.glow` here (no argv).

### B. New `tools/glow_sample_argv_witness.rish` (device-free)

Pattern after `glow_run_desk_witness.rish` / `glow_lower_cast_witness.rish`:

1. **Fixture still argv-free**
   - `rishi run tools/glow_run.rish glow/gen/cast-u32.glow`
   - assert `ok` · `GREEN` · `cast-u32.glow`

2. **Generator welcome — sample 42** (matches fixture welcome constant)
   - `rishi run tools/glow_run.rish glow/gen/sample-u32.glow 42`
   - assert `ok` · `GREEN` · `sample-u32.glow`

3. **Generator welcome — different sample 7** (proves parameterization)
   - `rishi run tools/glow_run.rish glow/gen/sample-u32.glow 7`
   - assert `ok` · `GREEN`

4. **Arity refuse** — missing sample on generator desk
   - `rishi run tools/glow_run.rish glow/gen/sample-u32.glow` with no second arg
   - assert **not** `ok` (Rishi `assert args.len == 2` for this stem)

5. **Parse refuse** — bad decimal
   - After a successful lower/build of `sample-u32` (or via a small `sh -c` run of the built bin): `glow/bin/sample-u32 not-a-u32`
   - assert exit **2** (usage / parse fail), not 0

6. **Lower emit pin** (via extended `glow_lower_cast_witness` or a one-shot in this witness)
   - argv-sample emit contains `minimal.args` and `parseInt(u32`
   - welcome fixture emit still contains `const raw: u64 = 42` and **no** requirement for argv

Final say line:

```
GREEN: glow sample argv G3 — fixture cast-u32; generator sample-u32 reads one @u32 from Rishi argv.
```

No adb, no device, no Sala — host Rishi + rye only.

---

## 4. What stays fixture vs what is generator

| Kind | Path | Sample | How it runs |
|------|------|--------|-------------|
| **Fixture desk** | `glow/gen/cast-u32.glow` | Baked in lower (`cast_welcome_raw = 42`) | `glow_run.rish` one arg; binary no argv |
| **Generator desk** | `glow/gen/sample-u32.glow` | Process argv[1] decimal `@u32` | `glow_run.rish` two args; `--sample-argv` lower |

Vocabulary (already seated G0): speak **fixture desk** / **generator** / **sample**; say **Glow gate** / **bartis** only as horizon — never claim this lap tokenizes `|=`.

All other `glow/gen/*.glow` files remain fixture desks.

---

## 5. Risks / pitfalls

1. **Rewriting the `.glow` with a baked literal** — looks GREEN, fails the G3 claim. Reject.
2. **Tokenizing `|=` "while we are here"** — out of scope; breaks alphabet/token witnesses; park for a bartis lap.
3. **Putting `sample-u32` into `glow_run_desk_witness.rish`** — that suite never passes argv; generator would fail or silently take the wrong emit path.
4. **Changing default `^-` welcome emit to read argv** — breaks every cast fixture and `glow_lower_cast_witness`. Mode must be opt-in (`--sample-argv` only).
5. **Stem-only magic without Rishi arity assert** — `sample-u32.glow` lowered as welcome would bake 42 and lie. Pair stem guard in `.rish` with `--sample-argv` in the driver.
6. **`sh -c "${bin} ${sample}"` interpolation** — keep sample a bare decimal (witness uses `42` / `7`); do not pass free-form strings in the first witness.
7. **`parseInt` vs Tally** — lowered emit may use `std.fmt.parseInt` to match existing cast emit style; do not drag `tally/parse_int.rye` into Glow emit this lap unless a style roster already requires it.
8. **Editing dated `204001` briefs** — dated_guard refuses; update living README/TAME Now lines instead.
9. **Claiming bartis / Glow gate is seated** — prose must say horizon; G3 is shell-sample + cast lower only.
10. **Width / buffer** — keep emit inside the existing 4096-byte rye buffer; no unbounded argv copying beyond `toSlice` arena.

---

## Implementation checklist (agent order)

1. Add `emit_from_argv_u32` + `lower_line_argv_sample` in `glow/lower_cast.rye`.
2. Wire `--sample-argv` in `glow/glow_run.rye` (argv parse before path; refuse wrong mold).
3. Extend `tools/glow_run.rish` arity + forward + stem guard for `sample-u32.glow`.
4. Add `glow/gen/sample-u32.glow`.
5. Extend cast lower witness; add `tools/glow_sample_argv_witness.rish`; run both GREEN.
6. Sync living docs (`glow/README.md`, TAME Glow pin, TASKS/ROADMAP/REMEMBER Now lines).
7. Session log + commit (component `glow:` / `tools:` — split if the diff is large).

---

## Out of scope (STOA92 siblings)

Token-driven lower · tidy `lower_mold` · Sala B0 — remain later check-ins. This plan is **G3 argv sample only**.

---

*May the fixture stay honest, the sample arrive from the shell, and bartis wait until the token table is ready.*
