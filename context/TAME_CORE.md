# TAME Core -- the highest points, compressed

**Stamp:** `20260811.200854` - **Voice:** Kyri - **Status:** Living -- the **core** of a core/shelf pair.
**Shelf (full, lossless):** [`TAME_GUIDANCE.md`](TAME_GUIDANCE.md) - **Source:** `../gratitude/TIGER_STYLE.md` (studied) - **Agent rules:** [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) - [`../.cursor/rules/tame-guidance.mdc`](../.cursor/rules/tame-guidance.mdc)

Token-dense on purpose. This is the smallest form that still holds TAME's highest points, so it can ride in the agent rules and be present every time we write **`.rye` - `.rish` - `.brix` - `.bron` - `.kyri` - Glow - Brush - `.myc`** code. The shelf keeps the full reasoning; the core keeps the reflexes.

## The spine

**Safety > Performance > Joy.** Safety is structural, not by convention. Performance is measured before optimized. Joy is clarity, named things, the habit of saying why. When they pull, safety wins; safety = performance => joy votes.

## Root -- every family language

1. **Bound everything.** Every allocation, collection, loop, pipeline names a **max**. Name the budget at construction; check at the edge; fail with a **named error**, never silent corruption. No unbounded recursion.
2. **Assert invariants first.** Write `assert` at construction - mutation - postcondition **before** the body; aim **>=2 per fn**; each preceded by `// invariant:`. State them **positively**.
3. **Explicit widths.** `u32` in-memory counts/indices/lengths (bounded by a named const) - `u64` wire-persistent sizes/timestamps - `usize` **only** at the inherited-std seam (assert the bound, keep arithmetic in `u32`, `@intCast` at the edge). Never `usize` in authored fields/params/returns.
4. **Say why.** Every assert, named const, and surprising choice earns a reason comment.
5. **Accrete, never break -- by tier.** Tier 1 proof-sealed (absolute) - Tier 2 testimony (recorded pass / erratum) - Tier 3 living (revisable). Only Tier 1 is absolute.
6. **One value model.** string - integer - bool - list - record -- composed side by side, never tangled.
7. **Smallest scope, fewest variables; explicit options at the call site; docs and implementation stay synced (assert it, don't assume it).**
8. **Reds-first.** A red books the allocation; a fix is closed by a **witness on metal**, never a claim.

## Rye reflexes (`.rye`)

- **Opening triad**, every hosted file: `const std` - `const assert = std.debug.assert` - `const print = std.debug.print`. Then bare `assert(...)` / `print(...)`.
- **`snake_case`** fns/vars/files - **short fns** (split past ~70 lines at natural seams) - **named errors with `try`**.
- **No bare `@memcpy`** in new code -> `tally/copy.rye` `copy_disjoint`. **No `std.debug.assert(`** (unqualified only). **No compound `assert(a and b)`** (split). No `Self = @This()`, `usingnamespace`, `FIXME`, `dbg(`.
- **Chapter allocator:** reach the arena via `const garden = init.arena.allocator()`; never construct `ArenaAllocator` in authored `.rye`, and never rename it `GardenAllocator` -- `garden` is Tally's own reserved name. Walled at zero by `tools/c/chapter_allocator_witness.rish`.
- Prefer `tally/parse_int.rye` over bare `std.fmt.parseInt`; `tally/kumara.rye` over bare Ed25519.

## The other family tongues

- **Rishi (`.rish`)** -- `run` returns `{ out, err, code, ok }`; check `.ok` **before** trusting `out`. `assert ... else "msg"` as a gate. `if/then/else`, `for-each`. No integer div/mod; put `run [ ... ]` args on one line.
- **Brix (`.brix`)** -- composition language; declares systems, **evaluates to Bron**; every field bounded; override by **`double-seat`**/infuse, never silent reflow.
- **Bron / Kyri (`.bron` - `.kyri`)** -- data notation: one `key value` per line, `#` comments, no quotes/braces; **parsed, not evaluated**; immutable values.
- **Glow** -- the language: runes, **shape** (never Hoon's *mold*), lowers Glow->Rye->Zig->RISC-V; the Root rules hold through the lowering.
- **Brush (Brushstroke)** -- paint/Skate surface; bounded frames, zero-copy where the pixels allow.
- **Myc (`.myc` / Mycelium)** -- Sui-side reimpl; the same bounds, asserts, and named errors cross the seam.

## The checkable surface -- what stands, on which clock, over what

Every tool below sits on `construction/standing-equipment.kyri`, so a roster pass runs it whether or not a hand remembers to. Read the clock and the reach beside each name: a green says exactly as much as the population behind it.

| Tool | Reads | Clock |
|---|---|---|
| `tools/w/width-check.rish` | widths, seam-only `usize`, over the authored rooms | lap |
| `tools/t/tame_style_check.rish` | tidy **bans** (fail) + **ratchets** (migrate on touch), 1,126 authored `.rye` | lap |
| `tools/c/chapter_allocator_witness.rish` | the chapter-allocator reflex, two walls at zero over 1,958 sources | lap |
| `tools/o/opening_lines_witness.rish` | the opening triad, **1,073 hosted `.rye` derived from the rooms roster** | lap |
| `tools/t/tame-check.rish` | unqualified assert, `Self = @This()`, tabs, trailing whitespace, **1,127 authored `.rye` derived from the rooms roster** | lap |
| `tools/r/rune_assert_sweep.rish` | asserts stated at all, and **each one named** -- 1,127 authored `.rye` derived from the rooms roster, plus the twelve elder cores by name | lap |
| `tools/t/tame_style_long_fn_witness.rish` | functions past 70 lines | cadence |
| `tools/w/width_check_th3.rish` | Mantra's own width reading | lap |
| `tools/l/living_docs_lint.rish` | living-doc links, status, retired words -- advise only | cadence |

**Three of these reached no lap until `20260908.111848`.** This section named five tools and called them *the audit*, and four of the five arrived on the roster only because somebody seated them one at a time for their own reasons. `rune_assert_sweep` was seated by nobody; `opening_lines_witness` and `tame-check` stood on the supplement's own lint table and nowhere else. All three read GREEN the hour they were rostered, so the loss was hearing rather than health. The runner this section used to name -- *the TAME Guidance Audit Quest* -- stands in exactly one place in the living tree, which is the sentence that named it. A roster row runs; a sentence describes.

**Three of them read a hand-typed list, and all three have been widened.** `opening_lines`, `tame_check` and `rune_assert_sweep` gated 24, 16 and 12 named files against regression, where the rooms in `tools/fixtures/t/tame_style_rooms.txt` hold **1,126** authored `.rye` and **1,073** of them are hosted. Measured `20260908.111848`: **123 of the 1,073 are missing at least one line of the opening triad.** A list holds what it was typed to hold, and the tree grows past it -- so each row above names its reach, and widening a list is its own lap.

**`rune_assert_sweep` took the third of those laps `20260908.161651`, and the widening found a boundary rather than a count.** Its scan derives the same population -- **1,127 authored `.rye`**, of which **1,100 carry functions** -- and reads two things TAME root rule 2 asks for: **100** function-bearing files carry no `assert(` at all, and **101** more assert without naming a single `// invariant:`. Both are ratchets under ceilings that only fall, because a wall at zero would ask for two hundred files in one lap. What the widening found is that **the elder twelve are not a subset of the roster**: five of them -- `mandate/store.rye`, `mandate/keyed.rye`, `kumara/tilak.rye`, `settlement/constellation.rye`, `sundial/sundial.rye` -- sit in four rooms `tame_style_rooms.txt` does not name at all. Deriving alone would have dropped five gated files while the printed population grew a hundredfold, which is a guard reading more and proving less, so the twelve keep a wall of their own at zero, each printed by name. Twenty-four behaviors are proven on a throwaway pen, both ratchets shown from the failing side by lowering a pen's ceilings to zero, since a control cannot plant a hundred files to watch a ceiling refuse. **Its first draft paid diffuser's tax and its second does not:** three `grep` calls per file against 1,127 sources is 3,381 processes and 19.3s, where three list-wide `grep -l` readings plus `comm` set arithmetic answer the same three questions in six processes and 237ms, taking the witness from 47.4s to **2.0s** with the control included.

**`opening_lines` took that lap `20260908.125347`.** Its scan derives the population from the same rooms roster the style scan's two halves read, so a room added once reaches all three readers. Two duties are walls: **zero** of the 1,073 write a qualified `std.debug.assert(`, and the twenty-four files the elder list held stay clean on all four of its checks, so the wider population lowers nothing the narrow one had proven. Three are ratchets under ceilings that only fall -- **5** files calling `std.debug.print(`, **67** missing the assert bind, **118** missing the print bind -- because TAME asks for the print bind as-you-touch and gates it nowhere. Eighteen behaviors are proven on a throwaway pen, every plant counted while it stood and read back to zero once lifted.

**`tame_check` took the same lap `20260908.133141`, and its widening found something.** Its scan derives the same population, reading **1,127 authored `.rye`** rather than sixteen -- every authored file, hosted or not, because a tab and a trailing space are faults whichever way a file opens. Three duties are walls at zero across all 1,127, each on a looser predicate than the literal it replaced: `std.debug.assert(` at any spacing, `Self = @This()` at any spacing, and any tab. What the sixteen could not see is **three files carrying trailing whitespace**, and all three turn out to be load-bearing. Two sit inside `\\` multiline string literals -- `glow/lower_named_cast.rye` and `brushstroke/brush_parse.rye` -- so those bytes are generated Zig and generated Brush rather than an untidy source; they are **reported** under `trailing_content` and gated nowhere, on the line the ASCII comment guards already drew. The third is `brushstroke/font8x8_data.rye:35`, the glyph row for the space character, whose `//` comment **is** a space; it stands as a ratchet at 1 rather than behind a named exemption, so a day that names the glyph in words lowers the ceiling honestly. Twenty-four behaviors are proven on a throwaway pen, the two halves of the split planted separately because neither alone could tell them apart.

**And `tame_check` was counting its own output too.** Its witness printed `length lines result.out` and said *all 17 files*, where the list held **16** paths and the seventeenth was the trailing empty line -- the same fault as the 25 below, in the guard standing next to it, found the same day. Two of two widened guards had been measuring the instrument rather than the tree, which is the argument for widening the third.

**The number in the row above was never a file count.** The elder witness printed `length lines result.out` and said *all 25 hosted files*, where the scan's list held **24** paths and the twenty-fifth was the trailing empty line. Three living pages carried the 25 from `20260729.230300`, this one among them. A guard that counts its own output is measuring the instrument rather than the tree, which is the same shape the widening itself repairs, one layer down.

**And the sentence at the head of this section is walled now, rather than kept by care** (`20260909.152920`). *Every tool below sits on the roster* was false for three of the five tools this table named until a hand seated them one at a time, and the repair held only as long as the next hand remembered. `tools/t/tame_core_surface_witness.rish` over `tools/fixtures/t/tame_core_surface_scan.sh` reads this table against `construction/standing-equipment.kyri` and holds three walls at zero over the nine tools above: each exists on disk, each carries a `path` row, and each declared Clock matches the roster's own `tier` -- a tier absent reading `lap`, which is the roster's own rule. Thirty readings prove it on throwaway pens, nineteen of them biting eight distinct refusals. It reads the declaration rather than the code: whether a tool reads what its Reads column claims, whether this table names every tool it ought to, and whether a rostered guard is green are three other questions with three other instruments.

Run them when touching authored code; a roster pass, cold at the open and hot after `git add`, runs them for you.

## Crash headroom

Reserve a doubling of the durable write up front (static allocation, TigerBeetle-style) so we never OOM and always **fail fast** at a bounded assert with room to name why. `[[crash headroom]]` - `[[double-seat]]`.

---

*The shelf holds the reasons; the core holds the reflexes. Read the core at the keyboard; reach the shelf when you must say why.*
