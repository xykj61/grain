# incense-inner.md `next` archive -- shelf 10

**Checkpoint:** `20260927.122323` -- **Walk-back nib:** `911e7197e0`
**Swept:** the `20260927.045618` and `20260927.060217` lap accounts, moved verbatim from
`recursion-prompts/incense-inner.md`'s `next` section so the page could carry the
`20260927.122323` backtick-path repair account under its 24,576-byte bound.

---

**This lap (`20260927.045618`) round-opened clean at `fd36d16e5a`, found no overlapping claim (five
standing rows all past their six-hour expiry), launched a fresh cold run and held fully still
through its whole run, watched with Monitor across five re-arms.** It closed clean: `tree_moved=no`,
`run_verdict=guard_red` (the roster's own expected self-check), 361 green, 18 red, 3 gated. Surveyed
the reds for a small fixable one: `pen_release` read `never_removed=9` over its own ceiling of 8,
naming `tools/fixtures/r/rye_key_control.sh` as the ninth -- yet that file already releases its pen
on three signals, `trap cleanup EXIT INT TERM`. Read the scan's own awk: pass 2 learns a pen
variable's name only from the line that assigns it via `mktemp -d`, and this file declares `PEN=""`
and its trapped `cleanup()` well ahead of the `PEN=$(mktemp -d)` line that actually names it a pen
-- an ordinary shell idiom for a cleanup armed before its target exists. Pass 2 met the removal
inside `cleanup()` with an empty `pen[]` and called it never_removed. Fixed it structurally: pass 1
(the file's own first, trap-name-collecting pass) now also collects every pen variable the whole
file will ever assign, so pass 2 sees the later-declared name from its first line rather than
discovering it partway through. `never_removed` fell 9 to 8, `verdict=released`. Added a leg to
`pen_release_control.sh` planting this exact ordering and proved it load-bearing by reverting the
scan fix and watching the leg fail (`never_removed=1`, `verdict=leaking`) before restoring it;
`pass=55` to `pass=58`, `fail=0`. Two unrelated readings in the same witness had also drifted with
the tree's own growth -- `runtime_pens=21` to `25`, and the header's stale "Forty-six behaviors" --
corrected both while the file was open. `pen_release_witness.rish` runs GREEN on metal;
`tame_style_check` GREEN; all three touched files plain ASCII, modes unchanged. No REDS row booked
(REDS.md 23 bytes free) -- an ordinary unrostered repair overlapping no claim. Next lap: fresh
round-open, cold run held still start to finish; ~18 reds remain untriaged (`width_check`'s th5
disagreement already TAME-ruled, `standing_equipment_redleg`'s chapter-lane remainder outside this
lane, `rule_twin`/`pond_enclosure_*` gated); `query_wire_retention` (%756), `ceiling_teeth`'s
`asserted_only` population, and the `shared_build_path`/`build_target` populations still want
Keaton's word or a larger plan than one lap affords.

**This lap (`20260927.060217`) round-opened clean at `ec7009729c`, found no overlapping claim (five
standing rows all stale), launched a fresh cold run and held fully still through its whole run,
watched with Monitor across six re-arms.** It closed clean: `tree_moved=no`,
`run_verdict=guard_red` (the roster's own expected self-check), 17 red (excluding the self-check),
3 gated. Surveyed the reds: `checkable_binding` read `settled_unbound=10` against `ceiling=8` --
listed the ten pages and found every one carried a `date/` shelf or a stamped basename per
`stamp-and-name.md`'s own test, exactly the testimony shape `backtick_path_scan.sh` and
`comment_path_scan.sh` already carve out and report apart, which `checkable_binding_scan.sh` had
never learned. Added `is_testimony()` to the scan mirroring backtick_path's own awk function, split
`settled_unbound` into a living (gated) count and a `settled_unbound_testimony` (reported) count,
updated list mode and printed fields. Ran the scan directly first to confirm the ten pages
reclassified before touching the control; the existing 40-leg control passed unchanged (none of its
pen pages carry a stamped basename), then added one new leg planting a stamped-basename page and
proving it reads `settled_unbound_testimony=1` rather than `settled_unbound=1` (42 legs, 0 failing).
`checkable_binding_witness.rish` runs GREEN on metal, `settled_unbound` fell 10 to 0,
`ceiling_ok=yes`. `tame_style_check` GREEN, `ascii_document_scan` `verdict=ok`, both shell scripts
kept mode 100755. No REDS row booked (23 bytes free) -- an ordinary unrostered repair overlapping no
claim. Pushed `xy` then `gp405` clean fast-forward. Next lap: fresh round-open, cold run held still
start to finish; ~18 reds remain untriaged (`width_check`'s th5 disagreement already TAME-ruled,
`standing_equipment_redleg`'s chapter-lane remainder outside this lane, `rule_twin`/
`pond_enclosure_*` gated); `query_wire_retention` (%756), `ceiling_teeth`'s `asserted_only`
population, and the `shared_build_path`/`build_target` populations still want Keaton's word or a
larger plan than one lap affords.
