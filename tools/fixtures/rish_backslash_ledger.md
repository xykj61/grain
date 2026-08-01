# Rish backslash-quote ledger — every advisory site, classed with a reason

**Stamp:** `20260801.161444` · e207 · Law: rishi passes `\"` through untouched;
inside sh **double**-quoted context it becomes a literal quote character
(vacuity risk); inside sh **single**-quoted patterns it reaches grep as an
escaped quote and works. Positive controls run where teeth were claimable.

## TOOTHED (fixed in tree, proof at site)
- pond_enclosure_sixbar.rish:68,107,109,124,126 — e206, planted-key proof
- pond_enclosure_sixbar.rish:54,56 — e207, Documents/Downloads bars (same family)
- gen_alias_sameness_witness.rish:14 — e207, `grep -qF $f` quote-free; 33/0 with teeth

## FIXLIST — vacuous, precise fixes named (queue item 9)
- stoa241:20 — `grep -E` plant does NOT match (control failed): the `\\"`
  double-escape never survives to a working pattern; recut single-quoted
  pattern with `\"` like stoa198's, then re-control.
- equinox_bundle.rish:41 — `case \"${path}\"` compares a quote-prefixed word;
  a /tmp path reads DURABLE (vacuous-pass on the tmpfs refusal). Recut
  `case ${path} in` (no spaces in paths here).
- equinox_bundle.rish:62 — manifest args arrive quote-wrapped; strip.
- amphora_restore_negative_witness.rish:54 — `test -n \"$f\"` vacuous-pass;
  recut `test x$f != x` (later asserts carry the plant today, so the
  witness still bites — but the guard should too).
- WAYLAND family — pond_brushstroke_frame:15 · surface p50:14 · p56:22 ·
  wayland_from_frame:19 · slc2a_ring3_metal:17 — all `test -n \"$WAYLAND…\"`
  vacuous-pass (claim the lane present when absent); recut `test x$… != x`.
  Metal-lane witnesses: pier reruns after fix.
- pond_enclosure_col2_probes:39 · scorecard:62 — `[ \"$e\" = empty ]` never
  equal → conservative-vacuous (reports hold/open even when closed); recut
  unquoted compares; truth over caution.
- make_key_qr_svg.rish:42 — `[ -n \"${FP…}\" ]` vacuous-pass; recut x-form.
  Touches key-card lane: fix text only, never values; pier verifies.

## CORRECT AS WRITTEN (single-quote grep, controls green)
- stoa198:22 (control: planted line matches) · surface p49:19 (live match) ·
  surface p50:27 (same shape) · hawm0:24 (live match) ·
  bricks_exist:12 (awk program single-quoted; runs; `[ -f \"$p\" ]` inner is
  double-context — conservative direction, echoes false-missing: FIXLIST
  footnote, low stakes)

## COMMENT / DOC / FIXTURE / PROBE (blessed, no code path)
- cursor_jail_macos:106,152,154,156 · generate_jail_local_keys_linux:127 ·
  generate_jail_local_keys_macos:114 · make_key_qr_svg:27,31 — comments
  documenting the very gap this ledger enforces
- fixtures/tame_style_long_fn:19 — intentional fixture shape
- rishi_quote_safe_witness:9 — probe whose truth is insensitive (noted e206)
