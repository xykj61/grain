# eval_expr splits at its own natural seams -- one of three named candidates taken up

**Status:** Landed -- checkable (every reading below is a run command, not an estimate)
**Room:** checkable
**Stamp:** `20261002.144246`
**Lane:** GRASS (TAME Guidance over SLC-product-facing code)
**Kin:** [the mycelium `main` reverse-read](20261002-100233_grass-mycelium-main-reverse-read.md) --
the account that named this file as one of three large real candidates left unread

## The question

The prior reverse-read narrowed `functions_over_70`'s honest remainder to 439 and named three large
real candidates still unread: `glow/glow_run.rye: main` (426 lines), `rye/src/main.rye:
bridge_to_zig` (377), and `rishi/src/main.rye: eval_expr` (242). It warned each "wants a careful
read of its own natural seams before any split, by whichever lane takes it up." This lap read the
smallest of the three.

## What the read found

`eval_expr` carries a different shape than mycelium's and caravan's own sequential narrative, where
splitting would scatter one story behind indirection -- already declined twice. It is a flat
**string-prefix dispatch table** -- 40-odd `if (std.mem.startsWith(u8, trimmed, "<word> "))` branches, each
delegating to its own `do_*` helper in one line, checked in a fixed order the comments already
explain (runes before comparisons, comparisons before infix word ops, both before arithmetic). That
shape has real seams: process control, file I/O, Glow runes, pipelines, comparison, two families of
infix word operators, and unary string builtins -- eight groups the function's own comments already
name and order.

## What changed

`rishi/src/main.rye`'s `eval_expr` (1135-1376, 242 lines) split into a 20-line dispatcher and eight
new functions, each named for the group its own comments already called out: `eval_expr_process`,
`eval_expr_file_io`, `eval_expr_runes`, `eval_expr_pipeline`, `eval_expr_comparison`,
`eval_expr_word_predicates`, `eval_expr_word_search`, `eval_expr_string_builtins`. Every helper
returns `EvalError!?Value` -- null means "move to the next group" -- so the dispatcher reads
as a flat list: `if (try eval_expr_process(...)) |v| return v;` one line per group. Every line,
comment, and error path moved verbatim, and the original wording stayed exactly as written. The two groups that read the
untrimmed `text` (comparison and the two word-op families, since `find_comparison` and
`find_word_op` need the original slice offsets) keep taking `text`; the rest take `trimmed`, exactly
as the original local variable did.

The infix word operators split further, into predicates (`starts-with`/`ends-with`/`matches`, 44
lines) and search (`index-of`/`contains`, 36 lines) instead of one 80-line group, keeping every new
function under the same 70-line line the split exists to clear.

## Proof, before any claim

**Build, clean.** `RYE_ZIG=$PWD/vendor/zig-toolchain/zig ./rye/bin/rye build rishi/src/main.rye
-femit-bin=rishi/bin/rishi -target x86_64-linux-musl -lc` succeeds cleanly, zero warnings.

**Every test in `rishi/tests/` (36 scripts), byte-identical stdout, stderr, and exit code** against
a baseline captured from the pre-split binary, re-proven after the final rebuild:

```
final mismatch=0
```

**The long-function scanner, run directly rather than through the slower advise wrapper:**

```
sh tools/fixtures/t/tame_style_long_fn_one.sh rishi/src/main.rye | sort -t= -k2 -rn
  rishi/src/main.rye: do_run_bounded = 182 lines
  rishi/src/main.rye: eval_operand = 153 lines
```

Run against `git show HEAD:rishi/src/main.rye` (the pre-split file) the same way:

```
  eval_expr = 242 lines
  do_run_bounded = 182 lines
  eval_operand = 153 lines
```

`eval_expr` leaves the roster, and every new entry stays under 70 -- the repair closes the entry
rather than relocating it.

**A dozen rishi-dependent witnesses re-run GREEN** on the rebuilt binary: `rishi_bare_path`,
`rishi_filter_chain`, `rishi_fold`, `rishi_lines_bounded`, `rishi_quoted_program`, `rishi_brief`,
`rishi_make_pen`, `rishi_run_record`, `rishi_quote_safe`, `rish_join_split`, `rish_dangling_else`,
`rish_report_bound`, `built_tool_freshness`, `glow_repl`, and `tame_style_check` itself (bans clean,
same ratchet numbers as before the split).

**One witness, `rishi_list_bound`, times out past 150 seconds on both the pre-split and post-split
binary alike** -- proven by building a throwaway `/tmp/rishi-old` from `git stash`'d source and
timing the same inner scan (`tools/fixtures/t/two_rooms_doorway_scan.rish`) against it: `3m10s`,
terminated, identical to the post-split timing. The slowness belongs to the doorway scan's own walk
over a tree that has outgrown the pace it kept when the witness was written, standing apart from
this change -- named here so a future reader attributes it correctly.

## What this narrows

`functions_over_70`'s honest remaining population (439 per the prior account) drops by one.
`glow/glow_run.rye: main` (426) and `rye/src/main.rye: bridge_to_zig` (377) remain the two large
real candidates still unread -- both compiler/bridge drivers, each wanting the same careful seam
read before any split.

## YOURS

This file's share closes clean. `glow/glow_run.rye: main` and `rye/src/main.rye: bridge_to_zig`
stay open for the next lap or lane that takes them up.
