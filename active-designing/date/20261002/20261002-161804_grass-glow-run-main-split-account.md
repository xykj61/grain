# Grass -- `glow_run.rye`'s `main` splits at its own head-dispatch seams

**Status:** Landed, proven on metal -- `20261002.161804`
**Room:** checkable -- every claim below is proven by a witness named in it

## What this closes

The eval_expr account named two remaining TAME-lane candidates:
`rye/src/main.rye: bridge_to_zig` (377 lines) and `glow/glow_run.rye: main`
(426 lines). `bridge_to_zig` is a sequential-narrative shape -- one mutating
Sha256 hasher threaded through nearly every step of a receipt-key
computation, matching caravan's and mycelium's already-declined shape --
and stays unsplit for the same reason those two were declined. `main` in
`glow_run.rye`, by contrast, is a flat dispatch table exactly like
`eval_expr`: argv parsing, two early fast-path shortcuts (STOA176 named-cast,
STOA168 mold-only), a line-count/shop-core classifier, a three-way dispatch
(shop-core argv, the multi-line family, the single-line family), and an
output write.

## The one constraint that shaped every helper

`tools/fixtures/g/glow_run_contract_scan.sh` derives the module's declared
exit codes from the file's own `//!` head table and compares them against
every bare-integer `return N;` line textually at or after `pub fn main(`.
Any extraction had to keep every bare-digit return inside `main`'s own text
-- never behind a plain function-call translator, and never as a switch
arm written `error.X => return N,` on one line, since the scan's regex
anchors `return` to the start of the line. Each translating switch arm
therefore wraps its return in its own block: `error.Broke => { return 1; }`.

## The split

Four setup/dispatch helpers -- `open_source` (argv parse + read),
`try_fast_lower` (the two STOA176/168 shortcuts), `classify_shape`
(line-count/shop-core gate), `lower_shop_core_argv` -- plus the two big
dispatch chains split exactly as `eval_expr` was: `lower_multiline` into
four family helpers (named-cast + cross-desk + shape-only, bartis + barket,
compose-lib, the three compose-core shapes, the remaining compose/jam-cue/
typed forms) and `lower_single_line` into six sigil-family helpers (pipe,
caret, query, face, cell, call), each returning `!?u32` -- null meaning try
the next family, the same pattern `eval_expr`'s own split already proved.
Every extracted helper raises the file's own named vocabulary --
`error.Usage` (4), `error.Unreadable` (3), `error.Broke` (1),
`error.Declined` (2) -- via Zig's inferred error sets, no new type
declared. Every line and comment moved verbatim into its new home.

## Proven on metal

- `tools/fixtures/t/tame_style_long_fn_one.sh glow/glow_run.rye` -- empty
  output: no function in the file reaches 70 lines (`main` ends at 69).
- `tools/g/glow_run_contract_witness.rish` -- GREEN: five exit codes
  declared, returned by `main`, and answered by the built binary.
- `tools/g/glow_run_desk_witness.rish` (1,133 lines, 218 named desks) --
  GREEN.
- `tools/g/glow_desk_run_witness.rish` (347 desks derived from the whole
  `glow/gen/` room, 301 bare + 46 sample-taking) -- GREEN: "347 runnable
  desks ... run, 301 bare and 46 on the sample each declares for itself, 3
  unmarked data fixtures at their ceiling split by stage, both runner-swap
  legs proven, 109 control behaviors green."
- Every rune-head witness this dispatch reaches -- call, call2, call3,
  calln, cell, list, quad, triple, shape, core, shop_core, alphabet,
  sample_argv, shop_gate_argv, shop_nest_tokenize, lower_compose_lib,
  digraph_twin, compose_after_inc, compose_tend_unary, preset_offset,
  vane_pair_mirrors, skate_gates, desk_arity, desk_reach -- GREEN.
- `tools/fixtures/t/tame_style_scan.sh bans` -- GREEN, clean.
- `sh tools/fixtures/q/qa_report_card.sh glow/glow_run.rye --setting door`
  -- register=85, reach=80, truth=100 (counted half); no molt frame owed.

`functions_over_70` fell by exactly one over the same measurement
(`tools/fixtures/t/tame_style_scan_advise.rish`), since `main`'s single
426-line entry is gone and replaced by twenty functions none of which
crosses 70.

## What stays open

`rye/src/main.rye: bridge_to_zig` (377 lines) remains declined, for the same
reason caravan's and mycelium's sequential-narrative shapes were declined
twice already -- the natural seams this lane looks for are seams a
dispatch table has and a mutating-accumulator narrative does not. `YOURS:`
none from this file.
