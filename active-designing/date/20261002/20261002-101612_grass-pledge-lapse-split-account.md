**Status:** checkable -- landed, witnesses GREEN on metal
**Room:** checkable

# The two named mycelium candidates split clean, caravan's decline did not apply

`construction/ITINERARY.md`'s GRASS account for the mycelium `main`-family reverse-read
(`20261002.100233`) left two items explicitly **unread**: `mycelium/pledge.rye: fold_pledge`
(89 lines) and `mycelium/lapse.rye: fold_lapse` (97 lines), naming them "two small genuine
mycelium candidates" distinct from the 49 standalone `main` demo proofs the same reverse-read
declined to split (the sequential-narrative shape caravan's `check_suffice_runs` rungs already
earned a decline on, `20260820.131713`).

Read in full, both functions are the same shape: a dispatch over a signed fact's `kind` (issue,
star reserve, tax), and within the tax branch a second dispatch over the body's phase tag
(`tag_pledge` opens a pledge; `tag_post`/`tag_void` settles one). That is independent-case
dispatch, not a sequential narrative -- the opposite of the caravan pattern, and exactly the
natural seam TAME's own tidy rule names: "functions past 70 lines -> split at natural seams."

## What moved

Each file's `fold_pledge`/`fold_lapse` kept its kind-dispatch (assert bound, verify signature,
issue/star-reserve/unknown-kind, parse the tax body's tag) and now calls one of two new private
helpers for the two tag branches, carrying every line, comment, and invariant assert verbatim:

- `apply_pledge_open` -- the `tag_pledge` branch (opens a pledge; `lapse.rye`'s copy also reads
  the deadline and checks it is strictly future).
- `apply_pledge_resolve` -- the `tag_post`/`tag_void` branch (honors or releases a settled
  pledge).

`fold_pledge` fell from 89 to 31 lines; `fold_lapse` from 97 to 34. Nothing else in either file
moved -- no constant, no struct field, no public signature, no error set.

## Proof, not claim

Both the Knot-continuation witnesses (the two files' own agent-doable arc) and every module one
level up that composes `pledge.rye`/`lapse.rye` by public API alone read GREEN after the split,
unchanged in their printed verdicts:

```
tools/m/mycelium_pledge_witness.rish        GREEN
tools/m/mycelium_lapse_witness.rish         GREEN
tools/m/mycelium_pledge_true_witness.rish   GREEN (app==awk, byte-level cross-check)
tools/m/mycelium_lapse_true_witness.rish    GREEN (app==awk, byte-level cross-check)
tools/m/mycelium_pledge_kyri_witness.rish   GREEN (render/parse round-trips byte-for-byte)
tools/m/mycelium_lapse_kyri_witness.rish    GREEN (render/parse round-trips byte-for-byte)
tools/m/mycelium_pledge_knot_witness.rish   GREEN
tools/m/mycelium_lapse_knot_witness.rish    GREEN
tools/m/mycelium_voucher_witness.rish       GREEN
tools/m/mycelium_voucher_knot_witness.rish  GREEN
tools/m/mycelium_statement_witness.rish     GREEN
tools/m/mycelium_statement_knot_witness.rish GREEN
tools/m/mycelium_portage_witness.rish       GREEN
tools/m/mycelium_portage_atomic_witness.rish GREEN
```

`tools/fixtures/t/tame_style_long_fn_scan.sh` no longer names either function; the reported
(never gated) `functions_over_70` reading fell from 439 to 437. `tools/fixtures/q/qa_report_card.sh`
reads both files `meter_shadow=A+` (composite 100) under the comment-grammar genre their own
`invariant:` lines earn.

## YOURS

None. `functions_over_70`'s two named remaining exceptions are closed; the honest remaining
population (437) concentrates in the three large files the prior reverse-read already named
(`glow/glow_run.rye: main`, `rye/src/main.rye: bridge_to_zig`, `rishi/src/main.rye: eval_expr`),
unread by this packet.
