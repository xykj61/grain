#!/bin/sh
# tools/fixtures/d/demo_output_control.sh -- prove tools/fixtures/d/demo_output_scan.sh from
# both sides on planted pages in a throwaway pen.
#
# Style: Gauge, Field setting (see ../../../context/GAUGE_STYLE.md)
#
# WHY A PEN. The scan RUNS what a page prints, so each of its three readings earns proof from
# planted pages whose commands are `echo` and `printf`: cheap, quiet, and answerable in a
# sentence. Every plant lives inside a temporary directory and leaves on exit, so the tracked
# tree stays clear of them -- which is `%775`'s own ruling applied here rather than cited, since
# a guard whose population holds its own control carries a failure mode the guard itself can
# never see.
#
# EVERY REFUSAL IS PLANTED AND THEN LIFTED. A refusal shown once, in the failing direction,
# reads exactly like a guard that refuses everything handed to it. So each pair below runs the
# plant and then runs the same page with the fault taken out, and both readings are asserted.
#
# THREE MUTATIONS BITE, each on a live copy of the scan: dropping the marker reset that keeps
# one block's `volatile` comment out of the block after it, loosening the `selected` reading
# from a whole line to a substring, and dropping the gate over a command that exits nonzero.
# A mutation that fails to apply leaves the scan whole, and the leg then reads the honest
# refusal and fails -- so a sed that stops matching is heard on the lap it stops.
#
# THE LIVE PAGE RUNS ONCE, in the witness above rather than twice here. Running the default
# roster a second time costs about forty seconds to learn a fact the witness already holds, so
# the witness asserts the live page's shape from its own scan output and this control keeps the
# one roster reading a pen can give.
#
# USAGE
#   sh tools/fixtures/d/demo_output_control.sh
#
# Driven by tools/d/demo_output_witness.rish. Run from the repository root.

set -eu

# The portable shell helpers, because `sed -i` has no spelling both GNU and BSD accept.
. tools/fixtures/s/shell_portable.sh

SCAN=tools/fixtures/d/demo_output_scan.sh
[ -f "$SCAN" ] || { echo "verdict=no_scan"; exit 1; }
root=$(pwd)

pen=$(mktemp -d)
cleanup() { rm -rf "$pen"; }
trap cleanup EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

legs=0
failed=0
leg() {
  legs=$((legs + 1))
  if [ "$1" = yes ]; then
    echo "leg $2=yes"
  else
    failed=$((failed + 1))
    echo "leg $2=no"
  fi
}

# run <scan> <page> -> writes $pen/out, returns the scan's exit code
run() {
  s=$1; p=$2
  set +e
  sh "$s" --page "$p" > "$pen/out" 2>"$pen/err"
  rc=$?
  set -e
  return $rc
}

reads() { grep -qx "$1" "$pen/out"; }

# ---- the three readings, each plant lifted -------------------------------------------------

cat > "$pen/exact_ok.md" <<'PAGE'
# plant
```sh
echo hello
```
```
hello
```
PAGE
run "$SCAN" "$pen/exact_ok.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 0 ] && reads 'verdict=ok' && reads 'matched=1' && reads 'pairs_exact=1' && echo yes || echo no)" exact_clean_ok

cat > "$pen/exact_drift.md" <<'PAGE'
# plant
```sh
echo hello
```
```
goodbye
```
PAGE
run "$SCAN" "$pen/exact_drift.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=output_drifted' && reads 'drifted=1' && echo yes || echo no)" exact_drift_caught

cat > "$pen/exact_extra.md" <<'PAGE'
# plant -- an exact block that shows only part of the answer is a drift
```sh
printf 'one\ntwo\n'
```
```
one
```
PAGE
run "$SCAN" "$pen/exact_extra.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=output_drifted' && echo yes || echo no)" exact_wants_whole_output

cat > "$pen/vol_ok.md" <<'PAGE'
# plant
```sh
echo 'count=999'
```
<!-- volatile: the count climbs -->
```
count=1
```
PAGE
run "$SCAN" "$pen/vol_ok.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 0 ] && reads 'verdict=ok' && reads 'pairs_volatile=1' && echo yes || echo no)" volatile_frees_digits

cat > "$pen/vol_key.md" <<'PAGE'
# plant -- the key is renamed, and a volatile block still binds every letter
```sh
echo 'count=999'
```
<!-- volatile: the count climbs -->
```
tally=1
```
PAGE
run "$SCAN" "$pen/vol_key.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=output_drifted' && echo yes || echo no)" volatile_binds_the_key

cat > "$pen/vol_verdict.md" <<'PAGE'
# plant -- a flipped verdict carries no digit, so a volatile block must still red
```sh
echo 'verdict=refused'
```
<!-- volatile: -->
```
verdict=ok
```
PAGE
run "$SCAN" "$pen/vol_verdict.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=output_drifted' && echo yes || echo no)" volatile_binds_the_verdict

cat > "$pen/sel_ok.md" <<'PAGE'
# plant
```sh
printf 'one\ntwo\nthree\n'
```
<!-- selected: two lines out of three -->
```
one
three
```
PAGE
run "$SCAN" "$pen/sel_ok.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 0 ] && reads 'verdict=ok' && reads 'pairs_selected=1' && echo yes || echo no)" selected_takes_a_subset

cat > "$pen/sel_missing.md" <<'PAGE'
# plant
```sh
printf 'one\ntwo\n'
```
<!-- selected: -->
```
four
```
PAGE
run "$SCAN" "$pen/sel_missing.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=output_drifted' && echo yes || echo no)" selected_missing_caught

cat > "$pen/sel_partial.md" <<'PAGE'
# plant -- a selected line is a WHOLE line, never a fragment of one
```sh
echo 'verdict=ok'
```
<!-- selected: -->
```
verdict=o
```
PAGE
run "$SCAN" "$pen/sel_partial.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=output_drifted' && echo yes || echo no)" selected_wants_whole_line

# ---- the marker belongs to ONE pair --------------------------------------------------------

cat > "$pen/marker_reset.md" <<'PAGE'
# plant -- a volatile pair, then an exact pair whose numbers must still bind
```sh
echo 'count=999'
```
<!-- volatile: -->
```
count=1
```

```sh
echo 'total=7'
```
```
total=8
```
PAGE
run "$SCAN" "$pen/marker_reset.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=output_drifted' && reads 'pairs_volatile=1' && reads 'pairs_exact=1' && echo yes || echo no)" marker_belongs_to_one_pair

# ---- pairing, and what passes free ---------------------------------------------------------

cat > "$pen/unpaired.md" <<'PAGE'
# plant -- a command shown to run rather than an answer to check
```sh
echo hello
```
```
hello
```

Run this one yourself:

```sh
echo standalone
```
PAGE
run "$SCAN" "$pen/unpaired.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 0 ] && reads 'verdict=ok' && reads 'pairs=1' && reads 'unpaired=1' && echo yes || echo no)" unpaired_passes_free

cat > "$pen/two_sh.md" <<'PAGE'
# plant -- two command fences in a row; only the second is answered
```sh
echo first
```
```sh
echo second
```
```
second
```
PAGE
run "$SCAN" "$pen/two_sh.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 0 ] && reads 'pairs=1' && reads 'unpaired=1' && echo yes || echo no)" second_fence_takes_the_answer

# ---- double read: whether another guard's corpus already holds a rostered page --------------
#
# `--overlap` runs no printed command, so these legs cost nothing and the live roster may be read
# here directly. Every state the reading can take is proven, including the two that must refuse a
# comfortable zero out loud.

ov() {
  set +e
  env $1 sh "$2" --overlap ${3:+--page "$3"} > "$pen/out" 2>"$pen/err"
  ovrc=$?
  set -e
}

ov "" "$SCAN" ""
leg "$([ "$ovrc" -eq 0 ] && reads 'verdict=overlap_read' && reads 'double_read=1' && reads 'double_read_state=read' && grep -q "^double_read: docs-geode/demos/README.md is on this roster" "$pen/out" && echo yes || echo no)" overlap_names_the_rostered_page

ov "" "$SCAN" "$pen/exact_ok.md"
leg "$([ "$ovrc" -eq 0 ] && reads 'double_read=0' && reads 'double_read_state=read' && echo yes || echo no)" overlap_page_outside_the_corpus_reads_zero

printf '#!/bin/sh\necho nothing\n' > "$pen/no_corpus.sh"
ov "DEMO_OUTPUT_SIBLING=$pen/no_corpus.sh" "$SCAN" ""
leg "$([ "$ovrc" -eq 0 ] && reads 'double_read_state=unreadable' && reads 'double_read=0' && echo yes || echo no)" overlap_unreadable_corpus_says_so

ov "DEMO_OUTPUT_SIBLING=$pen/absent_sibling.sh" "$SCAN" ""
leg "$([ "$ovrc" -eq 0 ] && reads 'double_read_state=no_sibling' && echo yes || echo no)" overlap_absent_sibling_says_so

# The default report carries the reading too, so a roster pass meets it without asking.
leg "$(grep -q 'echo "double_read=\$double_read"' "$SCAN" && echo yes || echo no)" overlap_reported_by_default

# ---- refusals the scan owes ----------------------------------------------------------------

cat > "$pen/errored.md" <<'PAGE'
# plant -- a page handing a reader a command that exits nonzero has already failed them
```sh
exit 3
```
```
PAGE
printf '```\n' >> "$pen/errored.md"
run "$SCAN" "$pen/errored.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=command_errored' && reads 'errored=1' && echo yes || echo no)" nonzero_command_gated

cat > "$pen/no_pairs.md" <<'PAGE'
# plant -- prose alone
Nothing here runs.
PAGE
run "$SCAN" "$pen/no_pairs.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=no_pairs' && echo yes || echo no)" empty_page_refuses

run "$SCAN" "$pen/nowhere.md" && rc=0 || rc=$?
leg "$([ "$rc" -eq 1 ] && reads 'verdict=roster_page_absent' && echo yes || echo no)" absent_page_refuses

set +e
sh "$SCAN" --nonsense > "$pen/out" 2>/dev/null
rc=$?
set -e
leg "$([ "$rc" -eq 1 ] && reads 'verdict=bad_flag' && echo yes || echo no)" unknown_flag_refuses

# ---- the roster ----------------------------------------------------------------------------
#
# The default roster is NOT run here. The witness above this control runs the scan with no
# flags, which IS the default roster, and running the live page a second time costs about
# forty seconds to learn a fact already in hand. The witness asserts the live page's shape
# from its own scan output instead. What stays here is the one reading a pen can give: that
# the roster written into the scan names the page this rung was drawn for.

leg "$(grep -q 'demos/README.md' "$SCAN" && echo yes || echo no)" roster_names_the_demos_page

# ---- mutations, each on a live copy of the scan ---------------------------------------------

mut() {
  cp "$SCAN" "$pen/mut.sh"
  LC_ALL=C sed_inplace "$1" "$pen/mut.sh"
  run "$pen/mut.sh" "$2" && mrc=0 || mrc=$?
  leg "$([ "$mrc" -eq "$3" ] && echo yes || echo no)" "$4"
}

# Drop the marker reset: the exact pair after a volatile one inherits the free digits and the
# planted drift walks.
mut 's/pend = 0; kind = "cmd"; cmdn = 0; marker = ""/pend = 0; kind = "cmd"; cmdn = 0/' "$pen/marker_reset.md" 0 mutation_marker_reset_bites

# Loosen selected from a whole line to a substring: the fragment plant walks.
mut 's/grep -Fxq -- "\$want" "\$work\/pairs\/\$n.out"/grep -Fq -- "$want" "$work\/pairs\/$n.out"/' "$pen/sel_partial.md" 0 mutation_selected_substring_bites

# Drop the errored gate: a command exiting 3 reads green.
mut 's/^if \[ "\$errored" -gt 0 \]; then$/if false; then/' "$pen/errored.md" 0 mutation_errored_gate_bites

# Drop the corpus membership test: a rostered page inside the sibling's corpus stops being
# counted, and the reading answers the comfortable zero it exists to refuse.
cp "$SCAN" "$pen/mut.sh"
LC_ALL=C sed_inplace 's/if grep -qxF -- "\$rpage" "\$work\/sibling_pages"; then/if false; then/' "$pen/mut.sh"
ov "" "$pen/mut.sh" ""
leg "$([ "$ovrc" -eq 0 ] && reads 'double_read=0' && echo yes || echo no)" mutation_corpus_membership_bites

echo "control_legs=$legs"
echo "control_failed=$failed"
[ "$failed" -eq 0 ] || { echo "control_verdict=failed"; exit 1; }
echo "control_verdict=ok"
