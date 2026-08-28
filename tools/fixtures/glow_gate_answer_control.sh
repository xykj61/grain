#!/bin/sh
# tools/fixtures/glow_gate_answer_control.sh -- prove the gate-answer scan bites, and prove what it
# leaves free.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every case below
# is asserted as hard in the free direction as in the bitten one. The pen is a throwaway directory
# of planted .rish files; nothing here touches the real tree, and nothing here builds a Glow desk.
#
# The two substring facts the whole scan rests on are cases 1 and 2, written from the recorded
# bytes of a real worker run rather than from a description of them:
#   an ACCEPT run prints "1\nEXIT:0\n" -- and that output satisfies contains "0"
#   a REFUSAL run prints "0\nEXIT:0\n" -- and that output does not satisfy contains "1"
#
# USAGE
#   sh tools/fixtures/glow_gate_answer_control.sh
#
# Driven by tools/g/glow_gate_answer_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/glow_gate_answer_scan.sh
[ -f "$scan" ] || { echo "FAIL: $scan is missing"; exit 1; }

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

fail=0
mark() {
  if [ "$2" = ok ]; then echo "case=$1 ok"; else echo "case=$1 FAILED -- $3"; fail=$((fail + 1)); fi
}

# count <file> -- the scan's indistinct_refusals reading over one planted file.
count() { sh "$scan" report "$1" 2>/dev/null | sed -n 's/^indistinct_refusals=//p'; }

expect() {
  got=$(count "$1")
  if [ "${got:-x}" = "$2" ]; then mark "$3" ok; else mark "$3" no "wanted $2, read ${got:-<none>}"; fi
}

echo "glow gate answer control -- pen $pen"

# --- the substring facts, from the worker's own output shape.
printf '1\nEXIT:0\n' > "$pen/accept.out"
printf '0\nEXIT:0\n' > "$pen/refuse.out"
if grep -q '0' "$pen/accept.out"; then mark accept_satisfies_zero ok; else mark accept_satisfies_zero no "an accept run did not satisfy contains 0"; fi
if grep -q '1' "$pen/refuse.out"; then mark refusal_holds_no_one no "a refusal run held a 1"; else mark refusal_holds_no_one ok; fi

# --- the real fault, planted in the shape that stood in the tree.
cat > "$pen/indistinct.rish" <<'EOF'
let zig = "vendor/zig-toolchain/zig"
let desk = "src/gate/gate-caravan-caps-bound-u32.glow"
let over = run ["env" "RYE_ZIG=${zig}" "sh" "tools/g/glow_run_worker.sh" desk "9"]
assert over.ok else "over side failed"
assert over.out contains "EXIT:0" else "over did not exit 0"
assert over.out contains "0" else "over did not speak 0"
EOF
expect "$pen/indistinct.rish" 1 indistinct_bitten

# --- the repaired form is free.
cat > "$pen/repaired.rish" <<'EOF'
let zig = "vendor/zig-toolchain/zig"
let desk = "src/gate/gate-caravan-caps-bound-u32.glow"
let over = run ["env" "RYE_ZIG=${zig}" "sh" "tools/g/glow_run_worker.sh" desk "9"]
assert over.ok else "over side failed"
assert over.out contains "EXIT:0" else "over did not exit 0"
assert (over.out contains "1") == false else "over spoke 1 where the wall says 0"
EOF
expect "$pen/repaired.rish" 0 repair_free

# --- asserting the exit line on purpose is free, and is never mistaken for the fault.
cat > "$pen/exitline.rish" <<'EOF'
let ok = run ["env" "RYE_ZIG=${zig}" "sh" "tools/g/glow_run_worker.sh" desk "4"]
assert ok.out contains "EXIT:0" else "accept did not exit 0"
EOF
expect "$pen/exitline.rish" 0 exit_line_free

# --- contains "0" over some OTHER command's output is free: the scan reads gate runs only.
cat > "$pen/othercmd.rish" <<'EOF'
let tally = run ["sh" "-c" "printf 0"]
assert tally.out contains "0" else "the count was not zero"
EOF
expect "$pen/othercmd.rish" 0 non_gate_run_free

# --- the accept side's genuine assertion is never counted.
cat > "$pen/acceptside.rish" <<'EOF'
let ok = run ["env" "RYE_ZIG=${zig}" "sh" "tools/g/glow_run_worker.sh" desk "4"]
assert ok.out contains "1" else "accept did not speak 1"
EOF
expect "$pen/acceptside.rish" 0 accept_side_free

# --- the runner spelling is read too, not only the worker.
cat > "$pen/runner.rish" <<'EOF'
let c2 = run ["rishi/bin/rishi" "run" "tools/g/glow_run.rish" "src/gate/gate-caravan-caps-pair-bound-u32.glow" "9" "8"]
assert c2.out contains "0" else "caravan over did not speak 0"
EOF
expect "$pen/runner.rish" 1 runner_spelling_read

# --- two faults in one file are both counted, so repairing one cannot hide the other.
cat > "$pen/two.rish" <<'EOF'
let a = run ["env" "RYE_ZIG=${zig}" "sh" "tools/g/glow_run_worker.sh" desk "9"]
assert a.out contains "0" else "a did not speak 0"
let b = run ["env" "RYE_ZIG=${zig}" "sh" "tools/g/glow_run_worker.sh" desk "5"]
assert b.out contains "0" else "b did not speak 0"
EOF
expect "$pen/two.rish" 2 both_faults_counted

# --- a file naming no gate run reads zero rather than refusing.
printf 'say "nothing here runs a Glow gate"\n' > "$pen/nogate.rish"
expect "$pen/nogate.rish" 0 no_gate_reads_zero

# --- an absent file is told apart from a passing one.
if sh "$scan" report "$pen/there-is-no-such-file.rish" 2>/dev/null | grep -q '^verdict=no_such_file'; then
  mark absent_told_apart ok
else
  mark absent_told_apart no "an absent file did not refuse by name"
fi

# --- THE CEILING, proven from both sides on a planted corpus rather than by handing the scan a
#     different number. The scan's own ceiling is 20, so a corpus of exactly 20 faults must pass
#     free and 21 must refuse. No override exists and none is wanted.
plant_corpus() {
  _dir=$1
  _n=$2
  rm -rf "$_dir"
  mkdir -p "$_dir"
  _i=1
  while [ "$_i" -le "$_n" ]; do
    {
      echo "let v$_i = run [\"env\" \"RYE_ZIG=\${zig}\" \"sh\" \"tools/g/glow_run_worker.sh\" desk \"9\"]"
      echo "assert v$_i.out contains \"0\" else \"v$_i did not speak 0\""
    } > "$_dir/plant_$_i.rish"
    _i=$((_i + 1))
  done
}

ceiling=$(sh "$scan" pen "$pen" 2>/dev/null | sed -n 's/^indistinct_ceiling=//p')
if [ -n "$ceiling" ]; then mark ceiling_published ok; else mark ceiling_published no "the scan published no ceiling"; fi

plant_corpus "$pen/at" "$ceiling"
out_at=$(sh "$scan" pen "$pen/at" 2>/dev/null)
if echo "$out_at" | grep -q "^indistinct_refusals=$ceiling" && echo "$out_at" | grep -q '^verdict=read'; then
  mark ceiling_at_bound_free ok
else
  mark ceiling_at_bound_free no "a corpus of exactly $ceiling did not pass free"
fi

plant_corpus "$pen/over" "$((ceiling + 1))"
out_over=$(sh "$scan" pen "$pen/over" 2>/dev/null)
if echo "$out_over" | grep -q '^verdict=indistinct_over_ceiling'; then
  mark ceiling_over_bound_refused ok
else
  mark ceiling_over_bound_refused no "a corpus of $((ceiling + 1)) did not refuse"
fi

# and the same plant, one fault repaired, comes back free -- the ratchet falls on a repair.
sed -i.bak 's|assert v1.out contains "0" |assert (v1.out contains "1") == false |' "$pen/over/plant_1.rish"
rm -f "$pen/over/plant_1.rish.bak"
if sh "$scan" pen "$pen/over" 2>/dev/null | grep -q '^verdict=read'; then
  mark repair_lowers_ratchet ok
else
  mark repair_lowers_ratchet no "repairing one fault did not bring the corpus back under the ceiling"
fi

# an absent pen is told apart from an empty reading.
if sh "$scan" pen "$pen/there-is-no-such-pen" 2>/dev/null | grep -q '^verdict=no_such_pen'; then
  mark absent_pen_told_apart ok
else
  mark absent_pen_told_apart no "an absent pen did not refuse by name"
fi

# --- the silent pair gate is recognised by its two-face head; a one-face desk is not.
printf '::  name  pen pair\n|=  [count=@u32 cap=@u32]\n?:  (gth count cap)  0  1\n' > "$pen/pair.glow"
printf '::  name  pen single\n|=  sample=@u32\n?:  (gth sample 7)  0  1\n' > "$pen/single.glow"
if grep -qE '^\|=  \[[a-z_]+=@u32 [a-z_]+=@u32\]' "$pen/pair.glow"; then mark pair_gate_seen ok; else mark pair_gate_seen no "a two-face desk was not recognised"; fi
if grep -qE '^\|=  \[[a-z_]+=@u32 [a-z_]+=@u32\]' "$pen/single.glow"; then mark single_gate_free no "a one-face desk was counted"; else mark single_gate_free ok; fi

if [ "$fail" -ne 0 ]; then
  echo "cases_failed=$fail"
  echo "control=failed"
  exit 4
fi
echo "cases_failed=0"
echo "control=ok"
exit 0
